%% -----------------------------------------------------------------------------
% 15 - zoomprf main - calculate cross-validated SNR
% ------------------------------------------------------------------------------
%
%
% ------------------------------------------------------------------------------
% 08/09/2024: Generated (SS)
% 23/11/2025: Last modified (SS)
% ------------------------------------------------------------------------------

%% .............................................................................Tidy up

clear all
close all

%% .............................................................................Subjects

Subjects.ID            = { ...
    'sub-01' ...
    'sub-02' ...
    'sub-03'};

Subjects.SessionPair      = {...
    'ses-02+03+04-odd' 'ses-02+03+04-eve'};
%%% Note:
% First entry of each row represents first half and second entry represents
% second half.
Subjects.Kernel        = {'FWHM-0' 'FWHM-1'};

%% .............................................................................Folders

% Load paths
Paths = load(fullfile('..', '..', '..', 'paths', 'RootPaths'));

% Roots
Fld.TlbxRoot       = Paths.TlbxRoot;
Fld.DataRoot       = Paths.DataRoot;
Fld.SamSrfRoot     = fullfile(Fld.DataRoot, 'derivatives', 'SamSrf');

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

%% .............................................................................Files

Files.Prf               = {...
    '2dg-fix_aperture-pins_vec_spmcan_CrsFit' ...
    'onoff_aperture-pins_vec_spmcan_CrsFit'};
%%% Note 1:
% '2dg-fix' = 2D Gaussian with fixed sigma
% 'onoff'   = on off model without parameters
%%% Note 2:
% These are the models for which cross-validation will be performed.

%% .............................................................................Switches

Switches.SaveAllVars = 0;

try

    %% -------------------------------------------------------------------------
    % (1) Calculate cross-validated SNR
    % --------------------------------------------------------------------------

    ss_zoomprf_main_calccsnr_wrapper(Subjects, Fld, Files, Para);
    
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