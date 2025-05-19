function Handle = ss_reswin(varargin)
% Input order: Handle, WidthMultiplier, HeightMultiplier
% 
% Resize figure winow.
% 
% ------------------------------------------------------------------------------
% Inputs
% ------------------------------------------------------------------------------
% Handle             - Figure handle [Figure object]
% WidthMultiplier    - Number by wich figure width is multiplied  [double]
% HeightMultiplier   - Number by which figure height is multiplied [double] 
% ------------------------------------------------------------------------------
% Outputs
% ------------------------------------------------------------------------------
% -/-
% ------------------------------------------------------------------------------
% 25/02/2022: Regenerated (SS)
% 02/01/2025: Last modified (SS)
% Source: DSS

%% .............................................................................Some defaults

DefInputs = {gcf, 1, 1};

% Assign user-specifie inputs
DefInputs(1:length(varargin)) = varargin;
[Handle, WidthMultiplier, HeightMultiplier] = DefInputs{:};

%% .............................................................................Resize 

Pos = get(Handle, 'Position');
set(Handle, 'Position', [Pos(1)-Pos(3) Pos(2) ...
    Pos(3)*WidthMultiplier Pos(4)*HeightMultiplier]);

end