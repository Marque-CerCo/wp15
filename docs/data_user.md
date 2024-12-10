# Data user

The data user is the researcher that aims to answer a specific research question using the data that is made available for analysis through the SIESTA platform. As the data is sensitive, the data itself is not directly available for download. The SIESTA platform allows the data user to interactively implement an analysis, which eventually is converted to an Apptainer and executed by the platforn owner on the data of behalf of the data user.

## Developing and testing the analysis

The data analysis can be implemented on basis of any analysis tool and/or analysis environment, given that it is possible to run the analysis in batch mode without user input. Graphical user interface dialogs that ask a question are not possible.

### General recommendations

Install all software and all dependencies from the command line, as that will facilitate the implementation of the container.

Once the container is built, it is read only. Installing additional software dependencies from within the analysis environment (for example downloading and installing "plug-ins" on the fly) will not work. If software dependencies need to be installed from within the analysis environment, this must be done in the container definition file, not in the analysis pipeline. See for an example the usecase-2.1 container with `r-base` and the the call to `install.packages` for the dependencies.

The only two directories that are shared with the analysis pipeline are directory with the input and the output data. The input directory is to be assumed to be read-only. The output directory can be used in any way you like, but only the files in the `whitelist.txt` with group level aggregate data will be shared with the data user.

During development and testing, the data user has access to an anonymous and scrambled version of the original dataset. This scrambled dataset has all the technical features of the original data, but the results of the analysis on this data should be assumed to be meaningless.

To facilitate debugging, the data user's analysis scripts should give explicit error messages. Rather than a try-except statement that prints "something went wrong", the analysis script should show _where_ in the analysis it went wrong (i.e., in which step, and on which subject) and _what_ went wrong. When possible, show a full stack trace of the error.

### Participant level

T.b.d.

### Group level

T.b.d.

## Storage requirements

The data user must specify to the platform owner what the storage requirements are for the analysis. How many file are created, how much storage does that require, what is the retention period of the intermediate data, and what data files comprise the final results that the data user needs.

The original dataset is not accessible to the data user and should be considered read-only. The analysis pipeline should not write any results to the original dataset. There is one output directory to hold the intermediate (scratch) results, the participant-level results, and the group-level results. It is up to the data user how to organize the data in the output directory.

## Computational requirements

The data user must specify to the platform owner what the computational requirements are for the analysis. Besides the amount of computational time and memory of the processes, the data user can specify whether the participant-level step in the analysis can be executed in parallel or not.

The analysis must be implemented as a containerized [BIDS application](https://doi.org/10.1371/journal.pcbi.1005209). For development and testing we recommend to use a Linux-based environment where the data user has full administrative rights to install software and dependencies. The steps for software and dependency installation must be transferred to a container definition file.

If the data user want to make use of MATLAB in the analysis, they should give the plarform owner access to the MATLAB license server and provide the `LM_LICENSE_FILE` environment variable.