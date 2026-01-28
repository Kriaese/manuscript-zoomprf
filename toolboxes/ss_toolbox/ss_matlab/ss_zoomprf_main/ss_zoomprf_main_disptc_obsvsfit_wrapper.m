function ss_zoomprf_main_disptc_obsvsfit_wrapper(Subjects, Fld, Files, Para)
%
%
%
% ------------------------------------------------------------------------------
% 18/08/2023: Generated (SS)
% 23/11/2025: Last modified (SS)

%% .............................................................................Get t0

T0 = tic;

%% .............................................................................Loop through subjects

for i_subj=1:size(Subjects.ID,2)

    CurrSubj = Subjects.ID{i_subj};

    %% .........................................................................Loop through kernel size

    for i_kernel=1:size(Subjects.Kernel,2)

        CurrKernel = Subjects.Kernel{i_kernel};

        %% .....................................................................Loop through sessions

        for i_sess = 1:size(Subjects.Sessions,2)

            CurrSess          = Subjects.Sessions{i_sess};

            %% .................................................................Paths

            PathSamSrfKernel           = fullfile(Fld.SamSrfRoot, CurrSubj, CurrSess, CurrKernel);
            PathResultsKernel          = fullfile(Fld.ResultsRoot, CurrSubj, CurrSess,CurrKernel);
            ss_checkfld(PathResultsKernel);

            %% .................................................................Loop through hemispheres

            for i_hemi = 1:size(Para.Hemis,2)

                CurrHemi = Para.Hemis{1, i_hemi};
                CurrVtxIdxHemi   = Subjects.VtxIdx{1, i_hemi};

                %% .............................................................Get data

                cd(PathSamSrfKernel)
                FileInfoM0 = dir([CurrHemi '*' CurrSess Files.Prf{1}]);
                DataM0 = load(FileInfoM0.name);

                FileInfoM1 = dir([CurrHemi '*' CurrSess Files.Prf{2}]);
                DataM1 = load(FileInfoM1.name);

                %% .............................................................Initialize figure window and tiled layout

                figure
                TiledLayoutHandle = tiledlayout(size(CurrVtxIdxHemi,2), 1);

                %% .............................................................Loop through vertex indices

                for i_vtxidxhemi=1:size(CurrVtxIdxHemi,2)

                    CurrVtxIdx = CurrVtxIdxHemi(i_subj, i_vtxidxhemi);

                    %% .........................................................Display observed and fitted time courses

                    nexttile

                    ss_samsrf_disptc_obsvsfit(DataM0, DataM1, CurrVtxIdx,...
                        Para.ModelType{1}, Para.ModelType{2}, Para.ValuesTitle{1}, ...
                        Para.ValuesTitle{2}, Para.Units, Para.SophFeatures, Para.BlockOnsets);

                    %% .........................................................Add plot features

                    AxisHandle = gca;
                    AxisHandle.YLim = Para.YLim;
                    AxisHandle.FontSize = 13;
                    AxisHandle.FontName = 'Helvetica';

                end

                %% .............................................................Define spacing and padding

                TiledLayoutHandle.TileSpacing   = 'compact';
                TiledLayoutHandle.Padding       = 'compact';
                TiledLayoutHandle.XLabel.String = Para.XLabel;
                TiledLayoutHandle.YLabel.String = Para.YLabel;

                %% .............................................................Resize window

                ss_reswin(gcf, 2, 2)

                %% .............................................................Save figure

                cd(PathResultsKernel)
                ss_exportgraphics([FileInfoM1.name(1:end-4) '_tc-obsvsfit.' Para.Ext], gcf, Para.Res);
                close all;

            end

        end

    end

end

%% .............................................................................Get T1

T1 = toc(T0);
TEnd = num2str(T1/60/60);

%% .............................................................................Display running time

disp(['Analysis completed in ' TEnd ' hours.']);

end