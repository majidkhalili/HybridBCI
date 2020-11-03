function [tempFeature] = eeg_Online_ExtractFeatures_Amplitude_Maximum_Value(Data, fs, passbandInterval)
% EEG_ONLINE_EXTRACTFEATURES_AMPLITUDE_MAXIMUM_VALUE Calculates the maximum amplitude value of the signal
% INPUTS:
%   Data              : Channels X Timepoints X Trials; Separated for eeg, emg, eog
%   fs                : Sampling rate in Hz
%   passbandInterval  : Boundaries for the bandpass filters (Delta, Theta, Alpha, ...)
% OUTPUTS:
%   features  : Value of the correspondant feature.

%Feature calculation
[maxValue, maxLoc] = max(Data);
tempFeature = maxValue;
      
end
