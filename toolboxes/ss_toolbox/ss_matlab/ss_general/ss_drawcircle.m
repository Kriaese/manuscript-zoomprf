function [Handle, Xc, Yc] = ss_drawcircle(Xm,Ym,Radius, varargin)
% Input order: Xm, Ym, Radius, LineColor, LineStyle, LineWidth, Plotting, Theta
% 
% Draws a circle.
%
%-------------------------------------------------------------------------------
% Inputs
%-------------------------------------------------------------------------------
% Xm         - X-coordinate of circle's midpoint [double]
% Ym         - Y-coordinate of circle's midpoint [double]
% Radius     - Radius of circle [double]
% LineColor  - Line color [double]
% LineStyle  - Line style [char]
% LineWidth  - Line width [double]
% Plotting   - Toggles whether circle should be plotted [double/logical] 
% Theta      - Thetas [double]
%-------------------------------------------------------------------------------
% Outputs
%-------------------------------------------------------------------------------
% Handle     - Figure handle [object]
% Xc         - X-ccordinates of circle [double]
% Yc         - Y-coordinates of circle [double]
%-------------------------------------------------------------------------------
% 04/03/2022: Generated (SS)
% 17/10/2024: Last modified (SS)

%% .............................................................................Some defaults

DefInputs = {[1 1 1] '-' 2 1 0:pi/50:2*pi};
DefInputs(1:length(varargin)) = varargin;
[LineColor, LineStyle, LineWidth, Plotting, Theta] = DefInputs{:};

%% .............................................................................Draw circle

Xc = Radius .* cos(Theta) + Xm;
Yc = Radius .* sin(Theta) + Ym;

if Plotting
    hold on;
    Handle = plot(Xc, Yc, 'Color', LineColor, 'LineWidth', LineWidth, ...
        'LineStyle', LineStyle);
else
    Handle = NaN;
end

end