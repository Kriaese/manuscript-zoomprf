%% -----------------------------------------------------------------------------
% 08 - zoomprf main - fitting
% ------------------------------------------------------------------------------
%
%
% ------------------------------------------------------------------------------
% 20/09/2022: Generated (SS)
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

Subjects.Sessions      = {'ses-02+03+04' 'ses-02+03+04-odd' 'ses-02+03+04-eve'};
Subjects.Kernel        = {'FWHM-0' 'FWHM-1'};

%% .............................................................................Folders

% Load paths
Paths = load(fullfile('..', '..', '..', 'paths', 'RootPaths'));

% Roots
Fld.TlbxRoot       = Paths.TlbxRoot;
Fld.DataRoot       = Paths.DataRoot;
Fld.SamSrfRoot     = fullfile(Fld.DataRoot, 'derivatives', 'SamSrf');

% Toolboxes
Fld.Toolboxes      = {'spm12' 'ss_toolbox' 'samsrf_v9.51'};

% SamSrf 
Fld.SamSrfApt      = 'aperture';

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

Para.Stage              = {'coarse'};
Para.ModelCSS           = 0;

Para.ModelType          = {'onoff' '2dg-fix'};
%%% Note:
% '2dg'     = 2D Gaussian   
% '2dg-fix' = 2D Gaussian with fixed sigma
% 'onoff'   = on off model without parameters

%% .............................................................................Files

Files.Apt               = 'task-prf_aperture-pins_vec';
Files.Mgh2SrfAggr       = '*mgh2srf_mean.mat';

%% .............................................................................Switches

Switches.SaveAllVars = 0;

try

    %% -------------------------------------------------------------------------
    % (1) Fitting
    % --------------------------------------------------------------------------

    ss_zoomprf_main_fit_wrapper(Subjects, Fld, Files, Para);

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