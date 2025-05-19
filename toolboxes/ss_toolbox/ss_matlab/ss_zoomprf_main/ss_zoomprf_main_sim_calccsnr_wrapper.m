function ss_zoomprf_main_sim_calccsnr_wrapper(Subjects, Fld, Files, Para)
%
%
%
% ------------------------------------------------------------------------------
% 09/11/2024: Generated (SS)
% 09/11/2024: Last modified (SS)
% ------------------------------------------------------------------------------
%%% TODO: ss_zoomprf_main_sim_calccsnr_wrapper coud be integrated into
%%% ss_zoomprf_main_calccsnr_wrapper if Fld.SamSrfSim were to be used for
%%% Subjects.ID and Fld.SamSrfSimSub for Subjects.Kernel.

%% .............................................................................Get t0

T0 = tic;

%% .............................................................................Try to get current parallel pool

% ss_parallel_gcp;

%% .............................................................................Loop through session pairs

for i_sesspair=1:size(Subjects.SessionPair,1)

    CurrSessPair = Subjects.SessionPair(i_sesspair,:);

    %% .........................................................................Paths

    PathSamSrfSimSubHalf1   = fullfile(Fld.SamSrfRoot, Fld.SamSrfSim, CurrSessPair{1}, Fld.SamSrfSimSub);
    PathSamSrfSimSubHalf2   = fullfile(Fld.SamSrfRoot, Fld.SamSrfSim, CurrSessPair{2}, Fld.SamSrfSimSub);

    %% .........................................................................Loop through map files

    for i_prffile = 1:size(Files.Prf,2)

        %% .....................................................................Loop through hemispheres

        for i_hemi = 1:size(Para.Hemis, 2)

            CurrHemi = Para.Hemis{i_hemi};

            %% .................................................................Loop through standard deviation of the noise

            for i_sd = 1:size(Para.Sd,2)

                CurrSd                  = Para.Sd(1, i_sd);
                CurrNReps               = Para.NReps(1, i_sd);
                CurrSearchSpaceCoverage = Files.SearchGridCoverge{1, i_sd};

                %% .............................................................Put together file name for maps 

                MapFileName = [CurrHemi '*' num2str(CurrNReps) '*' num2str(CurrSd) ...
                    '*' CurrSearchSpaceCoverage '*' Files.Prf{i_prffile} '.mat'];

                %% .............................................................Load map file for half 1

                cd(PathSamSrfSimSubHalf1)
                MapFileInfoHalf1 = dir(MapFileName);
                MapFileNameHalf1 = MapFileInfoHalf1(1).name;
                Map1             = load(MapFileNameHalf1);

                %% .............................................................Load map file for half 2

                cd(PathSamSrfSimSubHalf2)
                MapFileInfoHalf2 = dir(MapFileName);
                MapFileNameHalf2 = MapFileInfoHalf2(1).name;
                Map2             = load(MapFileNameHalf2);

                %% .............................................................Cross-validate SNR of map 1

                cd(PathSamSrfSimSubHalf1)
                ss_samsrf_crossvalsnr(Map1, Map2, MapFileNameHalf1);

                %% .............................................................Cross-validate SNR of map 2

                cd(PathSamSrfSimSubHalf2)
                ss_samsrf_crossvalsnr(Map2, Map1, MapFileNameHalf2);

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