function ss_zoomprf_main_sim_fit_wrapper(Subjects, Fld, Files, Para)
%
%
%
% ------------------------------------------------------------------------------
% 13/03/2023: Generated (SS)
% 15/10/2024: Last modified (SS)

%% .............................................................................Some settings

RoiFileName = '';
ScalingFactor = 4.25;
Suffix = '';

%% .............................................................................Get t0

T0 = tic;

% %% .............................................................................Try to get current parallel pool
%
% ss_parallel_gcp;

%% .............................................................................Loop through sessions

for i_sess = 1:size(Subjects.Sessions,2)

    CurrSess          = Subjects.Sessions{i_sess};

    %% .........................................................................Loop through standard deviation of noise

    for i_sd = 1:size(Para.Sd,2)

        CurrSd            = Para.Sd(1, i_sd);
        CurrNReps         = Para.NReps(1, i_sd);
        CurrSearchSpaceCoverage = Files.SearchGridCoverge{1, i_sd};
        
        %% .....................................................................Put together name of file containing simulated time courses 

        FileNameSim  = ['_' CurrSess '_' Files.Sim{1} num2str(CurrNReps) ...
            Files.Sim{2} num2str(strrep(num2str(CurrSd), '.', '')) ...
            Files.Sim{3} '_' CurrSearchSpaceCoverage];

        %% .....................................................................Paths

        PathSamSrfSimSub = fullfile(Fld.SamSrfRoot, Fld.SamSrfSim, CurrSess, Fld.SamSrfSimSub);
        PathSamSrfApt = fullfile(Fld.SamSrfRoot, Subjects.ID, Fld.SamSrfApt);
        cd(PathSamSrfSimSub)

        %% .....................................................................Loop through model types

        for i_mtype = 1:size(Para.ModelType,2)

            CurrModelType = Para.ModelType{i_mtype};

            %% .................................................................Put together name of prf and aperture file

            PrfFileName = [FileNameSim(2:end) '_' CurrModelType];
            %%% Note: We remove initial underscore here.
            AptFileName = fullfile(PathSamSrfApt, [Subjects.ID '_' Files.Apt]);

            %% .................................................................Perform pRF fitting

            ss_samsrf_fit(CurrModelType, Para.Hemis, FileNameSim, ...
                RoiFileName, AptFileName, PrfFileName, Para.Stage, ...
                Para.TR, Para.ModelCSS, Para.HrfType, Suffix, ScalingFactor)
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