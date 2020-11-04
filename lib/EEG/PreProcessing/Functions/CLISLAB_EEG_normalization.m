function [eeg_thinking, eeg_baseline, eog_thinking, eog_baseline, emg_thinking, emg_baseline] = normalization(eeg_thinking, eeg_baseline, eog_thinking, eog_baseline, emg_thinking, emg_baseline,selectSource)
% CLISLAB_EEG_NORMALIZATION Calculates the normalization.
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
%                       The amount of arrays would depend on user selection. Each array has a shape as [Channels X Timepoints X Trials].
%   eeg_baseline    :   Struct with the filtered EEG baseline data divided in an array for raw data and an array for each selected band. 
%                       The amount of arrays would depend on user selection. Each array has a shape as [Channels X Timepoints X Trials].
%   eog_thinking    :   Struct with the filtered EOG thinking data divided in an array for raw data and an array for each selected band. 
%                       The amount of arrays would depend on user selection. Each array has a shape as [Channels X Timepoints X Trials].
%   eog_baseline    :   Struct with the filtered EOG baseline data divided in an array for raw data and an array for each selected band. 
%                       The amount of arrays would depend on user selection. Each array has a shape as [Channels X Timepoints X Trials].
%   emg_thinking    :   Struct with the filtered EMG thinking data divided in an array for raw data and an array for each selected band. 
%                       The amount of arrays would depend on user selection. Each array has a shape as [Channels X Timepoints X Trials].
%   emg_baseline    :   Struct with the filtered EMG baseline data divided in an array for raw data and an array for each selected band. 
%                       The amount of arrays would depend on user selection. Each array has a shape as [Channels X Timepoints X Trials].
for k=1:size(eeg_thinking.wideband,1)
    % Modified AJG 2.08.2019
    eeg_thinking.wideband(k,:,:) = squeeze(eeg_thinking.wideband(k,:,:)) - squeeze(mean(eeg_thinking.wideband(k,:,:),2))';
    eeg_thinking.delta(k,:,:) = squeeze(eeg_thinking.delta(k,:,:)) - squeeze(mean(eeg_thinking.delta(k,:,:),2))';
    eeg_thinking.theta(k,:,:) = squeeze(eeg_thinking.theta(k,:,:)) - squeeze(mean(eeg_thinking.theta(k,:,:),2))';
    eeg_thinking.alpha(k,:,:) = squeeze(eeg_thinking.alpha(k,:,:)) - squeeze(mean(eeg_thinking.alpha(k,:,:),2))';
    eeg_thinking.beta(k,:,:) = squeeze(eeg_thinking.beta(k,:,:)) - squeeze(mean(eeg_thinking.beta(k,:,:),2))';

    eeg_baseline.wideband(k,:,:) = squeeze(eeg_baseline.wideband(k,:,:)) - squeeze(mean(eeg_baseline.wideband(k,:,:),2))';
    eeg_baseline.delta(k,:,:) = squeeze(eeg_baseline.delta(k,:,:)) - squeeze(mean(eeg_baseline.delta(k,:,:),2))';
    eeg_baseline.theta(k,:,:) = squeeze(eeg_baseline.theta(k,:,:)) - squeeze(mean(eeg_baseline.theta(k,:,:),2))';
    eeg_baseline.alpha(k,:,:) = squeeze(eeg_baseline.alpha(k,:,:)) - squeeze(mean(eeg_baseline.alpha(k,:,:),2))';
    eeg_baseline.beta(k,:,:) = squeeze(eeg_baseline.beta(k,:,:)) - squeeze(mean(eeg_baseline.beta(k,:,:),2))';
end

%Normalizing EOG
for k=1:size(eog_thinking.filtered,1)
    % Modified AJG 2.08.2019
    eog_thinking.filtered(k,:,:)   =   squeeze(eog_thinking.filtered(k,:,:)) - squeeze(mean(eog_thinking.filtered(k,:,:),2))';
    eog_baseline.filtered(k,:,:)   =   squeeze(eog_baseline.filtered(k,:,:)) - squeeze(mean(eog_baseline.filtered(k,:,:),2))';
 
end

%Normalizing EMG
for k=1:size(emg_thinking.filtered,1)
        % Modified AJG 2.08.2019
     emg_thinking.filtered(k,:,:)   =   squeeze(emg_thinking.filtered(k,:,:)) - squeeze(mean(emg_thinking.filtered(k,:,:),2))';
     emg_baseline.filtered(k,:,:)   =   squeeze(emg_baseline.filtered(k,:,:)) - squeeze(mean(emg_baseline.filtered(k,:,:),2))';
       
end

end
