%% -----------------------------------------------------------------------------
% 28 - zoomprf main - simulate - 2dg-fix model - accuracy - display count - 
%      recovered
% ------------------------------------------------------------------------------
%
%
% ------------------------------------------------------------------------------
% 11/11/2023: Generated (SS)
% 17/05/2025: Last modified (SS)
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
Para.Sd            = [2 2];
Para.NReps         = [100000 100000]; 
Para.ScalingFactor = 4.25; 
Para.XLim          = [-3 3].*Para.ScalingFactor; 
Para.YLim          = [-3 3].*Para.ScalingFactor; 
Para.XTicks        = [-2 0 2].*Para.ScalingFactor; 
Para.YTicks        = [-2 0 2].*Para.ScalingFactor; 
Para.AptXY         = [1 -1 -1 1; 1 1 -1 -1].*Para.ScalingFactor;
%%% Note: 
% 1st row: x points
% 2nd row: y points, 
% runing counterclockwise, starting with the upper right corner. 

Para.ColorBarLim   = [1 3000]; 
Para.Ext           = 'pdf'; 
Para.Res           =  300; 
Para.XLabel        = 'radial — ulnar (mm)'; 
Para.YLabel        = 'proximal — distal (mm)'; 
Para.ColorBarLabel = 'frequency'; 
Para.IdxPanelOrder = flipud(reshape(1:25, 5,5));
Para.IdxPanelOrder = reshape(Para.IdxPanelOrder', 1,[]);
Para.Units         = 'mm'; 

%% .............................................................................Files

Files.Prf          = {'task-prf_nrep-' '_sd-' '2dg-fix_aperture-pins_vec_spmcan_' ...
    '_2dg-fix_aperture-pins_vec_spmcan_CrsFit'};
Files.SearchSpace  = 'src'; 
Files.Count        = 'count'; 
Files.SearchGridCoverge = {'sgrid-match' 'sgrid-mismatch'};

%% .............................................................................Switches

Switches.SaveAllVars = 0;

try

    %% -------------------------------------------------------------------------
    % (1) Simulate - 2dg-fix model - accuracy - display count - recovered
    % --------------------------------------------------------------------------

    ss_zoomprf_main_sim_dispcount_wrapper(Subjects, Fld, Files, Para)

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