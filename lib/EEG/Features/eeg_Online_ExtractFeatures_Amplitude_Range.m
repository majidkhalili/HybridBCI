function [tempFeature] = eeg_Online_ExtractFeatures_Amplitude_Range(Data, fs, passbandInterval)
% EEG_ONLINE_EXTRACTFEATURES_AMPLITUDE_RANGE Calculates the range of the amplitude of the signal.
% INPUTS:
%   Data              : Channels X Timepoints X Trials; Separated for eeg, emg, eog
%   fs                : Sampling rate in Hz
%   passbandInterval  : Boundaries for the bandpass filters (Delta, Theta, Alpha, ...)
% OUTPUTS:
%   features  : Value of the correspondant feature.

% Feature calculation
[maxValue,~] = max(Data, [],2);
[minValue,~] = min(Data, [],2);
tempFeature = maxValue-minValue;
      
end
