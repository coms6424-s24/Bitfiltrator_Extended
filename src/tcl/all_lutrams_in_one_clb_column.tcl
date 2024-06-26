# author: Sahand Kashani <sahand.kashani@epfl.ch>

# To call this script, use the following command:
#
#   vivado -mode batch -source all_lutrams_in_one_clb_column.tcl -notrace -tclargs <fpga_part> <tile_type> <bitstream_out>
#
# Example:
#
#   vivado -mode batch -source all_lutrams_in_one_clb_column.tcl -notrace -tclargs xcu250-figd2104-2L-e CLEM output.bit
#
# The outputs of this script are 3 files:
#   - <bitstream_out>
#   - logic location file (using same prefix as <bitstream_out> with ".ll" extension)
#   - dcp file (using same prefix as <bitstream_out> with ".dcp" extension)

package require struct::list

source [file join [file dirname [info script]] helpers.tcl]

set script_path [file dirname [file normalize [info script]]]

proc main { fpga_part tile_type bitstream_out_name } {
  # We create an in-memory project to avoid having something written to disk at the current working directory.
  create_project "all_lutrams_in_one_clb_column" -in_memory -part ${fpga_part}
  # We create an "I/O Planning Project" so we don't need to run implementation to be able to open the device for inspection.
  set_property DESIGN_MODE PinPlanning [current_fileset]
  # Many commands below only work on an open design.
  open_io_design -name io_1

  set lut_pattern "SLICE_X(\\d+)Y(\\d+)/(\[ABCDEFGH\]6LUT)"

  # We first need to know how wide the design should be. This is why we used an "I/O Planning Project" as it
  # allows us to open the device for inspection. The normal "RTL" mode does not let us do this without synthesizing a
  # design first to have a design we can "open".
  lassign [get_first_col_with_tileType ${tile_type}] - - - - tiles

  # We sort the resulting list so we can get all elements in increasing Y-order.
  set lutrams [lsort -dictionary [get_bels -of_objects ${tiles} -regexp ${lut_pattern}]]
  # puts ${lutrams}

  set g_size [llength ${lutrams}]
  puts "Creating LUTRAM array of size ${g_size}"

  set_property DESIGN_MODE RTL [current_fileset]

  # Synthesize a design described in a verilog file. Note that `synth_design` will
  # automatically cause the project to transition to a standard "RTL" kernel again.
  # We also don't care about timing at all in this design, so we disable timing-driven
  # synthesis entirely.
  read_verilog $::script_path/lutram_array.v
  synth_design -top lutram_array -no_timing_driven -generic G_SIZE=${g_size}

  # Note that this design does not require an XDC file as nothing is connected to FPGA pins.

  # Place all cells at the locations we computed before synthesis. Note that care must
  # be taken when placing LUTRAMs as they cannot be placed in increasing order. Doing so
  # will result in the following error:
  #
  #   ERROR: [Vivado 12-1409] Cannot set loc and bel property of instance(s) lutram_ff_gen[0].lutram_inst/SP
  #     to bel A6LUT. The slice contains LUT-RAMs but none of them occupy the HLUT. A HLUT RAM is needed to provide write address signals to the rest of the RAM
  #
  # I therefore place the cells in descending order so I'm sure to populate the HLUT before any of the other
  # LUTs are placed.
  foreach idx [struct::list iota ${g_size}] {
    set reverse_idx [expr ${g_size} - 1 - ${idx}]
    # The name we query here is the name used in the verilog file.
    set lutram_cell [get_cells "lutram_gen[${reverse_idx}].lutram_inst"]
    set lutram_loc [lindex ${lutrams} ${reverse_idx}]
    place_cell ${lutram_cell} ${lutram_loc}
  }

  # # Optimizing the design is not really needed as it is somewhat performed by `synth_design`.
  # opt_design
  place_design
  route_design

  set checkpoint_out_name [replace_file_extension ${bitstream_out_name} "dcp"]
  write_checkpoint -force ${checkpoint_out_name}

  # # Debug
  # start_gui

  # Boards with HBM (like the U50) have a catastrophic trip (CATTRIP) port which
  # is supposed to be explicitly driven. If not driven, a DRC check fails and we
  # cannot generate a bitstream. This CATTRIP port is responsible for shutting
  # down the FPGA's power rails if the HBM reaches a critical temperature to
  # avoid damaging the card. Evan an empty bitstream for a HBM-enabled device
  # needs to have the CATTRIP port driven,
  # However, we do not want to use an XDC file in this TCL script to make it
  # work with all possible parts without requiring users to somehow find a XDC
  # file for each one. We therefore disable the DRC. This is safe as we are not
  # programming any device with this bitstream anyways.
  set_property IS_ENABLED 0 [get_drc_checks {PPURQ-1}]

  # Generate the bitstream.
  set_property BITSTREAM.GENERAL.COMPRESS FALSE     [current_design]
  set_property BITSTREAM.GENERAL.CRC DISABLE        [current_design]
  write_bitstream -force -logic_location_file ${bitstream_out_name}
}

# We test the length of $::argv instead of just checking $::argc as $::argc
# contains the count of args BEFORE options parsing. Options parsing removes
# optional args and the length of $::argv is the only way to get an accurate
# count of the mandatory args that are left behind.
if { [llength $::argv] != 3 } {
  puts "received mandatory args: $::argv"
  puts "expected mandatory args: <fpga_part> <tile_type> <bitstream_out>"
} else {
  set fpga_part [lindex $::argv 0]
  set tile_type [lindex $::argv 1]
  set bitstream_out [lindex $::argv 2]
  main ${fpga_part} ${tile_type} ${bitstream_out}
}
