function model = CLISLAB_BuildModel(trainFeatures,classifier)

% CLISLAB_BUILDMODEL Build a model based on the trainFeatures and using the
%   specified classifier
%   
%   MODEL=CLISLAB_BUILDMODEL(TRAINFEATURES,CLASSIFIER) returns a model with the
%   specified CLASSIFIER for the data in TRAINFEATURES
%   
%   
%   TRAINFEATURES has the following structure:
%       TRAINFEATURES.FEATURES [trialsXfeatures] the features for the model
%       TRAINFEATURES.FEATURESLABELS [featuresX3] the label of the features
%       TRAINFEATURES.CLASSLABELS [trialsX1] the class labels
%
%   CLASSIFIER is a string indicating the file name of the chosen
%   classifier
%
%   MODEL has the following structure:
%       MODEL.CLASSIFIER the classifier used for building the model
%       MODEL.FEATURESLABELS the labels of the used features
%       MODEL.MDL the model
%       MODEL.ACCURACY the estimated accuracy of the model between 0 and 1

features  = trainFeatures.features;
featuresLabels = trainFeatures.featuresLabels;
classLabels    = trainFeatures.classLabels;

% convert classifier from string to char
classifier = char(classifier);

% create the model structure
model = struct();
model.classifier = classifier;
model.featuresLabels = featuresLabels;

% create the model using the function in input
modelBuilder = eval(classifier);
[mdl, accuracy] = modelBuilder.classification(features, classLabels, featuresLabels);

model.mdl = mdl;
model.accuracy = accuracy;

% check if the accuracy of the model is significative (i.e. better than
% random)

significative = isSignificative(size(features,1), accuracy);
if significative
    fprintf('Model built with accuracy %g%% (p<%g)\n',accuracy, significative);
else
    warning('Model built with accuracy %g%% (BELOW CHANCE LEVEL)',accuracy);
end
end

function significative = isSignificative(n,accuracy)
% Müller-Putz, G., Scherer, R., Brunner, C., Leeb, R., & Pfurtscheller, G.
% (2008). Better than random: a closer look on BCI results. International
% Journal of Bioelectromagnetism, 10(EPFL-ARTICLE-164768), 52-55.

significative = 0;

p = 0.5;
alpha = [0.001 0.01 0.05]; % for 0.1%, 1%, 5%

for a = alpha
    chanceLevel = p+sqrt(p*(1-p)/(n+4))*norminv(1-a/2);
    chanceLevel = chanceLevel*100;
    if accuracy > chanceLevel
       significative = a;
       return
    end
end
end