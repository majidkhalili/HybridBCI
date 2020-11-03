function [tempFeature] = eeg_Online_ExtractFeatures_Amplitude_Area_under_Curve(Data, fs, passbandInterval)
% EEG_ONLINE_EXTRACTFEATURES_AMPLITUDE_AREA_UNDER_CURVE Calculates are by numerical integration.
% INPUTS:
%   Data              : Channels X Timepoints X Trials; Separated for eeg, emg, eog
%   fs                : Sampling rate in Hz
%   passbandInterval  : Boundaries for the bandpass filters (Delta, Theta, Alpha, ...)
% OUTPUTS:
%   features  : Value of the correspondant feature.

% Feature calculation
tempFeature = trapz(Data);
      
end
