function [featuresValues, featuresLabels]=CLISLAB_EEG_Online_ExtractFeatures(thinkingData, fs, selectedFeatures)
% CLISLAB_EEG_ONLINE_EXTRACTFEATURES Calls to the correspondant EEG Features functions.
% INPUTS:
%   thinkingData    :   Struct with the signals from which extract the features. The struct is divided in 3 structs: EEG, EMG and EOG. Some of these structs 
%                       could not appear depending on user selection.
%   fs              :   Sampling rate value.
%   selectedFeatures:   Cell array with the names of the features selected by the user.
%
% OUTPUTS:
%   featuresValues  :   Cell array with the calculated values. [Trials X Features].
%   featuresLabels  :   Cell array with the label of each row in 'featuresValues' (Feature name, band and channel).

%% Applying the feature functions
featuresValues=[];
featuresLabels=[];

featuresValuesEEG=[]; featuresValuesEOG=[]; featuresValuesEMG=[];
featuresLabelsEEG=[]; featuresLabelsEOG=[]; featuresLabelsEMG=[];

path = ['lib' filesep 'EEG' filesep 'Features'];

addpath(path);
if size(selectedFeatures,2)>1
    tmpSelectedFeatures = selectedFeatures;
    selectedFeatures = unique(selectedFeatures(:,1));
    
end
for i = 1:size(selectedFeatures,1) %Moving through the list of Features to calculate them
    if isfield(thinkingData,'eeg')
        if isempty(thinkingData.eeg)
            featuresValuesEEG=[];
            featuresLabelsEEG=[];
        elseif ~isempty(thinkingData.eeg)

            %Testing 'wideband' field
            if isfield(thinkingData.eeg,'wideband')
                passbandInterval = [0.5 30];
                for ii=1:size(thinkingData.eeg.channels,1) %Moving through the number of channels
                    temp1=[];
                    temp1{1,1}=[ selectedFeatures{i,1} ];
                    temp1{1,2}=[ 'wideband' ];
                    temp1{1,3}=[ thinkingData.eeg.channels{ii,1} ];
                    featuresLabelsEEG=cat(1,featuresLabelsEEG,temp1);
                    for k=1:size(thinkingData.eeg.wideband,3) %Moving through the number of trials, just for the Feature calculation           
                        temp2(1,k) = feval(string(selectedFeatures{i,1}), thinkingData.eeg.wideband(ii,:,k),fs,passbandInterval); %The calculation of the feature is in here
                    end
                    featuresValuesEEG=cat(1,featuresValuesEEG,temp2);
                end
            end

            %Testing 'delta' field
            if isfield(thinkingData.eeg,'delta')
                passbandInterval = [1 4];
                for ii=1:size(thinkingData.eeg.channels,1) %Moving through the number of channels
                    temp1=[];
                    temp1{1,1}=[ selectedFeatures{i,1} ];
                    temp1{1,2}=[ 'delta'];
                    temp1{1,3}=[ thinkingData.eeg.channels{ii,1} ];
                    featuresLabelsEEG=cat(1,featuresLabelsEEG,temp1);
                    for k=1:size(thinkingData.eeg.delta,3) %Moving through the number of trials, just for the Feature calculation           
                        temp2(1,k) = feval(string(selectedFeatures{i,1}), thinkingData.eeg.delta(ii,:,k),fs,passbandInterval); %The calculation of the feature is in here
                    end
                    featuresValuesEEG=cat(1,featuresValuesEEG,temp2);
                end
            end

            %Testing 'theta' field
            if isfield(thinkingData.eeg,'theta')
                passbandInterval = [4 7];
                for ii=1:size(thinkingData.eeg.channels,1) %Moving through the number of channels
                    temp1=[];
                    temp1{1,1}=[ selectedFeatures{i,1} ];
                    temp1{1,2}=[ 'theta'];
                    temp1{1,3}=[ thinkingData.eeg.channels{ii,1} ];
                    featuresLabelsEEG=cat(1,featuresLabelsEEG,temp1);
                    for k=1:size(thinkingData.eeg.theta,3) %Moving through the number of trials, just for the Feature calculation           
                        temp2(1,k) = feval(string(selectedFeatures{i,1}), thinkingData.eeg.theta(ii,:,k),fs,passbandInterval); %The calculation of the feature is in here
                    end
                    featuresValuesEEG=cat(1,featuresValuesEEG,temp2);
                end
            end

            %Testing 'alpha' field
            if isfield(thinkingData.eeg,'alpha')
                passbandInterval = [7 15];
                for ii=1:size(thinkingData.eeg.channels,1) %Moving through the number of channels
                    temp1=[];
                    temp1{1,1}=[ selectedFeatures{i,1} ];
                    temp1{1,2}=[ 'alpha'];
                    temp1{1,3}=[ thinkingData.eeg.channels{ii,1} ];
                    featuresLabelsEEG=cat(1,featuresLabelsEEG,temp1);
                    for k=1:size(thinkingData.eeg.alpha,3) %Moving through the number of trials, just for the Feature calculation           
                        temp2(1,k) = feval(string(selectedFeatures{i,1}), thinkingData.eeg.alpha(ii,:,k),fs,passbandInterval); %%%%%The calculation of the feature is in here
                    end
                    featuresValuesEEG=cat(1,featuresValuesEEG,temp2);
                end
            end

            %Testing 'beta' field
            if isfield(thinkingData.eeg,'beta')
                passbandInterval = [15 30];
                for ii=1:size(thinkingData.eeg.channels,1) %Moving through the number of channels
                    temp1=[];
                    temp1{1,1}=[ selectedFeatures{i,1} ];
                    temp1{1,2}=[ 'beta' ];
                    temp1{1,3}=[ thinkingData.eeg.channels{ii,1} ];
                    featuresLabelsEEG=cat(1,featuresLabelsEEG,temp1);
                    for k=1:size(thinkingData.eeg.beta,3) %Moving through the number of trials, just for the Feature calculation           
                        temp2(1,k) = feval(string(selectedFeatures{i,1}), thinkingData.eeg.beta(ii,:,k),fs,passbandInterval); %%%%%The calculation of the feature is in here
                    end
                    featuresValuesEEG=cat(1,featuresValuesEEG,temp2);
                end
            end

        end
    elseif ~isfield(thinkingData,'eeg')
        %     warning('The field thinkingData.eog does not exist');
        disp('The field thinkingData.eeg does not exist');
    end

    %% eog: Calculating "features_Amplitude_Maximum" and "features_Amplitude_Maximum_Labels"
    if isfield(thinkingData,'eog')
        if isempty(thinkingData.eog)
            featuresValuesEOG=[];
            featuresLabelsEOG=[];
        elseif ~isempty(thinkingData.eog)

            %Testing '2-50 Hz' field
            if isfield(thinkingData.eog,'filtered')
                passbandInterval = [0.5 50];
                for ii=1:size(thinkingData.eog.channels,1) %Moving through the number of channels
                    temp1=[];
                    temp1{1,1}=[ selectedFeatures{i,1} ];
                    temp1{1,2}=[ '0.5-50 Hz' ];
                    temp1{1,3}=[ thinkingData.eog.channels{ii,1} ];
                    featuresLabelsEOG=cat(1,featuresLabelsEOG,temp1);
                    for k=1:size(thinkingData.eog.filtered,3) %Moving through the number of trials, just for the Feature calculation           
                        temp2(1,k) = feval(string(selectedFeatures{i,1}), thinkingData.eog.filtered(ii,:,k),fs,passbandInterval); %%%%%The calculation of the feature is in here
                    end
                    featuresValuesEOG=cat(1,featuresValuesEOG,temp2);
                end
            end

        end
    elseif ~isfield(thinkingData,'eog')
        %     warning('The field thinkingData.eog does not exist');
        disp('The field thinkingData.eog does not exist');
    end

    %% emg: Calculating "features_Amplitude_Maximum" and "features_Amplitude_Maximum_Labels"
    if isfield(thinkingData,'emg')
        if isempty(thinkingData.emg)
            featuresValuesEMG=[];
            featuresLabelsEMG=[];
        elseif ~isempty(thinkingData.emg)

            %Testing '2-70 Hz' field
            if isfield(thinkingData.emg,'filtered')
            passbandInterval = [50 200];
                for ii=1:size(thinkingData.emg.channels,1) %Moving through the number of channels
                    temp1=[];
                    temp1{1,1}=[ selectedFeatures{i,1} ];
                    temp1{1,2}=[ '50-200 Hz' ];
                    temp1{1,3}=[ thinkingData.emg.channels{ii,1} ];
                    featuresLabelsEMG=cat(1,featuresLabelsEMG,temp1);
                    for k=1:size(thinkingData.emg.filtered,3) %Moving through the number of trials, just for the Feature calculation           
                        temp2(1,k) = feval(string(selectedFeatures{i,1}), thinkingData.emg.filtered(ii,:,k),fs,passbandInterval); %%%%%The calculation of the feature is in here
                    end
                    featuresValuesEMG=cat(1,featuresValuesEMG,temp2);
                end
            end

        end
    elseif ~isfield(thinkingData,'emg')
        %     warning('The field thinkingData.eog does not exist');
        disp('The field thinkingData.emg does not exist');
    end

featuresValues = cat(1,featuresValuesEEG,featuresValuesEOG,featuresValuesEMG);
featuresLabels = cat(1,featuresLabelsEEG,featuresLabelsEOG,featuresLabelsEMG);

end

featuresValues = featuresValues';

end

