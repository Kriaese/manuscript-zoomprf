function ss_zoomprf_main_fit_wrapper(Subjects, Fld, Files, Para)
%
%
%
% ------------------------------------------------------------------------------
% 16/08/2022: Generated (SS)
% 03/09/2024: Last modified (SS)
% ------------------------------------------------------------------------------

%% .............................................................................Some settings

RoiFileName = '';
ScalingFactor = 4.25; 
Suffix = ''; 

%% .............................................................................Get t0

T0 = tic;

% %% .............................................................................Try to get current parallel pool
%
% ss_parallel_gcp;

%% .............................................................................Loop through model types

for i_mtype=1:size(Para.ModelType,2)

    CurrModelType = Para.ModelType{i_mtype};

    %% .........................................................................Loop through subjects

    for i_subj=1:size(Subjects.ID,2)

        CurrSubj = Subjects.ID{i_subj};

        %% .....................................................................Paths

        PathSamSrfApt = fullfile(Fld.SamSrfRoot, CurrSubj, Fld.SamSrfApt);

        %% .....................................................................Loop through kernel size

        for i_kernel=1:size(Subjects.Kernel,2)

            CurrKernel = Subjects.Kernel{i_kernel};

            %% .................................................................Loop through sessions

            for i_sess = 1:size(Subjects.Sessions,2)

                CurrSess           = Subjects.Sessions{i_sess};

                %% .............................................................Paths

                PathSamSrfKernel   = fullfile(Fld.SamSrfRoot, CurrSubj, CurrSess, CurrKernel);

                %% .............................................................Get file names

                cd(PathSamSrfKernel)

                Mgh2SrfAggrFileInfo = dir(Files.Mgh2SrfAggr);
                Mgh2SrfAggrFileName = Mgh2SrfAggrFileInfo(1).name(3:end);

                AptFileName    = fullfile(PathSamSrfApt, [CurrSubj '_' Files.Apt]);

                PrfFileName    = [Mgh2SrfAggrFileName(2:end-4) '_' CurrModelType];

                %% .............................................................Perform fitting

                ss_samsrf_fit(CurrModelType, Para.Hemis, Mgh2SrfAggrFileName, ...
                    RoiFileName, AptFileName, PrfFileName , Para.Stage, ...
                    Para.TR, Para.ModelCSS, Para.HrfType, Suffix, ScalingFactor);

            end

        end

    end

end

%% .............................................................................Get T1

T1 = toc(T0);
TEnd = num2str(T1/60/60);

%% .............................................................................Display running time

disp(['Analysis completed in ' TEnd ' hours.']);

% %% .............................................................................Shut down parallel pool
%
% ss_parallel_shutdowngcp;

end