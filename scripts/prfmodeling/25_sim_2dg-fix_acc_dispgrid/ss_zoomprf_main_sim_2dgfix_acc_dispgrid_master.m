%% -----------------------------------------------------------------------------
% 25 - zoomprf main - simulate - 2dg-fix model - accuracy - display grid
% ------------------------------------------------------------------------------
%
%
% ------------------------------------------------------------------------------
% 10/11/2023: Generated (SS)
% 14/01/2026: Last modified (SS)
% ------------------------------------------------------------------------------

%% .............................................................................Tidy up

clear all
close all

%% .............................................................................Subjects

Subjects.Sessions  = {'ses-eve' 'ses-odd'};

%% .............................................................................Folders

% Load paths
Paths = load(fullfile('..', '..', '..', 'paths', 'RootPaths'));

% Roots
Fld.TlbxRoot       = Paths.TlbxRoot;
Fld.DataRoot       = Paths.DataRoot;
Fld.SamSrfRoot     = fullfile(Fld.DataRoot, 'derivatives', 'SamSrf');
Fld.ResultsRoot    = fullfile(Fld.DataRoot, 'derivatives', 'results');

% Toolboxes
Fld.Toolboxes      = {'ss_toolbox' 'scientificcolourmaps8'};

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

Para.Hemis         = {'sim'};
Para.Sd            = [0 2 0 2];
Para.NReps         = [1 100000 1 100000];
Para.ScalingFactor = 4.25;
Para.XYLim         = [-3 3 -3 3].*Para.ScalingFactor;
Para.XTicks        = [-2 0 2].*Para.ScalingFactor;
Para.YTicks        = [-2 0 2].*Para.ScalingFactor;
Para.AptXY         = [1 -1 -1 1; 1 1 -1 -1].*Para.ScalingFactor;
%%% Note: 
% 1st row: x points
% 2nd row: y points, 
% runing counterclockwise, starting with the upper right corner. 

Para.Ext    = 'pdf';
Para.Res    = 300;
Para.XLabel = 'radial — ulnar (mm)';
Para.YLabel = 'proximal — distal (mm)';

Para.GridType = 's'; 
%%% Note: 
% 'r' = recovered pRF parameters. 
% 's' = search space. 

%% .............................................................................Files

Files.Prf               = {'task-prf_nrep-' '_sd-' '2dg-fix_aperture-pins_vec_spmcan_' ...
    '_2dg-fix_aperture-pins_vec_spmcan_CrsFit'};
Files.SearchSpace       = 'src';
Files.SearchGridCoverge = {'sgrid-match' 'sgrid-match' 'sgrid-mismatch' 'sgrid-mismatch' };

%% .............................................................................Switches

Switches.SaveAllVars = 0;

try

    %% -------------------------------------------------------------------------
    % (1) Simulate - 2dg-fix model - accuracy - display grid
    % --------------------------------------------------------------------------

    ss_zoomprf_main_sim_dispgrid_wrapper(Subjects, Fld, Files, Para)

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