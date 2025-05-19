function ss_zoomprf_main_calccsnr_wrapper(Subjects, Fld, Files, Para)
%
%
%
% ------------------------------------------------------------------------------
% 08/09/2024: Generated (SS)
% 09/03/2025: Last modified (SS)
% ------------------------------------------------------------------------------

%% .............................................................................Get t0

T0 = tic;

%% .............................................................................Try to get current parallel pool

ss_parallel_gcp;

%% .............................................................................Loop through subjects

for i_subj=1:size(Subjects.ID,2)
    % parfor

    CurrSubj = Subjects.ID{i_subj};

    %% .........................................................................Loop through session pairs

    for i_sesspair=1:size(Subjects.SessionPair,1)

        CurrSessPair = Subjects.SessionPair(i_sesspair,:);

        %% .....................................................................Loop through kernel size

        for i_kernel=1:size(Subjects.Kernel,2)

            CurrKernel = Subjects.Kernel{i_kernel};

            %% .................................................................Paths

            PathSamSrfKernelHalf1   = fullfile(Fld.SamSrfRoot, CurrSubj,  CurrSessPair{1}, CurrKernel);
            PathSamSrfKernelHalf2   = fullfile(Fld.SamSrfRoot, CurrSubj,  CurrSessPair{2}, CurrKernel);

            %% .................................................................Loop through map files

            for i_prffile = 1:size(Files.Prf,2)

                %% .............................................................Loop through hemispheres

                for i_hemi = 1:size(Para.Hemis, 2)

                    CurrHemi = Para.Hemis{i_hemi};

                    MapFileName = [CurrHemi '*' Files.Prf{i_prffile} '.mat'];

                    %% .........................................................Load map file for half 1

                    cd(PathSamSrfKernelHalf1)
                    MapFileInfoHalf1 = dir(MapFileName);
                    MapFileNameHalf1 = MapFileInfoHalf1(1).name;
                    Map1             = load(MapFileNameHalf1);

                    %% .........................................................Load map file for half 2

                    cd(PathSamSrfKernelHalf2)
                    MapFileInfoHalf2 = dir(MapFileName);
                    MapFileNameHalf2 = MapFileInfoHalf2(1).name;
                    Map2             = load(MapFileNameHalf2);

                    %% .........................................................Cross-validate SNR of map 1

                    cd(PathSamSrfKernelHalf1)
                    ss_samsrf_crossvalsnr(Map1, Map2, MapFileNameHalf1);

                    %% .........................................................Cross-validate SNR of map 2

                    cd(PathSamSrfKernelHalf2)
                    ss_samsrf_crossvalsnr(Map2, Map1, MapFileNameHalf2);

                end

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