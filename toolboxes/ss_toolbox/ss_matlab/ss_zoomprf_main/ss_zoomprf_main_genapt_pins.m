function [StimSeq, StimPos, Stim] = ss_zoomprf_main_genapt_pins(SeqIdx, SaveApFrm, Resize, FileName)
%
% Generates 4*4 piezo aperture. 1 px corresponds to 0.05 mm. Note that
% aperture is constructed so that 0 is not a number but a border.
%
% ------------------------------------------------------------------------------
% Input
% ------------------------------------------------------------------------------
% SeqIdx     - Idx specifying sequence of stimulus positions [double]
% SaveApFrm  - Toggles whether aperture should be saved or not [logical/double]
% Resize     - Toggles whether aperture should be resized [logical/double]
% FileName   - File name [char]
% ------------------------------------------------------------------------------
% Output
% ------------------------------------------------------------------------------
% StimSeq    - Sequence of stimulus positions     [double]
% StimPos    - Individual stimulus positions      [double]
% Stim       - Whole stimulus, that is, pin array [double]
% ------------------------------------------------------------------------------
% 22/11/2021: Generated (SS)
% 16/07/2023: Last modified (SS)
% ------------------------------------------------------------------------------
%%% Dimensions/calculations:
% --> Outermost pin edge to outermost pin edge: 8.5 mm
% --> 1 pixel should correspond to 0.05 mm    : 8.5 mm / 0.05 mm = 170 pixel

%% .............................................................................Some defaults

if nargin < 1
    SeqIdx = [8 7 6 5 4 3 2 1 5 6 7 8 1 2 3 4 ones(1,14)*9];
    SaveApFrm = false;
    Resize = false;
    FileName = 'Aperture';
end

%% .............................................................................Dimensions

Pxl2mm          = 0.05; % 1 pxl = 0.05 mm
PinDiameter     = 1;    % 1mm
PinEdge2PinEdge = 1.5;  % 1.5mm
%%% Note: PinEdge2PinEdge refers to inner edges of 2 neighboring pins.
PinDiameter     = PinDiameter/Pxl2mm;
PinEdge2PinEdge = PinEdge2PinEdge/Pxl2mm;
AspectRatio     = 1.9; % 1.8
%%% Note: Needs to be 1.9 so that we indeed end up with a diameter of 20 pixels.
Alpha           = 1;

%% .............................................................................Generate disk

Disk = ss_img_oval(PinDiameter, PinDiameter, [AspectRatio  AspectRatio], Alpha);
Disk = Disk(:,:,1)./255;

%% .............................................................................Generate gap

Gap  = zeros(size(Disk,1),PinEdge2PinEdge);

%% .............................................................................Generate real and fake stimulus row

StimRow = [Disk, Gap, Disk, Gap, Disk, Gap, Disk];
FakeStimRow = zeros(size(StimRow));

%% .............................................................................Generate gap row

GapRow  = zeros(PinEdge2PinEdge, size(StimRow,2));

%% .............................................................................Generate whole stimulus

Stim = [StimRow; GapRow; StimRow; GapRow; StimRow; GapRow; StimRow];

%% .............................................................................Generate stimulus positions

StimPos = nan([size(Stim), 9]);

StimPos(:,:,1) = [StimRow; GapRow; FakeStimRow; GapRow; FakeStimRow; GapRow; FakeStimRow];
StimPos(:,:,2) = [FakeStimRow; GapRow; StimRow; GapRow; FakeStimRow; GapRow; FakeStimRow];
StimPos(:,:,3) = flipud(StimPos(:,:,2));
StimPos(:,:,4) = flipud(StimPos(:,:,1));

StimPos(:,:,5) = rot90(StimPos(:,:,1));
StimPos(:,:,6) = rot90(StimPos(:,:,2));
StimPos(:,:,7) = rot90(StimPos(:,:,3));
StimPos(:,:,8) = rot90(StimPos(:,:,4));
StimPos(:,:,9) = zeros(size(Stim));

%% .............................................................................Generate stimulus sequence

StimSeq = StimPos(:,:,SeqIdx);

%% .............................................................................Fliplr

StimSeq = fliplr(StimSeq); 
%%% Note: The experiment has been programmed so that the movement direction of
%%% the pin bar or pin columns reflects the perceived direction in the scanner
%%% (so when looking from above through the fingernail). For modeling and
%%% interpratation of the results, it seems, however, easier to turn around the 
%%% hand. This is why we flip the left and right direction here. 

%% .............................................................................Resize aperture

if Resize
    ApFrm = imresize(StimSeq, [100 100]);
else
    ApFrm = StimSeq;
end

%% .............................................................................Save aperture frames

if SaveApFrm
    if Resize
        save([FileName 'Res'], 'ApFrm');
    else
        save(FileName, 'ApFrm');
    end
end

end