function [SumStat, SumStatLabels] = ss_samsrf_calccr2diffsum(Map, RoiLabel, GlmConts)
%
%
% Summarizes diff-cR^2, Beta, and cR^2-neg-combo values.
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
% SumStat         - Summary stats of diff-cR^2, Beta, and cR^2-neg-combo values
%                   [double]
% SumStatLabels   - Labels for summary stats [cell]
% ------------------------------------------------------------------------------
% 15/12/2024: Generated (SS)
% 15/12/2024: Last modified (SS)
% ------------------------------------------------------------------------------

%% .............................................................................Expand surface

Map.Srf      = samsrf_expand_srf(Map.Srf);
GlmConts.Srf = samsrf_expand_srf(GlmConts.Srf);

%% .............................................................................Get indices for several values

IdxBeta         = strcmp(Map.Srf.Values, 'Beta');
IdxDiffCR2      = strcmp(Map.Srf.Values, 'diff-cR^2');
IdxCR2NegCombo  = strcmp(Map.Srf.Values, 'cR^2-neg-combo');

IdxStimRest     = strcmp(GlmConts.Srf.Values, 'Stim-Rest');

%% .............................................................................Get ROI index

IdxRoi = samsrf_loadlabel(RoiLabel);

if isnan(IdxRoi)
    IdxRoi = 1:size(Map.Srf.Data,2);
end

%% .............................................................................Get data in Roi

DataBeta           = Map.Srf.Data(IdxBeta, IdxRoi);
DataDiffCR2        = Map.Srf.Data(IdxDiffCR2, IdxRoi);
DataCR2NegCombo    = Map.Srf.Data(IdxCR2NegCombo, IdxRoi);

DataStimRest       = GlmConts.Srf.Data(IdxStimRest, IdxRoi); 

%% .............................................................................Clean data in Roi

IdxClean = DataCR2NegCombo == 0 & DataDiffCR2 > 0 & DataStimRest > 0;
%%% Note: Keep vertices for which both models produced a positive cR2 value and
%%% for whom the difference in cR2 is greater than 0 and for whom the 
%%% t-statistic in the glm was positive.

DataDiffCR2Clean  = DataDiffCR2(IdxClean);

%% .............................................................................Calculate summary statistics

SumStat = [...
    min(DataDiffCR2Clean) max(DataDiffCR2Clean) ...
    size(DataDiffCR2,2) size(DataDiffCR2Clean,2) ...
    sum(DataCR2NegCombo == 0) sum(DataDiffCR2 > 0) sum(DataStimRest > 0) sum(DataBeta >= 0) ...
    sum(isnan(DataBeta) | isnan(DataDiffCR2) | isnan(DataCR2NegCombo))];

%% .............................................................................Specfiy labels for summary statistics

SumStatLabels  = {...
    'diff-cR^2-min' 'diff-cR^2-max' ...
    'N' 'N_Clean' ...
    'N_cR^2-neg-combo=0' 'N_diff-cR^2>0' 'N_Stim-Rest>0' 'N_Beta>0(alt. model)' ...
    'N_NaN'};

end