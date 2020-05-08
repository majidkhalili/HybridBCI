function [pred, prob, acc] = CLISLAB_PredictLabel(model,dataFeatures,classLabels)

% CLISLAB_PREDICTLABEL Predict the class of a set of data using a model built with
%   CLISLAB_BuildModel function
%   
%   PRED=PREDICTLABEL(MODEL,DATAFEATURES) returns the predicted label for DATA. 
%   
%   [PRED,PROB]=PREDICTLABEL(MODEL,DATAFEATURES) returns the predicted label and his
%   probability
%   
%   [PRED,PROB,ACC]=PREDICTLABEL(MODEL,DATAFEATURES,CLASSLABELS) returns the
%   predicted labels, their probability, and the overall accuracy of the
%   prediction
%
%   MODEL is a model built with function BUILDMODEL
%
%   DATAFEATURES [trailsXfeatures] are the data to be predicted
%
%   CLASSLABELS the label of the class of the data. If it is missing no
%   accuracy can be returned
%
%   PRED the class label (or array of labels) of the prediction
%
%   PROB the probability (or array of probabilities) of the prediction
%
%   ACC the overall accuracy. Can be returned only if CLASSLABELS is a
%   input

classifier = eval(model.classifier);
[pred,prob] = classifier.prediction(model.mdl,dataFeatures);

if nargout == 3 && nargin < 3
    warning('No class labels: accuracy can not be calculated');
    acc = [];
elseif nargout == 3 && nargin == 3
    numTrials = length(classLabels);
    if numTrials ~= length(pred)
        warning('Wrong number of class labels: accuracy can not be calculated');
        acc = [];
        return
    end
    numCorrect = length(find(classLabels==pred.'));
    acc = 100*numCorrect/numTrials;
end