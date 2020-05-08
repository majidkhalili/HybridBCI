function [tempFeature] = eeg_Online_ExtractFeatures_Amplitude_Envelope_Maximum(Data, fs, passbandInterval)

Data(isnan(Data)) = [];

% Feature obtention
envelop = abs(hilbert(Data));
[maxValue, maxLoc] = max(envelop);

tempFeature = maxValue;

end