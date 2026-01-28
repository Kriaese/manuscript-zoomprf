%% -----------------------------------------------------------------------------
% 47 - zoomprf main - display maps for fits with masked funnction and anatomy 
% ------------------------------------------------------------------------------
%
%
% ------------------------------------------------------------------------------
% 21/11/2025: Generated (SS)
% 23/11/2025: Last modified (SS)
% ------------------------------------------------------------------------------

%% .............................................................................Tidy up

clear all
close all

%% .............................................................................Subjects

Subjects.ID            = { ...
    'sub-01' ...
    'sub-02' ...
    'sub-03'};

Subjects.Sessions      = {'ses-02+03+04-eve' 'ses-02+03+04-odd' 'ses-02+03+04'};
Subjects.Kernel        = {'FWHM-0' 'FWHM-1'};

Subjects.SessionsSamSrfLabel      = {'ses-01' 'ses-01' 'ses-01'};
%%% Note: Needs to be length of Subjects.Sessions
Subjects.KernelSamSrfLabel        = {'FWHM-1' 'FWHM-1'};
%%% Note: Needs to be length of Subjects.Kernel

%% .............................................................................Folders

% Load paths
Paths = load(fullfile('..', '..', '..', 'paths', 'RootPaths'));

% Roots
Fld.TlbxRoot       = Paths.TlbxRoot;
Fld.DataRoot       = Paths.DataRoot;

Fld.SamSrfRoot     = fullfile(Fld.DataRoot, 'derivatives', 'SamSrf');
Fld.ResultsRoot    = fullfile(Fld.DataRoot, 'derivatives', 'results');
Fld.FSRoot         = fullfile(Fld.DataRoot, 'derivatives', 'FreeSurfer');

% Toolboxes
Fld.Toolboxes      = {'ss_toolbox' 'samsrf_v9.51'};

% FreeSurfer
Fld.FSLabel        = 'label';
Fld.FSAtlas        = 'atlas';

% SamSrf
Fld.SamSrfLabel    = 'ROIs*';

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

Para.Hemis               = {'rh'};
Para.HemisSamsrfLabels   = {'rh'};

Para.Transparency        = 0;
%%% 0 = turn off transparency
Para.MapType             = {'x0'};
Para.PathColors          = {[1 1 1]};
Para.Mesh                = 'inflated';
Para.EccenRange          = [0 Inf];
Para.NR2ThreshGen        = 0;
%%% Note that "Gen" refers to general.
Para.X0                    = [0 8.500];

Para.Threshold           = {...
    [Para.NR2ThreshGen Para.X0    Para.EccenRange Para.Transparency]};

Para.Res                 = 300;
Para.CamView             = {[94 15 1.4] [-94 15 1.4]};
Para.Ext                 = 'png';

Para.RestrictMapsToLabels = true;

Para.BlurryBorderSteps   = 1; % 1:7;

Para.InactivatenR2Cleaning = true;

Para.Blanco              = false;
Para.PathWidth           = [1 1];

%% .............................................................................Files

Files.Data               = '*mgh2srf_mean_2dg-fix_aperture-pins_vec_spmcan_CrsFit.mat';
Files.FSLabel            = [];
Files.SamSrfLabel        = {'vertex-1' 'vertex-2'};
Files.FSAtlas            = [];

Files.AnatLabel          = {'D2a' 'samsrf'};
%%% Note: 'fsatlas': refers to the derived FreeSurfer atlas+corresponding labels; 
%%% 'samsrf' refers to manual labels defined using SamSrf; and  
%%% 'fslabels' refers to the standard free surfer labels. 

%% .............................................................................Switches

Switches.SaveAllVars = 0;

try

    %% -------------------------------------------------------------------------
    % (1) Display maps for fits with masked funnction and anatomy 
    % --------------------------------------------------------------------------

    ss_zoomprf_main_dispmaps_wrapper(Subjects, Fld, Files, Para)

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