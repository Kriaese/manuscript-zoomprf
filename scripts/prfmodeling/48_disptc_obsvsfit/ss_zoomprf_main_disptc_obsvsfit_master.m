%% -----------------------------------------------------------------------------
% 48 - zoomprf main - display time courses for observed vs fit data
% ------------------------------------------------------------------------------
%
%
% ------------------------------------------------------------------------------
% 18/08/2023: Generated (SS)
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

Subjects.Sessions      = {'ses-02+03+04' 'ses-02+03+04-eve' 'ses-02+03+04-odd'};
Subjects.Kernel        = {'FWHM-0' 'FWHM-1'};

Subjects.VtxIdx        = {[...
    60220 61173; ...
    58484 133561; ...
    56964 55163]};
%%% Note: Pick one or several vertices for each subject.

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

Para.Hemis         = {'rh'};
Para.ModelType     = {'onoff' '2dg-fix'};
%%% Note: 1st: Null model
%%%       2nd: Alternative model

Para.Ext           = 'png';
Para.Res           = 300;
Para.YLim          = [-1 1.5];
Para.ValuesTitle   = {{'cR^2'} {'x0' 'y0' 'cR^2' 'diff-cR^2'}};

Para.Units         = 'mm';

Para.XLabel        = 'volumes';
Para.YLabel        = 'response (z)';

Para.BlockOnsets   = 1:16:144; 
%%% Note: This is in volumes. 

Para.SophFeatures  = false; 

%% .............................................................................Files

Files.Prf          = {...
    ['*mgh2srf_mean_' Para.ModelType{1} '_aperture-pins_vec_spmcan_CrsFit.mat'] ...
    ['*mgh2srf_mean_' Para.ModelType{2} '_aperture-pins_vec_spmcan_CrsFit.mat']};
%%% Note: 1st: Null model
%         2nd: Alternative model

%% .............................................................................Switches

Switches.SaveAllVars = 0;

try

    %% -------------------------------------------------------------------------
    % (1) Display time courses for observed vs fit data
    % --------------------------------------------------------------------------

    ss_zoomprf_main_disptc_obsvsfit_wrapper(Subjects, Fld, Files, Para)

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