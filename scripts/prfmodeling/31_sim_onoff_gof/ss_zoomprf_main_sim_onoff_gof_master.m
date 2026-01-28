%% -----------------------------------------------------------------------------
% 31 - zoomprf main - simulate - onoff model - goodness-of-fit
% ------------------------------------------------------------------------------
%
%
% ------------------------------------------------------------------------------
% 13/03/2023: Generated (SS)
% 23/11/2025: Last modified (SS)
% ------------------------------------------------------------------------------

%% .............................................................................Tidy up

clear all
close all

%% .............................................................................Seeding

Rng = rng(14032023, 'twister');

%% .............................................................................Subjects

Subjects.ID        = 'sub-01';
%%% Note: Subject ID is used for aperture.
Subjects.Sessions  = {'ses-odd' 'ses-eve'};

%% .............................................................................Folders

% Load paths
Paths = load(fullfile('..', '..', '..', 'paths', 'RootPaths'));

% Roots
Fld.TlbxRoot       = Paths.TlbxRoot;
Fld.DataRoot       = Paths.DataRoot;
Fld.SamSrfRoot     = fullfile(Fld.DataRoot, 'derivatives', 'SamSrf');

% Toolboxes
Fld.Toolboxes      = {'ss_toolbox' 'samsrf_v9.51' 'spm12'};

% SamSrf
Fld.SamSrfApt      = 'aperture';
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

Para.TR            = 2;
Para.HrfType       = 'spmcan';
%%% Note:
%%% 'samsrfcan' = SamSrf's canonical HRF
%%% 'spmcan'    = Spm's canonical HRF
Para.Sd            = [2];
%%% Note: Para.Sd is standard deviation of the noise.
%%% Para.Sd = 0 means that no noise will be added.
Para.NReps         = [100000];
%%% Note: Needs to have the same size as Para.Sd
Para.ModelType     = 'onoff';
[X, Y]             = ndgrid(0, 0);
%%%: Note: This needs to be specified in aperture space.
Para.GroundTruth   = {[X(:) Y(:)]'};
%%% Note: Needs to have the same size as Para.Sd.

%% .............................................................................Files

Files.Apt                    = 'task-prf_aperture-pins_vec.mat';
Files.Affix                  = 'task-prf_';
Files.SearchGridCoverge      = {'sgrid-none'};
%%% Note:
%%% 'mix' = Some ground truth values are matching the search grid values.
%%% 'mismatch' = No ground truth values are matching the search grid values.
%%% 'match' = All ground truth values are matching the search grid values.
%%% 'none' = Does not apply (e.g., in case of onoff model).

%% .............................................................................Switches

Switches.SaveAllVars = 0;

try

    %% -------------------------------------------------------------------------
    % (1) Simulate - onoff model - goodness-of-fit
    % --------------------------------------------------------------------------

    ss_zoomprf_main_sim_wrapper(Subjects, Fld, Files, Para)

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