# author: Sahand Kashani <sahand.kashani@epfl.ch>
#ASSUMING device_info["composition"]["slrs"].items()["max_clock_region_row_idx"] is ABSOLUTE
import argparse
import re
from collections import defaultdict
from pathlib import Path

import format_json
import helpers


def extract_clb_col_tile_types(
  device_info_path: str | Path,
  out_path: str | Path
) -> None:
  device_info = helpers.read_json(device_info_path)

  # We store the name of every tile in a tile column that has a site that contains the name "SLICE" in it.
  # Something like this:
  #
  #   "SLR0": {
  #     "0": {
  #       "SLICE_X0Y0": "CLEL_R_X0Y0",
  #       "SLICE_X0Y1": "CLEL_R_X0Y1",
  #       "SLICE_X0Y2": "CLEL_R_X0Y2",
  #       "SLICE_X0Y3": "CLEL_R_X0Y3",
  #       ...
  #       "SLICE_X1Y0": "CLEM_X1Y0",
  #       "SLICE_X1Y1": "CLEM_X1Y1",
  #       "SLICE_X1Y2": "CLEM_X1Y2",
  #       "SLICE_X1Y3": "CLEM_X1Y3",
  #       "SLICE_X1Y4": "CLEM_X1Y4",
  #       "SLICE_X1Y5": "CLEM_X1Y5",
  #       ...
  #       "SLICE_X3Y0": "CLEL_R_X2Y0",  << Note that you MUST use the slice name to determine the
  #       "SLICE_X3Y1": "CLEL_R_X2Y1",     CLB column index, NOT the tile name. See here that the
  #       "SLICE_X3Y2": "CLEL_R_X2Y2",     tile name has 2 as its X-value whereas the slice name
  #       "SLICE_X3Y3": "CLEL_R_X2Y3",     has 3 as its X-value. It is therefore the 4th CLB column.
  #       "SLICE_X3Y4": "CLEL_R_X2Y4",
  #       "SLICE_X3Y5": "CLEL_R_X2Y5",
  #       "SLICE_X3Y6": "CLEL_R_X2Y6",
  #     "1": {
  #       ...
  #     }
  #   },

  #added another layer of default dict to allow for extra layer of 'half_bit'
  slr_rowMajor_slice_tile = defaultdict(
    lambda: defaultdict(
        lambda: defaultdict(dict)
    )
  )

  for (slrName, slrProperties) in device_info["composition"]["slrs"].items():
    #Assume these are ABSOLUTE values
    min_clock_region_row_idx = slrProperties["min_clock_region_row_idx"]
    max_clock_region_row_idx = slrProperties["max_clock_region_row_idx"]
    min_clock_region_col_idx = slrProperties["min_clock_region_col_idx"]
    max_clock_region_col_idx = slrProperties["max_clock_region_col_idx"]

    # Iterate over clock regions in row-order so we can accumulate the CLB columns' tile
    # names in every row. The order doesn't matter for now. We just want to have all
    # tile names.

    #rowMajor is absolute, as is clock_regions_in_row
    #The idea is that there is a center line dividing each SLR which need to determine top or bottom half from, 
    #and the relative row num is the distance from that center, with bottom being 1 and top being 0. So we get the min and max rows,
    #find the center line, and then do the calculations for each absolute major row to get the relative row for each.
     
    #center is center of SLR by row 0, in top half (so add +1 to make it top half )

    center =  round((max_clock_region_row_idx+min_clock_region_row_idx)/2)+1
    for rowMajor in range(min_clock_region_row_idx, max_clock_region_row_idx + 1):
      #Format of X<x>Y<y>
      clock_regions_in_row = [f"X{x}Y{rowMajor}" for x in range(min_clock_region_col_idx, max_clock_region_col_idx + 1)]

      for clock_region in clock_regions_in_row:
        clock_region_properties = slrProperties["clock_regions"][clock_region]
        # Some devices (like Zynq's) can have empty clock regions. We must therefore handle them explicitly.
        if len(clock_region_properties) != 0:
          for (tileColIdx, tiles) in clock_region_properties["tile_cols"].items():
            for (tile, sites) in tiles.items():
              for site in sites:
                if re.match(r"SLICE_X(\d+)Y(\d+)", site):
                  #change this to allow for halves
                  #get distance from top and bottom to see which half the row is in
                  rel_rowMajor_from_bottom = rowMajor - min_clock_region_row_idx 
                  rel_rowMajor_from_top = rowMajor - max_clock_region_row_idx
                  rel_rowMajor = abs(center - rowMajor)
                  half_bit = 0
                  #if in bottom  half
                  if(abs(rel_rowMajor_from_top)>abs(rel_rowMajor_from_bottom)):
                      half_bit = 1
                      #account for center being first row in top half
                      rel_rowMajor-=1
                  slr_rowMajor_slice_tile[slrName][half_bit][rel_rowMajor][site] = tile

  # We want the resulting dictionary to look liks this:
  #
  #   "slrs": {
  #     "SLR0": {
  #       "rowMajors": {
  #         "0": {
  #           "clb_tileTypes": {"0": "CLEL_R","1": "CLEM","2": "CLEM","3": "CLEL_R", ...}
  #         },
  #         "1": {
  #           "clb_tileTypes": {"0": "CLEL_R","1": "CLEM","2": "CLEM","3": "CLEL_R", ...}
  #         },
  #         "2": {
  #           "clb_tileTypes": {"0": "CLEL_R","1": "CLEM","2": "CLEM","3": "CLEL_R", ...}
  #         },
  #         "3": {
  #           "clb_tileTypes": {"0": "CLEL_R","1": "CLEM","2": "CLEM","3": "CLEL_R", ...}
  #         },
  #         ...
  #       }
  #     },
  #     ...
  #  }


  #was changed so now also have half bit



#add another layer for half_bit
  res = defaultdict(
    lambda: defaultdict(
      lambda: defaultdict(
        lambda: defaultdict(
          lambda: defaultdict(
            lambda: defaultdict(dict)
          )
        )
      )
    )
  )
  #added a half bit layer
  for (slrName, half_bit_dict) in slr_rowMajor_slice_tile.items():
    for (half_bit, rowMajor_dict) in half_bit_dict.items():
      for (rowMajor, siteTile_dict) in rowMajor_dict.items():
        res["slrs"][slrName]["half_bit"][half_bit]["rowMajors"][rowMajor]["clb_tileTypes"] = extract_col_types(siteTile_dict)

  # Emit output file.
  with open(out_path, "w") as f:
    json_str = format_json.emit(res, sort_keys=True)
    f.write(json_str)

# This function transforms a dict of (site -> tile) mappings in a given SLR row:
#
#       "SLICE_X0Y0": "CLEL_R_X0Y0",
#       "SLICE_X0Y1": "CLEL_R_X0Y1",
#       "SLICE_X0Y2": "CLEL_R_X0Y2",
#       "SLICE_X0Y3": "CLEL_R_X0Y3",
#       ...
#       "SLICE_X1Y0": "CLEM_X1Y0",
#       "SLICE_X1Y1": "CLEM_X1Y1",
#       "SLICE_X1Y2": "CLEM_X1Y2",
#       "SLICE_X1Y3": "CLEM_X1Y3",
#       "SLICE_X1Y4": "CLEM_X1Y4",
#       "SLICE_X1Y5": "CLEM_X1Y5",
#       ...
#       "SLICE_X3Y0": "CLEL_R_X2Y0",  << Note that you MUST use the slice name to determine the
#       "SLICE_X3Y1": "CLEL_R_X2Y1",     CLB column index, NOT the tile name. See here that the
#       "SLICE_X3Y2": "CLEL_R_X2Y2",     tile name has 2 as its X-value whereas the slice name
#       "SLICE_X3Y3": "CLEL_R_X2Y3",     has 3 as its X-value. It is therefore the 4th CLB column.
#       "SLICE_X3Y4": "CLEL_R_X2Y4",
#       "SLICE_X3Y5": "CLEL_R_X2Y5",
#       "SLICE_X3Y6": "CLEL_R_X2Y6",
#
# into something like this:
#
#   {
#     0 -> CLEL_R
#     1 -> CLEM
#     ...
#     3 -> CLEL_R
#     ...
#   }
#
# We basically keep the X-value of the SITE name and take everything before "_X<x>Y<y>" in the TILE
# name as the tile type.
#
#  [CLEL_R, CLEM, ...]
def extract_col_types(
  # site name -> tile name
  siteTile_dict: dict[str, str]
) -> dict[int, str]:
  siteX_tileType_dict: dict[int, str] = dict()

  name_pattern = r"(?P<type>\w+)_X(?P<x>\d+)Y(?P<y>\d+)"
  for (site, tile) in siteTile_dict.items():
    site_match = helpers.regex_match(name_pattern, site)
    tile_match = helpers.regex_match(name_pattern, tile)
    site_x = int(site_match.group("x"))
    tile_type = tile_match.group("type")
    siteX_tileType_dict[site_x] = tile_type

  return siteX_tileType_dict

# Main program (if executed as script)
if __name__ == "__main__":
  parser = argparse.ArgumentParser(description="Extracts the TILE_TYPE of every CLB column.")
  parser.add_argument("device_info_json", type=str, help="Input JSON file describing a FPGA's contents.")
  parser.add_argument("out_json", type=str, help="Output JSON file containing the TILE type of every CLB column.")
  args = parser.parse_args()

  extract_clb_col_tile_types(args.device_info_json, args.out_json)

  print("Done")
