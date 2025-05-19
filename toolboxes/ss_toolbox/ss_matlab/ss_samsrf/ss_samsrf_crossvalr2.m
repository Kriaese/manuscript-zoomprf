function ss_samsrf_crossvalr2(Map1, Map2, FileName1)
%
%
% Cross validates R2.
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
% 22/09/2022: Generated (SS)
% 04/09/2024: Last modified (SS)
% ------------------------------------------------------------------------------
% TODO: 
% (1) cR^2-sign-combi --> this is not just a sign combi but these are
% negative signs. So we might need a different name.


%% .............................................................................Add new value cR2 to map 1 if it's not there yet and preallocate data

NewValuecR2 = 'cR^2';

if sum(strcmp(Map1.Srf.Values, NewValuecR2)) == 0
    Map1.Srf.Values{end+1} = NewValuecR2 ;
    Map1.Srf.Data(end+1,:) = nan(1, size(Map1.Srf.X,2));
end

%% .............................................................................Get index of new value cR2 for map 1

IdxcR2 = strcmp(Map1.Srf.Values, NewValuecR2);

%% .............................................................................Cross validate R2 of map 1

for i_vtx=1:size(Map1.Srf.X,2)
    Map1.Srf.Data(IdxcR2,i_vtx) = ...
        (corr(Map1.Srf.X(:, i_vtx), Map2.Srf.Y(:, i_vtx)).^2)*sign(corr(Map1.Srf.X(:, i_vtx), Map2.Srf.Y(:, i_vtx)));
    %%% Note: We do not need end+1 here as we added nan to Data further
    %%% above.
end

%% .............................................................................Add new cR2 sign to map 1 if it's not there yet and preallocate data

NewValuecR2Sign = 'cR^2-sign';
if sum(strcmp(Map1.Srf.Values, NewValuecR2Sign)) == 0
    Map1.Srf.Values{end+1} = NewValuecR2Sign;
    Map1.Srf.Data(end+1,:) = nan(1, size(Map1.Srf.X,2));
end

%% .............................................................................Get index of new value cR2 sign for map 1

IdxcR2Sign = strcmp(Map1.Srf.Values, NewValuecR2Sign);

%% .............................................................................Get updated index of new value cR2 index 

IdxcR2Upd = strcmp(Map1.Srf.Values, NewValuecR2);
%%% Note: We update the idnex here because we might have one more row here as 
%%% compared to above when running this for the first time. 

%% .............................................................................Add cR2 sign to Map1

Map1.Srf.Data(IdxcR2Sign,:) = sign(Map1.Srf.Data(IdxcR2Upd,:));

%% .............................................................................Rename SamSrf structures of map 1

Srf   = Map1.Srf;
Model = Map1.Model;

%% .............................................................................Save SamSrf structures of Map 1

save(FileName1, 'Srf', 'Model', '-v7.3');

end