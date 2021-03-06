classdef CL_MatlabKNN < Classifier
   
    methods
       function [classifier_model, classifier_accuracy] = classification(obj, varargin)
            features = varargin{1};
            labels = varargin{2};

            param_optimization = 'auto';
            param_opts = 1;

            disp('KNN Model is building...');
            h = helpdlg({'KNN Model is building...','Please wait...'},'Building model');

            % Build the SVM model
            if param_opts == 1
                mdl = fitcknn(features,labels,...
                    'OptimizeHyperparameters',param_optimization,...
                    'HyperparameterOptimizationOptions',struct('ShowPlots',false,'Verbose',0,'Repartition',false));
            else
                mdl = fitcknn(features,labels);
            end

            % Calculate crossvalidation accuracy
            CVMdl = crossval(mdl);
            kloss = kfoldLoss(CVMdl);
            accuracy = 100*(1 - kloss);

            fprintf('KNN Model is built. Estimated accuracy: %g\n', accuracy);
            close(h);

            classifier_model = mdl;
            classifier_accuracy = accuracy;
       end
       
       
       function [classifier_predicted_label, classifier_probabilty] = prediction(obj, model, features)
            [pred,prob] = predict(model,features);
            prob = max(prob,[],2);
        
            classifier_predicted_label = pred;
            classifier_probabilty = prob;
       end

    end
    
end