function ss_zoomprf_main_sim_calcsumstats_wrapper(Subjects, Fld, Files, Para)
%
%
%
% ------------------------------------------------------------------------------
% 04/04/2023: Generated (SS)
% 16/10/2024: Last modified (SS)

%% .............................................................................Loop through sessions

for i_sess = 1:size(Subjects.Sessions,2)

    CurrSess = Subjects.Sessions{i_sess};

    %% .........................................................................Loop through hemis

    for i_hemi = 1:size(Para.Hemis,2)

        CurrHemi = Para.Hemis{i_hemi};

        %% .....................................................................Loop through standard deviation of the noise                                                                  

        for i_sd = 1:size(Para.Sd,2)

            CurrSd                  = Para.Sd(1, i_sd);
            CurrNReps               = Para.NReps(1, i_sd);
            CurrSearchSpaceCoverage = Files.SearchGridCoverge{1, i_sd};

            %% .................................................................Paths

            PathSamSrfSimSub  = fullfile(Fld.SamSrfRoot, Fld.SamSrfSim, CurrSess, Fld.SamSrfSimSub);

            %% .................................................................Put together file names

            FileNamePrf   = [CurrHemi '_' CurrSess '_' Files.Prf{1} num2str(CurrNReps)...
                Files.Prf{2} num2str(strrep(num2str(CurrSd), '.', '')) Files.Prf{3} ...
                CurrSearchSpaceCoverage Files.Prf{4}];
            FileNameSim   = [CurrHemi '_' CurrSess '_' Files.Sim{1} num2str(CurrNReps)...
                Files.Sim{2} num2str(strrep(num2str(CurrSd), '.', '')) Files.Sim{3} ...
                CurrSearchSpaceCoverage];
            FileNameSumStats = [FileNamePrf '_sumstats'];

            %% .................................................................Load files

            cd(PathSamSrfSimSub)
            PrfData = load(FileNamePrf);
            SimData = load(FileNameSim);

            %% .................................................................Get sum stats of simulated parameters

            [SumStats, ValuesCols, ValuesRows, ValuesDim3] = ...
                ss_zoomprf_main_sim_calcsumstats(PrfData.Srf, Para.Values, SimData.SimModel);

            %% .................................................................Save

            save(FileNameSumStats, 'ValuesRows', 'ValuesCols', 'SumStats', 'ValuesDim3');

        end

    end

end

end