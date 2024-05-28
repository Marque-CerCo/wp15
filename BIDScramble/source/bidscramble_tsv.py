#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Adds scrambled versions of the tsv files in the input directory to the output directory.
"""

import argparse
import textwrap
import pandas as pd
import shutil
import numpy as np
from pathlib import Path


def bidscramble_tsv(inputdir: str, outputdir: str, covariance: list[str], include: list[str]):

    # Defaults
    inputdir  = Path(inputdir).resolve()
    outputdir = Path(outputdir).resolve()
    outputdir.mkdir(parents=True, exist_ok=True)

    # Create pseudo-random out data for all files of each included data type
    for pattern in include:

        inputfiles = inputdir.rglob(pattern)

        for inputfile in inputfiles:

            # Define the output target
            outputfile = outputdir/inputfile.relative_to(inputdir)

            # Load or copy the data
            tsvdata = pd.DataFrame()
            if inputfile.suffix == '.tsv':
                print(f"Reading: {inputfile}")
                tsvdata = pd.read_csv(inputfile, sep='\t')
            else:
                print(f"Saving: {outputfile}")
                shutil.copyfile(inputfile, outputfile)
                continue

            # Permute columns that are not of interest (i.e. preserving the relation between them)
            for column in tsvdata.columns:
                if column not in covariance:
                    tsvdata[column] = np.random.permutation(tsvdata[column])

            # Permute the rows
            tsvdata = tsvdata.sample(frac=1).reset_index(drop=True)

            # Save the output data
            print(f"Saving: {outputfile}\n ")
            tsvdata.to_csv(outputfile, sep='\t', index=False, encoding='utf-8', na_rep='n/a')


def main():
    """Console script entry point"""

    # Parse the input arguments and run main(args)
    class CustomFormatter(argparse.ArgumentDefaultsHelpFormatter, argparse.RawDescriptionHelpFormatter):
        pass

    parser = argparse.ArgumentParser(formatter_class=CustomFormatter, description=textwrap.dedent(__doc__),
                                     epilog='examples:\n'
                                            '  bidscramble bids pseudobids -c age sex height -i *.tsv *.json CHANGES README\n\n'
                                            'author:\n'
                                            '  Marcel Zwiers\n ')
    parser.add_argument('inputdir',           help='The BIDS input-directory with the real data')
    parser.add_argument('outputdir',          help='The BIDS output-directory with generated pseudo data')
    parser.add_argument('-c', '--covariance', help='A list of variable names between which the covariance structure is preserved when generating the pseudo data', nargs='+')
    parser.add_argument('-i', '--include',    help='A list of include pattern(s) that select the files in the BIDS input-directory that are produced in the output directory', nargs='+', default=['*'])
    args = parser.parse_args()

    bidscramble_tsv(inputdir=args.inputdir, outputdir=args.outputdir, covariance=args.covariance, include=args.include)


if __name__ == "__main__":
    main()
