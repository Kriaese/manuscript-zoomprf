function ss_zoomprf_main_dispcolormaps_wrapper(Fld, Para)
%
%
%
% ------------------------------------------------------------------------------
% 26/06/2023: Regenerated (SS)
% 06/01/2025: Last modified (SS)
% ------------------------------------------------------------------------------

%% .............................................................................Paths

PathColorMaps = fullfile(Fld.ResultsRoot, Fld.ColorMaps);
ss_checkfld(PathColorMaps);
cd(PathColorMaps)

%% .............................................................................Loop through color maps

for i_cmap = 1:size(Para.ColorMaps,2)

    CurrCMap = Para.ColorMaps{1, i_cmap};

    %% .........................................................................Display color map

    samsrf_colourcode(CurrCMap);

    %% .........................................................................Save color map 
    
    ss_exportgraphics(['colormap-' CurrCMap '.' Para.Ext], gcf, Para.Res); 
    close all;

end

end