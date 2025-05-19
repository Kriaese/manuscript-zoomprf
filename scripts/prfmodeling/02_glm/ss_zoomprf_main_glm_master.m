%% -----------------------------------------------------------------------------
% 02 - zoomprf main - perform glm
% ------------------------------------------------------------------------------
%
%
% ------------------------------------------------------------------------------
% 16/09/2022: Generated (SS)
% 16/05/2025: Last modified (SS)
% ------------------------------------------------------------------------------

%% .............................................................................Tidy up

clear all
close all

%% .............................................................................Subjects

Subjects.ID            = { ...
    'sub-01' ...
    'sub-02' ...
    'sub-03'};

Subjects.Sessions      = {'ses-01' 'ses-02' 'ses-03' 'ses-04'};

Subjects.Kernel        = {'FWHM-0' 'FWHM-1'};

%% .............................................................................Folders

% Load paths
Paths = load(fullfile('..', '..', '..', 'paths', 'RootPaths'));

% Roots
Fld.TlbxRoot       = Paths.TlbxRoot;
Fld.DataRoot       = Paths.DataRoot;

Fld.SamSrfRoot         = fullfile(Fld.DataRoot, 'derivatives', 'SamSrf');
Fld.SourceDataRoot     = fullfile(Fld.DataRoot, 'sourcedata');

% Behavioral
Fld.Beh            = 'beh';  

% Toolboxes
Fld.Toolboxes      = {'ss_toolbox' 'samsrf_v9.51' 'spm12'};

%% .............................................................................Add toolboxes

for i_tlbxadd = 1:length(Fld.Toolboxes)
    CurrTlbxAdd = fullfile(Fld.TlbxRoot, Fld.Toolboxes{i_tlbxadd});
    if contains(CurrTlbxAdd, 'spm')
        addpath(CurrTlbxAdd);
    else
        addpath(genpath(CurrTlbxAdd));
    end
end

%% .............................................................................Parameters

Para.Hemis              = {'rh' 'lh'};
Para.TR                 = 2;
Para.HrfType            = 'spmcan';
%%% Note:
%%% 'samsrfcan' = SamSrf's canonical HRF
%%% 'spmcan'    = SPM's canonical HRF

%% .............................................................................Files

Files.Glm               = 'glm';
Files.Beh               = '*run-01*';  

Files.Mgh2Srf           = 'mgh2srf.mat';

%% .............................................................................Switches

Switches.SaveAllVars = 0;

try

    %% -------------------------------------------------------------------------
    % (1) Perform glm
    % --------------------------------------------------------------------------

    ss_zoomprf_main_glm_wrapper(Subjects, Fld, Files, Para)

    %% -------------------------------------------------------------------------
    % (2) Save all variables
    % --------------------------------------------------------------------------

    if Switches.SaveAllVars
        save(mfilename);
    end

    %% .........................................................................Remove toolboxes

    for i_tlbxrm = 1:length(Fld.Toolboxes)
        CurrTlbxRm = fullfile(Fld.TlbxRoot, Fld.Toolboxes{i_tlbxrm});
        if contains(CurrTlbxRm, 'spm')
            rmpath(CurrTlbxRm);
        else
            rmpath(genpath(CurrTlbxRm));
        end
    end

catch ME

    for i_tlbxrm = 1:length(Fld.Toolboxes)
        CurrTlbxRm = fullfile(Fld.TlbxRoot, Fld.Toolboxes{i_tlbxrm});
        if contains(CurrTlbxRm, 'spm')
            rmpath(CurrTlbxRm);
        else
            rmpath(genpath(CurrTlbxRm));
        end
    end

    rethrow(ME)
end