function LabelsLegend = ss_samsrf_dispprf2dapt(DataPrf, LabelsPrf, AptXY, LineColor, XLabel, YLabel, LineStyle, MidpointSymbol, SophFeatures)
%
% Plots 2D pRFs as well as outline of a rectangular aperture.
%
% ------------------------------------------------------------------------------
% Inputs
% ------------------------------------------------------------------------------
% DataPrf        - Prf data (1st row: x0s, 2nd row: y0s, 3rd row: sigmas) [double]
% LabelsPrf      - Prf labels (refers to different types, such as ground truth,
%                  median pRF etc.) [cell]
% AptXY          - x [1st row] and y points [2nd row] of corners of rectangle.
%                  Points run counterclockwise, starting with the upper right
%                  corner. [double]
% LineColor      - Line colors for different types of pRFs [double]
% XLabel         - X-axis label [char]
% YLabel         - Y-axis label [char]
% LineStyle      - Line styles for different pRFs [cell]
% MidpointSymbol - Symbol for midpoint of pRF [char]
% SophFeatures   - Toggles whether more sophisticated plot features including 
%                  legend should be added (true) or not (false) [logical]
%                  --> Note that for an array of plots, it might be desirable to
%                  drop individual legends and a global legend. 
% ------------------------------------------------------------------------------
% Outputs
% ------------------------------------------------------------------------------
% LabelsLegend   - Legend labels [cell]
% ------------------------------------------------------------------------------
% 17/04/2023: Generated (SS)
% 20/11/2024: Last modified (SS)

%% .............................................................................Some defaults

if nargin < 9
    SophFeatures = false;
end

%% .............................................................................Legend labels

LabelsLegend = ['mapping area' LabelsPrf];

%% .............................................................................Draw aperture

ss_drawrect(AptXY(1,:), AptXY(2,:), [0 0 0], 0.25);

%% .............................................................................Check if there is a ground truth

if sum(strcmp(LabelsPrf, 'ground truth')) == 1
    IdxGt = strcmp(LabelsPrf, 'ground truth');
end

%% .............................................................................Loop through prfs

for i_prf=1:size(DataPrf,2)

    CurrDataPrf = DataPrf(:, i_prf);
    CurrLineCol = LineColor(i_prf, :);
    CurrLineStyle = LineStyle{i_prf};
    CurrMidpointSymbol = MidpointSymbol{i_prf};

    %% .........................................................................Draw 2D pRF

    if sum(strcmp(LabelsPrf, 'ground truth')) == 1
        ss_drawcircle(DataPrf(1,IdxGt), DataPrf(2,IdxGt), CurrDataPrf(3,1), ...
            CurrLineCol, CurrLineStyle);
        %%% Note: This should make it easier to compare pRF sizes.
    else
        ss_drawcircle(CurrDataPrf(1,1), CurrDataPrf(2,1), CurrDataPrf(3,1), ...
            CurrLineCol, CurrLineStyle);
    end

    %% .........................................................................Draw midpoints of pRF

    plot(CurrDataPrf(1,1), CurrDataPrf(2,1), CurrMidpointSymbol, ...
        'Color', CurrLineCol, 'HandleVisibility','off', 'LineWidth', 2)

end

%% .............................................................................Add basic plot features

axis square
xline(0)
yline(0)

%% .............................................................................Add more sophisticated plot features

if SophFeatures
    set(gcf, 'Units', 'normalized');
    set(gcf, 'Position', [0 0 0.5 0.5]);
    xlabel(XLabel);
    ylabel(YLabel);
    legend(LabelsLegend, 'Location','northeastoutside');
end

end