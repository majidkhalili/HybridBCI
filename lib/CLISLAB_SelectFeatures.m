function [features,featuresLabels] = CLISLAB_SelectFeatures(features, featuresLabels,selectedFeatures)

    newValues = [];
    newLabels = {};
    features = features';
    lstFeaturesLabels = strcat(featuresLabels(:,1),featuresLabels(:,2),featuresLabels(:,3));
    lstSelectedFeatures = strcat(selectedFeatures(:,1),selectedFeatures(:,2),selectedFeatures(:,3));
    for iter = 1:size(selectedFeatures,1)
        idx = find(strcmp(lstFeaturesLabels,lstSelectedFeatures(iter)));
        newValues = cat(1,newValues,features(idx,:));
        newLabels = cat(1,newLabels,featuresLabels(idx,:));
    end
    features = newValues';
    featuresLabels = newLabels; 
    
end