classdef CL_LibSVM < Classifier
    methods
       function [classifier_model, classifier_accuracy] = classification(obj, varargin)
            use_mapminmax = 0;
            features = varargin{1};
            labels = varargin{2};

            % Parameters
            numFold = 5;
            param_c = [-10:10];
            param_g = [-10:10];
            
            % Scale data between 0 and 1
            if use_mapminmax
                [scaled,PS] = mapminmax(features');
                scaled = double(scaled)';
            else
                [scaled, minVal, maxVal] = obj.scaleSVM(features);
            end


            % Grid search for parameter selection
            bestcv = 0;
            for log2c = param_c
                for log2g = param_g
                    cmd = ['-v ', num2str(numFold), ' -c ', num2str(2^log2c), ' -g ', num2str(2^log2g), ' -q'];
                    cv = svmtrain(labels, scaled, cmd);
                    % delete command window output
                    %fprintf(repmat('\b',1,32));

                    if (cv >= bestcv)
                        bestcv = cv; bestc = 2^log2c; bestg = 2^log2g;
                    end
                end
            end
            fprintf('SELECTED PARAMETER: c = %g, g = %g (rate = %g)\n', bestc, bestg, bestcv);

            param = ['-c ', num2str(bestc), ' -g ', num2str(bestg), ' -q'];
            svmmodel = svmtrain(labels, scaled, param);

            model.mdl = svmmodel;
            if use_mapminmax
                model.PS=PS;
            else
                model.minVal = minVal;
                model.maxVal = maxVal;
            end


            classifier_model = model;
            classifier_accuracy = bestcv;
       end
       
       
       function [classifier_predicted_label, classifier_probabilty] = prediction(obj, model, features)
           use_mapminmax = 0; 
           if use_mapminmax
                scaled = mapminmax('apply',features',model.PS);
                scaled = double(scaled)';
           else
                if isfield(features,'features')
                    scaled = obj.scaleSVM(features.features,model.minVal,model.maxVal);
                else
                    scaled = obj.scaleSVM(features,model.minVal,model.maxVal);
                end
            end


            label_vector = repmat(-999,[size(scaled,1),1]);

            [predicted_label, ~, prob] = svmpredict(label_vector, scaled, model.mdl, '-q');

            classifier_predicted_label = predicted_label;
            classifier_probabilty = prob;
       end

    end

    methods (Access = private)
       function [scaled,minValue,maxValue] = scaleSVM(obj, data,lower,upper)
            % convert the input data do double
            data = double(data);
            
            if nargin < 3
                % normalize all the data between 0 and 1
                lower = min(data,[],1);
                upper = max(data,[],1);
            end

            scaled = (data - repmat(lower,size(data,1),1))*spdiags(1./(upper-lower)',0,size(data,2),size(data,2));


            if nargout > 1
                minValue = min(data,[],1);
                maxValue = max(data,[],1);
            end
        end 
    end
    
end