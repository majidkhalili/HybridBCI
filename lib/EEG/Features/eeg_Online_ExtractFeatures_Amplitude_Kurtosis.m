function [tempFeature] = eeg_Online_ExtractFeatures_Amplitude_Kurtosis(Data, fs, passbandInterval)

% Feature calculation
tempFeature = kurtosis(Data);
      
end