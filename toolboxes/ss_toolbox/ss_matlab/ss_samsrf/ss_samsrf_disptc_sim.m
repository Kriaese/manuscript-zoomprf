function LegendLabels = ss_samsrf_disptc_sim(Srf, Model, IdxVtx, SophFeatures, Units)
%
% Plots noise-free simulated time series for a 2D Gaussian pRF model.
%
% ------------------------------------------------------------------------------
% Inputs
% ------------------------------------------------------------------------------
% Srf            - SamSrf surface structure for data simulated according to a 2D
%                  Gaussian pRF model  [structure]
% Model          - SamSrf model structure for data simulated according to a 2D
%                  Gaussian pRF model  [structure]
% IdxVtx         - Indicates which vertex (i.e. ground truth pRF) should be
%                  displayed [double]
% SophFeatures   - Toggles whether more sophisticated plot features including
%                  legend should be added (true) or not (false) [logical]
%                  --> Note that for an array of plots, it might be desirable to
%                  drop individual legends and a global legend.
% Units          - Units of pRF parameters (x0, y0, sigma) [char]
% ------------------------------------------------------------------------------
% Outputs
% ------------------------------------------------------------------------------
% -/-
% ------------------------------------------------------------------------------
% 07/09/2023: Generated (SS)
% 29/01/2025: Last modified (SS)

%% .............................................................................Some defaults

if nargin < 4
    SophFeatures = false;
end

%% .............................................................................Check that requirements for a 2D Gaussian pRF model are fullfilled

if ~isequal(Model.Param_Names, {'x0', 'y0', 'Sigma'}')
    error('A pRF model other than a 2D Gaussian has been used for the simulations.')
end

%% .............................................................................Expand surface

Srf = samsrf_expand_srf(Srf);

%% .............................................................................Get simulated noise-free time courses

SimDataClean = Srf.DataClean(:, IdxVtx);

%% .............................................................................Z-score simulated data

SimDataCleanZScored = zscore(SimDataClean);

%% .............................................................................Get desired ground truth combinations

GroundTruth = Srf.Ground_Truth(:, IdxVtx);

%% .............................................................................Get indices for ground truth parameters

IdxGtX0    = strcmp(Model.Param_Names, 'x0');
IdxGtY0    = strcmp(Model.Param_Names, 'y0');
IdxGtSigma = strcmp(Model.Param_Names, 'Sigma');

%% .............................................................................Put together legend labels

LegendLabels = cell(1, size(GroundTruth ,2));
for i_ll=1:size(GroundTruth ,2)
    CurrGroundTruth = GroundTruth(:, i_ll);
    LegendLabels{i_ll} = ['{\itx_{0}} = ' num2str(CurrGroundTruth(IdxGtX0)), ...
        ' | {\ity_{0}} = ' num2str(CurrGroundTruth(IdxGtY0)), ...
        ' | {\it\sigma} = ' num2str(CurrGroundTruth(IdxGtSigma)) ' ' Units];
end

%% .............................................................................Get color map

CMap = ss_crameri_cmap('batlow', 0);
IdxCMap = 1:round(size(CMap,1)/size(IdxVtx,2)):size(CMap,1);
CMap = CMap(IdxCMap, :);

%% .............................................................................Get TR

TR = Model.TR;

%% .............................................................................Plot simulated time course

plot((1:size(SimDataCleanZScored,1))*TR*Model.Downsample_Predictions, ...
    SimDataCleanZScored, 'linewidth', 2);
hold on

%% .............................................................................Add colors

Axes = gca;
Axes.ColorOrder = CMap;

%% .............................................................................Add basic plot features

xlim([1 size(SimDataCleanZScored,1)]*TR);
grid on
line(xlim, [0 0], 'color', [1 1 1]/2, 'linewidth', 2);

%% .............................................................................Add more sophisticated features

if SophFeatures

    legend(LegendLabels, ...
        'Location','northoutside', 'NumColumns', ceil(size(IdxVtx,2)/2), ...
        'FontSize', 13);
    % set(gcf, 'Units', 'normalized');
    % set(gcf, 'Position', [.1 .1 .8 .4]);
    % set(gca, 'fontsize', 12);
    xlabel('time (s)');
    ylabel('response (z)');

end

end