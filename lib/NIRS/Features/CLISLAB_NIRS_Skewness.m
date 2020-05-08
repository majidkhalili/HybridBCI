function feature = CLISLAB_NIRS_Skewness(indata)
% indata.od = channelXtimepointsXtrials
% feature.featuresLabels = string;
% feature.features = trialXfeatures

labels = "Skewness";

signal = ["HbO" "HbR" "HbT"];
signal = signal(find(indata.source));
feature.featuresLabels = (labels + " - " + signal)';

numSignal = sum(indata.source);

data = indata.od;

%    using skewness   values of each channel as feature

% % Old version
% trainfeature=[];
% 
% for n = 1:size(data,3)
%     
%     trainfeature= [trainfeature; skewness(squeeze(data(:,:,n)'))];
%     
% end

s = skewness(data,1,2);
s = squeeze(s);
feature.featuresLabels = repmat(feature.featuresLabels,size(s,1)/numSignal,1);
feature.featuresLabels = feature.featuresLabels(:);
feature.features = s';