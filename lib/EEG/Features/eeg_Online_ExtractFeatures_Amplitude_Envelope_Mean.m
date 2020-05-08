function [tempFeature] = eeg_Online_ExtractFeatures_Amplitude_Envelope_Mean(Data, fs, passbandInterval)

Data(isnan(Data)) = [];

% Feature obtention
envelop = abs(hilbert(Data));
tempFeature = nanmean(envelop);

end