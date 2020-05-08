classdef CL_LibSVMoldversion < Classifier
   
    methods
       function [classifier_model, classifier_accuracy] = classification(obj, varargin)
            features = varargin{1};
            labels = varargin{2};
            names = varargin{3};

            %%% TODO loop around labels
            [uniqueNames,~,uniqueIdx] = unique(names(:,2));
            all_models = [];

            for u = 1:length(uniqueNames)

                % Extract the features corresponding to the label
                data_x = features(:,uniqueIdx == u);
                data_y = labels;

                best_model= struct;
                % Scale data between 0 and 1
                [scaled, best_model.minVal, best_model.maxVal] = scaleSVM(data_x);

                settings=struct();
                settings.cvnumfolds=5; % 5-fold cross-validation
                settings.testparams=2.^[-10:10]; % which parameters to test for optimization
                settings.cv_stratified=1; %balance class-distribution in training set or not#
                settings.opt_params=1; %enable parameter optimization


                data_pred=[];
                inds_all=1:size(scaled,1);
                inds_all = inds_all(randperm(length(inds_all)));

                % Cross-validation
                for fold=1:settings.cvnumfolds
                    % generate indicies for training and testing dataset
                    trials_test = inds_all(fold:settings.cvnumfolds:end);
                    trials_train = inds_all(~ismember(inds_all,trials_test));


                    if (settings.cv_stratified)
                        classlabels=unique(data_y);
                        minority_classamount = min(sum(data_y(trials_train)==classlabels(1)),sum(data_y(trials_train)==classlabels(2)));
                        a= find(data_y(trials_train)==classlabels(1)); a= a(randperm(length(a)));
                        b= find(data_y(trials_train)==classlabels(2)); b= b(randperm(length(b)));
                        trials_train = trials_train([a(1:minority_classamount); b(1:minority_classamount)]);
                    end

                    % parameter optimization: find optimal C on training data
                    if settings.opt_params==1
                        testc=settings.testparams;
                        for ti=1:length(testc)
                            svmparams=['-c ' num2str(testc(ti)) ' -s 0 -t 0 -v 5 -q'];
                            tacc(ti) = svmtrain(double(data_y(trials_train)),double(scaled(trials_train,:)),svmparams);
                            [a b]=max(tacc);
                            usec=testc(b);
                        end
                    else
                        usec=100;
                    end

                    %generate model
                    svmparams=['-c ' num2str(usec) ' -s 0 -t 0 -b 1 -q'];
                    model(fold) = svmtrain(double(data_y(trials_train)),double(scaled(trials_train,:)),svmparams);

                    %evaluate on testset
                    [predicted_label, accuracy(:,fold), decision_values]=svmpredict(double(data_y(trials_test)),double(scaled(trials_test,:)),model(fold));
                    data_pred(trials_test)=predicted_label;
                end

                acc=mean(data_pred'==data_y);

                % parameter optimization: find optimal C on training data
                if settings.opt_params==1
                    testc=settings.testparams;
                    for ti=1:length(testc)
                        svmparams=['-c ' num2str(testc(ti)) ' -s 0 -t 0 -v 5 -q'];
                        tacc(ti) = svmtrain(double(data_y),double(scaled),svmparams);
                        [a b]=max(tacc);
                        usec=testc(b);
                    end
                else
                    usec=100;
                end
                %generate model
                svmparams=['-c ' num2str(usec) ' -s 0 -t 0 -b 1 -q'];
                best_model.mdl = svmtrain(double(data_y(trials_train)),double(scaled(trials_train,:)),svmparams);

                best_model.trainaccuracy = acc*100;
                best_model.name = uniqueNames(u);
                best_model.featIdx = (uniqueIdx == u);
                all_models{u} = best_model;
            end

            all_models = [all_models{:}];

            best_model_feature = all_models([all_models.trainaccuracy]==max([all_models.trainaccuracy]));

            % If there are more models with max accuracy
            if length(best_model_feature) > 1
                % Criteria 1: HbO
                hbo_model = best_model_feature(contains([best_model_feature.name]),"HbO");
                if ~isempty(hbo_model)
                    best_model_feature = hbo_model;
                end
            end
            if length(best_model_feature) > 1
                % Criteria 2: minimum number of feature
                numFeat = zeros(1,length(best_model_feature));
                for i = 1:length(best_model_feature)
                    numFeat(i) = length(best_model_feature(i).minVal);
                end

                best_model_feature = best_model_feature(numFeat==min(numFeat));
            end
            if length(best_model_feature) > 1
                % Criteria 3: take the first one
                best_model_feature = best_model_feature(1);
            end

            classifier_model = best_model_feature;
            classifier_accuracy = best_model_feature.trainaccuracy;
       end
       
       
       function [classifier_predicted_label, classifier_probabilty] = prediction(obj, model, features)
            % Find the correct feature
            data_x = features(:,model.featIdx);

            scaled = scaleSVM(data_x,model.minVal,model.maxVal);

            label_vector = repmat(-999,[size(scaled,1),1]);

            [predicted_label, ~, prob] = svmpredict(label_vector, scaled, model.mdl, '-q');

            classifier_predicted_label = predicted_label;
            classifier_probabilty = prob;
       end

    end

    methods (Access = private)
       function [scaled,minValue,maxValue] = scaleSVM(data,lower,upper)
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