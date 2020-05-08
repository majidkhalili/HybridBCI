classdef CL_MatlabSVM_Fast < Classifier
   
    methods
       function [classifier_model, classifier_accuracy] = classification(obj, varargin)
            features = varargin{1};
            labels = varargin{2};

            param_opts = 0;

            param_optimization = 'auto';

            disp('SVM Model is building...');
            h = helpdlg({'SVM Model is building...','Please wait...'},'Building model');

            % Build the SVM model
            if param_opts == 1
                mdl = fitcsvm(features,labels,...
                    'OptimizeHyperparameters',param_optimization,...
                    'HyperparameterOptimizationOptions',struct('ShowPlots',false,'Verbose',0,'Repartition',false));
            else
                mdl = fitcsvm(features,labels);
            end
            % Calculate Score Transform to estimate the probability
            model = fitSVMPosterior(mdl);

            loss = resubLoss(model);
            accuracy = 100*(1 - loss);

            fprintf('SVM Model is built. Estimated accuracy: %g\n', accuracy);
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