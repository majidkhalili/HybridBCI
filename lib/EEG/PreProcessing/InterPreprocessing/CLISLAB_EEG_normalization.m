function [eeg_thinking, eeg_baseline, eog_thinking, eog_baseline, emg_thinking, emg_baseline] = normalization(eeg_thinking, eeg_baseline, eog_thinking, eog_baseline, emg_thinking, emg_baseline,selectSource)
%% Normalizing EEG
for k=1:size(eeg_thinking.wideband,1)
    % Modified AJG 2.08.2019
%     eeg_thinking.wideband(k,:,:)   =   squeeze(eeg_thinking.wideband(k,:,:)) - mean(squeeze(eeg_thinking.wideband(k,:,:)),1);
%     eeg_thinking.delta(k,:,:)      =   squeeze(eeg_thinking.delta(k,:,:)) - mean(squeeze(eeg_thinking.delta(k,:,:)),1);
%     eeg_thinking.theta(k,:,:)      =   squeeze(eeg_thinking.theta(k,:,:)) - mean(squeeze(eeg_thinking.theta(k,:,:)),1);
%     eeg_thinking.alpha(k,:,:)      =   squeeze(eeg_thinking.alpha(k,:,:)) - mean(squeeze(eeg_thinking.alpha(k,:,:)),1);
%     eeg_thinking.beta(k,:,:)       =   squeeze(eeg_thinking.beta(k,:,:)) - mean(squeeze(eeg_thinking.beta(k,:,:)),1);

    eeg_thinking.wideband(k,:,:) = squeeze(eeg_thinking.wideband(k,:,:)) - squeeze(mean(eeg_thinking.wideband(k,:,:),2))';
    eeg_thinking.delta(k,:,:) = squeeze(eeg_thinking.delta(k,:,:)) - squeeze(mean(eeg_thinking.delta(k,:,:),2))';
    eeg_thinking.theta(k,:,:) = squeeze(eeg_thinking.theta(k,:,:)) - squeeze(mean(eeg_thinking.theta(k,:,:),2))';
    eeg_thinking.alpha(k,:,:) = squeeze(eeg_thinking.alpha(k,:,:)) - squeeze(mean(eeg_thinking.alpha(k,:,:),2))';
    eeg_thinking.beta(k,:,:) = squeeze(eeg_thinking.beta(k,:,:)) - squeeze(mean(eeg_thinking.beta(k,:,:),2))';

        % Modified AJG 2.08.2019
%     eeg_baseline.wideband(k,:,:)   =   squeeze(eeg_baseline.wideband(k,:,:)) - mean(squeeze(eeg_baseline.wideband(k,:,:)),1);
%     eeg_baseline.delta(k,:,:)      =   squeeze(eeg_baseline.delta(k,:,:)) - mean(squeeze(eeg_baseline.delta(k,:,:)),1);
%     eeg_baseline.theta(k,:,:)      =   squeeze(eeg_baseline.theta(k,:,:)) - mean(squeeze(eeg_baseline.theta(k,:,:)),1);
%     eeg_baseline.alpha(k,:,:)      =   squeeze(eeg_baseline.alpha(k,:,:)) - mean(squeeze(eeg_baseline.alpha(k,:,:)),1);
%     eeg_baseline.beta(k,:,:)      =   squeeze(eeg_baseline.beta(k,:,:)) - mean(squeeze(eeg_baseline.beta(k,:,:)),1);

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
 
%     eog_thinking.filtered(k,:,:)   =   squeeze(eog_thinking.filtered(k,:,:)) - mean(squeeze(eog_thinking.filtered(k,:,:)),1);
%     eog_baseline.filtered(k,:,:)   =   squeeze(eog_baseline.filtered(k,:,:)) - mean(squeeze(eog_baseline.filtered(k,:,:)),1);
end

%Normalizing EMG
for k=1:size(emg_thinking.filtered,1)
        % Modified AJG 2.08.2019
     emg_thinking.filtered(k,:,:)   =   squeeze(emg_thinking.filtered(k,:,:)) - squeeze(mean(emg_thinking.filtered(k,:,:),2))';
     emg_baseline.filtered(k,:,:)   =   squeeze(emg_baseline.filtered(k,:,:)) - squeeze(mean(emg_baseline.filtered(k,:,:),2))';
       
%     emg_thinking.filtered(k,:,:)   =   squeeze(emg_thinking.filtered(k,:,:)) - mean(squeeze(emg_thinking.filtered(k,:,:)),1);
%     emg_baseline.filtered(k,:,:)   =   squeeze(emg_baseline.filtered(k,:,:)) - mean(squeeze(emg_baseline.filtered(k,:,:)),1);
end

end
