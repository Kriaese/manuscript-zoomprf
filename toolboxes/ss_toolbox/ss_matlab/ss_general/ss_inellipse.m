function [InOn, Out, In, On] = ss_inellipse(X, Y, XC, YC, A, B)
% 
% Checks whether points lie in/outside of/on the edge of an ellipse.
% 
%-----------------------------------------------------------------------------
% Inputs:
%-----------------------------------------------------------------------------
% X     - X-coordinates of query points [double]
% Y     - Y-coordinates of query points [double]
% XC    - X-coordinate of central point [double]
% YC    - Y-coordinate of central point [double]
% A     - Semimajor axis (half of the extent of the longer of the two 
%         principal axes.) [double]
% B     - Semiminor axis (half of the extent of the shorter of the two 
%         principal axes.) [double]
% 
%-----------------------------------------------------------------------------
% Outputs:
%-----------------------------------------------------------------------------
% InOn  - Indicates whether points are inside or on the edge of ellipse or not 
%         [logical]
% Out   - Indicates whether points are outside or on the edge of ellipse or not 
%         [logical]
% In    - Indicates whether points are inside ellipse or not [logical]
% On    - Inidcates whether points are on the edge of ellipse or not [logical]
%-----------------------------------------------------------------------------
% nd/10/2017: Generated (SS)
% 03/09/2024: Last modified (SS)

%% ...........................................................................Check query points

Ellipse = (X-XC).^2/(A^2) + (Y-YC).^2/(B^2); 
InOn = Ellipse <= 1; 
In = Ellipse < 1; 
On = Ellipse == 1; 
Out = Ellipse > 1; 

end 