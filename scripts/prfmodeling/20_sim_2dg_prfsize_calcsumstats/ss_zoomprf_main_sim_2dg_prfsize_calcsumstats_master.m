%% -----------------------------------------------------------------------------
% 20 - zoomprf main - simulate - 2dg model - prf size - calculate summary 
%      stats
% ------------------------------------------------------------------------------
% 
%
% ------------------------------------------------------------------------------
% 04/04/2023: Generated (SS)
% 18/05/2025: Last modified (SS)
% ------------------------------------------------------------------------------

%% .............................................................................Tidy up

clear all
close all

%% .............................................................................Subjects

Subjects.Sessions  = {'ses-all'};

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
Fld.SamSrfSimSub   = 'prfsize';

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
Para.Sd            = [0 2];
Para.NReps         = [1 100000];
Para.Values        = {'x0' 'y0' 'Sigma' 'aR^2'};
%%% Note that ground truth parameters for 2dg model will be ordered as
%%% follows: x0, y0, and Sigma. This order needs to be respecetd.

%% .............................................................................Files

Files.SearchGridCoverge  = {'sgrid-mix' 'sgrid-mix'};
Files.Sim                = {'task-prf_nrep-' '_sd-' '_2dg_aperture-pins_vec_spmcan_'};
Files.Prf                = {'task-prf_nrep-' '_sd-' '_2dg_aperture-pins_vec_spmcan_' ...
    '_2dg_aperture-pins_vec_spmcan_FneFit'};

%% .............................................................................Switches

Switches.SaveAllVars = 0;

try

    %% -------------------------------------------------------------------------
    % (1) Simulate - 2dg model - prf size - calculate summary stats
    % --------------------------------------------------------------------------

    ss_zoomprf_main_sim_calcsumstats_wrapper(Subjects, Fld, Files, Para)

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