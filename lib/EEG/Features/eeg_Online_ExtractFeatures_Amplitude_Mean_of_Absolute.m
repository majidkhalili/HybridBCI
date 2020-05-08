function [tempFeature] = eeg_Online_ExtractFeatures_Amplitude_Mean_of_Absolute(Data, fs, passbandInterval)

% Feature calculation
tempFeature = mean(abs(Data));
      
end