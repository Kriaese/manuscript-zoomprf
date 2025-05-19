function SeqIdx = ss_zoomprf_main_genseqidx(FileNamePattern)
%
% Extracts sequence indicating for every TR which location was stimulated.
%
% ------------------------------------------------------------------------------
% Input
% ------------------------------------------------------------------------------
% FileNamePattern - File name pattern [char]
% ------------------------------------------------------------------------------
% Output
% ------------------------------------------------------------------------------
% SeqIdx - Index indicating stimulus location/TR [double]
% ------------------------------------------------------------------------------
% 20/08/2022: Generated (SS)
% 14/06/2023: Last modified (SS)
% ------------------------------------------------------------------------------

%% .............................................................................Gather behav files

BehavFilesInfo = dir(FileNamePattern);

%% .............................................................................Loop through behav files

for i_files = 1:size(BehavFilesInfo,1)
    
    CurrBehavFile        = load(BehavFilesInfo(i_files).name);
    CurrStimPosSeq       = CurrBehavFile.Design.StimPosSequence;  
    CurrMicroTR          = CurrBehavFile.Design.MicroTR;  

    %% .........................................................................Check that pos sequences and micro TRs are equivalent 
    
    if i_files > 1 && ~isequal(CurrStimPosSeq, PrevStimPosSeq) && ...
        ~isequal(CurrMicroTR, PrevMicroTR)
        error('Stimulus position sequences or micro TRs not equivalent.')
    end 
    
    PrevStimPosSeq = CurrStimPosSeq; 
    PrevMicroTR    = CurrMicroTR;
    
end

%% .............................................................................Determine stimulus position sequence

SeqIdx = downsample(CurrStimPosSeq, CurrMicroTR);
SeqIdx(SeqIdx == 0) = 9;

end 