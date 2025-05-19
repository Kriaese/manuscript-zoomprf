function ss_samsrf_calcr2diff(Map1, Map2, FileName, R2Type)
%
%
% Calculates differences in R2 between 2 maps.
%
% ------------------------------------------------------------------------------
% Inputs
% ------------------------------------------------------------------------------
% Map1       - SamSrf surface and model structure resulting from pRF
%              fitting (for pRF model 1/map 1) [structure]
% Map2       - SamSrf surface and model structure resulting from pRF
%              fitting (for pRF model 1/map 2) [structure]
% FileName   - File name [char]
% R2Type     - Type of R2 for which differences are calculated [char]
% ------------------------------------------------------------------------------
% Outputs
% ------------------------------------------------------------------------------
% -/-
% ------------------------------------------------------------------------------
% 22/09/2022: Generated (SS)
% 05/09/2024: Last modified (SS)

%% .............................................................................Some defaults

if nargin < 4
    R2Type = 'aR^2';
end

%% .............................................................................Add new value 'difference in R2' to map 1 if it's not there yet and preallocate data

NewValueDiffR2 = ['diff-' R2Type];

if sum(strcmp(Map1.Srf.Values, NewValueDiffR2)) == 0
    Map1.Srf.Values{end+1} = NewValueDiffR2;
    Map1.Srf.Data(end+1,:)   = nan(1, size(Map1.Srf.Data,2));
end

%% .............................................................................Get R2 indices for map 1 and 2

IdxMap1R2 = strcmp(Map1.Srf.Values, R2Type);
IdxMap2R2 = strcmp(Map2.Srf.Values, R2Type);

%% .............................................................................Get index of new value 'difference in R2' for map 1

IdxMap1NewValueDiffR2 = strcmp(Map1.Srf.Values, NewValueDiffR2);

%% .............................................................................Add new value 'difference in R2' to map 1

Map1.Srf.Data(IdxMap1NewValueDiffR2,:) = Map1.Srf.Data(IdxMap1R2,:)-Map2.Srf.Data(IdxMap2R2,:);

%% .............................................................................If R2 type is c2

if strcmp(R2Type, 'cR^2')

    %% .........................................................................Get cR2 sign indices for map 1 and map 2

    IdxMap1cR2Sign = strcmp(Map1.Srf.Values, [R2Type '-sign']);
    IdxMap2cR2Sign = strcmp(Map2.Srf.Values, [R2Type '-sign']);

    %% .........................................................................Flag cR2s signs that are negative

    NegcR2Map1 = Map1.Srf.Data(IdxMap1cR2Sign,:) < 0;
    NegcR2Map2 = Map2.Srf.Data(IdxMap2cR2Sign,:) < 0;

    %% .........................................................................Add new value 'cR2 neg combo' to map 1 if it's not there yet and preallocate data

    NewValuecR2SignCombo = 'cR^2-neg-combo';
    if sum(strcmp(Map1.Srf.Values, NewValuecR2SignCombo )) == 0
        Map1.Srf.Values{end+1} = NewValuecR2SignCombo ;
        Map1.Srf.Data(end+1,:) = nan(1, size(Map1.Srf.Data,2));
    end

    %% .........................................................................Get index of new value 'cR2 neg combo' for map 1

    IdxMap1NewValuecR2SignCombo  = strcmp(Map1.Srf.Values, NewValuecR2SignCombo);

    %% .........................................................................Add new value 'cR2 neg combo' to map 1

    Map1.Srf.Data(IdxMap1NewValuecR2SignCombo,:) = NegcR2Map1 + NegcR2Map2;

end

%% .............................................................................Rename SamSrf structures of map 1

Srf   = Map1.Srf;
Model = Map1.Model;

%% .............................................................................Save SamSrf structures of map 1

save(FileName, 'Srf', 'Model', '-v7.3');

end