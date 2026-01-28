%% -----------------------------------------------------------------------------
% 38 - zoomprf main - simulate - onoff model - goodness-of-fit - calculate 
%      cross-validated SNR
% ------------------------------------------------------------------------------
%
%
% ------------------------------------------------------------------------------
% 15/11/2024: Generated (SS)
% 23/11/2025: Last modified (SS)
% ------------------------------------------------------------------------------

%% .............................................................................Tidy up

clear all
close all

%% .............................................................................Subjects


Subjects.SessionPair      = {...
    'ses-odd' 'ses-eve'};
%%% Note:
% First entry of each row represents first half and second entry represents
% second half.

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
Fld.SamSrfSim      = 'simulations';
Fld.SamSrfSimSub   = 'gof';

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

Para.Hemis              = {'sim'};
Para.Sd                 = [2];
Para.NReps              = [100000]; 

%% .............................................................................Files

Files.Prf               = {...
    'onoff_aperture-pins_vec_spmcan_CrsFit' ...
    '2dg-fix_aperture-pins_vec_spmcan_CrsFit'};
%%% Note 1:
% '2dg-fix' = 2D Gaussian with fixed sigma
% 'onoff'   = on off model without parameters
%%% Note 2:
% These are the models for which cross-validation will be performed.

Files.SearchGridCoverge = {'sgrid-none'};

%% .............................................................................Switches

Switches.SaveAllVars = 0;

try

    %% -------------------------------------------------------------------------
    % (1) Simulate - onoff model - goodness-of-fit - calculate cross-validated 
    %     SNR
    % --------------------------------------------------------------------------

    ss_zoomprf_main_sim_calccsnr_wrapper(Subjects, Fld, Files, Para);

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