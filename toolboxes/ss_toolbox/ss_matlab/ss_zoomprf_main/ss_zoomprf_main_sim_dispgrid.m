function ss_zoomprf_main_sim_dispgrid(Srf, AptXY, XLabel, YLabel, SearchSpace)
%
% Displays search grid or recovered pRF parameters for SamSrf coarse fitting
% procedure along with chosen ground truth pRF parameters.
%
% ------------------------------------------------------------------------------
% Input
% ------------------------------------------------------------------------------
% Srf         - SamSrf surface structure [structure]
% AptXY       - x [1st row] and y points [2nd row] of corners of rectangle.
%               Points run counterclockwise, starting with the upper right
%               corner. [double]
% XLabel      - X-axis label [char]
% YLabel      - Y-axis label [char]
% SearchSpace - x0 [1st row] and y0 [2nd row] search space value pairs for
%               coarse fit [double]
% ------------------------------------------------------------------------------
% Output
% ------------------------------------------------------------------------------
% -/-
% ------------------------------------------------------------------------------
% 10/11/2023: Generated (SS)
% 31/01/2025: Last modified (SS)
% ------------------------------------------------------------------------------
% Note: Function currently assumes that it deals with x0 and y0 values, that
% fitting has been performed without adding noise to the simulated data, and 
% that ground truth pRF parameters are part of the search grid.

%% .............................................................................Draw recovered pRF parameters (if there is only 4 input arguments)

if isempty(SearchSpace)

    %% .........................................................................Define legend labels

    LabelsLegend = {'mapping area' 'recovered' 'ground truth'};

    %% .........................................................................Determine unique ground truth values

    GroundTruth = Srf.Ground_Truth;

    %% .........................................................................Get index for pRF parameters of interest

    IdxValues   = ismember(Srf.Values, {'x0' 'y0'});

    %% .........................................................................Extract pRF parameters

    Data        = Srf.Data(IdxValues,:);

    %% .........................................................................Color for data 
    
    ColorData =  [0 0 0]; 

    %% .........................................................................Color for ground truth 

    ColorGroundTruth = [1 0 0];  

    %% .........................................................................Draw search space 

else

    %% .........................................................................Define legend labels

    LabelsLegend = {'mapping area' 'search space' 'ground truth'};

    %% .........................................................................Determine unique ground truth values

    GroundTruth = Srf.Ground_Truth;
    GroundTruth = unique(GroundTruth.', 'rows').';
    %%% Unique ground truth value pairs (row 1: xo; row 2: yo)

    %% .........................................................................Clean search space (throw out zeros)

    IdxSearchSpace = ~all(SearchSpace == 0,2);
    Data = SearchSpace(IdxSearchSpace,:);

    %% .........................................................................Color for data 
    
    ColorData = [0 0 0]; 

    %% .........................................................................Color for ground truth 

    ColorGroundTruth = [0 0 0];  

end

%% .............................................................................Throw error if there are 3 ground truhth values

if size(GroundTruth,1) > 2
    error('I cannot deal with a ground truth triplet')
end

%% .............................................................................Draw aperture

ss_drawrect(AptXY(1,:), AptXY(2,:), [0 0 0], 0.25); hold on;

%% .............................................................................Draw data (search space or recovered parameters)

scatter(Data(1,:), Data(2,:),  30, ColorData, 'o'); hold on;

%% .............................................................................Draw ground truth

scatter(GroundTruth(1,:), GroundTruth(2,:), 30, ColorGroundTruth,  'x', 'LineWidth', 1); hold on;

%% .............................................................................Draw shift (if there is only 4 input arguments)

if isempty(SearchSpace)

    if sum(sum(GroundTruth-Data,2),1) ~= 0
        warning('Parameter recovery is below 100%.')
        line([GroundTruth(1,:); Data(1,:)], [GroundTruth(2,:); Data(2,:)], ...
            'Color', [0 0 0],  'LineWidth', 0.5); hold on;
        LabelsLegend = [LabelsLegend 'shift'];
    end
    %%% Note: This should be the case if noise has been added to the data or if the
    %%% ground truth does not coincide with the search grid values.

end

%% .............................................................................Add plot features

% set(gcf, 'Units', 'normalized');
% set(gcf, 'Position', [0 0 0.5 0.5]);
xlabel(XLabel);
ylabel(YLabel);
axis square
xline(0)
yline(0)

%% .............................................................................Add legend

legend(LabelsLegend, 'Location','northoutside', 'Orientation','horizontal', 'FontSize', 11, 'NumColumns', 2);

end