function  ss_renamefile(ConstPattern, FileNameIdx, DestDir, Suffix)
%
% Cuts file names, adds suffix, and moves file to new location.
%
%-------------------------------------------------------------------------------
% Inputs
%-------------------------------------------------------------------------------
% ConstPattern   - Constant pattern in file name [char]
% FileNameIdx    - Index into file name [double]
% DestDir        - Destination directiory [char]
% Suffix         - File name suffix [char]
%-------------------------------------------------------------------------------
% Outputs
%-------------------------------------------------------------------------------
% -/-
%-------------------------------------------------------------------------------
% 15/09/2022: Generated (SS)
% 25/08/2024: Last modified (SS)

%% .............................................................................Some defaults

if nargin < 4
    Suffix = '';
end

%% .............................................................................Get all files

if iscell(ConstPattern)
    FileList = [];
    for i_cp=1:size(ConstPattern,1)
        CurrConstPattern = ConstPattern{i_cp,1};
        FileList  = [FileList; dir(CurrConstPattern)];
    end
else
    FileList  = dir(ConstPattern);
end

%% .............................................................................Loop through files

for i_fl=1:size(FileList,1)

    %% .........................................................................Move and rename files

    CurrFileName       = FileList(i_fl).name;
    [~ , ~, CurrExt]   = fileparts(CurrFileName);
    CurrFileNameCut    = CurrFileName(FileNameIdx);

    movefile(CurrFileName, fullfile(DestDir, [CurrFileNameCut Suffix CurrExt]));

end

end