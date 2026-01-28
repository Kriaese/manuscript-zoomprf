%% -----------------------------------------------------------------------------
% 45 - zoomprf main - display pRF workflow
% ------------------------------------------------------------------------------
%
%
% ------------------------------------------------------------------------------
% 23/06/2023: Generated (SS)
% 23/11/2025: Last modified (SS)
% ------------------------------------------------------------------------------

%% .............................................................................Tidy up

clear all
close all

%% .............................................................................Random number seed

Rng = rng(24072023, 'twister');

%% .............................................................................Subjects

Subjects.ID            = { ...
    'sub-01'};

%% .............................................................................Folders

% Load paths
Paths = load(fullfile('..', '..', '..', 'paths', 'RootPaths'));

% Roots
Fld.TlbxRoot       = Paths.TlbxRoot;
Fld.DataRoot       = Paths.DataRoot;
Fld.ResultsRoot    = fullfile(Fld.DataRoot, 'derivatives', 'results');
Fld.SamSrfRoot     = fullfile(Fld.DataRoot, 'derivatives', 'SamSrf');

% Toolboxes
Fld.Toolboxes      = {'ss_toolbox' 'samsrf_v9.51' 'spm12'};

% SamSrf
Fld.SamSrfApt      = 'aperture';

% PRF workflow
Fld.PrfWorkflow    = 'prfworkflow';

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

Para.Sd           = 2;
Para.TR           = 2;
Para.HrfType      = 'spmcan';
Para.Ext          = 'pdf';
Para.Res          = 300;
Para.ApFrmImgIdx  = 17:4:29;

%% .............................................................................Files

Files.AptImg      = 'task-prf_aperture-pins';
Files.AptVect     = 'task-prf_aperture-pins_vec';

%% .............................................................................Switches

Switches.SaveAllVars = 0;

try

    %% -------------------------------------------------------------------------
    % (1) Display prf workflow
    % --------------------------------------------------------------------------

    ss_zoomprf_main_dispprfworkflow_wrapper(Subjects, Fld, Files, Para)

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