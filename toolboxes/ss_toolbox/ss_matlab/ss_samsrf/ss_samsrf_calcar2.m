function ss_samsrf_calcar2(Srf, Model, NPara, FileName)
% 
%
% Calculates adjusted R2.
%
% ------------------------------------------------------------------------------
% Inputs
% ------------------------------------------------------------------------------
% Srf        - SamSrf surface structure resulting from pRF fitting (might or 
%              might not contain aR2) [structure]
% Model      - SamSrf mmodel structure resulting from pRF fitting [structure]
% NPara      - Number of parameters in pRF model [double]
% FileName   - File name [char]
% ------------------------------------------------------------------------------
% Outputs
% ------------------------------------------------------------------------------
% -/-
% ------------------------------------------------------------------------------
% 19/08/2022: Generated (SS)
% 03/09/2024: Last modified (SS)

%% .............................................................................Get R2 index

IdxR2 = strcmp(Srf.Values, 'R^2');

%% .............................................................................Get number of volumes

NVols = size(Srf.Y,1);

%% .............................................................................Add adjusted R2

NewValueaR2 = 'aR^2';
if sum(strcmp(Srf.Values, NewValueaR2)) == 0
    Srf.Values{end+1} = NewValueaR2;
end

IdxaR2 = strcmp(Srf.Values, 'aR^2'); 
Srf.Data(IdxaR2,:)  = nan(1, size(Srf.Data,2));

IdxGoodR2 = Srf.Data(IdxR2,:) > 0;

Srf.Data(IdxaR2, IdxGoodR2) = 1-((1-Srf.Data(IdxR2,IdxGoodR2))*(NVols-1))/(NVols-NPara-1); 

%% .............................................................................Save SamSrf structures

save(FileName, 'Srf', 'Model', '-v7.3');

end 