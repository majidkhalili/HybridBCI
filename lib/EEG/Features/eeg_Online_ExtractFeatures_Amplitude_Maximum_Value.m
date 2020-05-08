function [tempFeature] = eeg_Online_ExtractFeatures_Amplitude_Maximum_Value(Data, fs, passbandInterval)
 
%Feature calculation
[maxValue, maxLoc] = max(Data);
tempFeature = maxValue;
      
end