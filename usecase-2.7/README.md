# SIESTA - work package 15 - use case 2.7

This is a specific use case that serves as a prototype for development and testing the SIESTA computational strategy for sensitive medical imaging data on representative BIDS datasets. The general outline is provided in the documentation. In short, it consists of these steps:

- the data rights holder making a scrambled version of the data available
- the data user implementing and testing the pipeline on the scrambled version
- the data rights holder executing the pipeline on the real data

# Data rights holder

## Summary of the input data

This dataset contains fMRI recordings from 6 participants collected across 10 to 11 scanning sessions per subject, during which they were exposed to more than 8,000 stimuli composed of natural scene images and their associated textual captions. Each session consisted of 13 to 16 functional runs, with every run containing sequences of image and text stimuli presented in random order, interleaved with fixation periods and occasional mental imagery trials. The stimuli were selected from the COCO dataset and were designed to investigate shared semantic representations across visual perception, language processing, and mental imagery.

During the experiment, participants performed a one-back matching task in which they identified whether consecutive stimuli matched either within the same modality (image–image or text–text) or across modalities (image–text). In addition to perceptual trials, the dataset includes guided mental imagery sessions where participants imagined scenes associated with previously learned captions. Repeated presentations of a shared subset of stimuli were also included to improve signal reliability and support benchmarking analyses.

The dataset follows the BIDS organization standard and includes subject-specific folders containing anatomical and functional MRI scans for each session, stimulus files with image references and corrected captions, and participant drawings produced after the imagery tasks. It also provides preprocessed beta maps for training, test, and imagery conditions in both volumetric and surface-based representations.

## Data citation

https://doi.org/10.7554/eLife.107933

## Legal aspects of the input data

License CCO

# Data user

## Pipeline results

The analysis results in ...

## Computational requirements for the participant level

The execution of the pipeline for each participant takes ...

## Computational requirements for the group level

The execution of the group-level pipeline takes ...

## Output data

The output data that is to be shared consists of folders and files that represent group-level aggregated data. Many more individual-subject files are generated but these should not be shared with the researcher. The whitelist.txt file contains a complete list of the output data that is to be shared.
