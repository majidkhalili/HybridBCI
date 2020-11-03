function [tempFeature] = eeg_Online_ExtractFeatures_Amplitude_Mean_of_Absolute(Data, fs, passbandInterval)
% EEG_ONLINE_EXTRACTFEATURES_AMPLITUDE_MEAN_OF_ABSOLUTE Calculates the mean of the obsolute of the signal.
% INPUTS:
%   Data              : Channels X Timepoints X Trials; Separated for eeg, emg, eog
%   fs                : Sampling rate in Hz
%   passbandInterval  : Boundaries for the bandpass filters (Delta, Theta, Alpha, ...)
% OUTPUTS:
%   features  : Value of the correspondant feature.

% Feature calculation
tempFeature = mean(abs(Data));
      
end
