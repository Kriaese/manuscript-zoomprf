function ss_zoomprf_main_sim_calcpval_wrapper(Subjects, Fld, Files, Para)
%
%
%
% ------------------------------------------------------------------------------
% 14/11/2024: Generated (SS)
% 15/11/2024: Last modified (SS)
% ------------------------------------------------------------------------------

%% .............................................................................Get t0

T0 = tic;

%% .............................................................................Loop through sessions

for i_sess = 1:size(Subjects.Sessions,2)

    CurrSess   = Subjects.Sessions{i_sess};

    %% .........................................................................Loop through standard deviation of the noise

    for i_sd = 1:size(Para.Sd,2)

        CurrSd                  = Para.Sd(1, i_sd);
        CurrNReps               = Para.NReps(1, i_sd);
        CurrSearchSpaceCoverage = Files.SearchGridCoverge{1, i_sd};

        %% .....................................................................Loop through hemispheres

        for i_hemi = 1:size(Para.Hemis,2)

            CurrHemi          = Para.Hemis{1, i_hemi};

            %% .................................................................Put together file name

            MapFileName   = [CurrHemi '_' CurrSess '_' Files.Prf{1} num2str(CurrNReps) ...
                Files.Prf{2} num2str(strrep(num2str(CurrSd), '.', '')) Files.Prf{3} CurrSearchSpaceCoverage ...
                '_' Files.Prf{4}];

            %% .................................................................Paths

            PathSamSrfSimSub  = fullfile(Fld.SamSrfRoot, Fld.SamSrfSim, CurrSess, Fld.SamSrfSimSub);

            %% .................................................................Get data

            cd(PathSamSrfSimSub)
            Map = load(MapFileName);

            %% .................................................................Calculate p-values

            [SumStats, ValuesCols] = ss_zoomprf_main_sim_calcpval(Map.Srf, Para.R2DiffType, Para.CritVal);

            %% .................................................................Save

            save([MapFileName '_sumstat-' Para.R2DiffType], 'SumStats', 'ValuesCols')

        end

    end

end

%% .............................................................................Get T1

T1 = toc(T0);
TEnd = num2str(T1/60/60);

%% .............................................................................Display running time

disp(['Analysis completed in ' TEnd ' hours.']);

end