%% -----------------------------------------------------------------------------
% 37 - zoomprf main - simulate - onoff model - goodness-of-fit - display 
%      p-values
% ------------------------------------------------------------------------------
%
%
% ------------------------------------------------------------------------------
% 19/03/2023: Generated (SS)
% 23/11/2025: Last modified (SS)
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
Fld.ResultsRoot    = fullfile(Fld.DataRoot, 'derivatives', 'results');

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

Para.Edges         = -0.1:0.001:0.05;

Para.R2DiffType    = 'diff-cR^2';

Para.Ext           = 'pdf';
Para.Res           = 300;

Para.XLabel        = '{\itdiff-cR^{2}} [2dg-fix vs onoff]';
Para.YLabel        = 'frequency';

Para.YLim          = [0 5000];
Para.YTicks        = [0:5].*1000;

%% .............................................................................Files

Files.Prf                   = {'task-prf_nrep-' '_sd-' '_onoff_aperture-pins_vec_spmcan_' ...
    '2dg-fix_aperture-pins_vec_spmcan_CrsFit'};
Files.SearchGridCoverge     = {'sgrid-none'};
Files.SumStat               = ['sumstat-' Para.R2DiffType];

%% .............................................................................Switches

Switches.SaveAllVars = 0;

try

    %% -------------------------------------------------------------------------
    % (1) Simulate - onoff model - goodness-of-fit - display p-values
    % --------------------------------------------------------------------------

    ss_zoomprf_main_sim_disppval_wrapper(Subjects, Fld, Files, Para)

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