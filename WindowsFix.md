# Adapt Bitfiltrator for Windows

## Installation differences

In [the origninal readme](./README.md) the installation process is slightly different

1. Download and install conda. Follow GUI instructions.

    ``` ps
    wget https://repo.anaconda.com/miniconda/Miniconda3-latest-Windows-x86_64.exe
    -O ~/Downloads/Miniconda3-latest-Windows-x86_64.exe
    cd ~/Downloads
    ./Miniconda3-latest-Windows-x86_64.exe
    ```

2. Set up python 3.10 virtual environment called "bitfiltrator" and install
dependencies

    ``` ps
    conda create -n bitfiltrator python=3.10
    conda activate bitfiltrator
    pip install joblib more_itertools numpy pandas
    ```

3. Add vivado to your `PATH`

    1. Press Windows + R to open the Windows Run prompt.
    2. Type in ``sysdm.cpl`` and click OK. If prompted allow for app to make
    changes to your device.
    3. Open the "Advanced" tab and click on the "Environment Variables" button
    in the System Properties window.
    4. Double-click on "Path" under "System variables"
    5. Click "New" Button
    6. Add the following:

        ```ps
        C:\Xilinx\Vivado\2023.2
        ```

    7. Repeat 5 and add the following:

        ```ps
        C:\Xilinx\Vivado\2023.2\bin
        ```

4. You must ensure the virtual environment is active and Vivado is available in
your `PATH` before calling Bitfiltrator. This can generally be performed by
executing the following commands:

    ```bash
    conda activate bitfiltrator
    ```

## SRC file differences

Various files expliclity call Python3, which does not work on Windows. The `src`
code relies on Vivado's Python3 for to run certain commands. So to adapt the
code to work on Windows all explicit Python3 references need to be changed to
python.

1. Change `src\tcl\helpers.tcl` line 311 to:

    ```tcl
      # set formatted [exec python -m json.tool << ${json_str}]
    ```

2. Change `src\tcl\helpers.tcl` line 311 and 312 change python3 to python

    ```tcl
      set formatted [exec python ${format_json_script} --sort_keys << ${json_str}]
    ```

3. Change `src\helpers.py` line 77 python3 to python

    ```python
        cmd = ["python", script_path, *args]

    ```
