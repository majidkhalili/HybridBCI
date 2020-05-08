function feature = CLISLAB_NIRS_Mean(indata)
% indata.od = channelXtimepointsXtrials
% feature.featuresLabels = string;
% feature.features = trialXfeatures

labels = "Mean";

signal = ["HbO" "HbR" "HbT"];
signal = signal(find(indata.source));
feature.featuresLabels = (labels + " - " + signal)';

numSignal = sum(indata.source);

data = indata.od;

% % OLD VERSION
% trainfeature=[];
% 
% for n = 1:size(rdata,3)
%     
%     trainfeature= [trainfeature; mean((squeeze(rdata(:,:,n)')))];
%     
% end

% NEW Version by Ale
m = mean(data,2);
m = squeeze(m);
feature.featuresLabels = repmat(feature.featuresLabels,size(m,1)/numSignal,1);
feature.featuresLabels = feature.featuresLabels(:);
feature.features = m';