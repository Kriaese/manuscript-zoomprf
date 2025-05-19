%% -----------------------------------------------------------------------------
% 01 - zoomprf main - convert .mgh files to samsrf .mat files 
% ------------------------------------------------------------------------------
%
%
% ------------------------------------------------------------------------------
% 14/09/2022: Generated (SS)
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

Subjects.Sessions      = {...
     'ses-01' 'ses-02' 'ses-03' 'ses-04' 'ses-all' ...
     'ses-02+03+04' 'ses-02+03+04-odd' 'ses-02+03+04-eve'};

Subjects.Kernel        = {'FWHM-0' 'FWHM-1'};

%% .............................................................................Folders

% Load paths
Paths = load(fullfile('..', '..', '..', 'paths', 'RootPaths'));

% Roots
Fld.TlbxRoot       = Paths.TlbxRoot;
Fld.DataRoot       = Paths.DataRoot;

Fld.FSRoot         = fullfile(Fld.DataRoot, 'derivatives', 'FreeSurfer');
Fld.SamSrfRoot     = fullfile(Fld.DataRoot, 'derivatives', 'SamSrf');

% FreeSurfer
Fld.FSVol2Surf     = 'vol2surf';
Fld.FSSurf         = 'surf';

% SamSrf
Fld.SamSrfAnatomy  = 'anatomy';

% Toolboxes
Fld.Toolboxes      = {'ss_toolbox' 'samsrf_v9.51'};

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
Para.OddRuns            = strcat('run-', {'01' '03' '05' '07' '09'});
Para.EveRuns            = strcat('run-', {'02' '04' '06' '08' '10'});

Para.AnatPath           = fullfile('..', '..', 'anatomy'); 

%% .............................................................................Files

Files.Mgh               = '.mgh';
Files.Mgh2Srf           = '.mat';

%% .............................................................................Switches

Switches.SaveAllVars = 0;

try

    %% -------------------------------------------------------------------------
    % (1) Convert .mgh files to samsrf .mat files 
    % --------------------------------------------------------------------------

    ss_zoomprf_main_mgh2srf_wrapper(Subjects, Fld, Files, Para)

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