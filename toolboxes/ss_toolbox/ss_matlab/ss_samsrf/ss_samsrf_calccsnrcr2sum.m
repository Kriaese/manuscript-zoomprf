function [SumStat, SumStatLabels] = ss_samsrf_calccsnrcr2sum(Map, RoiLabel)
%
%
% Summarizes cSNR, cR2, and also  Beta  values.
%
% ------------------------------------------------------------------------------
% Inputs
% ------------------------------------------------------------------------------
% Map         - SamSrf surface and model structure resulting from pRF
%               fitting [structure]
% RoiLabel    - Name of ROI label to be loaded w/o extension [char]
% ------------------------------------------------------------------------------
% Outputs
% ------------------------------------------------------------------------------
% SumStat         - Summary stats of cSNR, cR2 (and also Beta) values [double]
% SumStatLabels   - Labels for summary stats [cell]
% ------------------------------------------------------------------------------
% 08/10/2024: Generated (SS)
% 16/03/2025: Last modified (SS)
% ------------------------------------------------------------------------------

%% .............................................................................Expand surface

Map.Srf = samsrf_expand_srf(Map.Srf);

%% .............................................................................Get indices

IdxCSNR = strcmp(Map.Srf.Values, 'cSNR'); 
IdxBeta = strcmp(Map.Srf.Values, 'Beta'); 
IdxCR2  = strcmp(Map.Srf.Values, 'cR^2'); 

%% .............................................................................Get ROI index 

IdxRoi = samsrf_loadlabel(RoiLabel); 

if isnan(IdxRoi)
    IdxRoi = 1:size(Map.Srf.Data,2); 
end 

%% .............................................................................Get data in Roi 

DataCSNR   = Map.Srf.Data(IdxCSNR, IdxRoi); 
DataBeta   = Map.Srf.Data(IdxBeta, IdxRoi); 
DataCR2    = Map.Srf.Data(IdxCR2,  IdxRoi); 

%% .............................................................................Calculate summary statistics 

SumStat = [...
    median(DataCR2) mad(DataCR2,1) min(DataCR2) max(DataCR2) size(DataCR2,2)...
    median(DataCSNR) mad(DataCSNR,1) min(DataCSNR) max(DataCSNR) size(DataCSNR,2)...
    sum(DataBeta > 0) sum(DataCR2 > 0) ...
    sum(isnan(DataCSNR) | isnan(DataBeta) | isnan(DataCR2))];

%% .............................................................................Specify labels for summary statistics 

SumStatLabels  = {...
    'mdn-cR^2' 'mad-cR^2' 'min-cR^2' 'max-cR^2' 'N-cR^2' ...
    'mdn-cSNR' 'mad-cSNR' 'min-cSNR' 'max-cSNR' 'N-cSNR' ...
    'N-Beta>0' 'N-cR^2>0' 'N-NaN'}; 

end