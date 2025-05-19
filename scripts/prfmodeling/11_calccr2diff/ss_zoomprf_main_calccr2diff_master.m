%% -----------------------------------------------------------------------------
% 11 - zoomprf main - calculate cross-validated R2 differences
% ------------------------------------------------------------------------------
%
%
% ------------------------------------------------------------------------------
% 23/09/2022: Generated (SS)
% 16/05/2025: Last modified (SS)
% ------------------------------------------------------------------------------
%

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

%% .............................................................................Folders

% Load paths
Paths = load(fullfile('..', '..', '..', 'paths', 'RootPaths'));

% Roots
Fld.TlbxRoot       = Paths.TlbxRoot;
Fld.DataRoot       = Paths.DataRoot;
Fld.SamSrfRoot     = fullfile(Fld.DataRoot, 'derivatives', 'SamSrf');

% Toolboxes
Fld.Toolboxes      = {'ss_toolbox'};

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

Para.Hemis             = {'rh' 'lh'};
Para.R2Type            = 'cR^2';

%% .............................................................................Files

Files.Prf               = {...
    '2dg-fix_aperture-pins_vec_spmcan_CrsFit'...
    'onoff_aperture-pins_vec_spmcan_CrsFit'};
%%% Note 1:
% '2dg-fix' = 2D Gaussian with fixed sigma
% 'onoff'   = on off model without parameters
%%% Note 2:
% Second entry is the one to be subtracted from first entry.
%%% Note 3:
% Results will be added to surface structure of first entry.

%% .............................................................................Switches

Switches.SaveAllVars = 0;

try

    %% -------------------------------------------------------------------------
    % (1) Calculate cross-validated R2 differences
    % --------------------------------------------------------------------------

    ss_zoomprf_main_calcr2diff_wrapper(Subjects, Fld, Files, Para);   
    
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