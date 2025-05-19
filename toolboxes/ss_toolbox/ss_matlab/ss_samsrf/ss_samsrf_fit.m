function Model = ss_samsrf_fit(ModelType, Hemis, FileNameSurf, FileNameRoi, varargin)
% Input order: ModelType, Hemis, FileNameSurf, FileNameRoi, FileNameApt, PrefixFileNameFit,
% Stage, TR, ModelCSS, HrfType, SuffixFileNameFit, ScalingFactor
%
% Fits different pRF models using a canonical HRF.
%
% ------------------------------------------------------------------------------
% Inputs
% ------------------------------------------------------------------------------
% ModelType         - Type of pRF model [char]
% Hemis             - Hemispheres ('lh' or 'rh') [cell]
% FileNameSurf      - File name of surface data [char]
% FileNameRoi       - File name of ROI used for fitting [char]
% FileNameApt       - File name of aperture [char]
% PrefixFileNameFit - Prefix for file name of pRF fits [char]
% Stage             - Fitting stages that are saved out ('fine', 'coarse').
%                     [cell]
% TR                - Repetition time [double]
% ModelCSS          - Toggles whether CSS shall be modelled (1=yes; 0=no)
%                     [double/logical]
% HrfType           - Toggles whether canonical HRF in SamSrf or SPM's
%                     canonical HRF should be used ('samsrfcan', 'spmcan')
%                     [char]
% SuffixFileNameFit - Suffix for file name of pRF fits [char]
% ScalingFactor     - Factor for scaling stimulus space [double]
% ------------------------------------------------------------------------------
% Outputs
% ------------------------------------------------------------------------------
% Model             - Structure containing fields with model and hrf
%                     parameters, coarse and fine-fitting parameters, and
%                     search grid.
% ------------------------------------------------------------------------------
% 23/08/2022: Generated (SS)
% 14/10/2024: Last modified (SS)
% ------------------------------------------------------------------------------
% TODO:
% (1) Check aspect ratio and calculation of FWHM.
% (2) Review  '2dgmr' and 'dog' model.

%% .............................................................................Some defaults

DefInputs = {'aps_pRF' 'pRF_' {'coarse' 'fine'} 3 0 'samsrfcan' '' 1};
DefInputs(1:length(varargin)) = varargin;
[FileNameApt, PrefixFileNameFit, Stage, TR, ModelCSS, HrfType, ...
    SuffixFileNameFit, ScalingFactor] = DefInputs{:};

if ~isempty(SuffixFileNameFit)
    SuffixFileNameFit = ['_' SuffixFileNameFit];
end

%% .............................................................................Model and search grid

% Scaling factor of the stimulus space (e.g. eccentricity)
Model.Scaling_Factor = ScalingFactor; 

% 2D Gaussian
if strcmp(ModelType, '2dg')
    % Which pRF model function?
    Model.Prf_Function = @(P,ApWidth) prf_gaussian_rf(P(1), P(2), P(3), ApWidth);
    % Names of parameters to be fitted
    Model.Param_Names = {'x0'; 'y0'; 'Sigma'};

    % If true, parameter 1 & 2 are polar (in degrees) & eccentricity coordinates
    Model.Polar_Search_Space = false;

    % X0 search grid or polar search grid
    Model.Param1 =  linspace(-2.5, 2.5, 25).*Model.Scaling_Factor;
    % Y0 search grid or eccentricity search grid
    Model.Param2 =  linspace(-2.5, 2.5, 25).*Model.Scaling_Factor;
    % Sigma search grid
    Model.Param3 = linspace(0, 3, 15).*Model.Scaling_Factor;
    Model.Param3 = Model.Param3(2:end); 
    % Unused
    Model.Param4 = 0;
    % Unused
    Model.Param5 = 0;

    % 2D Gaussian with fixed sigma
elseif strcmp(ModelType, '2dg-fix')
    % Which pRF model function?
    Model.Prf_Function = @(P,ApWidth) prf_gaussian_rf(P(1), P(2), 2.*Model.Scaling_Factor, ApWidth);
    % Names of parameters to be fitted
    Model.Param_Names = {'x0'; 'y0'};

    % If true, parameter 1 & 2 are polar (in degrees) & eccentricity coordinates
    Model.Polar_Search_Space = false;

    % X0 search grid or polar search grid
    Model.Param1 =  linspace(-2.5, 2.5, 25).*Model.Scaling_Factor;
    % Y0 search grid or eccentricity search grid
    Model.Param2 =  linspace(-2.5, 2.5, 25).*Model.Scaling_Factor;
    % Sigma search grid
    Model.Param3 = 0;
    % Unused
    Model.Param4 = 0;
    % Unused
    Model.Param5 = 0;

    % Radially oriented multivariate Gaussian
elseif strcmp(ModelType, '2dgmr')

    % Which pRF model function?
    Model.Prf_Function = @(P,ApWidth) prf_multivariate_rf(P(1), P(2), P(3), P(4), atan2(P(2),P(1))/pi*180, ApWidth);
    % Names of parameters to be fitted
    Model.Param_Names = {'x0'; 'y0'; 'Sigma1'; 'Sigma2'};

    % If true, parameter 1 & 2 are polar (in degrees) & eccentricity coordinates
    Model.Polar_Search_Space = false;

    % X0 search grid or polar search grid
    Model.Param1 =  linspace(-4, 4, 30).*Model.Scaling_Factor;
    % Y0 search grid or eccentricity search grid
    Model.Param2 =  linspace(-4, 4, 30).*Model.Scaling_Factor;
    % Horizontal sigma search grid
    Model.Param3 = linspace(0.5, 4, 14).*Model.Scaling_Factor;
    % Vertical sigma search grid
    Model.Param4 =  linspace(0.5, 4, 14).*Model.Scaling_Factor;
    % Unused
    Model.Param5 = 0;

    % Difference of Gaussians
elseif strcmp(ModelType, 'dog')

    % Which pRF model function?
    Model.Prf_Function = @(P,ApWidth) prf_dog_rf(P(1), P(2), P(3), P(4), P(5), ApWidth);
    % Names of parameters to be fitted
    Model.Param_Names = {'x0'; 'y0'; 'Centre'; 'Surround'; 'Delta'};

    % If true, parameter 1 & 2 are polar (in degrees) & eccentricity coordinates
    Model.Polar_Search_Space = false;

    % X0 search grid or polar search grid
    Model.Param1 =  linspace(-4, 4, 30).*Model.Scaling_Factor;
    % Y0 search grid or eccentricity search grid
    Model.Param2 =  linspace(-4, 4, 30).*Model.Scaling_Factor;
    % Surround sigma search grid
    Model.Param3 = linspace(0.5, 4, 14).*Model.Scaling_Factor;
    % Center sigma search grid
    Model.Param4 =  linspace(0.5, 4, 14).*Model.Scaling_Factor;
    % Delta (surround/centre amplitude) search grid
    Model.Param5 = 0 : 0.5 : 1;

    % Onoff model without any spatial tuning
elseif strcmp(ModelType, 'onoff')

    % Which pRF model function?
    Model.Prf_Function = @(P,ApWidth) double(prf_gaussian_rf(P(1), P(2), 1, ApWidth) > 0);
    % Names of parameters to be fitted
    Model.Param_Names = {'dummy1'; 'dummy2'};

    % If true, parameter 1 & 2 are polar (in degrees) & eccentricity coordinates
    Model.Polar_Search_Space = false;

    % X0 search grid or polar search grid
    Model.Param1 =  0;
    % Y0 search grid or eccentricity search grid
    Model.Param2 =  0;
    % Unused
    Model.Param3 = 0;
    % Unused
    Model.Param4 = 0;
    % Unused
    Model.Param5 = 0;

end

if strcmp(ModelType, 'onoff')
    NPara = 0;
else
    NPara = size(Model.Param_Names,1);
end

% Which of these parameters are scaled
Model.Scaled_Param = zeros(1, size( Model.Param_Names,1));
%%% Only zeros: no data cleaning at stage of fine fitting

% Which parameters must be positive?
Model.Only_Positive = zeros(1, size( Model.Param_Names,1));
%%% Only zeros: no data cleaning at stage of fine fitting

%% .............................................................................Hrf and downsampling

% Repetition time (TR) of pulse sequence
Model.TR = TR;

% HRF file or vector to use (empty = SamSrf canonical)
if strcmp(HrfType, 'samsrfcan')
    Model.Hrf = [];
elseif strcmp(HrfType, 'spmcan')
    Model.Hrf = spm_hrf(Model.TR);
end

% Define microtime resolution of time course prediction
Model.Downsample_Predictions = 1;

%% .............................................................................Coarse and fine fit parameters

% Limit data to above certain noise ceiling?
Model.Noise_Ceiling_Threshold = 0;

% If true, uses coarse fit for bad slow fits
Model.Replace_Bad_Fits = false;

% If > 0, smoothes data for coarse fit
Model.Smoothed_Coarse_Fit = 0;

% Define a Srf file to use as seed map
Model.Seed_Fine_Fit = '';

% Define threshold for what to include in fine fit
Model.Fine_Fit_Threshold = 1.0000e-100;
%%% As for fine fit, optimization loop does not work when Pimg (parameters) are
%%% all NaN and corresponding Rimg is 0. This seems to happen when there are no 
%%% data points available for a certain vertex. This is why we need to have a 
%%% threshold but only for empirical data.  
% -Inf; % 0.00;

% Defines block size for coarse fit
Model.Coarse_Fit_Block_Size = 10000;

% Include only coarse fits with positive correlation?
Model.Only_Positive_Coarse_Fits = false;

% Defines percentile of R2 distribution above which (>=) coarse fits are
% included.
Model.Coarse_Fit_Percentile = 100;
%%% Below 100, averaging is performed.

%% .............................................................................File names

% File name to indicate type of pRF model
[~, SplitFileNameApt] = fileparts(FileNameApt);
SplitFileNameApt = extractAfter(SplitFileNameApt, '_a');
ModelName  = [PrefixFileNameFit '_a' SplitFileNameApt '_' HrfType SuffixFileNameFit];
Model.Name = ModelName;

% Aperture file name
Model.Aperture_File = FileNameApt;

%% .............................................................................Fitting

% Loop through fitting stages
for i_stages = 1:size(Stage, 2)

    CurrStage = Stage{1, i_stages};

    % If true, only runs the coarse fit
    if strcmp(CurrStage, 'coarse')
        Model.Coarse_Fit_Only = 1;
        % If false, runs coarse+fine fit and fits a parameter reflecting
        % compressive spatial summation
    elseif strcmp(CurrStage, 'fine')
        Model.Coarse_Fit_Only = 0;
        if ModelCSS
            Model.Compressive_Nonlinearity = true;
        end
        Model.Name = [Model.Name '_FneFit'];
        %%% Note: We split off fine fit extension further below again after hemi
        %%% loop.
    end

    % Loop through hemispheres
    for i_hemi = 1:size(Hemis, 2)

        CurrHemi = Hemis{i_hemi};

        % Srf files and ROI
        SrfFiles = [CurrHemi FileNameSurf];

        if isempty(FileNameRoi)
            FileNameRoiExtr = FileNameRoi;
        else
            [SplitFilePathRoi, SplitFileNameRoi] = fileparts(FileNameRoi);
            FileNameRoiExtr =  fullfile(SplitFilePathRoi, [CurrHemi '_' SplitFileNameRoi]);
        end

        % Fit pRF model
        MapFileName = samsrf_fit_prf(Model, SrfFiles, FileNameRoiExtr);

        %% .....................................................................Post-processing

        % Rename search file
        if strcmp(CurrStage, 'coarse')
            SrcFileName = ['src_' Model.Name];
            movefile([SrcFileName '.mat'], [SrcFileName '_CrsFit.mat' ]);
            %%% Note: This means that, initially, for the "other" hemisphere, a 
            %%% novel search file will be generated and saved and then renamed, 
            %%% so that only 1 search file for both hemis remains.
        end

        % Load map we just analyzed
        ReloadedMapFile = load(MapFileName);

        % Calculate adjusted R2 and save file again
        ss_samsrf_calcar2(ReloadedMapFile.Srf, ReloadedMapFile.Model, NPara, MapFileName);

        if strcmp(ModelType, '2dgmr')
            % Add aspect ratio (log of radial/tangential)
            ss_samsrf_calcaspectratio(ReloadedMapFile.Srf, ReloadedMapFile.Model, MapFileName)
        elseif strcmp(ModelType, 'dog')
            % Calculate FWHM
            ss_samsrf_calcfwhm(ReloadedMapFile.Srf, ReloadedMapFile.Model, MapFileName)
        end

        clear MapFileName ReloadedMapFile

    end

    %% .........................................................................Resetting of model name

    if strcmp(CurrStage, 'fine')
        Model.Name = ModelName;
        %%% Note: Resetting of model name is necessary if e.g. fine fit is
        %%% being saved before coarse fit.
    end

end

end