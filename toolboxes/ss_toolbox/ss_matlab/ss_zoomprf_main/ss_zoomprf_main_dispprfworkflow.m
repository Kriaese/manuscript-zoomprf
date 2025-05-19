function ss_zoomprf_main_dispprfworkflow(ApFrmImg, ApFrmVec, ApXY, TR, HrfType, Ext, Res, SDNoise, ApFrmImgIdx)
%
% Generates figures for pRF modeling workflow.
%
% ------------------------------------------------------------------------------
% Input
% ------------------------------------------------------------------------------
% ApFrmImg     - Aperture frames as images [double]
% ApFrmVec     - Aperture frames as a vector [double]
% ApXY         - X- and y- coordinates of stimulus space [double]
% TR           - Repetition time [double]
% HrfType      - Type of hemodynamic response [char]
% Ext          - File extension [char]
% Res          - Resolution of output file [double]
% SDNoise      - Standard deviation of the noise [double]
% ApFrmImgIdx  - Index for aperure frames [double]
% ------------------------------------------------------------------------------
% Output
% ------------------------------------------------------------------------------
% -/-
% ------------------------------------------------------------------------------
% 24/06/2023: Generated (SS)
% 06/01/2025: Last modified (SS)
% ------------------------------------------------------------------------------

%% .............................................................................Define some parameters

X0            = 0.5;
Y0            = 0.5;
Sigma         = 0.5;
SigmaFix      = 2;
SigmaNo       = 1;
ApWidth       = size(ApFrmImg,2);
ColorBorder   = 0.75;
NPixelBorder  = 5;
YLim          = [-3 3];
ScalingFactor = 4.25;

Parameters = {[X0, Y0, Sigma] [X0, Y0 SigmaFix] [X0, Y0]};
ModelField = {'Model2dg' 'Model2dgfix' 'Model2dgonoff'};
ModelType  = {'2dg' '2dg-fix' 'onoff'};

Downsampling = 1;
TimeCourseLabels = {'hrf', 'pred-conv', 'noise', 'obs', 'sim'};

%% .............................................................................Get hrf

if strcmp(HrfType, 'samsrfcan')
    Hrf = samsrf_hrf(TR);
elseif strcmp(HrfType, 'spmcan')
    Hrf = spm_hrf(TR);
end

%% .............................................................................Set up function handles

PrfFunction.Model2dg       = @(P,ApWidth) prf_gaussian_rf(P(1), P(2), P(3), ApWidth);
PrfFunction.Model2dgfix    = @(P,ApWidth) prf_gaussian_rf(P(1), P(2), P(3), ApWidth);
PrfFunction.Model2dgonoff  = @(P,ApWidth) double(prf_gaussian_rf(P(1), P(2), SigmaNo, ApWidth) > 0);

%% .............................................................................Loop through model type (2dg, 2dg-fix, and onoff model)

for i_modeltype=1:size(ModelType,2)

    CurrParas = Parameters{1, i_modeltype};
    CurrModelField = ModelField{i_modeltype};
    CurrModelType  = ModelType{i_modeltype};

    %% .........................................................................Create pRF image (aperture space: -1 to 1)

    ImgPrf = PrfFunction.(CurrModelField)(CurrParas, ApWidth);

    %% .........................................................................Add image border

    ImgPrfPad = padarray(ImgPrf , [NPixelBorder, NPixelBorder], ColorBorder , 'both');

    %% .........................................................................Show pRF image with border

    imshow(ImgPrfPad);

    %% .........................................................................Save pRF image with border

    ss_exportgraphics(['prf-' CurrModelType '.' Ext], gcf, Res);
    close all;

    %% .........................................................................Create pRF vector (stimulus space: -4.25 to 4.25)

    VecPrf = PrfFunction.(CurrModelField)(CurrParas.*ScalingFactor, ApXY);

    %% .........................................................................Predict neuronal response

    PredTimeCourse = prf_predict_timecourse(VecPrf, ApFrmVec);

    %% .........................................................................Convolve neuronal response with HRF

    ConvTimeCourse = repmat(prf_convolve_hrf(PredTimeCourse, Hrf, Downsampling), 1, 2);

    %% .........................................................................Generate noise

    NoiseTimeCourse = randn(size(ConvTimeCourse))*SDNoise;

    %% .........................................................................Generate observed time course and z-score it

    ObsTimeCourseZ = zscore(ConvTimeCourse(:,1) + NoiseTimeCourse(:,1));

    %% .........................................................................Generate simulated time course and z-score it

    SimTimeCourseZ = zscore(ConvTimeCourse(:,2) + NoiseTimeCourse(:,2));

    %% .........................................................................Now also z-score convolved time course without noise, noise time course, and hrf

    ConvTimeCourseZ = zscore(ConvTimeCourse);
    NoiseTimeCourseZ = zscore(NoiseTimeCourse);
    HrfZ = zscore(Hrf);

    %% .........................................................................Put time courses together

    TimeCourses = {HrfZ, ConvTimeCourseZ(:,1), NoiseTimeCourseZ(:,2), ...
        ObsTimeCourseZ, SimTimeCourseZ};

    %% .........................................................................Loop through time courses

    for i_tc=1:size(TimeCourses,2)

        %% .....................................................................Plot time courses

        CurrTimeCourse = TimeCourses{1,i_tc};
        CurrTimeCourseLabel = TimeCourseLabels{i_tc};
        plot((1:Downsampling:length(CurrTimeCourse))*TR, CurrTimeCourse,...
            'linewidth', 2, 'color', [0 0 0]);
        ylim(YLim)
        set(gca,'XTickLabel',[]);
        set(gca,'YTickLabel',[]);
        axis square;

        %% .....................................................................Save time courses

        ss_exportgraphics(['tc-' CurrTimeCourseLabel '_prf-' CurrModelType '.' Ext], gcf, Res);
        close all;

    end

end

%% .............................................................................Loop through aperture frames

for i_apfrmimg=ApFrmImgIdx

    %% .........................................................................Get image of aperture frame (aperture space: -1 to 1)

    CurrApFrmImg = ApFrmImg(:,:, i_apfrmimg);

    %% .........................................................................Add image border

    ApFrmImgPad= padarray(CurrApFrmImg, [NPixelBorder, NPixelBorder], ColorBorder , 'both');

    %% .........................................................................Show image of aperture frame

    imshow(ApFrmImgPad);

    %% .........................................................................Save image of aperturte frame with border

    ss_exportgraphics(['aptframe-' num2str(i_apfrmimg) '.' Ext], gcf, Res);
    close all;

end

end