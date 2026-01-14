Demo data and code for "Noninvasive 3D mapping of tissue stress using reverberant shear wave"
-------------------------------------------------------

This project contains MATLAB scripts to reproduce the results from a study
on stress inversion in brain tissue, including simulated wavefields and
tumor data. The scripts generate stress maps and visualize wavefields
under different pressure conditions.

Scripts included:
- run_shell_simu.m : Reproduces Figure 2 results for simulated wavefields under different pressures.
- run_tumor_simu.m : Reproduces Figure 3 results for heterogeneous swelling pressures.
- run_meningioma.m : Reproduces Figure 5 results for Meningioma #4, showing wavefields and stress distribution.

-------------------------------------------------------
1. System Requirements
-------------------------------------------------------
- Software: MATLAB R2025a
- Operating System: Windows 10/11, macOS 13+, Linux distributions supporting MATLAB 2025a
- Dependencies: No additional toolboxes required beyond standard MATLAB installation
- Non-standard hardware: None (CPU computation, GPU not required)
- Tested on: MATLAB 2025a on Windows 11 

-------------------------------------------------------
2. Installation Guide
-------------------------------------------------------
1. Install MATLAB R2025a following standard instructions from MathWorks.
2. Download or clone the project folder containing all MATLAB scripts and dataset `.mat` files.
3. Ensure the folder containing scripts is added to MATLAB path.

-------------------------------------------------------
3. Demo
-------------------------------------------------------
To reproduce the demo figures using the provided datasets:

1. Open MATLAB and set the current folder to the project directory.
2. Run the scripts sequentially:
   a. run_shell_simu.m : Generates stress inversion results for Figure 2.
   b. run_tumor_simu.m : Generates stress inversion results for Figure 3.
   c. run_meningioma.m : Processes Meningioma #4 dataset and visualizes T1 map, wavefields, and stress distribution.

Expected output:
- Figure 2: Estimated vs. ground truth stress maps under different pressures.
- Figure 3: Stress inversion for heterogeneous swelling pressures with radial vs original direction fields.
- Figure 5: T1-weighted MRI slice, tumor wavefields (u1, u2, u3), and estimated stress distribution.

Expected run time:
- <10s per script on a normal desktop computer (Intel i5/i7 CPU, 16GB RAM).
