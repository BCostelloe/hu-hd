# Zebra Vigilance Analyses
Code for the analysis of individual and collective vigilance of zebras

## Data availability
Raw data for these analyses are available on the Herd Hover server. Data types are as follows:
- Movement trajectories: these are grouped by observation. They include all tracks from the observation, including those of non-focal animals that may only appear for a few frames. Each track consists of a continuous trajectory segment. Multiple segments may represent a single individual if, for example, the individual briefly leaves the frame during the observation. Currently, tracks are available for the following observations:
    - observation015
    - observation027
    - observation066
    - observation074
- Track metadata: these files provide metadata for the movement trajectories, including individual and species IDs, as well as whether the track represents a "focal" individual or not.

### Step 1: Data cleaning
To prepare the data for analysis, the first step is to match up the tracks with the individual and species IDs and then remove all non-focal tracks. This is done in the data-cleaning notebook.
