function ss_checkfld(Folder)
%
% Checks whether folder(s) already exist(s). If not, folder(s) will be 
% created.
%
%-------------------------------------------------------------------------------
% Inputs
%-------------------------------------------------------------------------------
% Folder - Folder names(s) [String or cell]
%-------------------------------------------------------------------------------
% Outputs
%-------------------------------------------------------------------------------
% -/-
%-------------------------------------------------------------------------------
% 25/06/2017: Generated (SS)
% 02/01/2025: Last modified (SS)

%% .............................................................................Some check-ups

if ~iscell(Folder)
    Folder = {Folder};
end

%% .............................................................................Loop through folders

for i_fld = 1:size(Folder,2)
    
    CurrFld = Folder{1,i_fld};
    
    %% .........................................................................Check existence of folder
    
    FolderExist = exist(CurrFld, 'dir');
    
    %% .........................................................................Create folder in case of non-existence
    
    if FolderExist ~= 7
        mkdir(CurrFld);
    end
    
end

end

