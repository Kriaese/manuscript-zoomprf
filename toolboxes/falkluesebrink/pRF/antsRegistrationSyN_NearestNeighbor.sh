#!/bin/bash

VERSION="1"

# Version 1 by Falk Lüsebrink
# falk dot luesebrink at dzne dot de
# 16.07.2024

# Changes made to the original script:
# 1) NearestNeighbor interpolation instead of linear interpolation
# 2) Changed size of matrix for "large images" to 1024

# trap keyboard interrupt (control-c)
trap control_c SIGINT

function setPath {
    cat <<SETPATH

--------------------------------------------------------------------------------------
Error locating ANTS
--------------------------------------------------------------------------------------
It seems that the ANTSPATH environment variable is not set. Please add the ANTSPATH
variable. This can be achieved by editing the .bash_profile in the home directory.
Add:

ANTSPATH=/home/yourname/bin/ants/

Or the correct location of the ANTS binaries.

Alternatively, edit this script ( `basename $0` ) to set up this parameter correctly.

SETPATH
    exit 1
}

# Uncomment the line below in case you have not set the ANTSPATH variable in your environment.
# export ANTSPATH=${ANTSPATH:="$HOME/bin/ants/"} # EDIT THIS

#ANTSPATH=YOURANTSPATH
if [[ ${#ANTSPATH} -le 3 ]];
  then
    setPath >&2
  fi

ANTS=${ANTSPATH}/antsRegistration

if [[ ! -s ${ANTS} ]];
  then
    echo "antsRegistration program can't be found. Please (re)define \$ANTSPATH in your environment."
    exit
  fi

function Usage {
    cat <<USAGE

Usage:

`basename $0` -d ImageDimension -f FixedImage -m MovingImage -o OutputPrefix

Compulsory arguments:

     -d:  ImageDimension: 2 or 3 (for 2 or 3 dimensional registration of single volume)

     -f:  Fixed image(s) or source image(s) or reference image(s)

     -m:  Moving image(s) or target image(s)

     -o:  OutputPrefix: A prefix that is prepended to all output files.

Optional arguments:

     -n:  Number of threads (default = ITK_GLOBAL_DEFAULT_NUMBER_OF_THREADS if defined, otherwise 1)

     -i:  initial transform(s) --- order specified on the command line matters

     -t:  transform type (default = 's')
        t: translation (1 stage)
        r: rigid (1 stage)
        a: rigid + affine (2 stages)
        s: rigid + affine + deformable syn (3 stages)
        sr: rigid + deformable syn (2 stages)
        so: deformable syn only (1 stage)
        b: rigid + affine + deformable b-spline syn (3 stages)
        br: rigid + deformable b-spline syn (2 stages)
        bo: deformable b-spline syn only (1 stage)

     -r:  radius for cross correlation metric used during SyN stage (default = 4)

     -s:  spline distance for deformable B-spline SyN transform (default = 26)

     -g:  gradient step size for SyN and B-spline SyN (default = 0.1)

     -x:  mask(s) for the fixed image space.  Should specify either a single image to be used for
          all stages or one should specify a mask image for each "stage" (cf -t option).  If
          no mask is to be used for a particular stage, the keyword 'NULL' should be used
          in place of a file name.

     -p:  precision type (default = 'f')
        f: float
        d: double

     -j:  use histogram matching (default = 0)
        0: false
        1: true
        
	 -k: use learning estimate once (default = 0)
     	0: false
     	1: true

     -y:  use 'repro' mode for exact reproducibility of output.  Uses GC metric for linear
          stages and a fixed random seed (default = 0).
        0: false
        1: true

     -z:  collapse output transforms (default = 1)

     -e:  Fix random seed to an int value

     NB:  Multiple image pairs can be specified for registration during the SyN stage.
          Specify additional images using the '-m' and '-f' options.  Note that image
          pair correspondence is given by the order specified on the command line.
          Only the first fixed and moving image pair is used for the linear registration
          stages.

Example:

`basename $0` -d 3 -f fixedImage.nii.gz -m movingImage.nii.gz -o output

--------------------------------------------------------------------------------------
ANTs was created by:
--------------------------------------------------------------------------------------
Brian B. Avants, Nick Tustison and Gang Song
Penn Image Computing And Science Laboratory
University of Pennsylvania

script by Nick Tustison

USAGE
    exit 1
}

function Help {
    cat <<HELP

Usage:

`basename $0` -d ImageDimension -f FixedImage -m MovingImage -o OutputPrefix

Example Case:

`basename $0` -d 3 -f fixedImage.nii.gz -m movingImage.nii.gz -o output

Compulsory arguments:

     -d:  ImageDimension: 2 or 3 (for 2 or 3 dimensional registration of single volume)

     -f:  Fixed image(s) or source image(s) or reference image(s)

     -m:  Moving image(s) or target image(s)

     -o:  OutputPrefix: A prefix that is prepended to all output files.

Optional arguments:

     -n:  Number of threads (default = ITK_GLOBAL_DEFAULT_NUMBER_OF_THREADS if defined, otherwise 1)

     -i:  initial transform(s) --- order specified on the command line matters

     -t:  transform type (default = 's')
        t: translation (1 stage)
        r: rigid (1 stage)
        a: rigid + affine (2 stages)
        s: rigid + affine + deformable syn (3 stages)
        sr: rigid + deformable syn (2 stages)
        so: deformable syn only (1 stage)
        b: rigid + affine + deformable b-spline syn (3 stages)
        br: rigid + deformable b-spline syn (2 stages)
        bo: deformable b-spline syn only (1 stage)

     -r:  radius for cross correlation metric used during SyN stage (default = 4)

     -s:  spline distance for deformable B-spline SyN transform (default = 26)

     -g:  gradient step size for SyN and B-spline SyN (default = 0.1)

     -x:  mask(s) for the fixed image space.  Should specify either a single image to be used for
          all stages or one should specify a mask image for each "stage" (cf -t option).  If
          no mask is to be used for a particular stage, the keyword 'NULL' should be used
          in place of a file name.

     -p:  precision type (default = 'd')
        f: float
        d: double

     -j:  use histogram matching (default = 0)
        0: false
        1: true
        
     -k: use learning estimate once (default = 0)
     	0: false
     	1: true

     -y:  use 'repro' mode for exact reproducibility of output.  Uses GC metric for linear
          stages and a fixed random seed (default = 0).
        0: false
        1: true

     -z:  collapse output transforms (default = 1)
        0: false
        1: true

     -e:  Fix random seed to an int value

     NB:  Multiple image pairs can be specified for registration during the SyN stage.
          Specify additional images using the '-m' and '-f' options.  Note that image
          pair correspondence is given by the order specified on the command line.
          Only the first fixed and moving image pair is used for the linear resgitration
          stages.

--------------------------------------------------------------------------------------
Get the latest ANTs version at:
--------------------------------------------------------------------------------------
https://github.com/ANTsX/ANTs/

--------------------------------------------------------------------------------------
Read the ANTS documentation at:
--------------------------------------------------------------------------------------
http://stnava.github.io/ANTs/

--------------------------------------------------------------------------------------
ANTS was created by:
--------------------------------------------------------------------------------------
Brian B. Avants, Nick Tustison and Gang Song
Penn Image Computing And Science Laboratory
University of Pennsylvania

Relevent references for this script include:
   * http://www.ncbi.nlm.nih.gov/pubmed/20851191
   * http://www.frontiersin.org/Journal/10.3389/fninf.2013.00039/abstract
--------------------------------------------------------------------------------------
script by Nick Tustison
--------------------------------------------------------------------------------------

HELP
    exit 1
}

function reportMappingParameters {
    cat <<REPORTMAPPINGPARAMETERS

--------------------------------------------------------------------------------------
 Mapping parameters
--------------------------------------------------------------------------------------
 ANTSPATH is $ANTSPATH

 Dimensionality:           $DIM
 Output name prefix:       $OUTPUTNAME
 Fixed images:             ${FIXEDIMAGES[@]}
 Moving images:            ${MOVINGIMAGES[@]}
 Mask images:              ${MASKIMAGES[@]}
 Initial transforms:       ${INITIALTRANSFORMS[@]}
 Number of threads:        $NUMBEROFTHREADS
 Spline distance:          $SPLINEDISTANCE
 SyN gradient step:        $SYNGRADIENTSTEP
 Transform type:           $TRANSFORMTYPE
 CC radius:                $CCRADIUS
 Precision:                $PRECISIONTYPE
 Use histogram matching    $USEHISTOGRAMMATCHING
 Use learning estimate	   $USELEARNINGESTIMATE
 Repro                     $REPRO
======================================================================================
REPORTMAPPINGPARAMETERS
}

cleanup()
{
  echo "\n*** Performing cleanup, please wait ***\n"

  runningANTSpids=$( ps --ppid $$ -o pid= )

  for thePID in $runningANTSpids
  do
      echo "killing:  ${thePID}"
      kill ${thePID}
  done

  return $?
}

control_c()
# run if user hits control-c
{
  echo -en "\n*** User pressed CTRL + C ***\n"
  cleanup
  exit $?
  echo -en "\n*** Script cancelled by user ***\n"
}

# Provide output for Help
if [[ "$1" == "-h" || $# -eq 0 ]];
  then
    Help >&2
  fi

#################
#
# default values
#
#################

DIM=3
FIXEDIMAGES=()
MOVINGIMAGES=()
INITIALTRANSFORMS=()
OUTPUTNAME=output
NUMBEROFTHREADS=0
SPLINEDISTANCE=26
SYNGRADIENTSTEP=0.1
TRANSFORMTYPE='s'
PRECISIONTYPE='f'
CCRADIUS=4
MASKIMAGES=()
USEHISTOGRAMMATCHING=0
USELEARNINGESTIMATE=0
COLLAPSEOUTPUTTRANSFORMS=1
RANDOMSEED=0
REPRO=0

# reading command line arguments
while getopts "d:e:f:g:h:i:k:m:j:n:o:p:r:s:t:x:y:z:" OPT
  do
  case $OPT in
      h) #help
   Help
   exit 0
   ;;
      d)  # dimensions
   DIM=$OPTARG
   ;;
      e)  # seed
   RANDOMSEED=$OPTARG
   ;;
      x)  # inclusive mask
   MASKIMAGES[${#MASKIMAGES[@]}]=$OPTARG
   ;;
      f)  # fixed image
   FIXEDIMAGES[${#FIXEDIMAGES[@]}]=$OPTARG
   ;;
      g)  # SyN gradient step
   SYNGRADIENTSTEP=$OPTARG
   ;;
      j)  # histogram matching
   USEHISTOGRAMMATCHING=$OPTARG
   ;;
   	  k) # learning estimate once
   USELEARNINGESTIMATE=$OPTARG
   ;;
      m)  # moving image
   MOVINGIMAGES[${#MOVINGIMAGES[@]}]=$OPTARG
   ;;
      i)  # initial transform
   INITIALTRANSFORMS[${#INITIALTRANSFORMS[@]}]=$OPTARG
   ;;
      n)  # number of threads
   NUMBEROFTHREADS=$OPTARG
   ;;
      o) #output name prefix
   OUTPUTNAME=$OPTARG
   ;;
      p)  # precision type
   PRECISIONTYPE=$OPTARG
   ;;
      r)  # cc radius
   CCRADIUS=$OPTARG
   ;;
      s)  # spline distance
   SPLINEDISTANCE=$OPTARG
   ;;
      t)  # transform type
   TRANSFORMTYPE=$OPTARG
   ;;
      y)  # reproducibility
   REPRO=$OPTARG
   ;;
      z)  # collapse output transforms
   COLLAPSEOUTPUTTRANSFORMS=$OPTARG
   ;;
     \?) # getopts issues an error message
   echo "$USAGE" >&2
   exit 1
   ;;
  esac
done

###############################
#
# Check inputs
#
###############################
if [[ ${#FIXEDIMAGES[@]} -ne ${#MOVINGIMAGES[@]} ]];
  then
    echo "Number of fixed images is not equal to the number of moving images."
    exit 1
  fi

for(( i=0; i<${#FIXEDIMAGES[@]}; i++ ))
  do
    if [[ ! -f "${FIXEDIMAGES[$i]}" ]];
      then
        echo "Fixed image '${FIXEDIMAGES[$i]}' does not exist.  See usage: '$0 -h 1'"
        exit 1
      fi
    if [[ ! -f "${MOVINGIMAGES[$i]}" ]];
      then
        echo "Moving image '${MOVINGIMAGES[$i]}' does not exist.  See usage: '$0 -h 1'"
        exit 1
      fi
  done

##############################
#
# Mask stuff
#
##############################

NUMBEROFMASKIMAGES=${#MASKIMAGES[@]}

MASKCALL=""
if [[ ${#MASKIMAGES[@]} -gt 0 ]];
  then
    for (( i = 0; i < ${#MASKIMAGES[@]}; i++ ))
      do
        MASKCALL="${MASKCALL} -x ${MASKIMAGES[$i]}"
      done
  fi

###############################
#
# Set number of threads
#
###############################

ORIGINALNUMBEROFTHREADS=${ITK_GLOBAL_DEFAULT_NUMBER_OF_THREADS}

# NUMBEROFTHREADS is > 0 if the option has been set to a positive value
if [[ $NUMBEROFTHREADS -lt 1 ]];
  then
    # Number of threads not set on the command line, try ITK_GLOBAL_DEFAULT_NUMBER_OF_THREADS
    if [[ $ORIGINALNUMBEROFTHREADS -gt 0 ]];
      then
	NUMBEROFTHREADS=$ORIGINALNUMBEROFTHREADS
      else
	NUMBEROFTHREADS=1
      fi
  fi

ITK_GLOBAL_DEFAULT_NUMBER_OF_THREADS=$NUMBEROFTHREADS
export ITK_GLOBAL_DEFAULT_NUMBER_OF_THREADS

##############################
#
# Print out options
#
##############################

reportMappingParameters

##############################
#
# Infer the number of levels based on
# the size of the input fixed image.
#
##############################

ISLARGEIMAGE=0

SIZESTRING=$( ${ANTSPATH}/PrintHeader ${FIXEDIMAGES[0]} 2 )
SIZESTRING="${SIZESTRING%\\n}"
SIZE=( `echo $SIZESTRING | tr 'x' ' '` )

for (( i=0; i<${#SIZE[@]}; i++ ))
  do
    if [[ ${SIZE[$i]} -gt 1024 ]]; # CHANGED from 256 to 1024; FL
      then
        ISLARGEIMAGE=1
        break
      fi
  done

##############################
#
# Construct mapping stages
#
##############################

RIGIDCONVERGENCE="[ 500x250,1e-8,10 ]" # Changed from 1000x500x250x100 for testing
RIGIDSHRINKFACTORS="2x1"
RIGIDSMOOTHINGSIGMAS="1x0vox"

AFFINECONVERGENCE="[ 1000x500x250x100,1e-6,10 ]"
AFFINESHRINKFACTORS="8x4x2x1"
AFFINESMOOTHINGSIGMAS="3x2x1x0vox"

SYNCONVERGENCE="[ 100x50x25x10,1e-6,5 ]"
SYNSHRINKFACTORS="8x4x2x1"
SYNSMOOTHINGSIGMAS="4x2x1x0vox"

if [[ $ISLARGEIMAGE -eq 1 ]];
  then
    RIGIDCONVERGENCE="[ 1000x1000x500x250,1e-8,5 ]"
    RIGIDSHRINKFACTORS="8x4x2x1"
    RIGIDSMOOTHINGSIGMAS="3x2x1x0vox"

    AFFINECONVERGENCE="[ 1000x500x250x100,1e-6,10 ]"
    AFFINESHRINKFACTORS="12x8x4x2"
    AFFINESMOOTHINGSIGMAS="4x3x2x1vox"

    SYNCONVERGENCE="[ 100x100x70x50x20,1e-6,10 ]"
    SYNSHRINKFACTORS="10x6x4x2x1"
    SYNSMOOTHINGSIGMAS="5x3x2x1x0vox"
  fi

LINEARMETRIC="MI"
LINEARMETRICPARAMETER=32

# Precedence for random seeding
# 1. Command line option -e
# 2. Environment variable ANTS_RANDOM_SEED
# 3. Fixed seed = 1 if run in repro mode
# 4. ITK default (system time)

if [[ -n ${ANTS_RANDOM_SEED} ]] && [[ ${RANDOMSEED} -eq 0 ]];
  then
    RANDOMSEED=${ANTS_RANDOM_SEED}
  fi

if [[ $REPRO -eq 1 ]];
  then
    LINEARMETRIC="GC"
    LINEARMETRICPARAMETER=1
    if [[ ${RANDOMSEED} -eq 0 ]];
      then
        RANDOMSEED=1
      fi
  fi

INITIALSTAGE="--initial-moving-transform [ ${FIXEDIMAGES[0]},${MOVINGIMAGES[0]},1 ]"

if [[ ${#INITIALTRANSFORMS[@]} -gt 0 ]];
  then
    INITIALSTAGE=""
    for(( i=0; i<${#INITIALTRANSFORMS[@]}; i++ ))
      do
        INITIALSTAGE="$INITIALSTAGE --initial-moving-transform ${INITIALTRANSFORMS[$i]}"
      done
  fi

tx=Rigid
if [[ $TRANSFORMTYPE == 't' ]] ; then
  tx=Translation
fi

RIGIDSTAGE="--transform ${tx}[ 0.1 ] \
            --metric ${LINEARMETRIC}[ ${FIXEDIMAGES[0]},${MOVINGIMAGES[0]},1,${LINEARMETRICPARAMETER},None,1 ] \
            --convergence $RIGIDCONVERGENCE \
            --shrink-factors $RIGIDSHRINKFACTORS \
            --smoothing-sigmas $RIGIDSMOOTHINGSIGMAS"

AFFINESTAGE="--transform Affine[ 0.1 ] \
             --metric ${LINEARMETRIC}[ ${FIXEDIMAGES[0]},${MOVINGIMAGES[0]},1,${LINEARMETRICPARAMETER},None,1 ] \
             --convergence $AFFINECONVERGENCE \
             --shrink-factors $AFFINESHRINKFACTORS \
             --smoothing-sigmas $AFFINESMOOTHINGSIGMAS"

SYNMETRICS=''
for(( i=0; i<${#FIXEDIMAGES[@]}; i++ ))
  do
    SYNMETRICS="$SYNMETRICS --metric ${LINEARMETRIC}[ ${FIXEDIMAGES[$i]},${MOVINGIMAGES[$i]},1,${LINEARMETRICPARAMETER},None,1 ]"
  done

SYNSTAGE="${SYNMETRICS} \
          --convergence $SYNCONVERGENCE \
          --shrink-factors $SYNSHRINKFACTORS \
          --smoothing-sigmas $SYNSMOOTHINGSIGMAS"

if [[ $TRANSFORMTYPE == 'sr' ]] || [[ $TRANSFORMTYPE == 'br' ]];
  then
    SYNCONVERGENCE="[ 100x50x25,1e-6,10 ]"
    SYNSHRINKFACTORS="4x2x1" 
    SYNSMOOTHINGSIGMAS="2x1x0vox"
          SYNSTAGE="${SYNMETRICS} \
          --convergence $SYNCONVERGENCE \
          --shrink-factors $SYNSHRINKFACTORS \
          --smoothing-sigmas $SYNSMOOTHINGSIGMAS"
  fi

if [[ $TRANSFORMTYPE == 'b' ]] || [[ $TRANSFORMTYPE == 'br' ]] || [[ $TRANSFORMTYPE == 'bo' ]];
  then
    SYNSTAGE="--transform BSplineSyN[ ${SYNGRADIENTSTEP},${SPLINEDISTANCE},0,3 ] \
             $SYNSTAGE"
  fi

if [[ $TRANSFORMTYPE == 's' ]] || [[ $TRANSFORMTYPE == 'sr' ]] || [[ $TRANSFORMTYPE == 'so' ]];
  then
    SYNSTAGE="--transform SyN[ ${SYNGRADIENTSTEP},3,0 ] \
             $SYNSTAGE"
  fi

NUMBEROFREGISTRATIONSTAGES=0
STAGES=''
case "$TRANSFORMTYPE" in
"r" | "t")
  STAGES="$INITIALSTAGE $RIGIDSTAGE"
  NUMBEROFREGISTRATIONSTAGES=1
  ;;
"a")
  STAGES="$INITIALSTAGE $RIGIDSTAGE $AFFINESTAGE"
  NUMBEROFREGISTRATIONSTAGES=2
  ;;
"b" | "s")
  STAGES="$INITIALSTAGE $RIGIDSTAGE $AFFINESTAGE $SYNSTAGE"
  NUMBEROFREGISTRATIONSTAGES=3
  ;;
"br" | "sr")
  STAGES="$INITIALSTAGE $RIGIDSTAGE  $SYNSTAGE"
  NUMBEROFREGISTRATIONSTAGES=2
  ;;
"bo" | "so")
  STAGES="$INITIALSTAGE $SYNSTAGE"
  NUMBEROFREGISTRATIONSTAGES=1
  ;;
*)
  echo "Transform type '$TRANSFORMTYPE' is not an option.  See usage: '$0 -h 1'"
  exit
  ;;
esac

if [[ $NUMBEROFMASKIMAGES -ne 0 && $NUMBEROFMASKIMAGES -ne 1 && $NUMBEROFMASKIMAGES -ne $NUMBEROFREGISTRATIONSTAGES ]];
  then
    echo "The specified number of mask images is not correct.  Please see help menu."
    exit
  fi

PRECISION=''
case "$PRECISIONTYPE" in
"f")
  PRECISION="--float 1"
  ;;
"d")
  PRECISION="--float 0"
  ;;
*)
  echo "Precision type '$PRECISIONTYPE' is not an option.  See usage: '$0 -h 1'"
  exit
  ;;
esac

RANDOMOPT=""

if [[ ! $RANDOMSEED -eq 0 ]]; then
    RANDOMOPT=" --random-seed $RANDOMSEED "
fi

COMMAND="${ANTS} --verbose 1 $RANDOMOPT \
                 --dimensionality $DIM $PRECISION \
                 --collapse-output-transforms $COLLAPSEOUTPUTTRANSFORMS \
                 --output [ $OUTPUTNAME,${OUTPUTNAME}Warped.nii.gz,${OUTPUTNAME}InverseWarped.nii.gz ] \
                 --interpolation NearestNeighbor \
                 --use-histogram-matching ${USEHISTOGRAMMATCHING} \
                 --use-estimate-learning-rate-once ${USELEARNINGESTIMATE} \
                 --winsorize-image-intensities [ 0.005,0.995 ] \
                 $MASKCALL \
                 $STAGES" # Changed from linear interpolation to Nearest Neighbor.

echo " antsRegistration call:"
echo "--------------------------------------------------------------------------------------"
echo ${COMMAND}
echo "--------------------------------------------------------------------------------------"

$COMMAND

###############################
#
# Restore original number of threads
#
###############################

ITK_GLOBAL_DEFAULT_NUMBER_OF_THREADS=$ORIGINALNUMBEROFTHREADS
export ITK_GLOBAL_DEFAULT_NUMBER_OF_THREADS
