function [nirsFeatures, nirsFeaturesLabels]=CLISLAB_NIRS_Online_ExtractFeatures(data, fs, selectSource, featureList)
% CLISLAB_NIRS_ONLINE_EXTRACTFEATURES Calls to the correspondant NIRS feature functions.
% INPUTS:
%   data            :   Struct with the signals from which extract the features. The struct is divided in 3 structs: HbO, HbR and HbT. Some of these structs 
%                       could not appear depending on user selection.
%   fs              :   Sampling rate value.
%   selectSource    :   Logical array with the selected sources. [HbO HbR HbT].
%   featureList     :   Cell array with the names of the features selected by the user.
%
% OUTPUTS:
%   nirsFeatures        :   Array with the calculated values. [Trials X Features].
%   nirsFeaturesLabels  :   Array with the label of each row in 'nirsFeatures' (Feature name, band and channel).

HbO = selectSource(1);
HbR = selectSource(2);
HbT = selectSource(3);


OD = [];
if HbO
    OD = cat(1,OD,data.hbo);
end
if HbR
    OD = cat(1,OD,data.hbr);
end
if HbT
    OD = cat(1,OD,data.hbt);
end

data.od = OD;
data.fs = fs;
data.source = selectSource;

nirsFeatures = [];
nirsFeaturesLabels = [];
nirsIdxChLabels = [];
nirsFeatFunc = [];

featureList = unique(featureList(1,:));

for i = 1:length(featureList)
    featureFunction = str2func(featureList{i});
    feature = featureFunction(data);
    
    nirsFeatures = [nirsFeatures feature.features];
    nirsFeaturesLabels = [nirsFeaturesLabels; feature.featuresLabels];
    nirsIdxChLabels = [nirsIdxChLabels; (1:length(feature.featuresLabels))'];
    nirsFeatFunc = [nirsFeatFunc; repmat(featureList(i),length(feature.featuresLabels),1)];
end

nirsFeaturesLabels = [nirsFeatFunc nirsFeaturesLabels nirsIdxChLabels];

end
