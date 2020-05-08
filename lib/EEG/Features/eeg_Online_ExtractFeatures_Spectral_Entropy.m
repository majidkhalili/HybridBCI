function [tempFeature] = eeg_Online_ExtractFeatures_Spectral_Entropy(Data, fs, passbandInterval)

% % Conversion factor to obtain microVolts
% Data = 0.0488281 * Data;

% Parameters for Spectral Calculation
% timeLength      =   size(Data,2)/fs;
windowLength	=   round(size(Data,2)/2); %Half the length of the time
overlapping      =   round(size(Data,2)/4); %50% overlapping, half the length of the windows
padding         =   5000;

% Welch’s power spectral density estimate
[spectrumWelch, freqVector] = pwelch(Data, hamming(windowLength), overlapping, padding, fs);

% Segmenting the Spectra to the specified Passband (by passbandInterval)
lowerPassbandLimit = find(freqVector==passbandInterval(1,1));
upperPassbandLimit = find(freqVector==passbandInterval(1,2));
segmentFreqVector  = freqVector(lowerPassbandLimit:upperPassbandLimit);
segmentSpectrumWelch  = spectrumWelch(lowerPassbandLimit:upperPassbandLimit);

% Calculating Spectral Entropy (= Shannon entropy on normalised PSD)
temp1=segmentSpectrumWelch./sum(segmentSpectrumWelch);
tempFeature = -sum(temp1.*log(temp1))/log(length(segmentSpectrumWelch));

end