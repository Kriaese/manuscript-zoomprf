function ss_zoomprf_main_dispprfworkflow_wrapper(Subjects, Fld, Files, Para)
%
%
%
% ------------------------------------------------------------------------------
% 23/06/2023: Last modified (SS)
% 05/01/2024: Last modified (SS)

%% .............................................................................Paths
 
PathSamSrfApt                   = fullfile(Fld.SamSrfRoot, Subjects.ID{1}, Fld.SamSrfApt);
PathSamSrfWorkflow              = fullfile(Fld.ResultsRoot, Fld.PrfWorkflow);
ss_checkfld(PathSamSrfWorkflow);

%% .............................................................................Get sequential index for positions

cd(PathSamSrfApt)
ApFileImg  = load([Subjects.ID{1} '_' Files.AptImg]); 
ApFileVect = load([Subjects.ID{1} '_' Files.AptVect]); 

%% .............................................................................Display workflow figures

cd(PathSamSrfWorkflow)
ss_zoomprf_main_dispprfworkflow(ApFileImg.ApFrm, ApFileVect.ApFrm, ApFileVect.ApXY,...
    Para.TR, Para.HrfType, Para.Ext, Para.Res, Para.Sd, Para.ApFrmImgIdx)

end