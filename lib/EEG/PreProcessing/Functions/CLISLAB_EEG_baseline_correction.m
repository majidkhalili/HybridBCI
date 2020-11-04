function [eeg_thinking, eeg_baseline, eog_thinking, eog_baseline, emg_thinking, emg_baseline] = baseline_correction(eeg_thinking, eeg_baseline, eog_thinking, eog_baseline, emg_thinking, emg_baseline,selectSource)
% CLISLAB_EEG_BASELINE_CORRECTION Calculates the baseline correction.
% INPUTS:
%   eeg_thinking    :   Struct with the EEG thinking data. [Channels X Timepoints X Trials].
%   eeg_baseline    :   Struct with the EEG baseline data. [Channels X Timepoints X Trials].
%   eog_thinking    :   Struct with the EOG thinking data. [Channels X Timepoints X Trials].
%   eog_baseline    :   Struct with the EOG baseline data. [Channels X Timepoints X Trials].
%   emg_thinking    :   Struct with the EMG thinking data. [Channels X Timepoints X Trials].
%   emg_baseline    :   Struct with the EMG baseline data. [Channels X Timepoints X Trials].
%   selectSource    :   Logical array with the selected sources. [EEG EOG EMG].
% OUTPUTS:
%   eeg_thinking    :   Struct with the filtered EEG thinking data divided in an array for raw data and an array for each selected band. 
%                       The amount of arrays would depend on user selection. Each arra has a shape as [Channels X Timepoints X Trials].
%   eeg_baseline    :   Struct with the filtered EEG baseline data divided in an array for raw data and an array for each selected band. 
%                       The amount of arrays would depend on user selection. Each arra has a shape as [Channels X Timepoints X Trials].
%   eog_thinking    :   Struct with the filtered EOG thinking data divided in an array for raw data and an array for each selected band. 
%                       The amount of arrays would depend on user selection. Each arra has a shape as [Channels X Timepoints X Trials].
%   eog_baseline    :   Struct with the filtered EOG baseline data divided in an array for raw data and an array for each selected band. 
%                       The amount of arrays would depend on user selection. Each arra has a shape as [Channels X Timepoints X Trials].
%   emg_thinking    :   Struct with the filtered EMG thinking data divided in an array for raw data and an array for each selected band. 
%                       The amount of arrays would depend on user selection. Each arra has a shape as [Channels X Timepoints X Trials].
%   emg_baseline    :   Struct with the filtered EMG baseline data divided in an array for raw data and an array for each selected band. 
%                       The amount of arrays would depend on user selection. Each arra has a shape as [Channels X Timepoints X Trials].%% Baseline Correction

for k=1:size(eeg_thinking.wideband,1)
    %Baseline correcting EEG
%     eeg_thinking.wideband(k,:,:) = squeeze(eeg_thinking.wideband(k,:,:)) - mean(squeeze(eeg_baseline.wideband(k,:,:)),1);
%     eeg_thinking.delta(k,:,:) = squeeze(eeg_thinking.delta(k,:,:)) - mean(squeeze(eeg_baseline.delta(k,:,:)),1);
%     eeg_thinking.theta(k,:,:) = squeeze(eeg_thinking.theta(k,:,:)) - mean(squeeze(eeg_baseline.theta(k,:,:)),1);
%     eeg_thinking.alpha(k,:,:) = squeeze(eeg_thinking.alpha(k,:,:)) - mean(squeeze(eeg_baseline.alpha(k,:,:)),1);
%     eeg_thinking.beta(k,:,:) = squeeze(eeg_thinking.beta(k,:,:)) - mean(squeeze(eeg_baseline.beta(k,:,:)),1);
%corrected by wu
    eeg_thinking.wideband(k,:,:) = squeeze(eeg_thinking.wideband(k,:,:)) - squeeze(mean(eeg_baseline.wideband(k,:,:),2))';
    eeg_thinking.delta(k,:,:) = squeeze(eeg_thinking.delta(k,:,:)) - squeeze(mean(eeg_baseline.delta(k,:,:),2))';
    eeg_thinking.theta(k,:,:) = squeeze(eeg_thinking.theta(k,:,:)) - squeeze(mean(eeg_baseline.theta(k,:,:),2))';
    eeg_thinking.alpha(k,:,:) = squeeze(eeg_thinking.alpha(k,:,:)) - squeeze(mean(eeg_baseline.alpha(k,:,:),2))';
    eeg_thinking.beta(k,:,:) = squeeze(eeg_thinking.beta(k,:,:)) - squeeze(mean(eeg_baseline.beta(k,:,:),2))';
end

%Baseline correcting EOG
for k=1:size(eog_thinking.filtered,1)
    %corrected by wu
eog_thinking.filtered(k,:,:) = squeeze(eog_thinking.filtered(k,:,:)) - squeeze(mean(eog_baseline.filtered(k,:,:),2))';
%     eog_thinking.filtered(k,:,:) = squeeze(eog_thinking.filtered(k,:,:)) - mean(squeeze(eog_baseline.filtered(k,:,:)),1);

end

%Baseline correcting EMG
for k=1:size(emg_thinking.filtered,1)
    %corrected by wu
emg_thinking.filtered(k,:,:) = squeeze(emg_thinking.filtered(k,:,:)) - squeeze(mean(emg_baseline.filtered(k,:,:),2))';
%     emg_thinking.filtered(k,:,:) = squeeze(emg_thinking.filtered(k,:,:)) - mean(squeeze(emg_baseline.filtered(k,:,:)),1);

end

end
