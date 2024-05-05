module ring_bram();

  parameter G_SIZE = 4;

  wire fake_clock;
  // wire [63 : 0] tmp [G_SIZE : 0];
  // wire [31 : 0] tmp [G_SIZE : 0];
  wire [15 : 0] tmp_A [G_SIZE : 0];
  wire [15 : 0] tmp_B [G_SIZE : 0];

  // assign tmp[0] = tmp[G_SIZE];
  assign tmp_A[0] = tmp_A[G_SIZE];
  assign tmp_B[0] = tmp_B[G_SIZE];

  // This FDRE is used as an "active" signal for the BRAM's clock signal, otherwise
  // Vivado will fail a DRC check when generating the bitstream.
  (* DONT_TOUCH = "yes" *)
  FDRE #(
    .INIT(1'b0),
    .IS_C_INVERTED(1'b0),
    .IS_D_INVERTED(1'b0),
    .IS_R_INVERTED(1'b0)
  )
  FDRE_inst (
    .Q(fake_clock),
    .C(1'b0),
    .CE(1'b0),
    .D(~fake_clock),
    .R(1'b0)
  );

  genvar i;
  generate
    for (i=0; i<G_SIZE; i=i+1) begin : bram_gen

      // RAMB18e1: 18K-bit Configurable Synchronous Block RAM UltraScale
      (* DONT_TOUCH = "yes" *)
      RAMB18E1 #(
   // Address Collision Mode: "PERFORMANCE" or "DELAYED_WRITE"
   .RDADDR_COLLISION_HWCONFIG("DELAYED_WRITE"),
   // Collision check: Values ("ALL", "WARNING_ONLY", "GENERATE_X_ONLY" or "NONE")
   .SIM_COLLISION_CHECK("ALL"),
   // DOA_REG, DOB_REG: Optional output register (0 or 1)
   .DOA_REG(0),
   .DOB_REG(0),
   // INITP_00 to INITP_07: Initial contents of parity memory array
   .INITP_00(256'h0000000000000000000000000000000000000000000000000000000000000000),
   .INITP_01(256'h0000000000000000000000000000000000000000000000000000000000000000),
   .INITP_02(256'h0000000000000000000000000000000000000000000000000000000000000000),
   .INITP_03(256'h0000000000000000000000000000000000000000000000000000000000000000),
   .INITP_04(256'h0000000000000000000000000000000000000000000000000000000000000000),
   .INITP_05(256'h0000000000000000000000000000000000000000000000000000000000000000),
   .INITP_06(256'h0000000000000000000000000000000000000000000000000000000000000000),
   .INITP_07(256'h0000000000000000000000000000000000000000000000000000000000000000),
   // INIT_00 to INIT_3F: Initial contents of data memory array
   .INIT_00(256'h0000000000000000000000000000000000000000000000000000000000000000),
   .INIT_01(256'h0000000000000000000000000000000000000000000000000000000000000000),
   .INIT_02(256'h0000000000000000000000000000000000000000000000000000000000000000),
   .INIT_03(256'h0000000000000000000000000000000000000000000000000000000000000000),
   .INIT_04(256'h0000000000000000000000000000000000000000000000000000000000000000),
   .INIT_05(256'h0000000000000000000000000000000000000000000000000000000000000000),
   .INIT_06(256'h0000000000000000000000000000000000000000000000000000000000000000),
   .INIT_07(256'h0000000000000000000000000000000000000000000000000000000000000000),
   .INIT_08(256'h0000000000000000000000000000000000000000000000000000000000000000),
   .INIT_09(256'h0000000000000000000000000000000000000000000000000000000000000000),
   .INIT_0A(256'h0000000000000000000000000000000000000000000000000000000000000000),
   .INIT_0B(256'h0000000000000000000000000000000000000000000000000000000000000000),
   .INIT_0C(256'h0000000000000000000000000000000000000000000000000000000000000000),
   .INIT_0D(256'h0000000000000000000000000000000000000000000000000000000000000000),
   .INIT_0E(256'h0000000000000000000000000000000000000000000000000000000000000000),
   .INIT_0F(256'h0000000000000000000000000000000000000000000000000000000000000000),
   .INIT_10(256'h0000000000000000000000000000000000000000000000000000000000000000),
   .INIT_11(256'h0000000000000000000000000000000000000000000000000000000000000000),
   .INIT_12(256'h0000000000000000000000000000000000000000000000000000000000000000),
   .INIT_13(256'h0000000000000000000000000000000000000000000000000000000000000000),
   .INIT_14(256'h0000000000000000000000000000000000000000000000000000000000000000),
   .INIT_15(256'h0000000000000000000000000000000000000000000000000000000000000000),
   .INIT_16(256'h0000000000000000000000000000000000000000000000000000000000000000),
   .INIT_17(256'h0000000000000000000000000000000000000000000000000000000000000000),
   .INIT_18(256'h0000000000000000000000000000000000000000000000000000000000000000),
   .INIT_19(256'h0000000000000000000000000000000000000000000000000000000000000000),
   .INIT_1A(256'h0000000000000000000000000000000000000000000000000000000000000000),
   .INIT_1B(256'h0000000000000000000000000000000000000000000000000000000000000000),
   .INIT_1C(256'h0000000000000000000000000000000000000000000000000000000000000000),
   .INIT_1D(256'h0000000000000000000000000000000000000000000000000000000000000000),
   .INIT_1E(256'h0000000000000000000000000000000000000000000000000000000000000000),
   .INIT_1F(256'h0000000000000000000000000000000000000000000000000000000000000000),
   .INIT_20(256'h0000000000000000000000000000000000000000000000000000000000000000),
   .INIT_21(256'h0000000000000000000000000000000000000000000000000000000000000000),
   .INIT_22(256'h0000000000000000000000000000000000000000000000000000000000000000),
   .INIT_23(256'h0000000000000000000000000000000000000000000000000000000000000000),
   .INIT_24(256'h0000000000000000000000000000000000000000000000000000000000000000),
   .INIT_25(256'h0000000000000000000000000000000000000000000000000000000000000000),
   .INIT_26(256'h0000000000000000000000000000000000000000000000000000000000000000),
   .INIT_27(256'h0000000000000000000000000000000000000000000000000000000000000000),
   .INIT_28(256'h0000000000000000000000000000000000000000000000000000000000000000),
   .INIT_29(256'h0000000000000000000000000000000000000000000000000000000000000000),
   .INIT_2A(256'h0000000000000000000000000000000000000000000000000000000000000000),
   .INIT_2B(256'h0000000000000000000000000000000000000000000000000000000000000000),
   .INIT_2C(256'h0000000000000000000000000000000000000000000000000000000000000000),
   .INIT_2D(256'h0000000000000000000000000000000000000000000000000000000000000000),
   .INIT_2E(256'h0000000000000000000000000000000000000000000000000000000000000000),
   .INIT_2F(256'h0000000000000000000000000000000000000000000000000000000000000000),
   .INIT_30(256'h0000000000000000000000000000000000000000000000000000000000000000),
   .INIT_31(256'h0000000000000000000000000000000000000000000000000000000000000000),
   .INIT_32(256'h0000000000000000000000000000000000000000000000000000000000000000),
   .INIT_33(256'h0000000000000000000000000000000000000000000000000000000000000000),
   .INIT_34(256'h0000000000000000000000000000000000000000000000000000000000000000),
   .INIT_35(256'h0000000000000000000000000000000000000000000000000000000000000000),
   .INIT_36(256'h0000000000000000000000000000000000000000000000000000000000000000),
   .INIT_37(256'h0000000000000000000000000000000000000000000000000000000000000000),
   .INIT_38(256'h0000000000000000000000000000000000000000000000000000000000000000),
   .INIT_39(256'h0000000000000000000000000000000000000000000000000000000000000000),
   .INIT_3A(256'h0000000000000000000000000000000000000000000000000000000000000000),
   .INIT_3B(256'h0000000000000000000000000000000000000000000000000000000000000000),
   .INIT_3C(256'h0000000000000000000000000000000000000000000000000000000000000000),
   .INIT_3D(256'h0000000000000000000000000000000000000000000000000000000000000000),
   .INIT_3E(256'h0000000000000000000000000000000000000000000000000000000000000000),
   .INIT_3F(256'h0000000000000000000000000000000000000000000000000000000000000000),
   // INIT_A, INIT_B: Initial values on output ports
   .INIT_A(18'h00000),
   .INIT_B(18'h00000),
   // Initialization File: RAM initialization file
   .INIT_FILE("NONE"),
   // RAM Mode: "SDP" or "TDP"
   .RAM_MODE("TDP"),
   // READ_WIDTH_A/B, WRITE_WIDTH_A/B: Read/write width per port
   .READ_WIDTH_A(0),                                                                 // 0-72
   .READ_WIDTH_B(0),                                                                 // 0-18
   .WRITE_WIDTH_A(0),                                                                // 0-18
   .WRITE_WIDTH_B(0),                                                                // 0-72
   // RSTREG_PRIORITY_A, RSTREG_PRIORITY_B: Reset or enable priority ("RSTREG" or "REGCE")
   .RSTREG_PRIORITY_A("RSTREG"),
   .RSTREG_PRIORITY_B("RSTREG"),
   // SRVAL_A, SRVAL_B: Set/reset value for output
   .SRVAL_A(18'h00000),
   .SRVAL_B(18'h00000),
   // Simulation Device: Must be set to "7SERIES" for simulation behavior
   .SIM_DEVICE("7SERIES"),
   // WriteMode: Value on output upon a write ("WRITE_FIRST", "READ_FIRST", or "NO_CHANGE")
   .WRITE_MODE_A("WRITE_FIRST"),
   .WRITE_MODE_B("WRITE_FIRST")
)
RAMB18E1_inst (
   // Port A Data: 16-bit (each) output: Port A data
   .DOADO(tmp_A[i+1]),                 // 16-bit output: A port data/LSB data
   .DOPADOP(),             // 2-bit output: A port parity/LSB parity
   // Port B Data: 16-bit (each) output: Port B data
   .DOBDO(tmp_B[i+1]),                 // 16-bit output: B port data/MSB data
   .DOPBDOP(),             // 2-bit output: B port parity/MSB parity
   // Port A Address/Control Signals: 14-bit (each) input: Port A address and control signals (read port
   // when RAM_MODE="SDP")
   .ADDRARDADDR(14'b0),     // 14-bit input: A port address/Read address
   .CLKARDCLK(fake_clock),         // 1-bit input: A port clock/Read clock
   .ENARDEN(1'b0),             // 1-bit input: A port enable/Read enable
   .REGCEAREGCE(1'b0),     // 1-bit input: A port register enable/Register enable
   .RSTRAMARSTRAM(1'b0), // 1-bit input: A port set/reset
   .RSTREGARSTREG(1'b0), // 1-bit input: A port register set/reset
   .WEA(2'b0),                     // 2-bit input: A port write enable
   // Port A Data: 16-bit (each) input: Port A data
   .DIADI(tmp_A[i]),                 // 16-bit input: A port data/LSB data
   .DIPADIP(2'b0),             // 2-bit input: A port parity/LSB parity
   // Port B Address/Control Signals: 14-bit (each) input: Port B address and control signals (write port
   // when RAM_MODE="SDP")
   .ADDRBWRADDR(14'b0),     // 14-bit input: B port address/Write address
   .CLKBWRCLK(fake_clock),         // 1-bit input: B port clock/Write clock
   .ENBWREN(1'b0),             // 1-bit input: B port enable/Write enable
   .REGCEB(1'b0),               // 1-bit input: B port register enable
   .RSTRAMB(1'b0),             // 1-bit input: B port set/reset
   .RSTREGB(1'b0),             // 1-bit input: B port register set/reset
   .WEBWE(4'b0),                 // 4-bit input: B port write enable/Write enable
   // Port B Data: 16-bit (each) input: Port B data
   .DIBDI(tmp_B[i]),                 // 16-bit input: B port data/MSB data
   .DIPBDIP(2'b0)              // 2-bit input: B port parity/MSB parity
);

// End of RAMB18E1_inst instantiation

      // // FIFO18e1: 18K FIFO (First-In-First-Out) Block RAM Memory UltraScale
      // (* DONT_TOUCH = "yes" *)
      // FIFO18e1 #(
      //   .CASCADE_ORDER("NONE"),            // FIRST, LAST, MIDDLE, NONE, PARALLEL
      //   .CLOCK_DOMAINS("COMMON"),          // COMMON, INDEPENDENT
      //   .FIRST_WORD_FALL_THROUGH("FALSE"), // FALSE, TRUE
      //   .INIT(36'h000000000),     // Initial values on output port
      //   .PROG_EMPTY_THRESH(256),           // Programmable Empty Threshold
      //   .PROG_FULL_THRESH(256),            // Programmable Full Threshold
      //   // Programmable Inversion Attributes: Specifies the use of the built-in programmable inversion
      //   .IS_RDCLK_INVERTED(1'b0),          // Optional inversion for RDCLK
      //   .IS_RDEN_INVERTED(1'b0),           // Optional inversion for RDEN
      //   .IS_RSTREG_INVERTED(1'b0),         // Optional inversion for RSTREG
      //   .IS_RST_INVERTED(1'b0),            // Optional inversion for RST
      //   .IS_WRCLK_INVERTED(1'b0),          // Optional inversion for WRCLK
      //   .IS_WREN_INVERTED(1'b0),           // Optional inversion for WREN
      //   .RDCOUNT_TYPE("RAW_PNTR"),         // EXTENDED_DATACOUNT, RAW_PNTR, SIMPLE_DATACOUNT, SYNC_PNTR
      //   .READ_WIDTH(36),                   // 4, 9, 18, 36
      //   .REGISTER_MODE("UNREGISTERED"),    // DO_PIPELINED, REGISTERED, UNREGISTERED
      //   .RSTREG_PRIORITY("RSTREG"),        // REGCE, RSTREG
      //   .SLEEP_ASYNC("FALSE"),             // FALSE, TRUE
      //   .SRVAL(36'h000000000),             // SET/reset value of the FIFO outputs
      //   .WRCOUNT_TYPE("RAW_PNTR"),         // EXTENDED_DATACOUNT, RAW_PNTR, SIMPLE_DATACOUNT, SYNC_PNTR
      //   .WRITE_WIDTH(36)                   // 4, 9, 18, 36
      // )
      // FIFO18e1_inst (
      //   // Cascade Signals outputs: Multi-FIFO cascade signals
      //   .CASDOUT(),              // 64-bit output: Data cascade output bus
      //   .CASDOUTP(),             // 8-bit output: Parity data cascade output bus
      //   .CASNXTEMPTY(),          // 1-bit output: Cascade next empty
      //   .CASPRVRDEN(),           // 1-bit output: Cascade previous read enable
      //   // Read Data outputs: Read output data
      //   .DOUT(tmp[i+1]),         // 64-bit output: FIFO data output bus
      //   .DOUTP(),                // 8-bit output: FIFO parity output bus.
      //   // Status outputs: Flags and other FIFO status outputs
      //   .EMPTY(),                // 1-bit output: Empty
      //   .FULL(),                 // 1-bit output: Full
      //   .PROGEMPTY(),            // 1-bit output: Programmable empty
      //   .PROGFULL(),             // 1-bit output: Programmable full
      //   .RDCOUNT(),              // 14-bit output: Read count
      //   .RDERR(),                // 1-bit output: Read error
      //   .RDRSTBUSY(),            // 1-bit output: Reset busy (sync to RDCLK)
      //   .WRCOUNT(),              // 14-bit output: Write count
      //   .WRERR(),                // 1-bit output: Write Error
      //   .WRRSTBUSY(),            // 1-bit output: Reset busy (sync to WRCLK)
      //   // Cascade Signals inputs: Multi-FIFO cascade signals
      //   .CASDIN(),               // 64-bit input: Data cascade input bus
      //   .CASDINP(),              // 8-bit input: Parity data cascade input bus
      //   .CASDOMUX(),             // 1-bit input: Cascade MUX select input
      //   .CASDOMUXEN(),           // 1-bit input: Enable for cascade MUX select
      //   .CASNXTRDEN(),           // 1-bit input: Cascade next read enable
      //   .CASOREGIMUX(),          // 1-bit input: Cascade output MUX select
      //   .CASOREGIMUXEN(),        // 1-bit input: Cascade output MUX select enable
      //   .CASPRVEMPTY(),          // 1-bit input: Cascade previous empty
      //   // Read Control Signals inputs: Read clock, enable and reset input signals
      //   .RDCLK(fake_clock),      // 1-bit input: Read clock
      //   .RDEN(1'b0),             // 1-bit input: Read enable
      //   .REGCE(1'b0),            // 1-bit input: Output register clock enable
      //   .RSTREG(1'b0),           // 1-bit input: Output register reset
      //   .SLEEP(1'b0),            // 1-bit input: Sleep Mode
      //   // Write Control Signals inputs: Write clock and enable input signals
      //   .RST(1'b0),              // 1-bit input: Reset
      //   .WRCLK(fake_clock),      // 1-bit input: Write clock
      //   .WREN(1'b0),             // 1-bit input: Write enable
      //   // Write Data inputs: Write input data
      //   .DIN(tmp[i]),            // 64-bit input: FIFO data input bus
      //   .DINP()                  // 8-bit input: FIFO parity input bus
      // );

      // // FIFO36e1: 36K FIFO (First-In-First-Out) Block RAM Memory UltraScale
      // (* DONT_TOUCH = "yes" *)
      // FIFO36e1 #(
      //   .CASCADE_ORDER("NONE"),            // FIRST, LAST, MIDDLE, NONE, PARALLEL
      //   .CLOCK_DOMAINS("COMMON"),          // COMMON, INDEPENDENT
      //   .EN_ECC_PIPE("FALSE"),             // ECC pipeline register, (FALSE, TRUE)
      //   .EN_ECC_READ("FALSE"),             // Enable ECC decoder, (FALSE, TRUE)
      //   .EN_ECC_WRITE("FALSE"),            // Enable ECC encoder, (FALSE, TRUE)
      //   .FIRST_WORD_FALL_THROUGH("FALSE"), // FALSE, TRUE
      //   .INIT(72'h000000000000000000),     // Initial values on output port
      //   .PROG_EMPTY_THRESH(256),           // Programmable Empty Threshold
      //   .PROG_FULL_THRESH(256),            // Programmable Full Threshold
      //   // Programmable Inversion Attributes: Specifies the use of the built-in programmable inversion
      //   .IS_RDCLK_INVERTED(1'b0),          // Optional inversion for RDCLK
      //   .IS_RDEN_INVERTED(1'b0),           // Optional inversion for RDEN
      //   .IS_RSTREG_INVERTED(1'b0),         // Optional inversion for RSTREG
      //   .IS_RST_INVERTED(1'b0),            // Optional inversion for RST
      //   .IS_WRCLK_INVERTED(1'b0),          // Optional inversion for WRCLK
      //   .IS_WREN_INVERTED(1'b0),           // Optional inversion for WREN
      //   .RDCOUNT_TYPE("RAW_PNTR"),         // EXTENDED_DATACOUNT, RAW_PNTR, SIMPLE_DATACOUNT, SYNC_PNTR
      //   .READ_WIDTH(72),                   // 4, 9, 18, 36, 72
      //   .REGISTER_MODE("UNREGISTERED"),    // DO_PIPELINED, REGISTERED, UNREGISTERED
      //   .RSTREG_PRIORITY("RSTREG"),        // REGCE, RSTREG
      //   .SLEEP_ASYNC("FALSE"),             // FALSE, TRUE
      //   .SRVAL(72'h000000000000000000),    // SET/reset value of the FIFO outputs
      //   .WRCOUNT_TYPE("RAW_PNTR"),         // EXTENDED_DATACOUNT, RAW_PNTR, SIMPLE_DATACOUNT, SYNC_PNTR
      //   .WRITE_WIDTH(72)                   // 4, 9, 18, 36, 72
      // )
      // FIFO36e1_inst (
      //   // Cascade Signals outputs: Multi-FIFO cascade signals
      //   .CASDOUT(),              // 64-bit output: Data cascade output bus
      //   .CASDOUTP(),             // 8-bit output: Parity data cascade output bus
      //   .CASNXTEMPTY(),          // 1-bit output: Cascade next empty
      //   .CASPRVRDEN(),           // 1-bit output: Cascade previous read enable
      //   // ECC Signals outputs: Error Correction Circuitry ports
      //   .DBITERR(),              // 1-bit output: Double bit error status
      //   .ECCPARITY(),            // 8-bit output: Generated error correction parity
      //   .SBITERR(),              // 1-bit output: Single bit error status
      //   // Read Data outputs: Read output data
      //   .DOUT(tmp[i+1]),         // 64-bit output: FIFO data output bus
      //   .DOUTP(),                // 8-bit output: FIFO parity output bus.
      //   // Status outputs: Flags and other FIFO status outputs
      //   .EMPTY(),                // 1-bit output: Empty
      //   .FULL(),                 // 1-bit output: Full
      //   .PROGEMPTY(),            // 1-bit output: Programmable empty
      //   .PROGFULL(),             // 1-bit output: Programmable full
      //   .RDCOUNT(),              // 14-bit output: Read count
      //   .RDERR(),                // 1-bit output: Read error
      //   .RDRSTBUSY(),            // 1-bit output: Reset busy (sync to RDCLK)
      //   .WRCOUNT(),              // 14-bit output: Write count
      //   .WRERR(),                // 1-bit output: Write Error
      //   .WRRSTBUSY(),            // 1-bit output: Reset busy (sync to WRCLK)
      //   // Cascade Signals inputs: Multi-FIFO cascade signals
      //   .CASDIN(),               // 64-bit input: Data cascade input bus
      //   .CASDINP(),              // 8-bit input: Parity data cascade input bus
      //   .CASDOMUX(),             // 1-bit input: Cascade MUX select input
      //   .CASDOMUXEN(),           // 1-bit input: Enable for cascade MUX select
      //   .CASNXTRDEN(),           // 1-bit input: Cascade next read enable
      //   .CASOREGIMUX(),          // 1-bit input: Cascade output MUX select
      //   .CASOREGIMUXEN(),        // 1-bit input: Cascade output MUX select enable
      //   .CASPRVEMPTY(),          // 1-bit input: Cascade previous empty
      //   // ECC Signals inputs: Error Correction Circuitry ports
      //   .INJECTDBITERR(),        // 1-bit input: Inject a double-bit error
      //   .INJECTSBITERR(),        // 1-bit input: Inject a single bit error
      //   // Read Control Signals inputs: Read clock, enable and reset input signals
      //   .RDCLK(fake_clock),      // 1-bit input: Read clock
      //   .RDEN(1'b0),             // 1-bit input: Read enable
      //   .REGCE(1'b0),            // 1-bit input: Output register clock enable
      //   .RSTREG(1'b0),           // 1-bit input: Output register reset
      //   .SLEEP(1'b0),            // 1-bit input: Sleep Mode
      //   // Write Control Signals inputs: Write clock and enable input signals
      //   .RST(1'b0),              // 1-bit input: Reset
      //   .WRCLK(fake_clock),      // 1-bit input: Write clock
      //   .WREN(1'b0),             // 1-bit input: Write enable
      //   // Write Data inputs: Write input data
      //   .DIN(tmp[i]),            // 64-bit input: FIFO data input bus
      //   .DINP()                  // 8-bit input: FIFO parity input bus
      // );

    end
  endgenerate

endmodule
