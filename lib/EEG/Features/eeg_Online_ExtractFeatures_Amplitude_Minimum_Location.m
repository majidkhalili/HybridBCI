function [tempFeature] = eeg_Online_ExtractFeatures_Amplitude_Minimum_Location(Data, fs, passbandInterval)
% EEG_ONLINE_EXTRACTFEATURES_AMPLITUDE_MINIMUM_LOCATION Calculates the time instant of the minimum amplitude value.
% INPUTS:
%   Data              : Channels X Timepoints X Trials; Separated for eeg, emg, eog
%   fs                : Sampling rate in Hz
%   passbandInterval  : Boundaries for the bandpass filters (Delta, Theta, Alpha, ...)
% OUTPUTS:
%   features  : Value of the correspondant feature.

% Feature calculation
[minValue, minLoc] = min(Data);
tempFeature = minLoc/fs; % Converting the datapoint in time location

      
end
