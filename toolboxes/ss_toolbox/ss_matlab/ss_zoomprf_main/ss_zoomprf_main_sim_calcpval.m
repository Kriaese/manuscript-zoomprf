function [SumStats, ValuesCols] = ss_zoomprf_main_sim_calcpval(Srf, R2DiffType, CritValues)
%
%
% Calcualtes p-values for a distribution of differential goodness-of-fit values
% based on critical values.
%
% ------------------------------------------------------------------------------
% Inputs
% ------------------------------------------------------------------------------
% SrfPrf        - SamSrf surface structure (after fitting) [structure]
% SumStatValues - Values for which summary stats are calculated [cell]
% ------------------------------------------------------------------------------
% Outputs
% ------------------------------------------------------------------------------
% SumStats      - Statistical summary listing p- and critical values [double]
% ValuesCols    - Column labels [cell]
% ------------------------------------------------------------------------------
% 14/11/2024: Generated (SS)
% 14/11/2024: Last modified (SS)

%% .............................................................................Get differential R2s

IdxR2Diff = strcmp(Srf.Values, R2DiffType);
R2Diff    = Srf.Data(IdxR2Diff,:);

%% .............................................................................Put together sum stats (p-values and critical values)

SumStats = [];
for i_sum=1:size(CritValues,2)
    CurrCritValue = CritValues(1,i_sum);
    SumStats = [SumStats; sum(R2Diff >= CurrCritValue)/size(R2Diff,2) CurrCritValue];
end

%% .............................................................................Check for negative R2s

if strcmp(R2DiffType, 'diff-cR^2')

    IdxR2SignCombo    = strcmp(Srf.Values,'cR^2-neg-combo');
    R2SignCombo       = Srf.Data(IdxR2SignCombo,:);

    if sum(R2SignCombo) > 0
        %%% Note: 
        %%% 1 = negative R2 for one model
        %%% 2 = nagtive R2 for both models
        error('Negative R2s present')
    end

end

%% .............................................................................Store column labels

ValuesCols = {'p' 'crit. value'};

end