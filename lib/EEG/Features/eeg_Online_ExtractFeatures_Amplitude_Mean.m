function [tempFeature] = eeg_Online_ExtractFeatures_Amplitude_Mean(Data, fs, passbandInterval)

% Feature calculation
tempFeature = mean(Data);
      
end