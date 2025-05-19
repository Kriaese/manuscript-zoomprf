function ss_zoomprf_main_sim_disppval_wrapper(Subjects, Fld, Files, Para)
%
%
%
% ------------------------------------------------------------------------------
% 14/03/2023: Generated (SS)
% 04/02/2025: Last modified (SS)
% ------------------------------------------------------------------------------

%% .............................................................................Get t0

T0 = tic;

%% .............................................................................Loop through sessions

for i_sess = 1:size(Subjects.Sessions,2)

    CurrSess   = Subjects.Sessions{i_sess};

    %% .........................................................................Loop through standard deviation

    for i_sd = 1:size(Para.Sd,2)

        CurrSd                  = Para.Sd(1, i_sd);
        CurrNReps               = Para.NReps(1, i_sd);
        CurrSearchSpaceCoverage = Files.SearchGridCoverge{1, i_sd};

        %% .....................................................................Loop through hemispheres

        for i_hemi = 1:size(Para.Hemis,2)

            CurrHemi = Para.Hemis{1, i_hemi};

            %% .................................................................Put together file names

            MapFileName   = [CurrHemi '_' CurrSess '_' Files.Prf{1} num2str(CurrNReps) ...
                Files.Prf{2} num2str(strrep(num2str(CurrSd), '.', '')) Files.Prf{3} CurrSearchSpaceCoverage ...
                '_' Files.Prf{4}];
            SumStatFileName   = [MapFileName  '_' Files.SumStat];

            %% .................................................................Paths

            PathSamSrfSimSub  = fullfile(Fld.SamSrfRoot, Fld.SamSrfSim, CurrSess, Fld.SamSrfSimSub);
            PathResultsSimSub = fullfile(Fld.ResultsRoot, Fld.SamSrfSim, CurrSess, Fld.SamSrfSimSub);
            ss_checkfld(PathResultsSimSub);

            %% .................................................................Get data

            cd(PathSamSrfSimSub)
            Map   = load(MapFileName);
            Stats = load(SumStatFileName);

            %% .................................................................Initialize figure window and tiled layout

            figure
            TiledLayoutHandle = tiledlayout(1, 1);

            %% .................................................................Display histogram

            nexttile
            ss_zoomprf_main_sim_dispval(Map.Srf, Para.R2DiffType, Stats, ...
                Para.Edges, Para.XLabel, Para.YLabel, Para.YLim, Para.YTicks)

            %% .................................................................Set font type and size

            set(gca, 'FontName', 'Helvetica');
            set(gca, 'fontsize', 13);

            %% .................................................................Define spacing and padding

            TiledLayoutHandle.TileSpacing   = 'compact';
            TiledLayoutHandle.Padding       = 'compact';

            %% .................................................................Resize figure

            ss_reswin(gcf, 2, 1)

            %% .................................................................Save figure

            cd(PathResultsSimSub)
            ss_exportgraphics([SumStatFileName '.' Para.Ext], gcf, Para.Res);

            close all;

        end

    end

end

%% .............................................................................Get T1

T1 = toc(T0);
TEnd = num2str(T1/60/60);

%% .............................................................................Display running time

disp(['Analysis completed in ' TEnd ' hours.']);

end