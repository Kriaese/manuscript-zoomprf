function ss_zoomprf_main_sim_dispval(Srf, R2DiffType, Stats, Edges, XLabel, YLabel, YLim, YTicks)
%
% Displays a histogram of simulated R2 difference along with p- and critical 
% values. 
%
% ------------------------------------------------------------------------------
% Input
% ------------------------------------------------------------------------------
% Srf         - SamSrf surface structure [structure]
% R2Type      - Type of differential R2 [char]
% Stats       - Structure containing
%                   .SumStats   - P- and crit.values [double]
%                   .ValuesCols - Column labels [cell]     
% Edges       - Edges of histogram [double]
% XLabel      - X-axis label [char]
% YLabel      - Y-axis label [char]
% YLim        - Limits of y-axis [double]
% YTicks      - Ticks of y-axis [double]
% ------------------------------------------------------------------------------
% Output
% ------------------------------------------------------------------------------
% -/-
% ------------------------------------------------------------------------------
% 14/11/2024: Generated (SS)
% 04/02/2025: Last modified (SS)
% ------------------------------------------------------------------------------

%% .............................................................................Get R2 index 

IdxR2Diff = strcmp(Srf.Values, R2DiffType);
R2Diff = Srf.Data(IdxR2Diff,:);

%% .............................................................................Generate histogram of differential R2 values

histogram(R2Diff, Edges, 'FaceColor', [0.5 0.5 0.5], 'EdgeColor', [0 0 0]);

%% .............................................................................Add axis labels

xlabel(XLabel)
ylabel(YLabel)

%% .............................................................................Add axis limits

ylim(YLim);
yticks(YTicks)

%% .............................................................................Get indices for p- and crit. value

IdxPVal    = strcmp(Stats.ValuesCols, 'p'); 
IdxCritVal = strcmp(Stats.ValuesCols, 'crit. value'); 

%% .............................................................................Add summary stats (p- and critical values)

for i_sumstat = 1:size(Stats.SumStats,1)

    CurrPVal    = Stats.SumStats(i_sumstat, IdxPVal);
    CurrCritVal = Stats.SumStats(i_sumstat, IdxCritVal);

    HandleXLine = xline(CurrCritVal, '-', [Stats.ValuesCols{IdxCritVal} ' = ' num2str(CurrCritVal) ...
        ' |{\it'  Stats.ValuesCols{IdxPVal} '} = ' strrep(num2str(round(CurrPVal,4)), '0.', '.')], ...
        'LineWidth', 2,'LabelVerticalAlignment', 'top');
    HandleXLine.FontSize =  13;
end

%% .............................................................................Add grid 

grid on; 

end