%% -----------------------------------------------------------------------------
% 21 - zoomprf main - simulate - 2dg model - prf size - display summary 
%      stats
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

Subjects.Sessions  = {'ses-all'};

%% .............................................................................Folders

% Load paths
Paths = load(fullfile('..', '..', '..', 'paths', 'RootPaths'));

% Roots
Fld.TlbxRoot       = Paths.TlbxRoot;
Fld.DataRoot       = Paths.DataRoot;

Fld.SamSrfRoot     = fullfile(Fld.DataRoot, 'derivatives', 'SamSrf');
Fld.ResultsRoot    = fullfile(Fld.DataRoot, 'derivatives', 'results');

% Toolboxes
Fld.Toolboxes      = {'ss_toolbox' 'samsrf_v9.51' 'scientificcolourmaps8'};

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
Para.ScalingFactor = 4.25; 
Para.XYLim         = [-3 3 -3 3].*Para.ScalingFactor; 
Para.XTicks        = [-2 0 2].*Para.ScalingFactor; 
Para.YTicks        = [-2 0 2].*Para.ScalingFactor; 
Para.AptXY         = [1 -1 -1 1; 1 1 -1 -1].*Para.ScalingFactor;
%%% Note: 
% 1st row: x points
% 2nd row: y points, 
% runing counterclockwise, starting with the upper right corner. 
Para.CMap = ss_crameri_cmap('batlow', 0);
Para.Color           = [ ...
    220, 20, 60, 255; ... 
    0,  0, 0, 255]./255;
Para.Color           = [Para.Color; Para.CMap(1,:), 1; Para.CMap(end, :), 1]; 
Para.LineStyle       = {'-' ':' '-' '-'}; 
Para.MidpointSymbols = {'x' '+' '+' '+'}; 
%%% Note:
% 1st: ground truth
% 2nd: median
% 3rd: 1st percentile 
% 4th: 99th percentile 

Para.Ext    = 'pdf'; 
Para.Res    = 300; 
Para.XLabel = 'radial — ulnar (mm)'; 
Para.YLabel = 'proximal — distal (mm)'; 

Para.Units  = 'mm'; 

%% .............................................................................Files

Files.SearchGridCoverge  = {'sgrid-mix' 'sgrid-mix'};
Files.Prf   = {'task-prf_nrep-' '_sd-' '_2dg_aperture-pins_vec_spmcan_' ...
    '_2dg_aperture-pins_vec_spmcan_FneFit_sumstats'};

%% .............................................................................Switches

Switches.SaveAllVars = 0;

try

    %% -------------------------------------------------------------------------
    % (1) Simulate - 2dg model - prf size - display summary stats
    % --------------------------------------------------------------------------

    ss_zoomprf_main_sim_dispsumstats_wrapper(Subjects, Fld, Files, Para)

   %% --------------------------------------------------------------------------
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