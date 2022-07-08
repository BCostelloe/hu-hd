# Zebra Vigilance Analyses
Code for the analysis of individual and collective vigilance of zebras

## Data availability
Data types for these analyses are as follows:
- Movement trajectories (data/raw_tracks/): There is one .npy file per observation which includes all tracks from the observation, including those of non-focal animals that may only appear for a few frames. Each track consists of a continuous trajectory segment. Multiple segments may represent a single individual if, for example, the individual briefly leaves the frame during the observation. Currently, tracks are available for the following observations:
    - observation015
    - observation027
    - observation066
    - observation074
- Track metadata: these files provide metadata for the movement trajectories, including individual and species IDs, as well as whether the track represents a "focal" individual or not.

### Step 0: Data prep (data-cleaning/data-prep.ipynb)
This step takes the .npy files from the raw_tracks folder and reshapes them into dataframes. It also matches up tracks with the track IDs, individual IDs, species IDs, and focal status. This notebook generates the files in the data/tracks/ folder. This step and the raw_tracks folder will not be included in the eventual dataset; rather, the user will start with the track files in the data/tracks/ folder.

### Step 1: Data cleaning (data-cleaning/data-cleaning.ipynb)
In this step, non-zebra and non-focal individuals are removed from the track files, and the track files are saved in the data/clean_tracks/ folder. 

### Step 2: Track segmentation (track-segmentation/)
We are not interested in analyzing vigilance while the animals are running or walking in a targeted manner. Therefore, we need to identify segments where the animal is running and exclude these from further analysis. For this we use track segmentation.

#### 2a. Track smoothing (track-segmentation/track-smoothing.ipynb)
The locations of the tracked animals in each frame are determined by taking the center of a bounding box, which can vary in size and dimensions from frame to frame. This "jitter" introduces noise into the movement trajectories that can make it hard for track segmentation models to identify movement modes. Therefore, we smooth the tracks prior to segmenting them. This notebook reads in the clean tracks and smooths them using 5 different windows: 5 frames, 15 frames, 31 frames, 45 frames, and 61 frames. For each observation, a new .csv file is saved as track-segmentation/tracks-for-segmentation/obXXX_smooth.csv. 

#### 2b. Track subsetting (track-segmentation/track-subsetting.ipynb)