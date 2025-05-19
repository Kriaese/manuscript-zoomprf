function ss_samsrf_calcaspectratio(Srf, Model, FileName)
% 
%
% Calculates aspect ratio of sigma1 and sigma2. 
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

%% ........................................................................Get sigma1 and sigma2 index

IdxSigma1 = strcmp(Srf.Values, 'Sigma1');
IdxSigma2 = strcmp(Srf.Values, 'Sigma2');

%% ........................................................................Calculate aspect ratio

% Add aspect ratio (log of radial/tangential)
Srf.Data = [Srf.Data; log2(Srf.Data(IdxSigma1,:) ./ Srf.Data(IdxSigma2,:))];
Srf.Values{end+1} = 'Aspect Ratio';

%% ........................................................................Save SamSrf structures

save(FileName, 'Srf', 'Model', '-v7.3');

end 