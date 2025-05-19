function ss_zoomprf_main_sim_getcount_wrapper(Subjects, Fld, Files, Para)
%
%
%
% ------------------------------------------------------------------------------
% 09/11/2023: Generated (SS)
% 07/11/2024: Last modified (SS)

%% .............................................................................Loop through sessions

for i_sess = 1:size(Subjects.Sessions,2)

    CurrSess          = Subjects.Sessions{i_sess};

    %% .........................................................................Loop through hemis

    for i_hemi = 1:size(Para.Hemis,2)

        CurrHemi = Para.Hemis{i_hemi};

        %% .....................................................................Loop through standard deviation

        for i_sd = 1:size(Para.Sd,2)

            CurrSd            = Para.Sd(1, i_sd);
            CurrNReps         = Para.NReps(1, i_sd);
            CurrSearchGridCoverage = Files.SearchGridCoverge{1, i_sd}; 
            
            FileNamePrf   = [CurrSess '_' Files.Prf{1} num2str(CurrNReps)...
                Files.Prf{2} num2str(strrep(num2str(CurrSd), '.', '')) Files.Prf{3}  CurrSearchGridCoverage Files.Prf{4}];
            FileNameSearchSpace = [Files.SearchSpace '_' FileNamePrf]; 
            FileNamePrf   = [CurrHemi '_' FileNamePrf]; 
            FileNameCount = [FileNamePrf '_count'];

            %% .................................................................Paths

            PathSamSrfSimSub = fullfile(Fld.SamSrfRoot, Fld.SamSrfSim, CurrSess, Fld.SamSrfSimSub);
            cd(PathSamSrfSimSub)
            
            %% .................................................................Load data 

            Data = load(FileNamePrf);
            SearchSpace = load(FileNameSearchSpace);
            
            %% .................................................................Get count of coarse fits

            [Count, ValuesCols, ValuesDim3] = ss_zoomprf_main_sim_getcount(Data.Srf, SearchSpace.S); 

            %% .................................................................Save

            save(FileNameCount, 'ValuesCols', 'Count', 'ValuesDim3');

        end

    end

end

end