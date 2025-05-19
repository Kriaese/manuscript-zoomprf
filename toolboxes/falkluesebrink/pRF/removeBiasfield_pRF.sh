#!/bin/bash
data=$1
prfpath=$2
spmpath=$3
biascorrpath=$4

echo ""
echo "------------------------------------------------------------------------------"
echo "| Performing bias field correction using SPM12"
echo "------------------------------------------------------------------------------"

matlab -nosplash -nodisplay -r "\
addpath('${prfpath}');\
addpath('${spmpath}');\
addpath('${biascorrpath}');\
preproc_pRF('"${data}"', '"${spmpath}"');\
rmpath('"${prfpath}"');\
rmpath('"${spmpath}"');\
rmpath('"${biascorrpath}"');\
exit;"
