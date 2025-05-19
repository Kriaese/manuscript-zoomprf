%% -----------------------------------------------------------------------------
% 00 - zoomprf main - change samsrf defaults
% ------------------------------------------------------------------------------
%
%
% ------------------------------------------------------------------------------
% 15/09/2022: Generated (SS)
% 16/05/2025: Last modified (SS)

%% .............................................................................Tidy up

clear all
close all

%% .............................................................................Folders

% Load paths
Paths = load(fullfile('..', '..', '..', 'paths', 'RootPaths'));

% Roots
Fld.TlbxRoot       = Paths.TlbxRoot;

% Toolboxes
Fld.Toolboxes      = {'samsrf_v9.51' 'ss_toolbox'};

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

Para.RoiList = {'D2a' 'D2b' 'D2c' 'D2d' 'D2e'};
%%% Multiple index finger ROIs for delineation purposes
Para.DispRoi = '<YNaN';
%%% Suface model not restricted to any ROI (whole brain)
Para.Curv   = 'FreeSurfer'; 
%%% Curvature follows FreeSurfer's style

%% .............................................................................Switches

Switches.SaveAllVars = 0;

try

    %% -------------------------------------------------------------------------
    % (1) Change samsrf defaults
    % --------------------------------------------------------------------------

    ss_samsrf_changedef(Para.RoiList, Para.DispRoi, Para.Curv, []);

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