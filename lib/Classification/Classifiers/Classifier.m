classdef Classifier < handle
   methods (Abstract)
       [classifier_model, classifier_accuracy] = classification(vargin);
       [classifier_predicted_label, classifier_probabilty] = prediction(model, features);
   end
    
end