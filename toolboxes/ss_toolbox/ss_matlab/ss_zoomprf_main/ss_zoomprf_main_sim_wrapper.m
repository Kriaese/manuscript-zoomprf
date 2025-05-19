function ss_zoomprf_main_sim_wrapper(Subjects, Fld, Files, Para)
%
%
%
% ------------------------------------------------------------------------------
% 28/03/2023: Generated (SS)
% 14/10/2024: Last modified (SS)
% ------------------------------------------------------------------------------

%% .............................................................................Some settings 

ScalingFactor = 4.25; 

%% .............................................................................Get t0

T0 = tic;

%% .............................................................................Try to get current parallel pool

ss_parallel_gcp;

%% .............................................................................Loop through sessions

for i_sess = 1:size(Subjects.Sessions,2)

    CurrSess          = Subjects.Sessions{i_sess};

    %% .........................................................................Loop through standard deviation of noise

    parfor i_sd = 1:size(Para.Sd,2)
        % for i_sd = 1:size(Para.Sd,2)

        CurrSd          = Para.Sd(1, i_sd);
        CurrNReps       = Para.NReps(1, i_sd);
        CurrGroundTruth = Para.GroundTruth{1, i_sd};
        CurrSearchGridCoverge  = Files.SearchGridCoverge{1, i_sd};

        %% .....................................................................Paths

        PathSamSrfSimSub = fullfile(Fld.SamSrfRoot, Fld.SamSrfSim, CurrSess, Fld.SamSrfSimSub);
        PathSamSrfApt    = fullfile(Fld.SamSrfRoot, Subjects.ID, Fld.SamSrfApt, [Subjects.ID '_' Files.Apt]);
        ss_checkfld(PathSamSrfSimSub);

        %% .....................................................................Simulate time course

        cd(PathSamSrfSimSub)
        ss_samsrf_simprf(PathSamSrfApt, Para.TR, Para.HrfType, CurrSd, CurrNReps, ...
            [CurrSess '_' Files.Affix], Para.ModelType, CurrGroundTruth, ...
            CurrSearchGridCoverge, ScalingFactor);

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