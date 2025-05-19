function ss_zoomprf_main_calcsumstat_wrapper(Subjects, Fld, Files, Para)
%
%
%
% ------------------------------------------------------------------------------
% 15/12/2024: Generated (SS)
% 17/03/2025: Last modified (SS)
% ------------------------------------------------------------------------------

%% .............................................................................Get t0

T0 = tic;

%% .............................................................................Try to get current parallel pool

ss_parallel_gcp;

%% .............................................................................Loop through subjects

for i_subj=1:size(Subjects.ID,2)
    % parfor

    CurrSubj = Subjects.ID{i_subj};

    %% .........................................................................Loop through sessions

    for i_sess=1:size(Subjects.Sessions,2)

        CurrSess              = Subjects.Sessions{i_sess};
        CurrSessSamSrfLabel   = Subjects.SessionsSamSrfLabel{i_sess};

        %% .....................................................................Loop through kernel size

        for i_kernel=1:size(Subjects.Kernel,2)

            CurrKernel            = Subjects.Kernel{i_kernel};
            CurrKernelSamSrfLabel = Subjects.KernelSamSrfLabel{i_kernel};

            %% .................................................................Paths

            PathSamSrfKernel       = fullfile(Fld.SamSrfRoot, CurrSubj, CurrSess, CurrKernel);
            PathSamSrfKernelLabel  = fullfile(Fld.SamSrfRoot, CurrSubj, CurrSessSamSrfLabel, CurrKernelSamSrfLabel);

            %% .................................................................Loop through map files

            for i_prffile = 1:size(Files.Prf,2)

                CurrMapFileName = Files.Prf{i_prffile}; 

                %% .............................................................Loop through hemispheres

                for i_hemi = 1:size(Para.Hemis, 2)

                    CurrHemi = Para.Hemis{i_hemi};

                    %% .........................................................Put together SamSrf label

                    cd(PathSamSrfKernelLabel)
                    SamSrfLabelList         = dir([Fld.SamSrfLabel]);
                    SamSrfLabelFileName     = strcat(SamSrfLabelList.folder, filesep, SamSrfLabelList.name, ...
                        filesep, CurrHemi, '_', Files.SamSrfLabel);

                    %% .........................................................Load glm contrast results

                    GlmContsFileName = [CurrHemi '*' Files.GlmConts '*'];
                    GlmContsFileInfo = dir(GlmContsFileName);
                    GlmContsFileName = GlmContsFileInfo(1).name;
                    GlmConts         = load(GlmContsFileName);
                    %%% Note: The glm results are always the ones that have 
                    %%% been used for delineating the activation cluster. These 
                    %%% glm results are used for cleaning the differential 
                    %%% cR2 values. This means if the delineation is based on 
                    %%% data smoothed at FWHM=1mm, the glm results for FWHM=1mm 
                    %%% are used irrespective of whether the differential cR2 
                    %%% values are based on data smoothed at FWHM=0mm 
                    %%% (unsmoothed) or at FWHM=1mm.

                    %% .........................................................Load map file

                    cd(PathSamSrfKernel)
                    MapFileName = [CurrHemi '*' CurrMapFileName '*'];
                    MapFileInfo = dir(MapFileName);
                    MapFileName = MapFileInfo(1).name;
                    Map         = load(MapFileName);

                    %% .........................................................Get different types of summary stats within label (roi)

                    if strcmp(Files.SumStat, 'sumstat-diff-cR^2')
                        [SumStat, SumStatLabels] = ss_samsrf_calccr2diffsum(Map, ...
                            SamSrfLabelFileName, GlmConts);
                    elseif strcmp(Files.SumStat, 'sumstats')
                        [SumStat, SumStatLabels] = ss_samsrf_calcsumstat(Map, ...
                            SamSrfLabelFileName, GlmConts);
                    end 

                    %% .........................................................Save

                    save([MapFileName(1:end-4) '_' Files.SumStat], 'SumStat', 'SumStatLabels'); 

                end

            end

        end

    end

end

%% .............................................................................Get T1

T1 = toc(T0);
TEnd = num2str(T1/60/60);

%% .............................................................................Display running time

disp(['Analysis completed in ' TEnd ' hours.']);

%% .............................................................................Shut down parallel pool

ss_parallel_shutdowngcp;

end