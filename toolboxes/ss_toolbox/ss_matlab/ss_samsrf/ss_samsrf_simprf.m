function ss_samsrf_simprf(varargin)
% Input order: FileNameApt, TR, HrfType, Sd, NReps, Affix, ModelType,
% GroundTruth, SearchGridCoverage, ScalingFactor
%
% Simulates time courses using different pRF models.
%
% ------------------------------------------------------------------------------
% Inputs
% ------------------------------------------------------------------------------
% FileNameApt        - File name of aperture [char]
% TR                 - Repetition time [double]
% HrfType            - Type of HRF [char]
% Sd                 - Standard deviation of random Gaussian noise [double]
% NReps              - Number of repetitions [double]
% Affix              - Affix for file name [char]
% ModelType          - Name of pRF model [char]
% GroundTruth        - Matrix containing the ground truth parameters [double]
% SearchGridCoverage - Label indicating to what extend ground truth values
%                      coincide with search grid values (e.g. grid-match or
%                      grid-mismatch or gid-mix) [char]
% ScalingFactor      - Factor for scaling stimulus space [double]
% ------------------------------------------------------------------------------
% Outputs
% ------------------------------------------------------------------------------
% -/-
% ------------------------------------------------------------------------------
% 03/03/2023: Generated (SS)
% 15/10/2024: Last modified (SS)

%% .............................................................................Some defaults

DefInputs = {'aps_pRF' 3 'samsrfcan' 0 200 '' '2dg' [0 0 1]' '' 1};
DefInputs(1:length(varargin)) = varargin;
[FileNameApt, TR, HrfType, Sd, NReps, Affix, ModelType, GroundTruth, ...
    SearchGridCoverage, ScalingFactor] = DefInputs{:};

%% .............................................................................Ground truth and model parameters

% Scaling factor of the stimulus space (e.g. eccentricity)
Model.Scaling_Factor = ScalingFactor;
GroundTruth = GroundTruth.*Model.Scaling_Factor;

% Onoff model without any spatial tuning
if strcmp(ModelType, 'onoff')
    Model.Prf_Function = @(P,ApWidth) double(prf_gaussian_rf(P(1), P(2), 1, ApWidth) > 0);
    % Names of parameters to be fitted
    Model.Param_Names = {'dummy1'; 'dummy2'};

    % 2D Gaussian
elseif strcmp(ModelType, '2dg')
    Model.Prf_Function = @(P,ApWidth) prf_gaussian_rf(P(1), P(2), P(3), ApWidth);
    % Names of parameters to be fitted
    Model.Param_Names = {'x0'; 'y0'; 'Sigma'};

    % 2D Gaussian with fixed sigma
elseif strcmp(ModelType, '2dg-fix')
    Model.Prf_Function = @(P,ApWidth) prf_gaussian_rf(P(1), P(2), 2.*Model.Scaling_Factor, ApWidth);
    % Names of parameters to be fitted
    Model.Param_Names = {'x0'; 'y0'};
end

% Which of these parameters are scaled?
Model.Scaled_Param = zeros(1, size(Model.Param_Names,1));
%%% only zeros: no data cleaning at stage of fine fitting

%% .............................................................................TR, Hrf, and downsampling

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

%% .............................................................................Simulate data

% Load apertures
load(FileNameApt)
% Simulate clean time courses
Srf = samsrf_simulate_prfs(GroundTruth, Model.Prf_Function, ApFrm, ApXY, Model);
% Number of repeats of vertices
Srf.Vertices = repmat(Srf.Vertices, NReps, 1);
% Number of repeats of ground truth set
Srf.Ground_Truth = repmat(GroundTruth, 1, NReps);
% Number of repeats of simulated clean time courses
Srf.Data = repmat(Srf.Data, 1, NReps);
% Store clean time courses
Srf.DataClean = Srf.Data;
% Add Gaussian noise to time courses
Srf.Data = Srf.Data + randn(size(Srf.Data))*Sd;

% Z-normalisation after adding noise
if Sd > 0
    Srf.Data = zscore(Srf.Data);
end

%% .............................................................................Rename

SimModel = Model;
%%% Rename because typically, SamSrf files do not contain a model structure.
%%% So when loading a file, a model structure that has been set up, might
%%% be overwritten.


%% .............................................................................Save simulated data

[~, SplitFileNameApt] = fileparts(FileNameApt);
SplitFileNameApt = extractAfter(SplitFileNameApt, '_a');
save(['sim_' Affix 'nrep-' num2str(NReps) '_sd-' strrep(num2str(Sd), '.', '') '_' ...
    ModelType '_a' SplitFileNameApt '_' HrfType '_' SearchGridCoverage '.mat'], ...
    'Srf', 'SimModel', '-v7.3');

end