function [SumStats, ValuesCols, ValuesRows, ValuesDim3] = ss_zoomprf_main_sim_calcsumstats(SrfPrf, SumStatValues, SimModel)
%
% Get summary stats of recovered pRF parameter estimates.
%
% ------------------------------------------------------------------------------
% Inputs
% ------------------------------------------------------------------------------
% SrfPrf        - SamSrf surface structure (after fitting) [structure]
% SumStatValues - Values for which summary stats are calculated [cell]
% SimModel      - SamSrf model structure used to simulate data on which fitting
%                 was perfomed [structure]
% ------------------------------------------------------------------------------
% Outputs
% ------------------------------------------------------------------------------
% SumStats      - Statisticall summary of recovered pRF estimates [double]
% ValuesCols    - Column labels [cell]
% ValuesRows    - Row labels [cell]
% ValuesDim3    - Labels for 3rd dimension [cell]
% ------------------------------------------------------------------------------
% 05/04/2023: Generated (SS)
% 16/10/2024: Last modified (SS)

%% .............................................................................Get unique ground truth combinations

UniqueGt = SrfPrf.Ground_Truth;
UniqueGt = unique(UniqueGt.', 'rows').';
%%% Note: Currently, we basically assume that a 2dg pRF model has been used and
%%% there are 3 ground truth parameters (x0, y0, and sigma).

%% .............................................................................Determine whether number of repetitions was 1

NReps1 = size(SrfPrf.Ground_Truth, 2) == size(UniqueGt,2);

%% .............................................................................Determine remainder (number of sum stats values besides x0, y0, and sigma)

Remainder = size(SumStatValues,2) - sum(ismember(SumStatValues, SimModel.Param_Names));
% Remainder = size(SumStatValues,2) - sum(ismember(SumStatValues, {'x0' 'y0' 'Sigma'}));

%% .............................................................................Specify col, row, and 3rd dim values

if NReps1 == true
    ValuesCols  = {'ground truth' 'recovered values'};
else
    ValuesCols  = {'ground truth' 'recovered median' 'recovered 1%-ile' 'recovered 99%-ile'};
end

ValuesRows  = SumStatValues;
ValuesDim3  = strcat('gtset-', ss_arraynum2str(1:size(UniqueGt,2)));

%% .............................................................................Get value index

IdxValues = ismember(SrfPrf.Values, SumStatValues');

%% .............................................................................Preallocate variables

SumStats = nan(size(ValuesRows,2), size(ValuesCols,2), size(UniqueGt,2));

%% .............................................................................Loop through unique ground truth values

for i_ugt=1:size(UniqueGt,2)

    CurrUniqueGt = UniqueGt(:, i_ugt);

    %% .........................................................................Extract fits

    GtIdx = sum(SrfPrf.Ground_Truth == CurrUniqueGt,1) == size(SimModel.Param_Names,1) ;
    Data  = SrfPrf.Data(IdxValues, GtIdx);

    %% .........................................................................Gather sum stats

    if NReps1 == true
        SumStats(:,:,i_ugt) = [[CurrUniqueGt; nan(Remainder,1)], Data];
    else
        SumStats(:,:,i_ugt) = [[CurrUniqueGt; nan(Remainder,1)], median(Data,2), ...
            prctile(Data, [1 99], 2)];
    end

end

end