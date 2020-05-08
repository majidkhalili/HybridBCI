function [tempFeature] = eeg_Online_ExtractFeatures_Amplitude_Standard_Deviation(Data, fs, passbandInterval)
 
% Feature calculation
tempFeature = nanstd(Data);
      
end