function [tempFeature] = eeg_Online_ExtractFeatures_Amplitude_Envelope_Mean(Data, fs, passbandInterval)
% EEG_ONLINE_EXTRACTFEATURES_AMPLITUDE_ENVELOPE_MEAN Calculates the mean value of the envelope of the signal.
% INPUTS:
%   Data              : Channels X Timepoints X Trials; Separated for eeg, emg, eog
%   fs                : Sampling rate in Hz
%   passbandInterval  : Boundaries for the bandpass filters (Delta, Theta, Alpha, ...)
% OUTPUTS:
%   features  : Value of the correspondant feature.

Data(isnan(Data)) = [];

% Feature obtention
envelop = abs(hilbert(Data));
tempFeature = nanmean(envelop);

end
