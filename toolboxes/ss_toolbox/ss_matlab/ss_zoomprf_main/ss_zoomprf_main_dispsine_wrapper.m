function ss_zoomprf_main_dispsine_wrapper(Fld, Para)
%
%
%
% ------------------------------------------------------------------------------
% 31/08/2023: Regenerated (SS)
% 02/01/2025: Last modified (SS)
% ------------------------------------------------------------------------------

%% .............................................................................Some variables 

WidthMultiplier = 0.8; 
HeightMultiplier = 0.2; 

%% .............................................................................Paths

PathSine = fullfile(Fld.ResultsRoot, Fld.Sine);
ss_checkfld(PathSine);

%% .............................................................................Plot sine wave

FigHandle = ss_zoomprf_main_dispsine;

%% .............................................................................Resize plot 

FigHandle = ss_reswin(FigHandle, WidthMultiplier, HeightMultiplier);

%% .............................................................................Save 

cd(PathSine)
ss_exportgraphics(['sine.' Para.Ext], FigHandle, Para.Res); 
close all; 

end