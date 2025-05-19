function ss_zoomprf_main_sim_calcr2diff_wrapper(Subjects, Fld, Files, Para)
%
%
%
% ------------------------------------------------------------------------------
% 17/03/2023: Generated (SS)
% 14/11/2024: Last modified (SS)
% ------------------------------------------------------------------------------

%% .............................................................................Get t0

T0 = tic;

%% .............................................................................Try to get current parallel pool

ss_parallel_gcp;

%% .............................................................................Loop through sessions

for i_sess = 1:size(Subjects.Sessions,2)

    CurrSess  = Subjects.Sessions{i_sess};

    %% .........................................................................Loop through standard deviation of the noise

    parfor i_sd = 1:size(Para.Sd,2)

        CurrSd                  = Para.Sd(1, i_sd);
        CurrNReps               = Para.NReps(1, i_sd);
        CurrSearchSpaceCoverage = Files.SearchGridCoverge{1, i_sd};

        %% .....................................................................Loop through hemispheres

        for i_hemi = 1:size(Para.Hemis,2)

            CurrHemi = Para.Hemis{1, i_hemi};
            MapFileNameStem   = [CurrHemi '_' CurrSess '_' Files.Prf{1} num2str(CurrNReps) ...
                Files.Prf{2} num2str(strrep(num2str(CurrSd), '.', '')) Files.Prf{3} CurrSearchSpaceCoverage];
            MapFileNameM1     = [MapFileNameStem '_' Para.ModelType{1} Files.Prf{4}];
            MapFileNameM0     = [MapFileNameStem '_' Para.ModelType{2} Files.Prf{4}];

            %% .................................................................Paths

            PathSamSrfSimSub= fullfile(Fld.SamSrfRoot, Fld.SamSrfSim, CurrSess,  Fld.SamSrfSimSub);
            cd(PathSamSrfSimSub)

            %% .................................................................Load M1 and M0 map

            MapM1 = load(MapFileNameM1);
            MapM0 = load(MapFileNameM0);

            %% .................................................................Calculate R2 difference

            ss_samsrf_calcr2diff(MapM1, MapM0, MapFileNameM1, Para.R2Type);

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