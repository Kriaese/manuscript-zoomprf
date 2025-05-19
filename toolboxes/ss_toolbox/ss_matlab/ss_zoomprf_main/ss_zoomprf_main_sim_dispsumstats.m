function ss_zoomprf_main_sim_dispsumstats(Stats, AptXY, LineColor, XLabel, YLabel, LineStyle, MidpointSymbols, ...
    XYLim, XTicks, YTicks, Units)
%
% Displays 2D ground truth and recovered pRF parameter as well as outline of a
% rectangular aperture.
%
% ------------------------------------------------------------------------------
% Input
% ------------------------------------------------------------------------------
% Stats               - Stats structure [structure]
%        .SumStats    - How many times a certain search space value pair has
%                       been chosen as the final coarse fit [double]
%        .ValuesRows  - Labels for pRF parameters {cell}
%        .ValuesCols  - Labels for pRF type (ground truth, recovered) [cell] 
%        .ValuesDim3  - Labels for ground truth value pairs [cell] 
% AptXY               - x [1st row] and y points [2nd row] of corners of 
%                       rectangle. Points run counterclockwise, starting with 
%                       the upper right corner. [double]
% LineColor           - Line colors for different types of pRFs [double]
% XLabel              - X-axis label [char]
% YLabel              - Y-axis label [char]
% LineStyle           - Line styles for types different pRFs [cell]
% MidpointSymbols     - Symbol for midpoint of pRF [char]
% XYLim               - X- and y-axis limits [char]
% XTicks              - X-Axis ticks [char]
% YTicks              - Y-axis ticks [char]
% Units               - Units of pRF parameters (x0, y0, sigma) [char]
% ------------------------------------------------------------------------------
% Output
% ------------------------------------------------------------------------------
% -/-
% ------------------------------------------------------------------------------
% 20/11/2024: Generated (SS)
% 29/01/2025: Last modified (SS)
% ------------------------------------------------------------------------------

%% .............................................................................Define some variables

FontSize = 13; 

%% .............................................................................Get title labels

ValuesRowsIdx = ismember(Stats.ValuesRows, {'x0', 'y0', 'Sigma'});
ValuesRows    = strrep(Stats.ValuesRows, 'x0', '{\itx_{0}} = ');
ValuesRows    = strrep(ValuesRows , 'y0', ' |{\ity_{0}} = ');
ValuesRows    = strrep(ValuesRows, 'Sigma', ' |{\it\sigma} = ');

%% .............................................................................Set divider for tiled layout

TiledLayoutDivider = 2;

%% .............................................................................Determine number of rows and columns for tiled layout

TiledLayoutCols = ceil(size(Stats.ValuesDim3,2)/TiledLayoutDivider);
TiledLayoutRows = ceil(size(Stats.ValuesDim3,2)/TiledLayoutCols);

%% .............................................................................Initialize figure window and tiled layout

figure
TiledLayoutHandle = tiledlayout(TiledLayoutRows, TiledLayoutCols);

%% .............................................................................Loop through dim 3 (ground truth sets)

for i_valdim3=1:size(Stats.SumStats,3)

    CurrSumStats = Stats.SumStats(:,:,i_valdim3);

    %% .........................................................................Get ground truth index

    GtIdx = strcmp(Stats.ValuesCols, 'ground truth');

    %% .........................................................................Put together title label

    TitleLabel = strcat(ValuesRows(ValuesRowsIdx), ...
        ss_arraynum2str(CurrSumStats(ValuesRowsIdx, GtIdx))') ;

    %% .........................................................................Display summary stats

    nexttile
    LabelsLegend = ss_samsrf_dispprf2dapt(CurrSumStats, Stats.ValuesCols,...
        AptXY, LineColor, XLabel, YLabel, ...
        LineStyle, MidpointSymbols);

    %% .........................................................................Add axis limits

    axis(XYLim);

    %% .........................................................................Add ticks + labels

    xticks(XTicks)
    yticks(YTicks)

    %% .........................................................................Specify font size for axes

    set(gca,'FontSize', FontSize)

    %% .........................................................................Add title

    title(sprintf('%s ', [TitleLabel{:} ' ' Units]), 'FontSize', FontSize)

end

set(gca, 'FontName', 'Helvetica');

%% .............................................................................Define spacing and padding

TiledLayoutHandle.TileSpacing   = 'compact';
TiledLayoutHandle.Padding       = 'compact';
TiledLayoutHandle.XLabel.String = XLabel;
TiledLayoutHandle.YLabel.String = YLabel;
TiledLayoutHandle.XLabel.FontSize = FontSize;
TiledLayoutHandle.YLabel.FontSize = FontSize;

%% .............................................................................Add legend

LegendHandle = legend(LabelsLegend, 'Orientation','horizontal', 'FontSize', FontSize);
LegendHandle.Layout.Tile = 'north';

%% .............................................................................Resize figure window

ss_reswin(gcf, 2, 2)

end