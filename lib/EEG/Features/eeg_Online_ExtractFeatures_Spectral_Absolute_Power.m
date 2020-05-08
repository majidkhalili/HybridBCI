function [tempFeature] = eeg_Online_ExtractFeatures_Spectral_Absolute_Power(Data, fs, passbandInterval)

% Parameters for Calculating the Welch Spectral Density
% timeLength      =   size(Data,2)/fs;
windowLength	=   round(size(Data,2)/2); % Half the length of the time
overlapping     =   round(size(Data,2)/4); % 50% overlapping, half the length of the windows
padding         =   5000;

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