function ss_zoomprf_main_calccsnrcr2sum_wrapper(Subjects, Fld, Files, Para)
%
%
%
% ------------------------------------------------------------------------------
% 08/10/2024: Generated (SS)
% 16/03/2025: Last modified (SS)
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

                %% .............................................................Loop through hemispheres

                for i_hemi = 1:size(Para.Hemis, 2)

                    CurrHemi = Para.Hemis{i_hemi};

                    %% .........................................................Put together SamSrf label

                    cd(PathSamSrfKernelLabel)
                    SamSrfLabelList         = dir([Fld.SamSrfLabel]);
                    SamSrfLabelFileName     = strcat(SamSrfLabelList.folder, filesep, SamSrfLabelList.name, ...
                        filesep, CurrHemi, '_', Files.SamSrfLabel);

                    %% .........................................................Load map file

                    cd(PathSamSrfKernel)
                    MapFileName = [CurrHemi '*' Files.Prf{i_prffile} '*'];
                    MapFileInfo = dir(MapFileName);
                    MapFileName = MapFileInfo(1).name;
                    Map         = load(MapFileName);

                    %% .........................................................Get summary of cSNR and cR2 values within label (roi)

                    [SumStat, SumStatLabels] = ss_samsrf_calccsnrcr2sum(Map, SamSrfLabelFileName);

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