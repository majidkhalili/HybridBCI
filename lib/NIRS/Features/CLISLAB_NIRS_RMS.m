function feature = CLISLAB_NIRS_RMS(indata)
% indata.od = channelXtimepointsXtrials
% feature.featuresLabels = string;
% feature.features = trialXfeatures

labels = "RMS";

signal = ["HbO" "HbR" "HbT"];
signal = signal(find(indata.source));
feature.featuresLabels = (labels + " - " + signal)';

numSignal = sum(indata.source);

data = indata.od;

% % Old Version
% trainfeature=[];
% 
% for n = 1:size(data,3)
%     
%     trainfeature= [trainfeature; rms(squeeze(data(:,:,n)'))];
%     
% end

% New version by Ale
r = rms(data,2);
r = squeeze(r);
feature.featuresLabels = repmat(feature.featuresLabels,size(r,1)/numSignal,1);
feature.featuresLabels = feature.featuresLabels(:);
feature.features = r';

