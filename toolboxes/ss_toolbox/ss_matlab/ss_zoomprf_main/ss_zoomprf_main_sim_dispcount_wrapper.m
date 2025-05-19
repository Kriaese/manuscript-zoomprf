function ss_zoomprf_main_sim_dispcount_wrapper(Subjects, Fld, Files, Para)
%
%
%
% ------------------------------------------------------------------------------
% 11/11/2023: Generated (SS)
% 09/01/2025: Last modified (SS)

%% .............................................................................Loop through sessions

for i_sess = 1:size(Subjects.Sessions,2)

    CurrSess  = Subjects.Sessions{i_sess};

    %% .........................................................................Loop through hemis

    for i_hemi = 1:size(Para.Hemis,2)

        CurrHemi = Para.Hemis{i_hemi};

        %% .....................................................................Loop through standard deviation

        for i_sd = 1:size(Para.Sd,2)

            CurrSd                  = Para.Sd(1, i_sd);
            CurrNReps               = Para.NReps(1, i_sd);
            CurrSearchSpaceCoverage = Files.SearchGridCoverge{1, i_sd};

            %% .................................................................Put together file names 

            FileNameStem            = [CurrSess '_' Files.Prf{1} num2str(CurrNReps) Files.Prf{2} ...
                num2str(strrep(num2str(CurrSd), '.', '')) '_' Files.Prf{3} CurrSearchSpaceCoverage Files.Prf{4}];
            FileNamePrf             = [CurrHemi '_' FileNameStem];
            FileNameSearchSpace     = [Files.SearchSpace '_' FileNameStem];
            FileNameCount           = [FileNamePrf '_' Files.Count];

            %% .................................................................Paths

            PathSamSrfSimSub  = fullfile(Fld.SamSrfRoot, Fld.SamSrfSim, CurrSess, Fld.SamSrfSimSub);
            PathResultsSimSub = fullfile(Fld.ResultsRoot, Fld.SamSrfSim, CurrSess, Fld.SamSrfSimSub);
            cd(PathSamSrfSimSub)

            %% .................................................................Get data

            Data        = load(FileNamePrf);
            SearchSpace = load(FileNameSearchSpace);
            Count       = load(FileNameCount);

            %% .................................................................Display count

            ss_zoomprf_main_sim_dispcount(Data.Srf, Count, SearchSpace.S, ...
                Para.AptXY, Para.XLabel, Para.YLabel, Para.XLim, Para.YLim, ...
                Para.XTicks, Para.YTicks, Para.ColorBarLabel, Para.IdxPanelOrder, ...
                Para.ColorBarLim, Para.Units);

            %% .................................................................Set font type

            set(gca, 'FontName', 'Helvetica');
            
            %% .................................................................Save figure

            cd(PathResultsSimSub)
            ss_exportgraphics([FileNamePrf '_counts-rec.' Para.Ext], gcf, Para.Res); 
            close all;

        end

    end

end

end