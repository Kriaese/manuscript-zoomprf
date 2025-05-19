function [SumStat, SumStatLabels] = ss_samsrf_calcsumstat(Map, RoiLabel, GlmConts)
%
%
% Summarizes x0, y0, sigma, Beta, and R^2 values.
%
% ------------------------------------------------------------------------------
% Inputs
% ------------------------------------------------------------------------------
% Map             - SamSrf surface and model structure resulting from pRF
%                   fitting [structure]
% RoiLabel        - Name of ROI label to be loaded w/o extension [char]
% GlmConts        - SamSrf surface structure resulting from glm contrast 
%                   [structure]
% ------------------------------------------------------------------------------
% Outputs
% ------------------------------------------------------------------------------
% SumStat         - Summary stats for x0, y0, sigma, Beta, Baseline and R^2 
%                   values [double]
% SumStatLabels   - Labels for summary stats [cell]
% ------------------------------------------------------------------------------
% 16/12/2024: Generated (SS)
% 17/12/2024: Last modified (SS)
% ------------------------------------------------------------------------------

%% .............................................................................Expand surfaces

Map.Srf      = samsrf_expand_srf(Map.Srf);
GlmConts.Srf = samsrf_expand_srf(GlmConts.Srf);

%% .............................................................................Get indices for several values

IdxX0         = strcmp(Map.Srf.Values, 'x0');
IdxY0         = strcmp(Map.Srf.Values, 'y0');
IdxSigma      = strcmp(Map.Srf.Values, 'Sigma');
IdxBeta       = strcmp(Map.Srf.Values, 'Beta');
IdxBaseline   = strcmp(Map.Srf.Values, 'Baseline');
IdxR2         = strcmp(Map.Srf.Values, 'R^2');

IdxStimRest     = strcmp(GlmConts.Srf.Values, 'Stim-Rest');

%% .............................................................................Get ROI index

IdxRoi = samsrf_loadlabel(RoiLabel);

if isnan(IdxRoi)
    IdxRoi = 1:size(Map.Srf.Data,2);
end

%% .............................................................................Get data in Roi

Data               = Map.Srf.Data(:, IdxRoi);
DataStimRest       = GlmConts.Srf.Data(IdxStimRest, IdxRoi); 

%% .............................................................................Clean data in Roi

IdxClean = DataStimRest > 0;
%%% Note: Keep vertices for whom the t-statistic in the glm was positive.

DataClean  = Data(:, IdxClean);

%% .............................................................................Calculate summary statistics

[X0AbsMin, IdxX0AbsMin] = min(abs(DataClean(IdxX0,:)));
[X0AbsMax, IdxX0AbsMax] = max(abs(DataClean(IdxX0,:)));
[Y0AbsMin, IdxY0AbsMin] = min(abs(DataClean(IdxY0,:))) ;
[Y0AbsMax, IdxY0AbsMax] = max(abs(DataClean(IdxY0,:)));
[SigmaMin, IdxSigmaMin] = min(DataClean(IdxSigma,:)) ;
[SigmaMax, IdxSigmaMax] = max(DataClean(IdxSigma,:));

SumStat = [ ...
    X0AbsMin X0AbsMax...
    Y0AbsMin Y0AbsMax ...
    SigmaMin SigmaMax ...
    min(DataClean(IdxR2,  IdxX0AbsMin ))       max(DataClean(IdxR2, IdxX0AbsMax )) ...
    min(DataClean(IdxR2,  IdxY0AbsMin ))       max(DataClean(IdxR2, IdxY0AbsMax )) ...
    min(DataClean(IdxR2,  IdxSigmaMin ))       max(DataClean(IdxR2, IdxSigmaMax )) ...
    min(DataClean(IdxBeta, IdxX0AbsMin ))      max(DataClean(IdxBeta, IdxX0AbsMax )) ...
    min(DataClean(IdxBeta, IdxY0AbsMin ))      max(DataClean(IdxBeta, IdxY0AbsMax )) ...
    min(DataClean(IdxBeta, IdxSigmaMin ))      max(DataClean(IdxBeta, IdxSigmaMax )) ...
    min(DataClean(IdxBaseline, IdxX0AbsMin ))  max(DataClean(IdxBaseline, IdxX0AbsMax )) ...
    min(DataClean(IdxBaseline, IdxY0AbsMin ))  max(DataClean(IdxBaseline, IdxY0AbsMax )) ...
    min(DataClean(IdxBaseline, IdxSigmaMin ))  max(DataClean(IdxBaseline, IdxSigmaMax )) ...
    size(Data,2) size(DataClean,2) ...
    sum(DataStimRest > 0) ...
    sum(isnan(Data(IdxX0,:)) | isnan(Data(IdxY0,:)) | isnan(Data(IdxSigma,:)) | ...
    isnan(Data(IdxR2,:))  | isnan(Data(IdxBeta,:))  | isnan(Data(IdxBaseline,:))) ];

%% .............................................................................Specfiy labels for summary statistics

SumStatLabels  = {...
    'x0-min-abs'             'x0-max-abs' ...
    'y0-min-abs'             'y0-max-abs' ...
    'sigma-min'              'sigma-max' ...
    'R^2_x0-min-abs'         'R^2_x0-max-abs' ...
    'R^2_y0-min-abs'         'R^2_y0-max-abs' ...
    'R^2_sigma-min'          'R^2_sigma-max' ...
    'Beta_x0-min-abs'        'Beta_x0-max-abs' ...
    'Beta_y0-min-abs'        'Beta_y0-max-abs' ...
    'Beta_sigma-min'         'Beta_sigma-max' ...
    'Baseline_x0-min-abs'    'Baseline_x0-max-abs' ...
    'Baseline_y0-min-abs'    'Baseline_y0-max-abs' ...
    'Baseline_sigma-min'     'Baseline_sigma-max' ...
    'N'                      'N_Clean' ...
    'N_Stim-Rest>0' ...
    'N_NaN'};

end