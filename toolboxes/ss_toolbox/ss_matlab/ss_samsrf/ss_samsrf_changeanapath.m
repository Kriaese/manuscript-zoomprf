function ss_samsrf_changeanapath(ConstPattern, AnatPath)
%
% Changes path to anatomical data.
%
%-------------------------------------------------------------------------------
% Inputs
%-------------------------------------------------------------------------------
% ConstPattern   - Constant pattern in file name [char]
% AnatPath       - Path to anatomical data in a SamSrf file [char]
% ------------------------------------------------------------------------------
% Output
% ------------------------------------------------------------------------------
% -/-
% ------------------------------------------------------------------------------
% 15/10/2021: Generated (SS)
% 25/08/2024: Last modified (SS)

%% .............................................................................Get all files

if iscell(ConstPattern)
    FileList  = [];
    for i_cp=1:size(ConstPattern,1)
        CurrConstPattern = ConstPattern{i_cp,1};
        FileList  = [FileList; dir(CurrConstPattern)];
    end
else
    FileList  = dir(ConstPattern);
end

%% .............................................................................Loop through files

for i_fl=1:size(FileList,1)

    %% .........................................................................Load srf file 

    CurrFile       = load(FileList(i_fl).name);

    %% .........................................................................Change path to anatomical data 
    
    [~, AnatFileName]  = fileparts(CurrFile.Srf.Meshes); 
    CurrFile.Srf.Meshes = fullfile(AnatPath, AnatFileName);
    Srf = CurrFile.Srf;
    
    %% .........................................................................Save

    save(FileList(i_fl).name, 'Srf', '-v7.3');

end

end