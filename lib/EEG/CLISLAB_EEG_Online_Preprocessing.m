function [preprocessedBaselineData,preprocessedThinkingData] = CLISLAB_EEG_Online_Preprocessing(baselineData, thinkingData, channelsLabels, fs, filter_type, interprocess, selectSource, frequencyBands)
% CLISLAB_EEG_ONLINE_PREPROCESSING Calls to the correspondant EEG preprocessing functions.
% INPUTS:
%   baselineData    :   Cell array containing the baseline data. [Channels X Timepoints X Trials].
%   thinkingData    :   Struct with the thinking data. The struct is divided in 3 structs: EEG, EMG and EOG. Some of these structs 
%                       could not appear depending on user selection.
%   channelsLabels  :   Cell array containing the channel labels.
%   fs              :   Sampling rate value.
%   filter_type     :   String with the name of the filter to be applied. Selected by user.
%   interprocess    :   Cell array containing the name of the processing functions to be applied. Selected by user.
%   selectSource    :   Logical array with the selected sources. [EEG EOG EMG].
%   frequencyBands  :   Struct with band's boundaries and a logical which indicates if the band has been selected by the user or not.
%
% OUTPUTS:
%   preprocessedBaselineData : Struct containing the processed baseline data. The struct is divided in 3 structs: EEG, EMG and EOG. Some of these structs 
%                              could not appear depending on user selection.
%   preprocessedThinkingData : Struct containing the processed thinking data. The struct is divided in 3 structs: EEG, EMG and EOG. Some of these structs 
%                              could not appear depending on user selection.

%% Conversion factor to obtain microVolts
% Added by AJG, 07.10.2019
% % +/- 410mV range in 24 bits resolution ADC on the Vamp
baselineData = 0.0488281 * baselineData;
thinkingData = 0.0488281 * thinkingData;

% changed by wu on 2019.05.14 change the funciton name (discard wu) 
%% Creating and Applying IIR Notch Filter to the raw signal
%Creating Notch Filter
% d = designfilt('bandstopiir','FilterOrder',2,'HalfPowerFrequency1',49,'HalfPowerFrequency2',51,'DesignMethod','butter','SampleRate',fs);
wo.notch = 50/(fs/2);  bw.notch = wo.notch/35;
[b.notch,a.notch] = iirnotch(wo.notch, bw.notch);

%Applying the Notch Filter to EEG, EOG and EMG (thinking and baseline)

% add by wu on 2019.05.14 check the dimension of feedback or training 
dimensionnumber=length(size(thinkingData));
if dimensionnumber==2
    thinkingData = (filtfilt(b.notch, a.notch, double(thinkingData')))';
    
    baselineData = (filtfilt(b.notch, a.notch, double(baselineData')))';
elseif dimensionnumber==3
    
for k=1:1:size(thinkingData,3)
    thinkingData(:,:,k) = (filtfilt(b.notch, a.notch, double(thinkingData(:,:,k)')))';
    
    baselineData(:,:,k) = (filtfilt(b.notch, a.notch, double(baselineData(:,:,k)')))';
end
end

all_baseline.raw = baselineData;
all_thinking.raw = thinkingData;

%% Separating blocks of eeg+eog, emg
nch=size(thinkingData,1);
nch_emg=0; nch_eeg=0; nch_eog=0;
eeg_thinking.raw=[]; eeg_baseline.raw=[];
eog_thinking.raw=[]; eog_baseline.raw=[];
emg_thinking.raw=[]; emg_baseline.raw=[];
% added by wu
emg_channels={};
eeg_channels={};
eog_channels={};

for i=1:nch
    chlabel = channelsLabels{i};
    % Modified by Ale
    % emg channels
    if contains(chlabel,'EM')
        nch_emg=nch_emg+1;
        emg_thinking.raw = cat(1,emg_thinking.raw,all_thinking.raw(i,:,:));
        emg_baseline.raw = cat(1,emg_baseline.raw,all_baseline.raw(i,:,:));
        %              emg_thinking.raw(nch_emg,:,:)=all_thinking.raw(i,:,:);
        %              emg_baseline.raw(nch_emg,:,:)=all_baseline.raw(i,:,:);
        emg_channels{nch_emg,1}=chlabel;
        % eog channels
    elseif contains(chlabel,'EO')
        nch_eog=nch_eog+1;
        eog_thinking.raw = cat(1,eog_thinking.raw,all_thinking.raw(i,:,:));
        eog_baseline.raw = cat(1,eog_baseline.raw,all_baseline.raw(i,:,:));
        %              eog_thinking.raw(nch_eog,:,:)=all_thinking.raw(i,:,:);
        %              eog_baseline.raw(nch_eog,:,:)=all_baseline.raw(i,:,:);
        eog_channels{nch_eog,1}=chlabel;
        % the rest, eeg channels
    else %EEG
        nch_eeg=nch_eeg+1;
        eeg_thinking.raw = cat(1,eeg_thinking.raw,all_thinking.raw(i,:,:));
        eeg_baseline.raw = cat(1,eeg_baseline.raw,all_baseline.raw(i,:,:));
        %              eeg_thinking.raw(nch_eeg,:,:)=all_thinking.raw(i,:,:);
        %              eeg_baseline.raw(nch_eeg,:,:)=all_baseline.raw(i,:,:);
        eeg_channels{nch_eeg,1}=chlabel;
        %          end
    end
end

%% Filtering eeg, eog and emg signals

[eeg_thinking, eeg_baseline, eog_thinking, eog_baseline, emg_thinking, emg_baseline] = feval(filter_type, eeg_thinking, eeg_baseline, eog_thinking, eog_baseline, emg_thinking, emg_baseline, frequencyBands, fs);

%% Cropping eeg, eog and emg signals
%corrected by wu
wn = 50; %lenght of a segment of datapoints to remove (after filtering) at the beginning and end of the data to avoid artifacts from filtering
if isempty(eeg_thinking.raw)
    eeg_thinking.wideband   =   [];
    eeg_thinking.delta      =   [];
    eeg_thinking.theta      =   [];
    eeg_thinking.alpha      =   [];
    eeg_thinking.beta       =   [];
else
    eeg_thinking.wideband   =   eeg_thinking.wideband(:, wn:end-wn, :);
    eeg_thinking.delta      =   eeg_thinking.delta(:, wn:end-wn, :);
    eeg_thinking.theta      =   eeg_thinking.theta(:, wn:end-wn, :);
    eeg_thinking.alpha      =   eeg_thinking.alpha(:, wn:end-wn, :);
    eeg_thinking.beta       =   eeg_thinking.beta(:, wn:end-wn,: );
end
if isempty(eeg_baseline.raw)
    eeg_baseline.wideband   =   [];
    eeg_baseline.delta      =   [];
    eeg_baseline.theta      =   [];
    eeg_baseline.alpha      =   [];
    eeg_baseline.beta       =   [];
else
    eeg_baseline.wideband   =   eeg_baseline.wideband(:, wn:end-wn, :);
    eeg_baseline.delta      =   eeg_baseline.delta(:, wn:end-wn, :);
    eeg_baseline.theta      =   eeg_baseline.theta(:, wn:end-wn, :);
    eeg_baseline.alpha      =   eeg_baseline.alpha(:, wn:end-wn, :);
    eeg_baseline.beta       =   eeg_baseline.beta(:, wn:end-wn,: );
end
% corrected by wu on 2019.05.14 from & to ||
if isempty(eog_thinking.raw)|| isempty(eog_baseline.raw)
    eog_thinking.filtered   =   [];
    eog_baseline.filtered   =   [];
else
    eog_thinking.filtered   =   eog_thinking.filtered(:, wn:end-wn, :);
    eog_baseline.filtered   =   eog_baseline.filtered(:, wn:end-wn, :);
end

if isempty(emg_thinking.raw) || isempty(emg_baseline.raw)
    emg_thinking.filtered   =   [];
    emg_baseline.filtered   =   [];
else
    emg_thinking.filtered   =   emg_thinking.filtered(:, wn:end-wn, :);
    emg_baseline.filtered   =   emg_baseline.filtered(:, wn:end-wn, :);
end

%% interprocess Functions
if ~isempty(interprocess)
    
    for k=1:length(interprocess)  %Common Average Reference
        [eeg_thinking, eeg_baseline, eog_thinking, eog_baseline, emg_thinking, emg_baseline] = feval(char(interprocess{k}),eeg_thinking, eeg_baseline, eog_thinking, eog_baseline, emg_thinking, emg_baseline, selectSource);
    end
end

%% Storing desired Variables

preprocessedThinkingData.eeg = eeg_thinking;
preprocessedBaselineData.eeg = eeg_baseline;
preprocessedThinkingData.eeg.channels = eeg_channels;
preprocessedBaselineData.eeg.channels = eeg_channels;

preprocessedThinkingData.eog = eog_thinking;
preprocessedBaselineData.eog = eog_baseline;
preprocessedThinkingData.eog.channels = eog_channels;
preprocessedBaselineData.eog.channels = eog_channels;

preprocessedThinkingData.emg = emg_thinking;
preprocessedBaselineData.emg = emg_baseline;
preprocessedThinkingData.emg.channels = emg_channels;
preprocessedBaselineData.emg.channels = emg_channels;

%% Selecting the set of Source Signals (eeg, eog, emg)
%If the source is not desired, the code removes (with rmfield) the respective source

%Testing the existance of the logical input variable "selectSource"
if nargin<8
    selectSource=[1 1 1]; %[eeg eog emg]
end

%Evaluationg the logical vector "selectSource"
if selectSource(1) == 0
    %     if isfield(thinkingData, 'eeg')
    preprocessedThinkingData = rmfield(preprocessedThinkingData, 'eeg');
    preprocessedBaselineData=  rmfield(preprocessedBaselineData, 'eeg');
else
    if  isempty(preprocessedThinkingData.eeg.raw)
        preprocessedThinkingData = rmfield(preprocessedThinkingData, 'eeg');
    preprocessedBaselineData=  rmfield(preprocessedBaselineData, 'eeg');
    end
    %         thinkingData = rmfield(thinkingData, 'eeg');
    %     end
end
if selectSource(2) == 0
    %     if isfield(thinkingData, 'eog')
    %         thinkingData = rmfield(thinkingData, 'eog');
    %     end#
    preprocessedThinkingData = rmfield(preprocessedThinkingData, 'eog');
    preprocessedBaselineData=  rmfield(preprocessedBaselineData, 'eog');
    else
    if  isempty(preprocessedThinkingData.eog.raw)
        preprocessedThinkingData = rmfield(preprocessedThinkingData, 'eog');
    preprocessedBaselineData=  rmfield(preprocessedBaselineData, 'eog');
    end
end
if selectSource(3) == 0
    %     if isfield(thinkingData, 'emg')
    %         thinkingData = rmfield(thinkingData, 'emg');
    %     end
    preprocessedThinkingData = rmfield(preprocessedThinkingData, 'emg');
    preprocessedBaselineData=  rmfield(preprocessedBaselineData, 'emg');
    else
    if  isempty(preprocessedThinkingData.emg.raw)
        preprocessedThinkingData = rmfield(preprocessedThinkingData, 'emg');
    preprocessedBaselineData=  rmfield(preprocessedBaselineData, 'emg');
    end
end


%% For eeg, selecting the Pass-Bands
%If the pass-band filter is not desired, the code removes (with rmfield) the respective pass-band

%Evaluationg the logical vector "frequencyBands" [wideband delta theta alpha beta]
if isfield(preprocessedThinkingData,'eeg')
    if ~frequencyBands(1).used
        preprocessedBaselineData.eeg=rmfield(preprocessedBaselineData.eeg,'wideband');
        preprocessedThinkingData.eeg=rmfield(preprocessedThinkingData.eeg,'wideband');
    end
    if ~frequencyBands(2).used
        preprocessedBaselineData.eeg=rmfield(preprocessedBaselineData.eeg,'delta');
        preprocessedThinkingData.eeg=rmfield(preprocessedThinkingData.eeg,'delta');
    end
    if ~frequencyBands(3).used
        preprocessedBaselineData.eeg=rmfield(preprocessedBaselineData.eeg,'theta');
        preprocessedThinkingData.eeg=rmfield(preprocessedThinkingData.eeg,'theta');
    end
    if ~frequencyBands(4).used
        preprocessedBaselineData.eeg=rmfield(preprocessedBaselineData.eeg,'alpha');
        preprocessedThinkingData.eeg=rmfield(preprocessedThinkingData.eeg,'alpha');
    end
    if ~frequencyBands(5).used
        preprocessedBaselineData.eeg=rmfield(preprocessedBaselineData.eeg,'beta');
        preprocessedThinkingData.eeg=rmfield(preprocessedThinkingData.eeg,'beta');
    end
    
end

end
