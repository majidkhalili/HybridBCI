function feature = CLISLAB_NIRS_Slope(indata)
% CLISLAB_NIRS_SLOPE Fits the data using a 1st order polynomial.
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

labels = "Slope";

signal = ["HbO" "HbR" "HbT"];
signal = signal(find(indata.source));
feature.featuresLabels = (labels + " - " + signal)';

numSignal = sum(indata.source);

data = indata.od;

for i = 1:size(data,3)
    for j = 1:size(data,1)
    lineFitting = polyfit([1:size(data,2)], squeeze(data(j,:,i)),1);
    slope(j,i) = lineFitting(1);
    end
end

feature.featuresLabels = repmat(feature.featuresLabels,size(slope,1)/numSignal,1);
feature.featuresLabels = feature.featuresLabels(:);
feature.features = slope';

end
