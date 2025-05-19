function ss_samsrf_disptc_obsvsfit(M0, M1, VtxIdx, M0Label, M1Label, M0ValuesTitle, M1ValuesTitle, Units, SophFeatures)
%
% Plots best fitting time courses of a null model (M0) and an alternative
% model (M1) along wth the underlying observed time course for a given vertex.
%
% ------------------------------------------------------------------------------
% Inputs
% ------------------------------------------------------------------------------
% M0  - Structure for null model [structure]
%       .Srf   - SamSrf surface structure resulting from pRF fitting
%       .Model - SamSrf model structure resulting from pRF fitting
% M1  - Structure for alternative model [structure]
%       .Srf   - SamSrf surface structure resulting from pRF fitting
%       .Model - SamSrf model structure resulting from pRF fitting
% VtxIdx - Vertex index [double]
% M0Label - Label for m0 model [char]
% M1Label - Label for m1 model [char]
% M0ValuesTitle - Parameters that will be added to title for null model [cell]
% M1ValuesTitle - Parameters that will be added to title alternative model [cell]
% Units         - Units for x0, y0, and sigma [char]
% SophFeatures  - Toggles whether more sophisticated plot features including
%                 legend should be added (true) or not (false) [logical]
%                 --> Note that for an array of plots, it might be desirable to
%                 drop individual legends and a global legend.
% ------------------------------------------------------------------------------
% Outputs
% ------------------------------------------------------------------------------
% -/-
% ------------------------------------------------------------------------------
% 17/08/2023: Generated (SS)
% 04/02/2025: Last modified (SS)

%% .............................................................................Some defaults

if nargin < 9
    SophFeatures = false;
end

%% .............................................................................Define colors

CMap = ss_crameri_cmap('batlow', false);
Steps = 6;
IdxCMap = 1:round(size(CMap,1)/Steps):size(CMap,1);
Colors = CMap([IdxCMap(1), IdxCMap(Steps-1)],:);

%% .............................................................................Expand surfaces

M0.Srf = samsrf_expand_srf(M0.Srf);
M1.Srf = samsrf_expand_srf(M1.Srf);

%% .............................................................................Get observed time course

Y0 = M0.Srf.Y(:,VtxIdx);
Y1 = M1.Srf.Y(:,VtxIdx);

%% .............................................................................Check that observed time courses are equal

if ~isequal(Y0, Y1)
    error('Fitted time courses are not equal.')
end

%% .............................................................................Get fitted time courses (final fits)

X0 = M0.Srf.X(:,VtxIdx);
X1 = M1.Srf.X(:,VtxIdx);

%% .............................................................................Convolve fitted time courses with HRF if need be

if isfield(M0.Model, 'Hrf') && ~M0.Model.Coarse_Fit_Only
    X0 = prf_convolve_hrf(X0, M0.Model.Hrf, M0.Model.Downsample_Predictions);
end

if isfield(M1.Model, 'Hrf') && ~M1.Model.Coarse_Fit_Only
    X1 = prf_convolve_hrf(X1, M1.Model.Hrf, M1.Model.Downsample_Predictions);
end

%% .............................................................................Get data (fitted parameters)

Data0 = M0.Srf.Data(:,VtxIdx);
Data1 = M1.Srf.Data(:,VtxIdx);

%% .............................................................................Scale fitted time courses using beta and baseline estimates

IdxBeta0 = strcmp(M0.Srf.Values,'Beta');
IdxBaseline0 = strcmp(M0.Srf.Values,'Baseline');
X0 = X0 * Data0(IdxBeta0) + Data0(IdxBaseline0);

IdxBeta1 = strcmp(M1.Srf.Values,'Beta');
IdxBaseline1 = strcmp(M1.Srf.Values,'Baseline');
X1 = X1 * Data1(IdxBeta1) + Data1(IdxBaseline1);

X = [X0, X1];

%% .............................................................................Check if TRs are equal

if ~isequal(M0.Model.TR, M1.Model.TR)
    error('TRs are unequal.')
end

%% .............................................................................Get TR

TR = M0.Model.TR;

%% .............................................................................Check if downsampling is equal

if ~isequal(M0.Model.Downsample_Predictions, M1.Model.Downsample_Predictions)
    error('Downsampling is not equal.')
end

%% .............................................................................Plot observed time course

plot((1:length(Y0))*TR*M0.Model.Downsample_Predictions, Y0, 'color', ...
    [0.5 0.5 0.5 0.5], 'linewidth', 2, 'Marker', '.', ...
    'MarkerFaceColor',[0, 0, 0], 'MarkerEdgeColor',  [0 0 0]);
hold on

%% .............................................................................Plot fitted time courses (first m0 then m1, see above)

for i_x=1:size(X,2)
    CurrX = X(:,i_x);
    CurrCol = Colors(i_x,:);
    plot((1:M0.Model.Downsample_Predictions:length(CurrX))*TR, CurrX, 'linewidth',...
        2, 'color', [CurrCol 1]);
end

%% .............................................................................Add axis limits, grid, and axis labels

xlim([1 length(Y0)]*TR);
grid on

if  SophFeatures
    xlabel('time (s)');
    ylabel('response (z)');
end

%% .............................................................................Add 0 line and legend

line(xlim, [0 0], 'color', [0 0 0], 'linewidth', 1, 'linestyle', ':');
legend({'observed' [M0Label ' fit'] [M1Label ' fit']}, ...
    'Location','northeast', 'NumColumns',3);

%% .............................................................................Put togther title for m0

Title0 = [M0Label ': '];
IdxValuesTitle0 = find(ismember(M0.Srf.Values, M0ValuesTitle))';

if isempty(IdxValuesTitle0)
    Title0 = [Title0 'none'];
else
    for i_t0 = IdxValuesTitle0
        CurrValue0 = M0.Srf.Values{i_t0};
        CurrTitle0 = [CurrValue0 ' = ' num2str(round(Data0(i_t0),2))];
        if ismember(CurrValue0, {'x0', 'y0', 'Sigma'})
            CurrTitle0 = [CurrTitlle0 ' ' Units];
        end
        if i_t0 ~= IdxValuesTitle0(1,end)
            CurrTitle0 = [CurrTitle0 '{|}'];
        end
        Title0 = [Title0 CurrTitle0];
    end
    Title0     = strrep(Title0 , 'x0', '{\itx_{0}}');
    Title0     = strrep(Title0  , 'y0', '{\ity_{0}}');
    Title0     = strrep(Title0 , 'Sigma', '{\it\sigma}');
    Title0     = strrep(Title0 , 'diff-cR^2', '{\it{diff-cR^2}}');
    Title0     = strrep(Title0 , 'cR^2', '{\itcR^2}');
end

%% .............................................................................Put togther title for m1

Title1 = [M1Label ': '];
IdxValuesTitle1 = find(ismember(M1.Srf.Values, M1ValuesTitle))';

if isempty(IdxValuesTitle1)
    Title1 = [Title1 'none'];
else
    for i_t1 = IdxValuesTitle1
        CurrValue1 = M1.Srf.Values{i_t1};
        CurrTitle1 = [CurrValue1 ' = ' num2str(round(Data1(i_t1),2))];
        if ismember(CurrValue1, {'x0', 'y0', 'Sigma'})
            CurrTitle1 = [CurrTitle1 ' ' Units];
        end
        if i_t1 ~= IdxValuesTitle1(1,end)
            CurrTitle1 = [CurrTitle1 ' {|} '];
        end
        Title1 = [Title1 CurrTitle1];
    end
    Title1     = strrep(Title1 , 'x0', '{\itx_{0}}');
    Title1     = strrep(Title1  , 'y0', '{\ity_{0}}');
    Title1     = strrep(Title1 , 'Sigma', '{\it\sigma}');
    Title1     = strrep(Title1 , 'diff-cR^2', '{\it{diff-cR^2}}');
    Title1     = strrep(Title1 , 'cR^2', '{\itcR^2}');
end

%% .............................................................................Add title

title({Title0; Title1},  'FontSize', 13);

%% .............................................................................Add vertex index as text

text(0.01,0.01, ['vertex: ' num2str(VtxIdx)], ...
    'units', 'normalized', ...
    'horizontalalignment','left', ...
    'verticalalignment', 'bottom', 'FontSize', 13);

end