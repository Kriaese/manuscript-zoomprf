function ss_samsrf_crossvalsnr(Map1, Map2, FileName1)
%
%
% Cross validates SNR (std_signal/std_noise).
%
% ------------------------------------------------------------------------------
% Inputs
% ------------------------------------------------------------------------------
% Map1       - SamSrf surface and model structure resulting from pRF
%              fitting (half 1) [structure]
% Map2       - SamSrf surface and model structure resulting from pRF
%              fitting (half2) [structure]
% FileName1  - File name (half 1) [char]
% ------------------------------------------------------------------------------
% Outputs
% ------------------------------------------------------------------------------
% -/-
% ------------------------------------------------------------------------------
% 04/09/2024: Generated (SS)
% 09/10/2024: Last modified (SS)
% ------------------------------------------------------------------------------

%% .............................................................................Expand surfaces

Map1.Srf = samsrf_expand_srf(Map1.Srf);
Map2.Srf = samsrf_expand_srf(Map2.Srf);

%% .............................................................................Extract fitted time course of map 1 

X1     = Map1.Srf.X; 

%% .............................................................................Convolve fitted time courses of map 1 with hrf if need be 

if isfield(Map1.Model, 'Hrf') && ~Map1.Model.Coarse_Fit_Only
    X1Conv = nan(size(X1)); 
    for i_vtx=1:size(X1,2)
        X1Conv(:, i_vtx) = prf_convolve_hrf(X1(:,i_vtx), Map1.Model.Hrf, ...
            Map1.Model.Downsample_Predictions);
    end 
    X1 = XConv; 
end

%% .............................................................................Get data for map 1 (fitted parameters)

Data1 = Map1.Srf.Data;

%% .............................................................................Scale fitted time courses of map 1 using beta and baseline estimates

IdxBeta1 = strcmp(Map1.Srf.Values,'Beta');
IdxBaseline1 = strcmp(Map1.Srf.Values,'Baseline');
X1 = X1 .* Data1(IdxBeta1,:) + Data1(IdxBaseline1,:);

%% .............................................................................Extract empirically observed time course of map 2 (z-scored)

Y2 = Map2.Srf.Y; 

%% .............................................................................Calculate residuals

Residuals = Y2 - X1; 

%% .............................................................................Calculate SNR (std_signal/std_res) 

NewValuecSNR = 'cSNR';
if sum(strcmp(Map1.Srf.Values, NewValuecSNR)) == 0
    Map1.Srf.Values{end+1} = NewValuecSNR;
    Map1.Srf.Data(end+1,:) = nan(1, size(Map1.Srf.Data,2));  
end

IdxcSNR = strcmp(Map1.Srf.Values, 'cSNR'); 
Map1.Srf.Data(IdxcSNR,:)  = std(X1)./std(Residuals);


%% .............................................................................Rename SamSrf structures of map 1

Srf   = Map1.Srf;
Model = Map1.Model;

%% .............................................................................Save SamSrf structures of Map 1

save(FileName1, 'Srf', 'Model', '-v7.3');

end