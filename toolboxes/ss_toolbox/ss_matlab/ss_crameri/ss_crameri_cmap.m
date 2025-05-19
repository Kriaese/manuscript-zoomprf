function CMap = ss_crameri_cmap(Name, Flip, Granularity)
% 
% Transforms Crameri color map into a Matlab color map. 
% 
% ------------------------------------------------------------------------------
% Inputs 
% ------------------------------------------------------------------------------
% Name          - Name of color map [char]
% Flip          - Toggles whether color map should be inverted [double/logical]
% Granularity   - Granularity of color map [double]
% ------------------------------------------------------------------------------
% Outputs
% ------------------------------------------------------------------------------
% CMap          - Matlab color map [double]
% ------------------------------------------------------------------------------
% Copyright (c) 2021, Fabio Crameri.
%   Crameri, F. (2018), Scientific colour maps, Zenodo, doi:10.5281/zenodo.1243862
% ------------------------------------------------------------------------------
% 15/03/2022: Generated (SS)
% 21/10/2024: Last modified (SS)

%% .............................................................................Some defaults 

if nargin < 3
    Granularity = 256;
end 

%% .............................................................................Load color map

CMap = load(Name);
CMap = CMap.(Name);

%% .............................................................................Rescale (if need be)

if Granularity~=size(CMap,1)
   CMap = interp1(1:size(CMap,1), CMap, ...
       linspace(1,size(CMap,1), Granularity), 'linear');
end

%% .............................................................................Flip (if need be)

if Flip
   CMap = flipud(CMap); 
end

end 