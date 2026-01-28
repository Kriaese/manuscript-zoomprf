%% -----------------------------------------------------------------------------
% 41 - zoomprf main - display 2D Gaussian pRF 
% ------------------------------------------------------------------------------
%
%
% ------------------------------------------------------------------------------
% 28/06/2023: Generated (SS)
% 23/11/2025: Last modified (SS)
% ------------------------------------------------------------------------------

%% .............................................................................Tidy up

clear all
close all

%% .............................................................................Folders

% Load paths
Paths = load(fullfile('..', '..', '..', 'paths', 'RootPaths'));

% Roots
Fld.TlbxRoot       = Paths.TlbxRoot;
Fld.DataRoot       = Paths.DataRoot;
Fld.ResultsRoot    = fullfile(Fld.DataRoot, 'derivatives', 'results');

% Toolboxes
Fld.Toolboxes      = {'ss_toolbox' 'samsrf_v9.51' 'scientificcolourmaps8'};

% PRF 2D Gaussian
Fld.Prf2dg         = 'prf2dg';

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

Para.Ext       = 'pdf'; 
Para.Res       = 300; 

Para.PrfX0     = 0; 
Para.PrfY0     = 0; 
Para.PrfSigma  = 0.75; 
Para.ApWidth   = 170;  
Para.MeshX     = [-4.25:0.05:-0.05, 0.05:0.05:4.25]; 
Para.MeshY     = [-4.25:0.05:-0.05, 0.05:0.05:4.25]; 

%% .............................................................................Switches

Switches.SaveAllVars = 0;

try

    %% -------------------------------------------------------------------------
    % (1) Display 2D Gaussian pRF 
    % --------------------------------------------------------------------------

    ss_zoomprf_main_dispc2dgprf_wrapper(Fld, Para)

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