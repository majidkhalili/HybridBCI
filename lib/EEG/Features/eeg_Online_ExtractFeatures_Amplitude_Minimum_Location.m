function [tempFeature] = eeg_Online_ExtractFeatures_Amplitude_Minimum_Location(Data, fs, passbandInterval)
 
% Feature calculation
[minValue, minLoc] = min(Data);
tempFeature = minLoc/fs; % Converting the datapoint in time location

      
end