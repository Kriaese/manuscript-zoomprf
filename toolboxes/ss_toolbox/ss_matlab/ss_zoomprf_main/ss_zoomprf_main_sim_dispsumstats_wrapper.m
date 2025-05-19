function ss_zoomprf_main_sim_dispsumstats_wrapper(Subjects, Fld, Files, Para)
%
%
%
% ------------------------------------------------------------------------------
% 17/04/2023: Generated (SS)
% 08/01/2025: Last modified (SS)
%-------------------------------------------------------------------------------

%% .............................................................................Loop through sessions

for i_sess = 1:size(Subjects.Sessions,2)

    CurrSess  = Subjects.Sessions{i_sess};

    %% .........................................................................Paths

    PathSamSrfSimSub  = fullfile(Fld.SamSrfRoot, Fld.SamSrfSim, CurrSess, Fld.SamSrfSimSub);
    PathResultsSimSub = fullfile(Fld.ResultsRoot, Fld.SamSrfSim, CurrSess, Fld.SamSrfSimSub);
    ss_checkfld(PathResultsSimSub);

    %% .........................................................................Loop through hemis

    for i_hemi = 1:size(Para.Hemis,2)

        CurrHemi = Para.Hemis{i_hemi};

        %% .....................................................................Loop through standard deviation of the noise

        for i_sd = 1:size(Para.Sd,2)

            CurrSd                  = Para.Sd(1, i_sd);
            CurrNReps               = Para.NReps(1, i_sd);
            CurrSearchSpaceCoverage = Files.SearchGridCoverge{1, i_sd};

            %% .................................................................Put together file names

            FileNameSumStats  = [CurrHemi '_' CurrSess '_' Files.Prf{1} ...
                num2str(CurrNReps) Files.Prf{2} num2str(strrep(num2str(CurrSd), '.', '')) ...
                Files.Prf{3} CurrSearchSpaceCoverage Files.Prf{4}];

            %% .................................................................Get data

            cd(PathSamSrfSimSub)
            Data = load(FileNameSumStats);

            %% .................................................................Display summary stats

            ss_zoomprf_main_sim_dispsumstats(Data, Para.AptXY, Para.Color, ...
                Para.XLabel, Para.YLabel,...
                Para.LineStyle, Para.MidpointSymbols, Para.XYLim, ...
                Para.XTicks, Para.YTicks, Para.Units)

            %% .................................................................Save figure

            cd(PathResultsSimSub)
            ss_exportgraphics([FileNameSumStats '.' Para.Ext], gcf, Para.Res); 
            close all;


        end

    end

end

end