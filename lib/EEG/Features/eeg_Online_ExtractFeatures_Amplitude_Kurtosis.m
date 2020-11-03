function [tempFeature] = eeg_Online_ExtractFeatures_Amplitude_Kurtosis(Data, fs, passbandInterval)
% EEG_ONLINE_EXTRACTFEATURES_AMPLITUDE_AMPLITUDE_KURTOSIS Calculates Kurtosis of the probability distribution
% INPUTS:
%   Data              : Channels X Timepoints X Trials; Separated for eeg, emg, eog
%   fs                : Sampling rate in Hz
%   passbandInterval  : Boundaries for the bandpass filters (Delta, Theta, Alpha, ...)
% OUTPUTS:
%   features  : Value of the correspondant feature.

% Feature calculation
tempFeature = kurtosis(Data);
      
end
