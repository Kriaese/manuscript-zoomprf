function ss_zoomprf_main_sim_disptc_wrapper(Subjects, Fld, Files, Para)
%
%
%
% ------------------------------------------------------------------------------
% 07/09/2023: Generated (SS)
% 12/01/2026: Last modified (SS)

%% .............................................................................Get t0

T0 = tic;

%% .............................................................................Loop through sessions

for i_sess = 1:size(Subjects.Sessions,2)

    CurrSess          = Subjects.Sessions{i_sess};

    %% .........................................................................Loop through hemispheres

    for i_hemi = 1:size(Para.Hemis,2)

        CurrHemi = Para.Hemis{1, i_hemi};

        %% .....................................................................Loop through standard deviation of the noise

        for i_sd = 1:size(Para.Sd,2)

            CurrSd                  = Para.Sd(1, i_sd);
            CurrNReps               = Para.NReps(1, i_sd);
            CurrSearchSpaceCoverage = Files.SearchGridCoverge{1, i_sd};

            %% .................................................................Put together file names

            SimFileName   = [CurrHemi '_' CurrSess '_' Files.Prf{1} ...
                num2str(CurrNReps) Files.Prf{2} ...
                num2str(strrep(num2str(CurrSd), '.', '')) '_' Files.Prf{3} ...
                '_' CurrSearchSpaceCoverage];

            %% .................................................................Paths

            PathSamSrfSimSub  = fullfile(Fld.SamSrfRoot, Fld.SamSrfSim, CurrSess, Fld.SamSrfSimSub);
            PathResultsSimSub = fullfile(Fld.ResultsRoot, Fld.SamSrfSim, CurrSess, Fld.SamSrfSimSub);

            %% .................................................................Get data

            cd(PathSamSrfSimSub)
            SimData = load(SimFileName);

            %% .................................................................Initialize figure window and tiled layout

            figure
            TiledLayoutHandle = tiledlayout(1, 1);

            %% .................................................................Display simulated time courses

            nexttile
            ss_samsrf_disptc_sim(SimData.Srf, SimData.SimModel, Para.VtxIdx, Para.SophFeatures, Para.Units, Para.BlockOnsets);

            %% .................................................................Add axis limits

            ylim(Para.YLim);
            yticks(Para.YTicks)

            %% .................................................................Set font type and size

            set(gca, 'FontName', 'Helvetica');
            set(gca, 'fontsize', 13)

            %% .................................................................Define spacing and padding

            TiledLayoutHandle.TileSpacing   = 'compact';
            TiledLayoutHandle.Padding       = 'compact';

            %% .................................................................Resize figure

            ss_reswin(gcf, 2, 1)

            %% .................................................................Save figure

            cd(PathResultsSimSub)
            ss_exportgraphics([SimFileName '_tc-sim.' Para.Ext], gcf, Para.Res); 

            close all;

        end

    end

    %% .........................................................................Get T1

    T1 = toc(T0);
    TEnd = num2str(T1/60/60);

    %% .........................................................................Display running time

    disp(['Analysis completed in ' TEnd ' hours.']);

end