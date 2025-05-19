function CellArray = ss_arraynum2str(Array)
% 
% Transforms each numerical element of an array to a string and stores
% output as a cell array. 
% 
% ------------------------------------------------------------------------------
% Input
% ------------------------------------------------------------------------------
% Array     - Array containing numerical elements [double]
% ------------------------------------------------------------------------------
% Output
% ------------------------------------------------------------------------------
% CellArray - Cell array containing string elements [cell]
% ------------------------------------------------------------------------------
% 17/04/2023: Generated (SS)
% 17/10/2024: Last modified (SS)

%% .............................................................................num2str

CellArray = arrayfun(@num2str, ...
    Array, 'UniformOutput', false);

end 