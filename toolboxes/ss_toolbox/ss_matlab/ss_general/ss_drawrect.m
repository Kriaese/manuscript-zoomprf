function ss_drawrect(XPoints, YPoints, Color, Alpha)
% 
% Draws rectangles onto plot. 
% 
% ------------------------------------------------------------------------------
% Inputs
% ------------------------------------------------------------------------------
% XPoints - Edges on x-axis [double]
% YPoints - Edges on y-axis [double]
% Color   - Color of reactangle [double]
% Alpha   - Transparency of rectangle [double]
% ------------------------------------------------------------------------------
% Outputs
% ------------------------------------------------------------------------------
% -/-
% ------------------------------------------------------------------------------
% 06/02/2023: Generated (SS)
% 17/10/2024: Last modified (SS)

%% .............................................................................Draw rectangles

fill(XPoints, YPoints, Color, 'FaceAlpha', Alpha, 'EdgeColor','none');

end 