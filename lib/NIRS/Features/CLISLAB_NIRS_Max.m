function feature = CLISLAB_NIRS_Max(indata)
% indata.od = channelXtimepointsXtrials
% feature.featuresLabels = string;
% feature.features = trialXfeatures

labels = "Max";

signal = ["HbO" "HbR" "HbT"];
signal = signal(find(indata.source));
feature.featuresLabels = (labels + " - " + signal)';

numSignal = sum(indata.source);

data = indata.od;

% % Old version
% trainfeature=[];
% 
% for n = 1:size(data,3)
%     
%     trainfeature= [trainfeature; max(squeeze(data(:,:,n)'))];
%     
% end

% New version by Ale
m = max(data,[],2);
m = squeeze(m);
feature.featuresLabels = repmat(feature.featuresLabels,size(m,1)/numSignal,1);
feature.featuresLabels(:);
feature.features = m';
