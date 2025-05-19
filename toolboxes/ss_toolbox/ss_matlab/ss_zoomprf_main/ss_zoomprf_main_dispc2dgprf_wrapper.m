function ss_zoomprf_main_dispc2dgprf_wrapper(Fld, Para)
%
%
%
% ------------------------------------------------------------------------------
% 26/06/2023: Regenerated (SS)
% 21/12/2024: Last modified (SS)
% ------------------------------------------------------------------------------

%% .............................................................................Paths

PathPrf2dg = fullfile(Fld.ResultsRoot, Fld.Prf2dg);
ss_checkfld(PathPrf2dg);
cd(PathPrf2dg)

%% .............................................................................Plot 2dg pRF

FigHandle = ...
    ss_samsrf_disp2dgprf(Para.PrfX0, Para.PrfY0, Para.PrfSigma, Para.ApWidth, ...
    Para.MeshX, Para.MeshY);

%% .............................................................................Save 2dg pRF as 3D plot

ss_exportgraphics(['2dgprf-3d.' Para.Ext], FigHandle, Para.Res); 

%% .............................................................................Save 2dg pRF as 2D plot

view(2)
ss_exportgraphics(['2dgprf-2d.' Para.Ext], FigHandle,  Para.Res); 
close all;

end