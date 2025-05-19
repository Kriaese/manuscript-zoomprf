%% -----------------------------------------------------------------------------
% 17 - zoomprf main - calculate summary stats for cross-validated SNR and R2
% ------------------------------------------------------------------------------
%
%
% ------------------------------------------------------------------------------
% 08/10/2024: Generated (SS)
% 18/05/2025: Last modified (SS)
% ------------------------------------------------------------------------------

%% .............................................................................Tidy up

clear all
close all

%% .............................................................................Subjects

Subjects.ID            = { ...
    'sub-01' ...
    'sub-02' ...
    'sub-03'};

Subjects.Sessions      = {'ses-02+03+04-odd' 'ses-02+03+04-eve'};
Subjects.Kernel        = {'FWHM-0' 'FWHM-1'};

Subjects.SessionsSamSrfLabel      = {'ses-01' 'ses-01'};
%%% Note: Needs to be length of Subjects.Sessions
Subjects.KernelSamSrfLabel        = {'FWHM-1' 'FWHM-1'};
%%% Note: Needs to be length of Subjects.Kernel

%% .............................................................................Folders

% Load paths
Paths = load(fullfile('..', '..', '..', 'paths', 'RootPaths'));

% Roots
Fld.TlbxRoot       = Paths.TlbxRoot;
Fld.DataRoot       = Paths.DataRoot;
Fld.SamSrfRoot     = fullfile(Fld.DataRoot, 'derivatives', 'SamSrf');

% Toolboxes
Fld.Toolboxes      = {'ss_toolbox' 'samsrf_v9.51'};

% SamSrf
Fld.SamSrfLabel    = 'ROIs*';

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

Para.Hemis              = {'rh'};

%% .............................................................................Files

Files.Prf               = {...
    '2dg-fix_aperture-pins_vec_spmcan_CrsFit' ...
    'onoff_aperture-pins_vec_spmcan_CrsFit'};

Files.SamSrfLabel           = 'D2a';
Files.SumStat               = 'sumstat-cSNR-cR^2';

%% .............................................................................Switches

Switches.SaveAllVars = 0;

try

    %% -------------------------------------------------------------------------
    % (1) Calculate summary stats for cross-validated SNR and R2
    % --------------------------------------------------------------------------

    ss_zoomprf_main_calccsnrcr2sum_wrapper(Subjects, Fld, Files, Para);

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