function ss_samsrf_calcfwhm(Srf, Model, FileName)
% 
%
% Calculates FWHM. 
%
% -------------------------------------------------------------------------
% Inputs
% -------------------------------------------------------------------------
% Srf        - SamSrf surface structure resulting from pRF fitting without 
%              adjusted R2
% Model      - SamSrf mdoel structure resulting from pRF fitting
% FileName   - File name [char]
% -------------------------------------------------------------------------
% Outputs
% -------------------------------------------------------------------------
% -/-
% -------------------------------------------------------------------------
% 21/09/2022: Generated (SS)
% 21/09/2022: Last modified (SS)

%% ........................................................................Calculate FWHM

Srf = samsrf_dog_fwhm(Srf);

%% ........................................................................Save SamSrf structures

save(FileName, 'Srf', 'Model', '-v7.3');

end 