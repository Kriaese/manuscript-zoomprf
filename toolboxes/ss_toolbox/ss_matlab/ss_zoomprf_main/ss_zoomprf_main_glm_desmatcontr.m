function [RegrNames, DesignMatrix, Contr, ContrNames] = ss_zoomprf_main_glm_desmatcontr(BehavFileName)
%x
% Generates design matrix and contrasts for glm.
%
% ------------------------------------------------------------------------------
% Inputs
% ------------------------------------------------------------------------------
% BehavFileName - Name of behavioral file [char]
% ------------------------------------------------------------------------------
% Outputs
% ------------------------------------------------------------------------------
% RegrNames     - Names of regressors [cell]
% DesignMatrix  - Design matrix [double]
% Contr         - Contrasts [double]
% ContrNames    - Names of contrasts [cell]
% ------------------------------------------------------------------------------
% 16/09/2022: Generated (SS)
% 14/07/2023: Last modified (SS)

%% .............................................................................Get position per volume 

PositionPerVol = ss_zoomprf_main_genseqidx(BehavFileName)';

%% .............................................................................Define regressor names

RegrNames  = {'Pos1' 'Pos2' 'Pos3' 'Pos4' 'Pos5' 'Pos6' 'Pos7' 'Pos8'};
RegrPos    = [1:8];

%% .............................................................................Generate design matrix

DesignMatrix = zeros(size(PositionPerVol,1), size(RegrNames,2));

for i_rpos=1:size(RegrPos,2)
    CurrRegrPos = RegrPos(1, i_rpos); 
    DesignMatrix(PositionPerVol == CurrRegrPos, i_rpos) = 1;
end

%% .............................................................................Define contrasts

Contr      = [1 1 1 1 1 1 1 1];
ContrNames = {'Stim-Rest'};

end