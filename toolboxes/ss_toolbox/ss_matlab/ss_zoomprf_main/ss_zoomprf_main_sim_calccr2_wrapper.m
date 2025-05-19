function ss_zoomprf_main_sim_calccr2_wrapper(Subjects, Fld, Files, Para)
%
%
%
% ------------------------------------------------------------------------------
% 18/03/2023: Generated (SS)
% 10/11/2024: Last modified (SS)
% ------------------------------------------------------------------------------

%% .............................................................................Get t0

T0 = tic;

%% .............................................................................Try to get current parallel pool

% ss_parallel_gcp;

%% .............................................................................Paths

PathSamSrfSimSubHalf1   = fullfile(Fld.SamSrfRoot, Fld.SamSrfSim, Subjects.Sessions{1}, Fld.SamSrfSimSub);
PathSamSrfSimSubHalf2   = fullfile(Fld.SamSrfRoot, Fld.SamSrfSim, Subjects.Sessions{2}, Fld.SamSrfSimSub);

%% .............................................................................Loop through standard deviation

for i_sd = 1:size(Para.Sd,2)
% parfor

    CurrSd                  = Para.Sd(1, i_sd);
    CurrNReps               = Para.NReps(1, i_sd);
    CurrSearchSpaceCoverage = Files.SearchGridCoverge{1, i_sd};

    %% .........................................................................Loop through map files

    for i_prffile = 1:size(Files.Prf,2)

        %% .....................................................................Loop through model type

        for i_modeltype= 1:size(Para.ModelType,2)

            CurrModelType = Para.ModelType{i_modeltype};

            %% .................................................................Loop through hemispheres

            for i_hemi = 1:size(Para.Hemis, 2)

                CurrHemi = Para.Hemis{i_hemi};

                %% .............................................................Put together file name

                MapFileName = [CurrHemi '*' num2str(CurrNReps)  '*' num2str(strrep(num2str(CurrSd), '.', '')) ...
                    '*'  CurrSearchSpaceCoverage '*' CurrModelType ...
                    Files.Prf{i_prffile} '.mat'];

                %% .............................................................Load map file for half 1

                cd(PathSamSrfSimSubHalf1)
                MapFileInfoHalf1  = dir(MapFileName);
                MapFileNameHalf1  = MapFileInfoHalf1(1).name;
                Map1              = load(MapFileNameHalf1);

                %% .............................................................Load map file for half 2

                cd(PathSamSrfSimSubHalf2)
                MapFileInfoHalf2  = dir(MapFileName);
                MapFileNameHalf2  = MapFileInfoHalf2(1).name;
                Map2              = load(MapFileNameHalf2);

                %% .............................................................Cross-validate R2 of map 1

                cd(PathSamSrfSimSubHalf1)
                ss_samsrf_crossvalr2(Map1, Map2, MapFileNameHalf1);

                %% .............................................................Cross-validate R2 of map 2

                cd(PathSamSrfSimSubHalf2)
                ss_samsrf_crossvalr2(Map2, Map1, MapFileNameHalf2);

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

% ss_parallel_shutdowngcp;

end