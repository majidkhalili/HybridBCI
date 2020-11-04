function [tempFeature] = eeg_Online_ExtractFeatures_Amplitude_Standard_Deviation(Data, fs, passbandInterval)
% EEG_ONLINE_EXTRACTFEATURES_AMPLITUDE_STANDARD_DEVIATION Calculates the standard deviation.
% INPUTS:
%   Data              : Channels X Timepoints X Trials; Separated for eeg, emg, eog
%   fs                : Sampling rate in Hz
%   passbandInterval  : Boundaries for the bandpass filters (Delta, Theta, Alpha, ...)
% OUTPUTS:
%   features  : Value of the correspondant feature.

% Feature calculation
tempFeature = nanstd(Data);
      
end
