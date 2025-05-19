function ss_zoomprf_main_genapt_wrapper(Subjects, Fld, Files)
%
%
%
% ------------------------------------------------------------------------------
% 16/08/2022: Last modified (SS)
% 10/04/2025: Last modified (SS)

%% .............................................................................Define some variables

AutoSaveApFrm = false;
%%% Note: Switches off autosaving of aperture frame.
Resize        = false;
Scaling       = 4.25;

%% .............................................................................Loop through subjects

for i_subj=1:size(Subjects.ID,2)

    CurrSubj = Subjects.ID{i_subj};

    %% .........................................................................Paths

    PathBeh              = fullfile(Fld.SourceDataRoot, CurrSubj, Subjects.Sessions{1}, Fld.Beh);
    PathSamSrfApt        = fullfile(Fld.SamSrfRoot, CurrSubj, Fld.SamSrfApt);
    ss_checkfld(PathSamSrfApt);

    %% .........................................................................Get sequential index for positions

    cd(PathBeh)
    SeqIdx = ss_zoomprf_main_genseqidx(Files.Beh);

    %% .........................................................................Generate 2D aperture

    ApFrm = ss_zoomprf_main_genapt_pins(SeqIdx, AutoSaveApFrm, Resize, Files.Apt);

    %% .........................................................................Generate file name of aperture

    AptFileName = [CurrSubj '_' Files.Apt]; 

    %% .........................................................................Save 2D aperture

    cd(PathSamSrfApt)
    save(AptFileName, 'ApFrm');

    %% .........................................................................Vectorize Aperture

    VectoriseApertures(AptFileName, Scaling)

end

end