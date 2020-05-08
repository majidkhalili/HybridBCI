function [tempFeature] = eeg_Online_ExtractFeatures_Amplitude_Maximum_Location(Data, fs, passbandInterval)

%Feature calculation
[maxValue, maxLoc] = max(Data);
tempFeature = maxLoc/fs; % Converting the datapoint in time location

      
end