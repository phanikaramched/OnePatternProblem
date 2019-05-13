# OnePatternProblem

adds one pattern at the end of hdf5 EBSD file to sort out the issue with non-rectangular map.

Due to a likely camera buffer error, the last data point (and pattern) are missed in the .bcf file.
Converting to .hdf5 file produces a non-rectangular map and xEBSDv3 fails. This fix copies the second-last pattern to the last point and adjusts map positions accordingly.