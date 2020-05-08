function feature = CLISLAB_NIRS_Kurtosis(indata)
% indata.od = channelXtimepointsXtrials
% feature.featuresLabels = string;
% feature.features = trialXfeaturesname = 'kurtosis';

labels = "Kurtosis";

signal = ["HbO" "HbR" "HbT"];
signal = signal(find(indata.source));
feature.featuresLabels = (labels + " - " + signal)';

numSignal = sum(indata.source);

data = indata.od;

%    using kurtosis values of each channel as feature

% % Old Version
% trainfeature=[];
% 
% for n = 1:size(data,3)
%     
%     trainfeature= [trainfeature; kurtosis(squeeze(data(:,:,n)'))];
%     
% end

% New Version by Ale
k = kurtosis(data,1,2);
k = squeeze(k);
feature.featuresLabels = repmat(feature.featuresLabels,size(k,1)/numSignal,1);
feature.featuresLabels = feature.featuresLabels(:);
feature.features = k';