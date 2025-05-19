function ss_zoomprf_main_sim_dispgrid_wrapper(Subjects, Fld, Files, Para)
%
%
%
% ------------------------------------------------------------------------------
% 10/11/2023: Generated (SS)
% 09/01/2025: Last modified (SS)

%% .............................................................................Loop through sessions

for i_sess = 1:size(Subjects.Sessions,2)

    CurrSess  = Subjects.Sessions{i_sess};

    %% .........................................................................Loop through hemis

    for i_hemi = 1:size(Para.Hemis,2)

        CurrHemi = Para.Hemis{i_hemi};

        %% .....................................................................Loop through standard deviation

        for i_sd = 1:size(Para.Sd,2)

            CurrSd                 = Para.Sd(1, i_sd);
            CurrNReps              = Para.NReps(1, i_sd);
            CurrSearchGridCoverage = Files.SearchGridCoverge{1, i_sd};

            %% .................................................................Generate file names

            FileNameStem        = [CurrSess '_' Files.Prf{1} num2str(CurrNReps) Files.Prf{2} ...
                num2str(strrep(num2str(CurrSd), '.', ''))  '_' Files.Prf{3} CurrSearchGridCoverage Files.Prf{4}];
            FileNamePrf         = [CurrHemi '_' FileNameStem];
            FileNameSearchSpace = [Files.SearchSpace '_' FileNameStem];

            %% .................................................................Paths

            PathSamSrfSimSub = fullfile(Fld.SamSrfRoot, Fld.SamSrfSim, CurrSess, Fld.SamSrfSimSub);
            PathResultsSimSub = fullfile(Fld.ResultsRoot, Fld.SamSrfSim, CurrSess, Fld.SamSrfSimSub);
            ss_checkfld(PathResultsSimSub);
            cd(PathSamSrfSimSub)

            %% .................................................................Get data

            Data = load(FileNamePrf);

            %% .................................................................Initialize figure window and tiled layout

            figure
            TiledLayoutHandle = tiledlayout(1, 1);
            nexttile

            %% .................................................................Simulated scenario ...

            if strcmp(Para.GridType, 's')

                %% .............................................................Get search space

                SearchSpace = load(FileNameSearchSpace);

                %% .............................................................Specify suffix

                Suffix = '_grids-sim';

                %% .............................................................Recovered parameters...
            else
                %% .............................................................Get search space

                SearchSpace.S = [];

                %% .............................................................Specify suffix

                Suffix = '_grids-rec';

            end


            %% .................................................................Display grids

            ss_zoomprf_main_sim_dispgrid(Data.Srf, Para.AptXY, Para.XLabel, ...
                Para.YLabel, SearchSpace.S);

            %% .................................................................Add axis limits

            axis(Para.XYLim);

            %% .................................................................Add ticks

            xticks(Para.XTicks)
            yticks(Para.YTicks)

            %% .................................................................Set font type and size

            set(gca, 'FontName', 'Helvetica');
            set(gca, 'fontsize', 13);

            %% .................................................................Define spacing and padding

            TiledLayoutHandle.TileSpacing   = 'compact';
            TiledLayoutHandle.Padding       = 'compact';

            %% .................................................................Save figure

            cd(PathResultsSimSub)
            ss_exportgraphics([FileNamePrf Suffix '.' Para.Ext], gcf, Para.Res);
            close all;

        end

    end

end

end