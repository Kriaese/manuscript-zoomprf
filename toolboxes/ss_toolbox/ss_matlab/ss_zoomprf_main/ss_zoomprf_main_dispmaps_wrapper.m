function ss_zoomprf_main_dispmaps_wrapper(Subjects, Fld, Files, Para)
%
%
%
% ------------------------------------------------------------------------------
% 18/09/2022: Regenerated (SS)
% 06/01/2025: Last modified (SS)
% ------------------------------------------------------------------------------

%% .............................................................................Get t0

T0 = tic;

%% .............................................................................Try to get current parallel pool

ss_parallel_gcp;

%% .............................................................................Change SamSrf defaults

ss_samsrf_changedef([], [], [], Para.PathWidth(1));

%% .............................................................................Loop through subjects

for i_subj=1:size(Subjects.ID,2)

    CurrSubj = Subjects.ID{i_subj};

    %% .........................................................................Paths

    PathFSLabel          = fullfile(Fld.FSRoot, CurrSubj, Fld.FSLabel);
    PathFSAtlas          = fullfile(Fld.FSRoot, CurrSubj, Fld.FSAtlas);

    %% .........................................................................Loop through kernel size

    for i_kernel=1:size(Subjects.Kernel,2)

        CurrKernel = Subjects.Kernel{i_kernel};
        CurrKernelSamSrfLabel = Subjects.KernelSamSrfLabel{i_kernel};

        %% .....................................................................Loop through sessions

        for i_sess = 1:size(Subjects.Sessions,2)
            % parfor

            CurrSess   = Subjects.Sessions{i_sess};
            CurrSessSamSrfLabel   = Subjects.SessionsSamSrfLabel{i_sess};

            %% .................................................................Paths

            PathSamSrfKernel           = fullfile(Fld.SamSrfRoot, CurrSubj, CurrSess, CurrKernel);
            PathSamSrfKernelLabel      = fullfile(Fld.SamSrfRoot, CurrSubj, CurrSessSamSrfLabel, CurrKernelSamSrfLabel);
            PathResultsKernel          = fullfile(Fld.ResultsRoot, CurrSubj, CurrSess, CurrKernel);
            ss_checkfld(PathResultsKernel);

            %% .................................................................Loop through hemis

            for i_hemi=1:size(Para.Hemis,2)

                CurrHemi = Para.Hemis{i_hemi};
                CurrCamView = Para.CamView{i_hemi};

                %% .............................................................Get file info and load file

                cd(PathSamSrfKernel)
                FileInfo = dir([CurrHemi '_' Files.Data]);

                File = load(FileInfo.name);

                %% .............................................................Expand standard surface struture

                File.Srf = samsrf_expand_srf(File.Srf);

                %% .............................................................Put together SamSrf labels

                cd(PathSamSrfKernelLabel)
                SamSrfLabelList  = dir([Fld.SamSrfLabel]);

                if ~isempty(Files.SamSrfLabel ) && sum(strcmp(CurrHemi, Para.HemisSamsrfLabels)) > 0
                    %%% Note that this conditional here allows us to have one
                    %%% hemisphere without a sepcific label. This might be
                    %%% necessary if we expect unilateral effects.
                    SamSrfLabels     = strcat(SamSrfLabelList.folder, filesep, SamSrfLabelList.name, ...
                        filesep, CurrHemi, '_', Files.SamSrfLabel , '.label');
                else
                    SamSrfLabels     = [];
                end

                %% .............................................................Put together FreeSurfer labels

                if ~isempty(Files.FSLabel)
                    FSLabels = strcat(PathFSLabel, filesep, CurrHemi, Files.FSLabel, '.label');
                else
                    FSLabels = [];
                end

                 %% ............................................................Put together FreeSurfer atlas labels

                if ~isempty(Files.FSAtlas)
                    FSAtlasLabels = strcat(PathFSAtlas, filesep, CurrHemi, Files.FSAtlas, '.label');
                else
                    FSAtlasLabels = [];
                end

                %% .............................................................Put together all labels 

                Labels = [SamSrfLabels, FSLabels, FSAtlasLabels];

                %% .............................................................Loop through map types

                for i_mapt = 1:size(Para.MapType,2)

                    CurrThreshold = Para.Threshold{i_mapt};
                    CurrMapType   = Para.MapType{i_mapt};
                    CurrPathColor = Para.PathColors{i_mapt};

                    %% .........................................................Reformat noise ceiling maps (if necessary)

                    if strcmp(CurrMapType, 'Noise Ceiling') && isfield(File.Srf, 'Noise_Ceiling')
                        File.Srf.Data = [File.Srf.Noise_Ceiling; File.Srf.Data];
                        File.Srf.Values = [{'Noise Ceiling'}; File.Srf.Values];
                    end

                    %% .........................................................Add fake nR2 (if no nR2 present or no nR2 cleaning desired)

                    if ~strcmp(File.Srf.Values{1}, 'nR^2') || Para.InactivatenR2Cleaning
                        IdxMapType = strcmp(File.Srf.Values, CurrMapType);
                        IdxMapTypeNaN = isnan(File.Srf.Data(IdxMapType,:));

                        %% .....................................................Create novel fake nR2 vector

                        if ~strcmp(File.Srf.Values{1}, 'nR^2')
                            File.Srf.Data = [nan(1, size(File.Srf.Data,2)); File.Srf.Data];
                            File.Srf.Data(1, ~IdxMapTypeNaN) = 1;
                            File.Srf.Values = [{'nR^2'}; File.Srf.Values];

                            %% .................................................Transform existing nR2 vector into fake nR2 vector
                        else
                            IdxNR2 = strcmp(File.Srf.Values, 'nR^2');
                            File.Srf.Data(IdxNR2, :) = nan(1, size(File.Srf.Data,2));
                            File.Srf.Data(IdxNR2 , ~IdxMapTypeNaN) = 1;
                            clear IdxNR2
                        end
                    end

                    %% .........................................................Check if multiple nR2 entries are present

                    if sum(strcmp(File.Srf.Values, 'nR^2')) > 1
                        error('multiple nR^2 entries')
                    end

                    %% .........................................................Restrict maps to labels (if desired)

                    Affix = '';

                    if Para.RestrictMapsToLabels && ~isempty(Labels)

                        %% .....................................................Set all non-nan vertices to -1

                        IdxNR2      = strcmp(File.Srf.Values, 'nR^2');
                        IdxNR2NaN   = isnan(File.Srf.Data(IdxNR2, :));
                        File.Srf.Data(IdxNR2, ~IdxNR2NaN) = -1;

                        IdxLabel = [];

                        for i_labels=1:size(Labels,2)
                            IdxLabel = [IdxLabel; samsrf_loadlabel(Labels{1, i_labels}(1:end-6))];
                        end

                        %% .....................................................Set all label vertices to 1
                        
                        File.Srf.Data(IdxNR2, IdxLabel) = 1;

                        %% .....................................................Ensure that label vertices that used to be nan stay nan

                        File.Srf.Data(IdxNR2, IdxNR2NaN) = NaN;
                        %%% Make sure that NaNs stay NaNs.
                        
                        %% .....................................................Update affix

                        Affix = [Affix, '_masked-func'];
                    else
                        Affix = [Affix, ''];
                    end

                    %% .........................................................Restrict surface reconstruction (a.k.a. 'anatomy') to label (if desired)

                    if ~isempty(Files.AnatLabel)

                        %% .....................................................Get array index for anatomy label

                        if strcmp(Files.AnatLabel{2}, 'fsatlas')
                            AnatLabel = fullfile(PathFSAtlas, [CurrHemi Files.AnatLabel{1}]);
                        elseif strcmp(Files.AnatLabel{2}, 'samsrf')
                            AnatLabel = fullfile(SamSrfLabelList.folder, SamSrfLabelList.name, [CurrHemi '_' Files.AnatLabel{1}]);
                        elseif strcmp(Files.AnatLabel{2}, 'fslabels')
                            AnatLabel = fullfile(PathFSLabel, [CurrHemi Files.AnatLabel{1}]);
                        end

                        IdxAnatLabelArray = samsrf_loadlabel(AnatLabel);

                        %% .....................................................Set alpha level of all vertices to 1

                        File.Srf.VxAlpha = zeros(size(File.Srf.Vertices,1),1);
                        File.Srf.VxAlpha(IdxAnatLabelArray) = 1;

                        %% .....................................................Loop through steps of blurry border

                        for i_steps = Para.BlurryBorderSteps

                            %% .................................................Get array index of vertices surrounding current anatomy label (i.e. border)

                            IdxBorderArray = samsrf_borderpath(File.Srf, IdxAnatLabelArray);

                            %% .................................................Define alpha level for these border vertices

                            File.Srf.VxAlpha(IdxBorderArray) = 1 - i_steps/size(Para.BlurryBorderSteps,2);

                            %% .................................................Add these vertices to the Roi label

                            IdxAnatLabelArray = [IdxAnatLabelArray; IdxBorderArray];

                        end

                        %% .....................................................Create a logical index of vertices

                        IdxAnatLabelLogical = true(size(File.Srf.Vertices,1),1);

                        %% .....................................................Set all vertices of interest to false

                        IdxAnatLabelLogical(IdxAnatLabelArray) = false;

                        %% .....................................................Set all vertices of non-interest to nan

                        File.Srf.Vertices(IdxAnatLabelLogical,:) = NaN;

                        %% .....................................................Update affix

                        Affix = [Affix, '_masked-anat'];
                    else
                        Affix = [Affix, ''];
                    end

                    %% .........................................................Display map

                    figure;
                    samsrf_surf(File.Srf, Para.Mesh, CurrThreshold,...
                        [Labels, [NaN CurrPathColor]], CurrCamView, CurrMapType);

                    %% .........................................................Resize figure

                    % ss_reswin(gcf, 3, 3);

                    %% .........................................................Save map

                    cd(PathResultsKernel)

                    if Para.Blanco
                        MapTypeSuffix = 'blanco';
                    else
                        MapTypeSuffix = CurrMapType;
                    end

                    ss_exportgraphics([[FileInfo.name(1:end-4) ...
                        '_map-' strrep(MapTypeSuffix, ' ', '') Affix] '.' Para.Ext], gcf, Para.Res); 

                    close all;

                end

            end

        end

    end

end


%% .............................................................................Change SamSrf defaults

ss_samsrf_changedef([], [], [], Para.PathWidth(2));

%% .............................................................................Get T1

T1 = toc(T0);
TEnd = num2str(T1/60/60);

%% .............................................................................Display running time

disp(['Analysis completed in ' TEnd ' hours.']);

%% .............................................................................Shut down parallel pool

ss_parallel_shutdowngcp;

end