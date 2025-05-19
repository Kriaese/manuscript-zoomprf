function ss_zoomprf_main_mgh2srf_wrapper(Subjects, Fld, Files, Para)
%
%
% ------------------------------------------------------------------------------
% 13/07/2023: Generated (SS)
% 30/08/2024: Last modified (SS)

%% .............................................................................Get t0

T0 = tic;

%% .............................................................................Try to get current parallel pool

ss_parallel_gcp;

%% .............................................................................Loop through subjects (loop might be used for parallel processing)

for i_subj=1:size(Subjects.ID,2)
    % parfor

    CurrSubj = Subjects.ID{i_subj};

    %% .........................................................................Paths

    PathSamSrfAnat     = fullfile(Fld.SamSrfRoot, CurrSubj, Fld.SamSrfAnatomy, filesep);
    PathFSSurf         = fullfile(Fld.FSRoot, CurrSubj, Fld.FSSurf);

    %% .........................................................................Paths

    PathFSVol2Surf = fullfile(Fld.FSRoot, CurrSubj, Fld.FSVol2Surf);

    %% .........................................................................Loop through kernel size

    for i_kernel=1:size(Subjects.Kernel,2)

        CurrKernel = Subjects.Kernel{i_kernel};

        %% .....................................................................Loop through sessions (loop might be used for parallel processing)

        for i_sess = 1:size(Subjects.Sessions,2)
             % parfor

            CurrSess = Subjects.Sessions{i_sess};

            %% .................................................................Settings for individual sessions

            if sum(strcmp(CurrSess, {'ses-01' 'ses-02' 'ses-03' 'ses-04' })) > 0

                MghPat     = ['*' CurrSess '*' CurrKernel '_BBR' Files.Mgh];
                Mgh2SrfPat = ['*' CurrSess '*' CurrKernel '_BBR' Files.Mgh2Srf];
                %%% Note: We need '_' here because otherwise all kernel
                %%% sizes that contain a 0 will be selected (e.g. 0 and
                %%% 0.5).

                Combi         = {'runwise' 'runaggr'};
                Norm          = [1 1];
                Avg           = [false true];
                NoiseCeiling  = [false true];
                FileNameIdx   = {1:32; 1:30};
                Suffix        = { ...
                    ['_' CurrKernel '_BBR_mgh2srf'] ...
                    ['all_' CurrKernel '_BBR_mgh2srf_mean']};

                %% .............................................................Settings for all sessions

            elseif strcmp(CurrSess, 'ses-all')

                MghPat          = ['*' CurrKernel '_BBR'  Files.Mgh];
                Mgh2SrfPat      = ['*' CurrKernel '_BBR'  Files.Mgh2Srf];

                Combi         = {'runaggr'};
                Norm          = 1;
                Avg           = true;
                NoiseCeiling  = true;
                FileNameIdx   = {1:14};
                Suffix        = {['all_task-prf_run-all_' CurrKernel '_BBR_mgh2srf_mean']};

                %% .............................................................Settings for subset of all sessions

            elseif sum(strcmp(CurrSess, {'ses-01+02' 'ses-03+04' 'ses-02+03+04' ...
                    'ses-02+03+04-odd' 'ses-02+03+04-eve'})) > 0

                StringSplits = strsplit(CurrSess, '+');

                %% .............................................................Remove odd-even suffix

                if contains(CurrSess, {'-odd', '-eve'})
                    StringSplits = strrep(StringSplits ,'-odd', '');
                    StringSplits = strrep(StringSplits ,'-eve', '');
                end

                %% .............................................................Loop through string splits

                MghPat   = {};

                for i_ss=1:size(StringSplits,2)

                    CurrStringSplit = StringSplits{1, i_ss};
                    CurrStringSplit = CurrStringSplit(end-1:end);

                    %% .........................................................Create patterns for (odd or even) runs

                    if contains(CurrSess, '-odd')
                        MghPatSess     = strcat(['*ses-' CurrStringSplit '*'], Para.OddRuns);
                        MghPat(i_ss,:) = strcat(MghPatSess, ['*' CurrKernel '_BBR'  Files.Mgh]);
                        RunAffix           = 'odd';
                    elseif contains(CurrSess, '-eve')
                        MghPatSess     = strcat(['*ses-' CurrStringSplit '*'], Para.EveRuns);
                        MghPat(i_ss,:) = strcat(MghPatSess, ['*' CurrKernel '_BBR'  Files.Mgh]);
                        RunAffix           = 'eve';
                    else
                        MghPat(i_ss,:) = {['*ses-' CurrStringSplit '*' CurrKernel '_BBR' Files.Mgh]};
                        RunAffix           = 'all';
                    end

                end

                MghPat    = MghPat(:);
                Mgh2SrfPat= ['*' CurrKernel '_BBR' Files.Mgh2Srf];

                Combi         = {'runaggr'};
                Norm          = 1;
                Avg           = true;
                NoiseCeiling  = true;
                FileNameIdx   = {1:10};
                Suffix        = {[CurrSess '_task-prf_run-' RunAffix '_' CurrKernel '_BBR_mgh2srf_mean']};

            end

            %% .................................................................Paths

            PathSamSrfKernel     = fullfile(Fld.SamSrfRoot, CurrSubj, CurrSess, CurrKernel);
            ss_checkfld(PathSamSrfKernel);

            %% .................................................................Loop through combis

            for i_combi = 1:size(Combi,2)

                CurrCombi         = Combi{i_combi};
                CurrNorm          = Norm(i_combi);
                CurrAvg           = Avg(i_combi);
                CurrNoiseCeiling  = NoiseCeiling(i_combi);
                CurrFileNameIdx   = FileNameIdx{i_combi};
                CurrSuffix        = Suffix{i_combi};

                %% .............................................................Mgh2Srf

                cd(PathFSVol2Surf)
                ss_samsrf_mgh2srf(Para.Hemis, CurrCombi, PathFSSurf, MghPat, ...
                    CurrNorm, CurrAvg, CurrNoiseCeiling, PathSamSrfAnat);

                %% .............................................................Rename files and move

                ss_renamefile(Mgh2SrfPat, CurrFileNameIdx, PathSamSrfKernel, CurrSuffix)

                %% .............................................................Rename path to anatomical data

                cd(PathSamSrfKernel)
                ss_samsrf_changeanapath([Mgh2SrfPat(1:end-4) '*'], Para.AnatPath)

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