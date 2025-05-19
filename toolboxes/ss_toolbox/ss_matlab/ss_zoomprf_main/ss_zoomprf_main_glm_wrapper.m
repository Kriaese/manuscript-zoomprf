function ss_zoomprf_main_glm_wrapper(Subjects, Fld, Files, Para)
%
%
%
% ------------------------------------------------------------------------------
% 14/08/2022: Last modified (SS)
% 10/04/2025: Last modified (SS)

%% .............................................................................Get t0

T0 = tic;

%% .............................................................................Try to get current parallel pool

ss_parallel_gcp;

%% .............................................................................Generate hrf

if strcmp(Para.HrfType, 'spmcan')
    Hrf = spm_hrf(Para.TR);
elseif strcmp(Para.HrfType, 'samsrfcan')
    Hrf = samsrf_hrf(Para.TR);
end

%% .............................................................................Loop through subjects

for i_subj=1:size(Subjects.ID,2)
    % parfor

    CurrSubj = Subjects.ID{i_subj};

    %% .........................................................................Loop through kernel size

    for i_kernel=1:size(Subjects.Kernel,2)

        CurrKernel = Subjects.Kernel{i_kernel};

        %% .....................................................................Loop through sessions

        for i_sess = 1:size(Subjects.Sessions,2)

            CurrSess   = Subjects.Sessions{i_sess};

            %% .................................................................Paths

            PathBeh  = fullfile(Fld.SourceDataRoot, CurrSubj, CurrSess, Fld.Beh);

            %% .................................................................Get regressor names, design matrix, contrasts, and contrast names

            cd(PathBeh)
            [RegrNames, DesignMatrix, Contr, ContrNames] = ....
                ss_zoomprf_main_glm_desmatcontr(Files.Beh);

            if i_sess > 1
                if ~isequal(PrevDesignMatrix, DesignMatrix)
                    error('Design matrices ar unequal')
                end
            end

            PrevDesignMatrix = DesignMatrix;

            %% .................................................................Convolve with hrf

            X = conv2(DesignMatrix, Hrf);

            %% .................................................................Truncate to original length

            X = X(1:size(DesignMatrix,1),:);

            %% .................................................................Paths

            PathSamSrfKernel     = fullfile(Fld.SamSrfRoot, CurrSubj, CurrSess, CurrKernel);

            %% .................................................................Loop through hemis

            for i_hemi=1:size(Para.Hemis,2)

                CurrHemi = Para.Hemis{i_hemi};

                %% .............................................................Get files

                cd(PathSamSrfKernel)
                FileList = dir([CurrHemi '*' CurrSess '*' Files.Mgh2Srf]);
                FileNames = {FileList.name};
                
                %% .............................................................Generate glm file name

                FileNameGlm = [FileNames{1}(1:30) 'all' FileNames{1}(33:end-4) '_' Para.HrfType '_' Files.Glm];

                %% .............................................................Expand X (as runs will be concatenated)

                XExp = repmat(X, size(FileNames,2),1);

                %% .............................................................Complement contrasts (account for constants)

                ContrCompl = [Contr zeros(size(Contr,1), size(FileNames,2)) ];

                %% .............................................................Perform glm

                samsrf_glm(FileNames, XExp, RegrNames, '', FileNameGlm(4:end));

                %% .............................................................Delete figure

                delete('*.fig')

                %% .............................................................Calcualate contrasts

                samsrf_glm_conts(FileNameGlm, ContrCompl, ContrNames);

                close all

            end

        end

    end

end

%% .............................................................................Get T1

T1 = toc(T0);
TEnd = num2str(T1/60/60);

%% .............................................................................Display running time

disp(['Analysis completed in ' TEnd ' hours.']);

%% .............................................................................Shut down parallel pool

ss_parallel_shutdowngcp;

end