function [tempFeature] = eeg_Online_ExtractFeatures_Amplitude_Minimum_Value(Data, fs, passbandInterval)
 
% Feature calculation
[minValue, minLoc] = min(Data);
tempFeature = minValue;
      
end