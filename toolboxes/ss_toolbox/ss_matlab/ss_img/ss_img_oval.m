function [Stim, SemimajorAxis, SemiminorAxis] = ss_img_oval(Width, Height, AspectRatio, Alpha)
%
% Generates an oval stimulus.
%
% ------------------------------------------------------------------------------
% Inputs:
% ------------------------------------------------------------------------------
% Width                  - Width of image (double)
% Height                 - Height of image (double)
% AspectRatio            - Apect ratio (1st value: semimajor; 2nd value:
%                          semiminor; double)
% Alpha                  - Level of transparency of oval (double)
% ------------------------------------------------------------------------------
% Outputs:
% ------------------------------------------------------------------------------
% Stim                   - Stimulus matrix (double)
% SemimajorAxis          - Semiminoraxis (double)
% SemiminorAxis          - Semimajor axis (double)
% ------------------------------------------------------------------------------
% 16/04/2018: Generated (SS)
% 03/09/2024: Last modified (SS)

%% .............................................................................Generate stimulus template

Stim = ones(Height, Width, 3).*255;

%% .............................................................................Generate mesh grid

[X, Y] = meshgrid([-Height/2:-1 1:Height/2], [-Width/2:-1 1:Width/2]);

%% .............................................................................Flip Y

Y = flipud(Y); 

%% .............................................................................Define axes

SemimajorAxis = Width/AspectRatio(1);
SemiminorAxis = Height/AspectRatio(2);

%% .............................................................................Generate oval mask

Mask = ss_inellipse(X, Y, 0, 0, SemimajorAxis, SemiminorAxis);
%%% Notes: Identifies points in and on ellipes
%%% Stim = Stim.*Mask: causes problems in Matlab 2014a

%% .............................................................................Generate stimulus

Stim = Stim.*repmat(Mask, 1, 1, size(Stim,3));

%% .............................................................................Add alpha channel

Stim(:, :, 4) = Mask.*Alpha;

end