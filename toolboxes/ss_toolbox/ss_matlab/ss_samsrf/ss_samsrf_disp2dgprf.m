function FigHandle = ss_samsrf_disp2dgprf(PrfX0, PrfY0, PrfSigma, ApWidth, MeshX, MeshY)
%
% Generates surface plots of a 2D Gaussian pRF.
%
% ------------------------------------------------------------------------------
% Input
% ------------------------------------------------------------------------------
% PrfX0     - X-coordinate of pRF [double]
% PrfY0     - X-coordinate of pRF [double]
% PrfSigma  - PRF size [double]
% ApWidth   - Witdh of aperture [double]
% MeshX     - X-coordinates of mesh  [double]
% MeshX     - Y-coordinates of mesh [double]
% ------------------------------------------------------------------------------
% Output
% ------------------------------------------------------------------------------
% FigHandle - Figure handle 
% ------------------------------------------------------------------------------
% 28/06/2023: Generated (SS)
% 15/11/2024: Last modified (SS)
% ------------------------------------------------------------------------------

%% .............................................................................Generate RF profile

Prf = prf_gaussian_rf(PrfX0, PrfY0, PrfSigma, ApWidth);

%% .............................................................................Generate meshgrid

[GridX, GridY] = meshgrid(MeshX, MeshY);
GridY = flipud(GridY);

%% .............................................................................Generate surface plot

SurfaceObject = surf(GridX, GridY, Prf);

%% .............................................................................Add plot features

SurfaceObject.EdgeColor = 'none';

CMap = ss_crameri_cmap('batlow', false);
colormap(CMap)

grid off
axis off
axis square

%% .............................................................................Get figure handle

FigHandle = gcf;

end

