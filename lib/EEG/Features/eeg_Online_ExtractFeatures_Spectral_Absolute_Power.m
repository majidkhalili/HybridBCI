function [tempFeature] = eeg_Online_ExtractFeatures_Spectral_Absolute_Power(Data, fs, passbandInterval)
% EEG_ONLINE_EXTRACTFEATURES_SPECTRAL_ABSOLUTE_POWER Calculates the area of Welch's spectral density of the signal.
% INPUTS:
%   Data              : Channels X Timepoints X Trials; Separated for eeg, emg, eog
%   fs                : Sampling rate in Hz
%   passbandInterval  : Boundaries for the bandpass filters (Delta, Theta, Alpha, ...)
% OUTPUTS:
%   tempFeature  : Value of the correspondant feature.

% Parameters for Calculating the Welch Spectral Density
windowLength      =   round(size(Data,2)/2); % Half the length of the time
overlapping       =   round(size(Data,2)/4); % 50% overlapping, half the length of the windows
padding           =   5000;

% Welch’s power spectral density estimate
[spectrumWelch, freqVector] = pwelch(Data, hamming(windowLength), overlapping, padding, fs);

% Segmenting the Spectra to the specified Passband (by passbandInterval)
lowerPassbandLimit = find(freqVector==passbandInterval(1,1));
upperPassbandLimit = find(freqVector==passbandInterval(1,2));
segmentFreqVector  = freqVector(lowerPassbandLimit:upperPassbandLimit);
segmentSpectrumWelch  = spectrumWelch(lowerPassbandLimit:upperPassbandLimit);

% Calculating the integral of the Spectra in the specified Passband (by passbandInterval)
tempFeature = trapz(segmentSpectrumWelch);
      
end
