classdef LibSVM_test < Classifier
   
    methods
       function [classifier_model, classifier_accuracy] = classification(obj, varargin)
            features = varargin{1};
            labels = varargin{2};

            % Scale data between 0 and 1
            [scaled, minVal, maxVal] = obj.scaleSVM(features);

            % Parameters
            numFold = 5;
            param_c = -10:10;
            param_g = -10:10;

            % Options
            opt_params = 1;

            % Generate indicies for the two classes
            classlabels = unique(labels);
            inds_class(1,:) = find(labels==classlabels(1));
            inds_class(2,:) = find(labels==classlabels(2));

            % Randomize index order
            inds_all = randperm(length(labels));
            inds_class(1,:) = inds_class(1,randperm(length(inds_class(1,:))));
            inds_class(2,:) = inds_class(1,randperm(length(inds_class(2,:))));

            % Crossvalidation
            for fold = 1:numFold
                % Divide test and train
                trials_test = inds_class(:,fold:numFold:end);
                trials_test = trials_test(:);
                trials_train = inds_all(~ismember(inds_all,trials_test));

                trials_test = trials_test(randperm(length(trials_test)));
                trials_train = trials_train(randperm(length(trials_train)));

                % Grid search for parameter optimization
                if opt_params == 1
                    bestcv = 0;
                    for log2c = param_c
                        for log2g = param_g
                            cmd = ['-v ', num2str(numFold), ' -c ', num2str(2^log2c), ' -g ', num2str(2^log2g), ' -q'];
                            cv = svmtrain(labels(trials_train), trials_train, cmd);
                            % delete command window output
                            fprintf(repmat('\b',1,32));

                            if (cv >= bestcv)
                                bestcv = cv; bestc = 2^log2c; bestg = 2^log2g;
                            end
                        end
                    end
                else
                    bestc = 1;
                    bestg = 1/length(trials_train);
                end

                % Generate model
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
            model.minVal = minVal;
            model.maxVal = maxVal;

            classifier_model = model;
            classifier_accuracy = bestcv;
       end
       
       
       function [classifier_predicted_label, classifier_probabilty] = prediction(obj, model, features)
            scaled = scaleSVM(features,model.minVal,model.maxVal);

            label_vector = repmat(-999,[size(scaled,1),1]);

            [predicted_label, ~, prob] = svmpredict(label_vector, scaled, model.mdl, '-q');

            classifier_predicted_label = predicted_label;
            classifier_probabilty = prob;
       end

    end

    methods (Access = private)

        function [scaled,minValue,maxValue] = scaleSVM(obj,data,lower,upper)

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