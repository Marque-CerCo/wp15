# Product owner

The product owner is the person or organization responsible for the SIESTA infrastructure. They take care of the secure storage and compute environment and allow "data rights holders" to upload data to the platform and "data users" to perform analyses on that data.

The neuroimaging use cases in wp15 require the data to be organized according to the [BIDS format](http://bids-standard.org/), and the analysis to be implemented as a containerized [BIDS application](https://doi.org/10.1371/journal.pcbi.1005209). The product owner should be able to verify the validity of the dataset with the [BIDS validator](https://bids-standard.github.io/bids-validator/).

## Storage requirements

The data rights holder should specify how large the dataset is that they want to have stored on the SIESTA system.

Since large amounts of data are expected to be transferred (many GB, over many files), the transfer may take a considerable time.

There should be a possibility to check the completeness and integrity of the transferred files, for example using a [manifest file](https://en.wikipedia.org/wiki/Manifest_file) containing checksums and an application like [md5sum](https://en.wikipedia.org/wiki/Md5sum).

The product owner should get information from the data rights holder on:

- the total amount of data that is to be transferred (in GB or TB)
- the number of files and directories that the data comprises of
- a manifest file to check completeness and integrity after data transfer
- the retention period of the data on the SIESTA storage system

## Uploading the data by the data rights holder

Assuming that the SIESTA platform implements a secure file transfer protocol that is accessible to the data rights holder, then the data rights holder can initiate the data transfer. The product owner should provide upload instructions to the data rights holder.

## Downloading the data by the product owner

Assuming that the SIESTA platform does _not_ implement a secure file transfer protocol accessible to the data rights holder, the data rights holder needs to give the product owner access to the dataset and the product owner initiates the transfer.

In the different use cases under wp15 we have identified different transfer mechanisms that data rights holders may use. Furthermore, there are a number of generic data transfer mechanisms that the data rights holders may use.

- OpenNeuro command-line interface
- OSF command-line interface
- DataLad (based on git-annex)
- AWS S3
- sftp
- scp
- GridFTP
- ftp
- webdav
- wget
- curl

Some of these allow for recursively downloading a directory containing files and subdirectories. Others are more suited for the download of a single file. In case the dataset being transferred is contained in a (potentially compressed) archive, such as a zip, tar, tgz, or rar file, the product owner must "unzip" the dataset.  

Besides storing the dataset, disk space should be made available to allow for intermediate and final results.

A regular analysis on the dataset often involves two phases: computations at the "participant" level (looping over all subjects), followed by computations at the "group" level (aggregating results over subjects). It is quite common that the participant-level computations result in intermediate data that is of a similar size as the original data.

## Computational requirements

The "participant" level computations can in principle be parallelized over subjects. The "group" level computations usually do not involve or allow for parallel computation.

The data user decides on the analysis that is to be executed on the data. Hence the the data user must specify the computational requirements, or at least provide an estimate of the computational requirements. Some computations will scale linearly in time with the dataset size (for example 2x as many subjects in the dataset means 2x longer computations) but other computations will have a non-linear relationship to the dataset size.

The product owner should get information from the data user on:

- the number of processes to run
- whether these run sequentially or in parallel
- the number of cores per process
- the amount of memory per process
- the amount of computational time per process

## Executing the computations

SInce the data user cannot have direct access to the sensitive data, the computation is to be initiated by the product owner. Following the computations, the results are potentially reviewd by the data rights holder and shared with the data user.

The analysis is to be implemented by the data user as a containerized [BIDS application](https://doi.org/10.1371/journal.pcbi.1005209). To allow development, testing , and deployment on the compute environment of the data user, we have settled on [Apptainer](https://apptainer.org). If needed, the platform operator should be able to convert the apptainer image into a docker image.
