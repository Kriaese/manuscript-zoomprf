function [Count, ValuesCols, ValuesDim3] = ss_zoomprf_main_sim_getcount(Srf, SearchSpace)
%
% Counts how many times a certain search spaace value pair has been chosen as 
% the final fit in the scope of the coarse fitting procedure implemented in 
% SamSrf.
%
% ------------------------------------------------------------------------------
% Input
% ------------------------------------------------------------------------------
% Srf         - SamSrf surface structure [structure]
% SearchSpace - Search space value pairs for coarse fit (row 1: xo; row 2:
%               yo) [double]
% ------------------------------------------------------------------------------
% Output
% ------------------------------------------------------------------------------
% Count       - How many times a certain search space value pair has been
%               chosen as the final fit [double]
% ValuesCols  - Search space value pair labels/column labels [cell]
% ValuesDim3  - Ground truth value pair labels/labels for 3rd dimension [cell]
% ------------------------------------------------------------------------------
% 08/11/2023: Generated (SS)
% 07/11/2024: Last modified (SS)
% ------------------------------------------------------------------------------
% Note: Function currently assumes implicitely that it deals with x0 and y0
% estimates.

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

%% .............................................................................Define labels for search space combis and unique ground truth combis

ValuesCols  = strcat('spset-', ss_arraynum2str(1:size(SearchSpace,2)));
ValuesDim3  = strcat('gtset-', ss_arraynum2str(1:size(UniqueGroundTruth,2)));

%% .............................................................................Get index for pRF parameters of interest

IdxValues   = ismember(Srf.Values, {'x0' 'y0'});

%% .............................................................................Preallocate variables

Count = zeros(1, size(SearchSpace,2), size(UniqueGroundTruth,2));

%% .............................................................................Loop through unique ground truth values

for i_ugt=1:size(UniqueGroundTruth,2)

    CurrUniqueGroundTruth = UniqueGroundTruth(:, i_ugt);
    
    %% .........................................................................Get ground truth index

    GroundTruthIdx = sum(Srf.Ground_Truth == CurrUniqueGroundTruth,1) == 2;
    
    %% .........................................................................Get data 

    Data = Srf.Data(IdxValues, GroundTruthIdx);
    %%% Parameter estimate pairs (row 1: xo; row 2: yo)

    %% .........................................................................Loop through search space combis

    for i_spc=1:size(SearchSpace,2)

        %% .....................................................................Get count for current search space pair

        CurrSearchSpaceCombi = SearchSpace(:, i_spc);
        CountSearchSpaceCombi = sum(Data ==  CurrSearchSpaceCombi,1) == 2;

        %% .....................................................................Store count

        Count(1, i_spc, i_ugt) = sum(CountSearchSpaceCombi);

    end

end

end