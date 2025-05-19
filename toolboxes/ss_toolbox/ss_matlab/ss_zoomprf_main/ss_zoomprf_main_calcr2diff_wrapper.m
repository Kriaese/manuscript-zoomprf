function ss_zoomprf_main_calcr2diff_wrapper(Subjects, Fld, Files, Para)
%
%
%
% ------------------------------------------------------------------------------
% 22/08/2022: Generated (SS)
% 04/09/2024: Last modified (SS)
% ------------------------------------------------------------------------------

%% .............................................................................Get t0

T0 = tic;

%% .............................................................................Try to get current parallel pool

ss_parallel_gcp;

%% .............................................................................Loop through subjects

for i_subj=1:size(Subjects.ID,2)
    % parfor

    CurrSubj = Subjects.ID{i_subj};

    %% .........................................................................Loop through kernel size

    for i_kernel=1:size(Subjects.Kernel,2)

        CurrKernel = Subjects.Kernel{i_kernel};

        %% .....................................................................Loop through sessions

        for i_sess = 1:size(Subjects.Sessions,2)

            CurrSess = Subjects.Sessions{i_sess};

            %% .................................................................Paths

            PathSamSrfKernel   = fullfile(Fld.SamSrfRoot, CurrSubj, CurrSess, CurrKernel);

            %% .................................................................Get file names

            cd(PathSamSrfKernel)

            %% .................................................................Loop through hemispheres

            for i_hemi = 1:size(Para.Hemis, 2)

                CurrHemi = Para.Hemis{i_hemi};

                %% .............................................................Load map 1

                MapFileInfo1 = dir([CurrHemi '*' Files.Prf{1} '*']);
                MapFileName1 = MapFileInfo1(1).name;
                Map1         = load(MapFileName1);

                %% .............................................................Load map 2

                MapFileInfo2 = dir([CurrHemi '*' Files.Prf{2} '*']);
                MapFileName2 = MapFileInfo2(1).name;
                Map2         = load(MapFileName2);

                %% .............................................................Calculate R2 difference

                ss_samsrf_calcr2diff(Map1, Map2, MapFileName1, Para.R2Type);

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