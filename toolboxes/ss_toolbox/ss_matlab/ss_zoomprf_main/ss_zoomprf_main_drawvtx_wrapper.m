function ss_zoomprf_main_drawvtx_wrapper(Subjects, Fld, Files, Para)
%
%
%
% ------------------------------------------------------------------------------
% 19/11/2022: Last modified (SS)
% 19/11/2025: Last modified (SS)

%% .............................................................................Loop through subjects

for i_subj=1:size(Subjects.ID,2)

    CurrSubj = Subjects.ID{i_subj};

    %% .........................................................................Loop through kernel size

    for i_kernel=1:size(Subjects.Kernel,2)

        CurrKernel = Subjects.Kernel{i_kernel};

        %% .....................................................................Loop through sessions

        for i_sess = 1:size(Subjects.Sessions,2)

            CurrSess   = Subjects.Sessions{i_sess};

            %% .................................................................Paths

            PathSamSrfKernel     = fullfile(Fld.SamSrfRoot, CurrSubj, CurrSess, CurrKernel);
            
            cd(PathSamSrfKernel)
            LabelInfo  = dir([Fld.SamSrfLabel]); 
            PathSamSrfLabel     = fullfile(PathSamSrfKernel, LabelInfo.name); 

            %% .................................................................Loop through hemis

            for i_hemi=1:size(Para.Hemis,2)

                CurrHemi = Para.Hemis{i_hemi};

                %% .............................................................Get files

                FileInfo = dir([CurrHemi '*' CurrSess Files.Mgh2SrfAggr]);
                Data     = load(FileInfo.name);

                %% .............................................................Get vertex indices for current hemisphere
                
                CurrVtxIdxHemi   = Subjects.VtxIdx{1, i_hemi}; 

                %% .............................................................Loop through vertices 

                for i_vtxidxhemi=1:size(CurrVtxIdxHemi,2)

                    CurrVtxIdx = CurrVtxIdxHemi(i_subj, i_vtxidxhemi);

                    %% .........................................................Convert SamSrf data to FreeSurfer label

                    samsrf_srf2label(Data.Srf, fullfile(PathSamSrfLabel, [CurrHemi '_vertex-' num2str(i_vtxidxhemi) ]), 1, CurrVtxIdx);

                end

            end

        end

    end

end


end