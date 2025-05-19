function ss_zoomprf_main_sim_dispcount(Srf, Stats, SearchSpace, AptXY, XLabel, YLabel, ...
    XLim, YLim, XTicks, YTicks, ColBarLabel, IdxPanelOrder, ColorBarLim, Units)
%
% Displays ground truth pRF parameters and how many times a search space value 
% pair has been chosen as the final coarse fit in SamSrf.
%
% ------------------------------------------------------------------------------
% Input
% ------------------------------------------------------------------------------
% Srf           - SamSrf surface structure [structure]
% Stats         - Stats structure [structure]
%        .Count       - How many times a certain search space value pair has
%                       been chosen as the final coarse fit [double]
%        .ValuesDim3  - Ground truth value pairs for coarse fit [cell]
% SearchSpace   - Search space value pairs for coarse fit (row 1: xo; row 2:
%                 yo) [double]
% AptXY         - x [1st row] and y points [2nd row] of corners of rectangle.
%                 Points run counterclockwise, starting with the upper right
%                 corner. [double]
% XLabel        - X-axis label [char]
% YLabel        - Y-axis label [char]
% XLim          - X-axis limit [char]
% YLim          - Y-axis limit [char]
% XTicks        - X-Axis ticks [char]
% YTicks        - Y-axis ticks [char]
% ColBarLabel   - Label for color bar [char]
% IdxPanelOrder - Index indicating how panels shall be ordered (double)
% ColorBarLim   - Limits of color bar [double]
% Units         - Units of pRF parameters (x0, y0, sigma) [char]
% ------------------------------------------------------------------------------
% Output
% ------------------------------------------------------------------------------
% -/-
% ------------------------------------------------------------------------------
% 10/11/2023: Generated (SS)
% 31/01/2025: Last modified (SS)
% ------------------------------------------------------------------------------
% Note: Function assumes that it deals with x0 and y0 values, that fitting
% has been performed with adding noise to the simulated data.
% ------------------------------------------------------------------------------

%% .............................................................................Define legend labels

LabelsLegend = {'mapping area' 'recovered' 'ground truth'};

%% .............................................................................Set limits of colorbar

if isempty(ColorBarLim)
    ColorBarLim = [1 max(Stats.Count(:))];
end 
%%% This means that counts below 1 will be mapped to the first row in the
%%% colormap. This is why we set alpaha=0 for counts of 0.

%% .............................................................................Determine unique ground truth values

UniqueGroundTruth = Srf.Ground_Truth;
UniqueGroundTruth = unique(UniqueGroundTruth.', 'rows').';
%%% Unique ground truth value pairs (row 1: xo; row 2: yo)

%% .............................................................................Throw error if there are 3 ground truth values

if size(UniqueGroundTruth,1) > 2
    error('I cannot deal with a ground truth triplet')
end

%% .............................................................................Clean search space (throw out zeros)

IdxSearchSpace = ~all(SearchSpace == 0,2);
SearchSpace = SearchSpace(IdxSearchSpace,:);

%% .............................................................................Determine color map

CMap = ss_crameri_cmap('batlow', false);

%% .............................................................................Set divider for tiled layout

TiledLayoutDivider = 5;

%% .............................................................................Determine number of rows and columns for tiled layout

TiledLayoutCols = ceil(size(Stats.ValuesDim3,2)/TiledLayoutDivider);
TiledLayoutRows = ceil(size(Stats.ValuesDim3,2)/TiledLayoutCols);

%% .............................................................................Initialize figure window and tiled layout

figure
TiledLayoutHandle = tiledlayout(TiledLayoutRows, TiledLayoutCols);

%% .............................................................................Loop through columns (unique ground truth values)

for i_valcols=1:size(Stats.ValuesDim3,2)

    CurrIdxPanelOrder     = IdxPanelOrder(1,i_valcols); 
    CurrCount             = Stats.Count(:, :, CurrIdxPanelOrder);
    CurrUniqueGroundTruth = UniqueGroundTruth(:, CurrIdxPanelOrder);
   
    %% .........................................................................Create next tile and plot aperture

    nexttile
    ss_drawrect(AptXY(1,:), AptXY(2,:), [0 0 0], 0.25); hold on;

    %% .........................................................................Plot counts

    FigureHandle = scatter(SearchSpace(1,:), SearchSpace(2,:), 12, CurrCount, 'filled'); hold on;

    %% .........................................................................Set color map

    colormap(CMap);

    %% .........................................................................Set counts of 0 to fully transparent

    FigureHandle.AlphaData = ones(size(CurrCount));
    FigureHandle.AlphaData(CurrCount == 0) = 0;
    FigureHandle.MarkerFaceAlpha = 'flat';

    %% .........................................................................Add color bar

    if mod(i_valcols,TiledLayoutDivider) == 0
        ColBarHandle = colorbar;
        ColBarHandle.Label.String = ColBarLabel;
    end

    %% .........................................................................Add ground truth

    scatter(CurrUniqueGroundTruth(1,1), CurrUniqueGroundTruth(2,1), 12, [1 0 0], 'x');

    %% .........................................................................Add plot features

    axis square;
    clim(ColorBarLim);
    box on;
    grid on;
    xlim(XLim)
    ylim(YLim)
    xticks(XTicks)
    yticks(YTicks)
    xtickangle(0)

    %% .........................................................................Set font size

    set(gca, 'fontsize', 8);

    %% .........................................................................Add title

    title(['{\itx_{0}} = ' num2str(round(CurrUniqueGroundTruth(1,1),2) ) '{|}' ' {\ity_{0}} = ' num2str(round(CurrUniqueGroundTruth(2,1),2)) ' ' Units], ...
        'FontSize', 6);

end

%% .............................................................................Define spacing and padding

TiledLayoutHandle.TileSpacing = 'compact';
TiledLayoutHandle.Padding = 'compact';
TiledLayoutHandle.XLabel.String = XLabel;
TiledLayoutHandle.YLabel.String = YLabel;
TiledLayoutHandle.XLabel.FontSize = 13;
TiledLayoutHandle.YLabel.FontSize = 13;

%% .............................................................................Add legend

LegendHandle = legend(LabelsLegend, 'Orientation','horizontal', 'FontSize', 11);
LegendHandle.Layout.Tile = 'north'; 

%% .............................................................................Resize figure window

ss_reswin(gcf, 1.5, 2)

end

