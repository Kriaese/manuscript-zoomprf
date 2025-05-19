function ss_samsrf_changedef(RoiList, DispRoi, Curv, PathWidth)
%
% Changes SamSrf defaults.
%
% ------------------------------------------------------------------------------
% Inputs
% ------------------------------------------------------------------------------
% RoiList   - List of Rois for delination purposes [cell]
% DispRoi   - Roi used for displaying surface model [char]
% Curv      - Style of curvature when displaying surface model [char] 
% PathWidth - Width of label path [double]
% ------------------------------------------------------------------------------
% Outputs
% ------------------------------------------------------------------------------
% -/-
% ------------------------------------------------------------------------------
% 01/09/2023: Generated (SS)
% 27/08/2024: Last modified (SS)

%% .............................................................................Load default values

load('SamSrf_defaults.mat')

%% .............................................................................Change default values

if ~isempty(RoiList)
    % Rois for delineations 
    def_roilist = RoiList;
end 

if ~isempty(DispRoi)
    % Roi for suface model 
    def_disproi = DispRoi;
end 
    
if ~isempty(Curv)
    % Curvature 
    def_curv    = Curv;
end 

if ~isempty(PathWidth)
    % Path width  
    def_pathwidth = PathWidth;
end 

clear RoiList DispRoi Curv PathWidth

%% .............................................................................Save default values

save(which('SamSrf_defaults.mat'))

end