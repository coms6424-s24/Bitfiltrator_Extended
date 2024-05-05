# Bitfiltrator Extended to Support Xilinx 7-Series Device Architecture

#### Original Code + Paper by Sahand Kashani, Mahyar Emami, and James R. Larus
#### Extension to 7-series by Noam Hirschorn, Isabelle Friedfeld-Gebaide, and Dan Ivanovich

## Description
This is our project for COMS 6424: Hardware Security. We looked at the paper "Bitfiltrator: a General Approach for Reverse-Engineering Xilinx Bitstream Formats," which included a codebase for reversing the structure of FPGA Bitstreams for Xilinx Ultrascale and Ultrascale+ devices. Their codebase centered around the `src/create_device_summary.py` CLI, which would automate the reversing process described in their paper and output a summary of the extracted information. We made it our goal to modify their codebase to extend `create_device_summary.py`'s functionality to apply to Xilinx 7-Series devices.

## Requirements
This codebase works on a Linux environment with Vivado v2022.1 installed. Testing during development was done on a device running Ubuntu 22.04 running Python 3.10.13.

Please install Python 3.10, Vivado 2022.1, and the pip requirements (`pip install -r requirements.txt`)

## Execution
Run `python src/create_device_summary.py <FPGA part number> <working dir path> <output json path>`. Do NOT run multiple times on different FPGA parts with the same working directory path - the code will assume any existing bitstreams from the previous executions belong to the current device, and things will break.

**Important note on FPGA part numbers**: The 7-Series devices encode their part numbers into their bitstreams differently than US/US+, with some devices only saving part of their part number. For example, bitstreams for the `xc7a12tcpg238-1` encode their part number into their bitstream as `7a12tcpg238`. Thus, one of our adjustments tries to find an exact part number match, but, in the case of 7-Series partial part number encoding, will default to the first partial match it finds. Thus, when picking an FPGA part number from `resources/parts_all.json` or `resources/parts_webpack.json` to run (we recommend picking from `parts_webpack`), **please use the FIRST part number in any list**. For example, if you want to use a part number for the `xc7a12t`, you'd look at the following line:
```json
"xc7a12t": ["xc7a12tcpg238-1","xc7a12tcpg238-2","xc7a12tcpg238-2L","xc7a12tcpg238-3","xc7a12tcsg325-1","xc7a12tcsg325-2","xc7a12tcsg325-2L","xc7a12tcsg325-3"],
```  
In this case, you **must** pick the part number `xc7a12tcpg238-1`, the first in the list. Otherwise, the code will not be able to correctly match your bitstream metadata to the correct FPGA part architecture due to the incomplete encoding of 7-series part numbers in the bitstream. 

We recommend only **running the code on Artix-7 devices** (see Known Issues).
## Recommended (Tested) Execution Arguments
The following example statements have been tested and confirmed to work:
```
python src/create_device_summary.py xc7a12tcpg238-1 wdir-xc7a12tcpg238-1 out-xc7a12tcpg238-1.json
```

```
python src/create_device_summary.py xc7a25tcpg238-1 wdir-xc7a25tcpg238-1 out-xc7a25tcpg238-1.json
```

```
python src/create_device_summary.py xc7a25tlcpg238-2L wdir-xc7a25tlcpg238-2L out-xc7a25tlcpg238-2L.json
```
All of these are Artix-7 devices in `resources/parts_webpack.json`.
## Known Issues
In its current state, this project cannot be called a true extension - some modifications that were made to account for differences in 7-Series architecture will cause fatal issues when running on Ultrascale/Ultrascale+ devices, and we did not have time to go back through and adapt all of these modified functions to adapt to US/7-Series. Thus, this codebase would require a bit more work, such as splitting extraction functions/summary dict structure into separate classes/functions depending on the architecture. Generally, we tried to implement things flexibly but would sometimes have to commit to adjusting shared data structures in a way that would only work for 7-Series.

Some 7-Series devices/part numbers seem to encode some of their metadata, eg their `license` data, differently than others. We did not have time to test enough devices to find all of these issues, so this codebase will not work for 100% of 7-Series devices. It will reverse almost all of the information about the devices, but may fail in trying to serialize device metadata into JSON output.

We did all development and testing around Artix-7 devices and did not have time to do development work for other 7-Series families. We recommend only running the code on Artix-7 devices. 