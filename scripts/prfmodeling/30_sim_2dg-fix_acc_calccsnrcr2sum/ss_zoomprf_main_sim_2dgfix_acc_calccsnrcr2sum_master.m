%% -----------------------------------------------------------------------------
% 30 - zoomprf main - simulate - 2dg-fix model - accuracy - calculate summary 
%      stats for cross-validated SNR and R2
% ------------------------------------------------------------------------------
%
%
% ------------------------------------------------------------------------------
% 09/11/2024: Generated (SS)
% 23/11/2025: Last modified (SS)
% ------------------------------------------------------------------------------

%% .............................................................................Tidy up

clear all
close all

%% .............................................................................Subjects

Subjects.Sessions      = {'ses-odd' 'ses-eve'};

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
Fld.SamSrfSimSub   = 'accuracy';

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
Para.Sd                 = [2 2];
Para.NReps              = [100000 100000];

%% .............................................................................Files

Files.Prf               = {...
    '2dg-fix_aperture-pins_vec_spmcan_CrsFit'};
Files.SearchGridCoverge  = {'sgrid-match' 'sgrid-mismatch'};
Files.SumStat            = 'sumstat-cSNR-cR^2';

%% .............................................................................Switches

Switches.SaveAllVars = 0;

try

    %% -------------------------------------------------------------------------
    % (1) Simulate - 2dg-fix model - accuracy - calculate summary stats for 
    %     cross-validated SNR and R2
    % --------------------------------------------------------------------------

    ss_zoomprf_main_sim_calccsnrcr2sum_wrapper(Subjects, Fld, Files, Para) 

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