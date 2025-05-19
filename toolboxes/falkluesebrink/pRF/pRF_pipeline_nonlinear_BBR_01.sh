#!/bin/bash
# Pipeline for preprocessing cleaned, converted, and BIDS-standardized functional
# and structural magnetic resonance imaging data acquired at 7T in the scope of 
# a tactile population receptive field (pRF) experiment.   
# ***************************************
# Generated: 13.10.2022 (FL)
# Last modified: 23.08.2024 (SS)
 
# ***************************************
# * Please define variables here
# ***************************************
# Define subject(s) to be processed
sub="01 02 03"

# Define kernels to be used
FWHM="0 1"

# Define sessions to be processed 
ses="01 02 03 04"

# Specify path to data directory
input_directory=/home/sstoll/projects/zoomprf_main/data

# Specify paths to toolbox directories
prf_directory=/home/sstoll/projects/toolboxes/postdoc-kuehn-tuebingen/falkluesebrink/pRF
spm_directory=/home/sstoll/projects/toolboxes/postdoc-kuehn-tuebingen/spm12
biascorr_directory=/home/sstoll/projects/toolboxes/postdoc-kuehn-tuebingen/falkluesebrink/biasCorrection

# Projection fraction for surface projection of functional data with FreeSurfer
projFrac=0.5

# Maximum number of threads used for processing functional data using ANTs
ants_threads_functional=16

# ***************************************
# * Software used
# ***************************************
### For setting up the pipeline and initial validation
# FreeSurfer: freesurfer-linux-ubuntu18_x86_64-7.3.2-20220804-6354275
# ANTs: 2.3.5
# MATLAB: 9.12.0.1884302 (R2022a)
# SPM12: 7771 (for more details, see 'Custom scripts/files used')
# Bash: 4.4.20(1)-release (x86_64-pc-linux-gnu) 
# Ubuntu: 18
# biasCorrection: -/- (https://github.com/fluese/biasCorrection)
#
### For finalizing the pipeline and final validation
# FreeSurfer: freesurfer-linux-ubuntu22_x86_64-7.3.2-20220804-6354275
# ANTs: 2.3.5.dev208-g6f137
# MATLAB: 9.13.0.2193358 (R2022b) Update 5
# SPM12: 7771 (for more details, see 'Custom scripts/files used')
# Bash: 5.1.16(1)-release (x86_64-pc-linux-gnu)
# Ubuntu: 22.04.2 LTS
# biasCorrection: 1 parent 5447c4c commit d85f05f (https://github.com/fluese/biasCorrection)

# ***************************************
# * Custom scripts/files used
# ***************************************
# antsIntrasubjectAverage_NearestNeighbor.sh
# antsRegistrationSyN_NearestNeighbor.sh
# removeBiasfield_pRF.sh
# preproc_pRF.m
# ****************************************
# biasCorrection.m
# defjob.mat
# spm_preproc_run_fl_standalone.m (changed based on SPM12: 6365)
# spm_preproc_write8_fl_standalone.m (changed based on SPM12: 6137)

# ***************************************
# * Setup
# ***************************************
# Make sure that at least one thread is used, but no more than four. A template is to be generated from four files. Therefore, it can be parallized by a factor of four at max.
ants_threads_anatomical=${ants_threads_functional}
if (( ants_threads_anatomical > 4 )); then
	ants_threads_anatomical=4
elif (( ants_threads_anatomical < 1 )); then
	ants_threads_anatomical=1
fi

# Make sure that at least one thread is used, but no more than eight. More than eight threads are said to not improve speed for FreeSurfer.
freesurfer_threads=${ants_threads_functional}
if (( freesurfer_threads > 8 )); then
	freesurfer_threads=8
elif (( freesurfer_threads < 1 )); then
	freesurfer_threads=1
fi

subCounter=0
for sub_ID in $sub; do
	echo "***************************************"
	echo "* Processing of subject ${sub_ID} started."
	echo "***************************************"
	# Set up variables for paths
	output_directory=${input_directory}/derivatives/sub-${sub_ID}/
	SUBJECTS_DIR=${input_directory}/derivatives/FreeSurfer/

 	# Create folders
	for ses_ID in $ses; do
		mkdir -p ${output_directory}/ses-${ses_ID}/func/
		mkdir -p ${output_directory}/ses-${ses_ID}/anat/
	done
	mkdir -p ${output_directory}/ses-all/func/
	mkdir -p ${output_directory}/ses-all/anat/
	mkdir -p ${SUBJECTS_DIR}/
 
	# 4. Disassemble time series of each functional run, average, and mask it
	echo ""
	echo "***************************************"
	echo "* Disassemble time series of each functional run, average, and mask it"
	echo "***************************************"
	for ses_ID in $ses; do
		num_runs=$(find ${input_directory}/sub-${sub_ID}/ses-${ses_ID}/func/ -name "*run-*_bold.nii.gz" | wc -l)
		for run_ID in $( eval echo {01..${num_runs}} ); do
			if [ -f "${output_directory}/ses-${ses_ID}/func/sub-${sub_ID}_ses-${ses_ID}_task-pRF_run-${run_ID}_bold_mean_masked.nii.gz" ]; then
				echo "Average and mask for functional data of session ${ses_ID} and run ${run_ID} exist already. Skipping re-processing it."		
			else
				# Dissemble time series of each functional run again... [Better way?]
				ImageMath 4 \
				${input_directory}/sub-${sub_ID}/ses-${ses_ID}/func/sub-${sub_ID}_ses-${ses_ID}_task-pRF_run-${run_ID}_bold_disassemble.nii.gz \
				TimeSeriesDisassemble \
				${input_directory}/sub-${sub_ID}/ses-${ses_ID}/func/sub-${sub_ID}_ses-${ses_ID}_task-pRF_run-${run_ID}_bold.nii.gz

				# Create average of each functional run
				AverageImages 3 \
				${output_directory}/ses-${ses_ID}/func/sub-${sub_ID}_ses-${ses_ID}_task-pRF_run-${run_ID}_bold_mean.nii.gz \
				0 \
				${input_directory}/sub-${sub_ID}/ses-${ses_ID}/func/sub-${sub_ID}_ses-${ses_ID}_task-pRF_run-${run_ID}_bold_disassemble*.nii.gz
				
				# Remove dissembled time series of each functional run again
				rm -f ${input_directory}/sub-${sub_ID}/ses-${ses_ID}/func/sub-${sub_ID}_ses-${ses_ID}_task-pRF_run-${run_ID}_bold_disassemble*.nii.gz
				
				# Create brain mask of each functional average
				ThresholdImage 3 \
				${output_directory}/ses-${ses_ID}/func/sub-${sub_ID}_ses-${ses_ID}_task-pRF_run-${run_ID}_bold_mean.nii.gz \
				${output_directory}/ses-${ses_ID}/func/sub-${sub_ID}_ses-${ses_ID}_task-pRF_run-${run_ID}_bold_mean_brainmask.nii.gz \
				700 100000

				# Get largest component of mask
				ImageMath 3 \
				${output_directory}/ses-${ses_ID}/func/sub-${sub_ID}_ses-${ses_ID}_task-pRF_run-${run_ID}_bold_mean_brainmask.nii.gz \
				GetLargestComponent \
				${output_directory}/ses-${ses_ID}/func/sub-${sub_ID}_ses-${ses_ID}_task-pRF_run-${run_ID}_bold_mean_brainmask.nii.gz

				# Morphologically close mask to fill holes
				ImageMath 3 \
				${output_directory}/ses-${ses_ID}/func/sub-${sub_ID}_ses-${ses_ID}_task-pRF_run-${run_ID}_bold_mean_brainmask.nii.gz \
				MC \
				${output_directory}/ses-${ses_ID}/func/sub-${sub_ID}_ses-${ses_ID}_task-pRF_run-${run_ID}_bold_mean_brainmask.nii.gz \
				2

				# Mask each functional average
				ImageMath 3 \
				${output_directory}/ses-${ses_ID}/func/sub-${sub_ID}_ses-${ses_ID}_task-pRF_run-${run_ID}_bold_mean_masked.nii.gz \
				m \
				${output_directory}/ses-${ses_ID}/func/sub-${sub_ID}_ses-${ses_ID}_task-pRF_run-${run_ID}_bold_mean.nii.gz \
				${output_directory}/ses-${ses_ID}/func/sub-${sub_ID}_ses-${ses_ID}_task-pRF_run-${run_ID}_bold_mean_brainmask.nii.gz
			fi
		done
	done

	# 5. Create unbiased template of all masked functional averages across sessions
	echo ""
	echo "***************************************"
	echo "* Create unbiased template of all masked functional averages across sessions"
	echo "***************************************"
	if [ -f "${output_directory}/ses-all/func/sub-${sub_ID}_ses-all_task-pRF_run-all_bold_mean_masked_template0.nii.gz" ]; then
		echo "Functional template of all masked functional averages across sessions exists already. Skipping re-processing it."		
	else
		find ${output_directory}/ses-0*/ \
		-name "sub-${sub_ID}_ses-*_task-pRF_run-*_bold_mean_masked.nii.gz" \
		| sort > ${output_directory}/ses-all/func/sub-${sub_ID}_ses-all_task-pRF_run-all_paths.txt

		antsIntrasubjectAverage_NearestNeighbor.sh \
		-d 3 \
		-i 4 \
		-c 2 \
		-a 2 \
		-b 0 \
		-n 0 \
		-e 1 \
		-k 1 \
		-r 1 \
		-j ${ants_threads_functional} \
		-f 8x4x2x1 \
		-s 4x2x1x0 \
		-q 1000x1000x500x250 \
		-t Rigid \
		-o ${output_directory}/ses-all/func/sub-${sub_ID}_ses-all_task-pRF_run-all_bold_mean_masked_ \
		${output_directory}/ses-all/func/sub-${sub_ID}_ses-all_task-pRF_run-all_paths.txt
	fi

	# 6. Resample structural data to the resolution of functional data
	echo ""
	echo "***************************************"
	echo "* Resample structural data to the resolution of functional data"
	echo "***************************************"
	for ses_ID in $ses; do
		if [ -f "${output_directory}/ses-${ses_ID}/anat/sub-${sub_ID}_ses-${ses_ID}_T1w_downsampled.nii.gz" ]; then
			echo "Structural data of session ${ses_ID} already resampled. Skipping re-processing it."		
		else
            # Get resolution of functional data
			voxel_sizes=$(mri_info ${input_directory}/sub-${sub_ID}/ses-${ses_ID}/func/sub-${sub_ID}_ses-${ses_ID}_task-pRF_run-01_bold.nii.gz | grep "voxel sizes")
            # res: col (x), row (y), slice (z) and frame resolution
   			read x y z <<< $(awk -F'[:,]' '{print $2, $3, $4}' <<< "$voxel_sizes")
            
            # Resample
			mri_convert \
			-rt cubic \
			-vs $x $y $z \
			-i ${input_directory}/sub-${sub_ID}/ses-${ses_ID}/anat/sub-${sub_ID}_ses-${ses_ID}_T1w.nii.gz \
			-o ${output_directory}/ses-${ses_ID}/anat/sub-${sub_ID}_ses-${ses_ID}_T1w_downsampled.nii.gz
            # -vs, --voxsize <size_x> <size_y> <size_z>
		fi
	done

	# 7. Bias-correct structural data
	echo ""
	echo "***************************************"
	echo "* Bias-correct structural data"
	echo "***************************************"
	for ses_ID in $ses; do
		if [ -f "${output_directory}/ses-${ses_ID}/anat/sub-${sub_ID}_ses-${ses_ID}_T1w_downsampled_biasCorrected.nii.gz" ]; then
			echo "Structural data of session ${ses_ID} already bias-corrected. Skipping re-processing it."		
		else
			removeBiasfield_pRF.sh ${output_directory}/ses-${ses_ID}/anat/sub-${sub_ID}_ses-${ses_ID}_T1w_downsampled.nii.gz ${prf_directory} ${spm_directory} ${biascorr_directory}
		fi
	done

	# 8. Mask structural data 
	echo ""
	echo "***************************************"
	echo "* Mask structural data"
	echo "***************************************"
    	for ses_ID in $ses; do
	    	if [ -f "${output_directory}/ses-${ses_ID}/anat/sub-${sub_ID}_ses-${ses_ID}_T1w_downsampled_biasCorrected_masked.nii.gz" ]; then
		    	echo "Structural data of session ${ses_ID} already masked. Skipping re-processing it."		
	   	 else
		    	mri_synthstrip \
		    	-i ${output_directory}/ses-${ses_ID}/anat/sub-${sub_ID}_ses-${ses_ID}_T1w_downsampled_biasCorrected.nii.gz \
		    	-o ${output_directory}/ses-${ses_ID}/anat/sub-${sub_ID}_ses-${ses_ID}_T1w_downsampled_biasCorrected_masked.nii.gz \
		    	-b 1 #\
  		    	#--no-csf
	    	fi
    	done
 
	# 9. Create unbiased template of all masked structural data across sessions
	echo ""
	echo "***************************************"
	echo "* Create unbiased template of all masked structural data across sessions"
	echo "***************************************"
	if [ -f "${output_directory}/ses-all/anat/sub-${sub_ID}_ses-all_T1w_downsampled_biasCorrected_masked_template0.nii.gz" ]; then
		echo "Structural template of all masked structural data across sessions exists already. Skipping re-processing it."		
	else
		antsIntrasubjectAverage_NearestNeighbor.sh \
		-d 3 \
		-i 4 \
		-c 2 \
		-g 0.1 \
		-e 1 \
		-k 1 \
		-a 2 \
		-b 0 \
		-n 0 \
		-r 1 \
		-j ${ants_threads_anatomical} \
		-f 8x4x2x1 \
		-s 4x2x1x0 \
		-q 1000x1000x500x250 \
		-t Rigid \
		-o ${output_directory}/ses-all/anat/sub-${sub_ID}_ses-all_T1w_downsampled_biasCorrected_masked_ \
		${output_directory}/ses-0[1-4]/anat/*biasCorrected_masked.nii.gz
	fi
	
	# 10. Apply transformations for generating masked structural template to UNMASKED structural data
	echo ""
	echo "***************************************"
	echo "* Apply transformations for generating masked structural template to UNMASKED structural data"
	echo "***************************************"
	counter=0
	for ses_ID in $ses; do
        if [ -f "${output_directory}/ses-all/anat/sub-${sub_ID}_ses-all_T1w_downsampled_biasCorrected_template0.nii.gz" ]; then                    
			echo "Transformations to UNMASKED structural data of session ${ses_ID} already applied. Skipping re-processing it."		
		else
			antsApplyTransforms \
			-d 3 \
			-e 0 \
			-v 1 \
			-n NearestNeighbor \
			--float \
			-r ${output_directory}/ses-all/anat/sub-${sub_ID}_ses-all_T1w_downsampled_biasCorrected_masked_template0.nii.gz \
			-t ${output_directory}/ses-all/anat/sub-${sub_ID}_ses-all_T1w_downsampled_biasCorrected_masked_sub-${sub_ID}_ses-${ses_ID}_T1w_downsampled_biasCorrected_masked${counter}0GenericAffine.mat \
			-i ${output_directory}/ses-${ses_ID}/anat/sub-${sub_ID}_ses-${ses_ID}_T1w_downsampled_biasCorrected.nii.gz \
			-o ${output_directory}/ses-${ses_ID}/anat/sub-${sub_ID}_ses-${ses_ID}_T1w_downsampled_biasCorrected_Warped.nii.gz
		
			counter=$((counter+1))
		fi
	done
	
	# 11. Create unbiased template of all UNMASKED structural data across sessions
	echo ""
	echo "***************************************"
	echo "* Create unbiased template of all UNMASKED structural data across sessions"
	echo "***************************************"
	if [ -f "${output_directory}/ses-all/anat/sub-${sub_ID}_ses-all_T1w_downsampled_biasCorrected_template0.nii.gz" ]; then
		echo "Structural template of all UNMASKED structural data acrosss sessions exists already. Skipping re-processing it."		
	else
      ls ${output_directory}/ses-0[1-4]/anat/sub-${sub_ID}_ses-0[1-4]_T1w_downsampled_biasCorrected_Warped.nii.gz > \
      ${output_directory}/ses-all/anat/sub-${sub_ID}_ses-all_T1w_downsampled_biasCorrected_Warped_paths.txt
      
      ImageSetStatistics 3 \
      ${output_directory}/ses-all/anat/sub-${sub_ID}_ses-all_T1w_downsampled_biasCorrected_Warped_paths.txt \
      ${output_directory}/ses-all/anat/sub-${sub_ID}_ses-all_T1w_downsampled_biasCorrected_template0.nii.gz \
      0
	fi

	# 12. Mask UNMASKED structural template
	echo ""
	echo "***************************************"
	echo "* Mask UNMASKED structural template"
	echo "***************************************"
	if [ -f "${output_directory}/ses-all/anat/sub-${sub_ID}_ses-all_T1w_downsampled_biasCorrected_template0_masked.nii.gz" ]; then
		echo "UNMASKED structural template already masked. Skipping re-processing it."		
	else
		mri_synthstrip \
		-i ${output_directory}/ses-all/anat/sub-${sub_ID}_ses-all_T1w_downsampled_biasCorrected_template0.nii.gz \
		-o ${output_directory}/ses-all/anat/sub-${sub_ID}_ses-all_T1w_downsampled_biasCorrected_template0_masked.nii.gz \
		-b 1 #\
		#--no-csf
	fi

	# 13. Register novel masked structural template to masked functional template
	echo ""
	echo "***************************************"
	echo "* Register novel masked structural template to masked functional template"
	echo "***************************************"
	# This yields better results than the other way round. The inverse transformation will be used in stage 14 as it yields the information to transform the functional template data into the space of the structural template data.
	if [ -f "${output_directory}/ses-all/anat/sub-${sub_ID}_ses-all_T1w_downsampled_biasCorrected_template0_masked_registered_to_sub-${sub_ID}_ses-all_task-pRF_run-all_bold_mean_masked_template0_0GenericAffine.mat" ]; then
		echo "Novel masked structural template already registered to masked functional template. Skipping re-processing it."		
	else
		antsRegistrationSyN_NearestNeighbor.sh \
		-d 3 \
		-t r \
		-n ${ants_threads_functional} \
		-f ${output_directory}/ses-all/func/sub-${sub_ID}_ses-all_task-pRF_run-all_bold_mean_masked_template0.nii.gz \
		-m ${output_directory}/ses-all/anat/sub-${sub_ID}_ses-all_T1w_downsampled_biasCorrected_template0_masked.nii.gz \
		-o ${output_directory}/ses-all/anat/sub-${sub_ID}_ses-all_T1w_downsampled_biasCorrected_template0_masked_registered_to_sub-${sub_ID}_ses-all_task-pRF_run-all_bold_mean_masked_template0_
	fi
	
	# 14. Coarse function-to-structure coregistration: Apply forward transformations for generating masked functional template and inversetransformations for coregistering masked structural and masked functional template to each unmasked functional run. 
    # Thus, each unmasked functional image (from each run and session) will be warped into the space of the masked structural template.
	echo ""
	echo "***************************************"
	echo "* Coarse function-to-structure coregistration of each unmasked functional run by applying"
    echo "* forward transformations for generating masked functional template and"
    echo "* inverse transformations for coregistering novel masked structural template and masked functional template"
	echo "***************************************"
	counter=0
	for ses_ID in $ses; do
		num_runs=$(find ${input_directory}/sub-${sub_ID}/ses-${ses_ID}/func/ -name "*ses-${ses_ID}*run-*_bold.nii.gz" \
		| wc -l)
		
		for run_ID in $( eval echo {01..${num_runs}} ); do
			if [ -f "${output_directory}/ses-${ses_ID}/func/sub-${sub_ID}_ses-${ses_ID}_task-pRF_run-${run_ID}_bold_registered_to_sub-${sub_ID}_ses-all_T1w_downsampled_biasCorrected_template0.nii.gz" ]; then
				echo "Foward and inverse transformations to unmasked functional data of session ${ses_ID} and run ${run_ID} already applied. Skipping re-processing it."		
			else
				antsApplyTransforms \
				-d 3 \
				-e 3 \
				-n NearestNeighbor \
				--float 1 \
				--verbose 1 \
				-r ${output_directory}/ses-all/anat/sub-${sub_ID}_ses-all_T1w_downsampled_biasCorrected_template0.nii.gz \
				-t [${output_directory}/ses-all/anat/sub-${sub_ID}_ses-all_T1w_downsampled_biasCorrected_template0_masked_registered_to_sub-${sub_ID}_ses-all_task-pRF_run-all_bold_mean_masked_template0_0GenericAffine.mat,1] \
				-t ${output_directory}/ses-all/func/sub-${sub_ID}_ses-all_task-pRF_run-all_bold_mean_masked_sub-${sub_ID}_ses-${ses_ID}_task-pRF_run-${run_ID}_bold_mean_masked${counter}0GenericAffine.mat \
				-i ${input_directory}/sub-${sub_ID}/ses-${ses_ID}/func/sub-${sub_ID}_ses-${ses_ID}_task-pRF_run-${run_ID}_bold.nii.gz \
				-o ${output_directory}/ses-${ses_ID}/func/sub-${sub_ID}_ses-${ses_ID}_task-pRF_run-${run_ID}_bold_registered_to_sub-${sub_ID}_ses-all_T1w_downsampled_biasCorrected_template0.nii.gz
                # Note that we skip the affix "masked" here entirely to wipe the slate clean and omit potential confusion when output images are masked again. 
			fi
			counter=$((counter+1))
		done
	done
	
	# 15. Run recon-all on unmasked structural template
	echo ""
	echo "***************************************"
	echo "* Run recon-all on unmasked structural template"
	echo "***************************************"
	if [ -f "${SUBJECTS_DIR}/sub-${sub_ID}/mri/aseg.mgz" ]; then
		echo "Recon-all finished already. Skipping re-processing it."		
	else
        echo ""
	    echo "***************************************"
	    echo "* Run autorecon 1"
	    echo "***************************************"
		if [ -f "${SUBJECTS_DIR}/sub-${sub_ID}/mri/brainmask.mgz" ]; then
			echo "Autorecon 1 completed already. Skipping re-processing it." 
			echo ""
		else
			if [ -d "${SUBJECTS_DIR}/sub-${sub_ID}/" ]; then
				echo "Subject folder exists already."
				recon-all \
				-autorecon1 \
				-hires \
				-threads ${freesurfer_threads} \
				-parallel \
				-s sub-${sub_ID}
			else
				recon-all \
				-autorecon1 \
				-hires \
				-threads ${freesurfer_threads} \
				-parallel \
				-i ${output_directory}/ses-all/anat/sub-${sub_ID}_ses-all_T1w_downsampled_biasCorrected_template0.nii.gz \
				-s sub-${sub_ID}
			fi
		fi
		
        echo ""
		echo "***************************************"
		echo "* Create brainmask.mgz" 		
		echo "***************************************"
		if [ -f "${SUBJECTS_DIR}/sub-${sub_ID}/mri/brainmask.synthstrip.mgz" ]; then
			echo "Brainmask created already. Skipping re-processing it." 
			echo "" 
		else
			# A backup of the original brainmask can be found here: /mri/brainmask.auto.mgz
			mri_synthstrip \
			-i ${SUBJECTS_DIR}/sub-${sub_ID}/mri/T1.mgz \
			-o ${SUBJECTS_DIR}/sub-${sub_ID}/mri/brainmask.synthstrip.mgz \
			-b 1 \
            --no-csf
			
			cp \
			${SUBJECTS_DIR}/sub-${sub_ID}/mri/brainmask.synthstrip.mgz \
			${SUBJECTS_DIR}/sub-${sub_ID}/mri/brainmask.mgz
		fi
		
		echo ""
	    echo "***************************************"
	    echo "* Run autorecon 2+3"
	    echo "***************************************"
		# [It seems odd, but careg is not part of autorecon2? This may be a bug and should be reported potentially.]
		recon-all \
		-autorecon2 \
		-autorecon3 \
		-careg \
		-no-isrunning \
		-hires \
		-threads ${freesurfer_threads} \
		-parallel \
		-s sub-${sub_ID}
	fi

	# 16. Fine function-to-structure coregistration of each coarsely-registered functional runs via boundary-based registration and surface projection 
	# Create folder for surface projection
	vol2surf=${SUBJECTS_DIR}/sub-${sub_ID}/vol2surf/
	mkdir -p ${vol2surf}

    echo ""
	echo "***************************************"
	echo "* Fine function-to-structure coregistration of each coarsely-registered functional run"
    echo "* via boundary-based registration, followed by surface projection" 
	echo "***************************************"

	for ses_ID in $ses; do
		num_runs=$(find ${output_directory}/ses-${ses_ID}/func/ -name "*run-*_bold_mean.nii.gz" | wc -l)
		for run_ID in $( eval echo {01..${num_runs}} ); do

			# Fine coregistration via boundary-based segmentation
			if [ -f ${vol2surf}/sub-${sub_ID}_ses-${ses_ID}_run-${run_ID}.lta ]; then
                echo ""
				echo "Fine coregistration of coarsely-registered functional data for session ${ses_ID} and run ${run_ID} exists already. Skipping re-processing it."
			else
				bbregister \
				--s sub-${sub_ID} \
				--mov ${output_directory}/ses-${ses_ID}/func/sub-${sub_ID}_ses-${ses_ID}_task-pRF_run-${run_ID}_bold_registered_to_sub-${sub_ID}_ses-all_T1w_downsampled_biasCorrected_template0.nii.gz \
				--init-header \
				--bold \
				--nearest \
				--reg ${vol2surf}/sub-${sub_ID}_ses-${ses_ID}_run-${run_ID}.lta
			fi
		
			# Surface projection
			for hemi in lh rh; do
				for FWHM_ID in $FWHM; do
					if [ -f "${vol2surf}/${hemi}_sub-${sub_ID}_ses-${ses_ID}_task-pRF_run-${run_ID}_bold_registered_to_sub-${sub_ID}_ses-all_T1w_downsampled_biasCorrected_template0_FWHM-${FWHM_ID//./p}_BBR.mgh" ]; then
						if [[ ${hemi} == lh ]]; then
							echo "Surface projection of left hemisphere of finely-registered functional data for session ${ses_ID} and run ${run_ID} using a FWHM of ${FWHM_ID} exists already. Skipping re-processing it."		
						elif [[ ${hemi} == rh ]]; then
							echo "Surface projection of right hemisphere of finely-registered functional data for session ${ses_ID} and run ${run_ID} using a FWHM of ${FWHM_ID} exists already. Skipping re-processing it."		
						fi
					else
						mri_vol2surf \
						--mov ${output_directory}/ses-${ses_ID}/func/sub-${sub_ID}_ses-${ses_ID}_task-pRF_run-${run_ID}_bold_registered_to_sub-${sub_ID}_ses-all_T1w_downsampled_biasCorrected_template0.nii.gz \
						--reg ${vol2surf}/sub-${sub_ID}_ses-${ses_ID}_run-${run_ID}.lta \
						--hemi ${hemi} \
						--o ${vol2surf}/${hemi}_sub-${sub_ID}_ses-${ses_ID}_task-pRF_run-${run_ID}_bold_registered_to_sub-${sub_ID}_ses-all_T1w_downsampled_biasCorrected_template0_FWHM-${FWHM_ID//./p}_BBR.mgh \
						--projfrac ${projFrac} \
						--surf-fwhm ${FWHM_ID}
					fi
				done
			done
		done
	done
	
	# 17. Atlas generation
	# Create folder for atlas
	atlas=${SUBJECTS_DIR}/sub-${sub_ID}/atlas/
	mkdir -p ${atlas}
	
	# Generate atlas using rh.aparc.annot and lh.aparc.annot (defaults)
	echo ""
	echo "***************************************"
	echo "* Generation of atlas"
	echo "***************************************"
	for hemi in lh rh; do
		if [ -f "${atlas}/${hemi}.postcentral.label" ]; then
		    if [[ ${hemi} == lh ]]; then
			    echo "Atlas generation for left hemisphere done already. Skipping re-processing it."		
			elif [[ ${hemi} == rh ]]; then
			    echo "Atlas generation for right hemisphere done already. Skipping re-processing it."		
			fi	
		else
			mri_annotation2label --subject sub-${sub_ID} --hemi ${hemi} --outdir ${atlas}					
		fi
	done

	echo ""
	echo "***************************************"
	echo "* Processing of subject ${sub_ID} finished successfully."
	echo "***************************************"

    subCounter=$((subCounter+1))

done
