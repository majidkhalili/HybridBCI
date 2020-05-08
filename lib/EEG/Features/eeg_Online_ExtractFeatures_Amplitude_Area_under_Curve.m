function [tempFeature] = eeg_Online_ExtractFeatures_Amplitude_Area_under_Curve(Data, fs, passbandInterval)

% Feature calculation
tempFeature = trapz(Data);
      
end