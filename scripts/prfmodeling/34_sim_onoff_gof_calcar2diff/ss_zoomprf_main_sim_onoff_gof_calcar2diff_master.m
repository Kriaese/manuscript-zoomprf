%% -----------------------------------------------------------------------------
% 34 - zoomprf main - simulate - onoff model - calculate adjusted R2 difference
%      (adj. for model complexity)
% ------------------------------------------------------------------------------
%
%
% ------------------------------------------------------------------------------
% 17/03/2023: Generated (SS)
% 18/05/2025: Last modified (SS)
% ------------------------------------------------------------------------------

%% .............................................................................Tidy up

clear all
close all

%% .............................................................................Subjects

Subjects.Sessions  = {'ses-odd' 'ses-eve'};

%% .............................................................................Folders

% Load paths
Paths = load(fullfile('..', '..', '..', 'paths', 'RootPaths'));

% Roots
Fld.TlbxRoot       = Paths.TlbxRoot;
Fld.DataRoot       = Paths.DataRoot;
Fld.SamSrfRoot     = fullfile(Fld.DataRoot, 'derivatives', 'SamSrf');

% Toolboxes
Fld.Toolboxes      = {'ss_toolbox'};

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

Para.Hemis         = {'sim'};
Para.Sd            = [2];
Para.NReps         = [100000];
Para.R2Type        = 'aR^2';
Para.ModelType     = {'2dg-fix' 'onoff'};
%%% Note:
% '2dg'     = 2D Gaussian   
% '2dg-fix' = 2D Gaussian with fixed sigma
% 'onoff'   = on off model without parameters

%% .............................................................................Files

Files.Prf                = {'task-prf_nrep-' '_sd-' '_onoff_aperture-pins_vec_spmcan_' ...
    '_aperture-pins_vec_spmcan_CrsFit'};
Files.SearchGridCoverge  = {'sgrid-none'};

%% .............................................................................Switches

Switches.SaveAllVars = 0;

try

    %% -------------------------------------------------------------------------
    % (1) Simulate - onoff model - calculate adjusted R2 difference (adj. for 
    %     model complexity)
    % --------------------------------------------------------------------------

    ss_zoomprf_main_sim_calcr2diff_wrapper(Subjects, Fld, Files, Para);

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