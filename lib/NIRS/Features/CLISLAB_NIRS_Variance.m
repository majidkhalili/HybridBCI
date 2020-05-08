function feature = CLISLAB_NIRS_Variance(indata)
% indata.od = channelXtimepointsXtrials
% feature.featuresLabels = string;
% feature.features = trialXfeatures

labels = "Variance";

signal = ["HbO" "HbR" "HbT"];
signal = signal(find(indata.source));
feature.featuresLabels = (labels + " - " + signal)';

numSignal = sum(indata.source);

data = indata.od;

%    using variance values of each channel as feature
% % Old version
% trainfeature=[];
% 
% for n = 1:size(data,3)
%     
%     trainfeature= [trainfeature; var(squeeze(data(:,:,n)'))];
%     
% end
% feature = trainfeature;

% New version by Ale

v = var(data,0,2);
v = squeeze(v);
feature.featuresLabels = repmat(feature.featuresLabels,size(v,1)/numSignal,1);
feature.featuresLabels = feature.featuresLabels(:);
feature.features = v';