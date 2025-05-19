function ss_zoomprf_main_sim_calccsnrcr2sum_wrapper(Subjects, Fld, Files, Para)
%
%
%
% ------------------------------------------------------------------------------
% 10/11/2024: Generated (SS)
% 16/03/2025: Last modified (SS)
% ------------------------------------------------------------------------------

%% .............................................................................Get t0

T0 = tic;

%% .............................................................................Try to get current parallel pool

% ss_parallel_gcp;

%% .............................................................................Loop through sessions

for i_sess=1:size(Subjects.Sessions,2)

    CurrSess          = Subjects.Sessions{i_sess};

    %% .........................................................................Paths

    PathSamSrfSimSub  = fullfile(Fld.SamSrfRoot, Fld.SamSrfSim, CurrSess, Fld.SamSrfSimSub);

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

                %% .............................................................Load map file

                cd(PathSamSrfSimSub)
                MapFileName = [CurrHemi '*' num2str(CurrNReps) '*' num2str(CurrSd) ...
                    '*' CurrSearchSpaceCoverage '*' Files.Prf{i_prffile} '.mat'];
                MapFileInfo = dir(MapFileName);
                MapFileName = MapFileInfo(1).name;
                Map         = load(MapFileName);

                %% .............................................................Get summary of cSNR and cR2 values within label (roi)

                [SumStat, SumStatLabels] = ss_samsrf_calccsnrcr2sum(Map, '');

                %% .............................................................Save

                save([MapFileName(1:end-4) '_' Files.SumStat], 'SumStat', 'SumStatLabels');

            end

        end

    end

    %% .........................................................................Get T1

    T1 = toc(T0);
    TEnd = num2str(T1/60/60);

    %% .........................................................................Display running time

    disp(['Analysis completed in ' TEnd ' hours.']);

    %% .........................................................................Shut down parallel pool

    % ss_parallel_shutdowngcp;

end