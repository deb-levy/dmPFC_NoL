# dmPFC_NoL
This code accompanies Levy et al., 2025, "Role for left dorsomedial prefrontal cortex in self-generated, but not externally-cued, language production". Relies on pre-existing VLSM (https://aphasialab.org/vlsm/), MLSM (https://github.com/atdemarco/svrlsmgui), and odds (https://www.mathworks.com/matlabcentral/fileexchange/15347-odds) toolboxes.

## Key analysis files

| Filename  | Description |
| ------------- | ------------- |
| nol_analysis.m  | The main analysis code.  |

## Data files available upon reasonable request

| Filename  | Description |
| ------------- | ------------- |
| vlsm_design.txt  | Design file used for main VLSM analysis  |
| vlsm_design_tumorOnly.txt  | Design file used for tumor-only VLSM analysis  |
| mlsm_design.csv  | Design file used for main MLSM analysis  |
| lesions | Folder containing smoothed lesion masks as nifti files |

## Auxiliary files

| Filename  | Description |
| ------------- | ------------- |
| lsm_ROI.nii | LSM-ROI as created from union of VLSM and MLSM clusters |
| mlsm_params.mat | Parameter file to load into svrlsmgui to recreate MLSM analysis |


