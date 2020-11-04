function feature = CLISLAB_NIRS_Variance(indata)
% CLISLAB_NIRS_VARIANCE Calculates the expected value of the squared deviation from the mean.
% INPUTS:
%   indata  :   Struct with the signals from which extract the features. The struct is divided in 6 structs: HbO, HbR, HbT, od, fs and source. 
%               Some of these structs could not appear depending on user selection. 
%                 - HbO     : Struct with a shape as [Channels X Timepoints X Trials]. 
%                 - HbR     : Struct with a shape as [Channels X Timepoints X Trials]. 
%                 - HbT     : Struct with a shape as [Channels X Timepoints X Trials]. 
%                 - od      : Struct that contains the data after OxyDeoxy conversion with a shape as [(3 X Channels) X Timepoints X Trials].
%                 - fs      : Sampling rate value.
%                 - source  : Logical array with the selected sources. [HbO HbR HbT].
% OUTPUTS:
%   feature  : Struct with the value of the correspondant feature. The struct is divided in 2 structs: featureLabels and features.
%               - featureLabels : String array with the name of the feature and the correspondant source with a shape as [(3 X Channels)].
%               - features      : Array with the feature values with shape [Trials X (3 X Channels)].

labels = "Variance";

signal = ["HbO" "HbR" "HbT"];
signal = signal(find(indata.source));
feature.featuresLabels = (labels + " - " + signal)';

numSignal = sum(indata.source);

data = indata.od;

% New version by Ale

v = var(data,0,2);
v = squeeze(v);
feature.featuresLabels = repmat(feature.featuresLabels,size(v,1)/numSignal,1);
feature.featuresLabels = feature.featuresLabels(:);
feature.features = v';

end
