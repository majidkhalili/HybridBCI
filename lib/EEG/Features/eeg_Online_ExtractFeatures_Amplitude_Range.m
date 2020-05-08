function [tempFeature] = eeg_Online_ExtractFeatures_Amplitude_Range(Data, fs, passbandInterval)
 
% Feature calculation
[maxValue,~] = max(Data, [],2);
[minValue,~] = min(Data, [],2);
tempFeature = maxValue-minValue;
      
end