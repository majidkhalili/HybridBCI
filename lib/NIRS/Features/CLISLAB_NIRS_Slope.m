function feature = CLISLAB_NIRS_Slope(indata)
% indata.od = channelXtimepointsXtrials
% feature.featuresLabels = string;
% feature.features = trialXfeatures

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