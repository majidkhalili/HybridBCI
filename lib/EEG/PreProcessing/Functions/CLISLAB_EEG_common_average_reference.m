function [eeg_thinking, eeg_baseline, eog_thinking, eog_baseline, emg_thinking, emg_baseline] = CLISLAB_EEG_common_average_reference(eeg_thinking, eeg_baseline, eog_thinking, eog_baseline, emg_thinking, emg_baseline,selectSource)
%% Common Average Reference
if selectSource(1)==1 %eeg
    if ~isempty(eeg_thinking.wideband) % when no eeg data
        dimisionnumber=length(size(eeg_thinking.wideband)); % build model or feedback section
        if dimisionnumber==2 % feedback
            eeg_thinking.wideband=eeg_thinking.wideband-mean(eeg_thinking.wideband,1);
            eeg_thinking.delta=eeg_thinking.delta-mean(eeg_thinking.delta,1);
            eeg_thinking.theta=eeg_thinking.theta-mean(eeg_thinking.theta,1);
            eeg_thinking.alpha=eeg_thinking.alpha-mean(eeg_thinking.alpha,1);
            eeg_thinking.beta=eeg_thinking.beta-mean(eeg_thinking.beta,1);
            
            eeg_baseline.wideband=eeg_baseline.wideband-mean(eeg_baseline.wideband,1);
            eeg_baseline.delta=eeg_baseline.delta-mean(eeg_baseline.delta,1);
            eeg_baseline.theta=eeg_baseline.theta-mean(eeg_baseline.theta,1);
            eeg_baseline.alpha=eeg_baseline.alpha-mean(eeg_baseline.alpha,1);
            eeg_baseline.beta=eeg_baseline.beta-mean(eeg_baseline.beta,1);
        elseif dimisionnumber==3 %building model
            for k=1:size(eeg_thinking.wideband,3)
                %CAR for EEG Thinking lengths
                eeg_thinking.wideband(:,:,k)=eeg_thinking.wideband(:,:,k)-mean(eeg_thinking.wideband(:,:,k),1);
                eeg_thinking.delta(:,:,k)=eeg_thinking.delta(:,:,k)-mean(eeg_thinking.delta(:,:,k),1);
                eeg_thinking.theta(:,:,k)=eeg_thinking.theta(:,:,k)-mean(eeg_thinking.theta(:,:,k),1);
                eeg_thinking.alpha(:,:,k)=eeg_thinking.alpha(:,:,k)-mean(eeg_thinking.alpha(:,:,k),1);
                eeg_thinking.beta(:,:,k)=eeg_thinking.beta(:,:,k)-mean(eeg_thinking.beta(:,:,k),1);
                %CAR for EEG Baseline lengths
                eeg_baseline.wideband(:,:,k)=eeg_baseline.wideband(:,:,k)-mean(eeg_baseline.wideband(:,:,k),1);
                eeg_baseline.delta(:,:,k)=eeg_baseline.delta(:,:,k)-mean(eeg_baseline.delta(:,:,k),1);
                eeg_baseline.theta(:,:,k)=eeg_baseline.theta(:,:,k)-mean(eeg_baseline.theta(:,:,k),1);
                eeg_baseline.alpha(:,:,k)=eeg_baseline.alpha(:,:,k)-mean(eeg_baseline.alpha(:,:,k),1);
                eeg_baseline.beta(:,:,k)=eeg_baseline.beta(:,:,k)-mean(eeg_baseline.beta(:,:,k),1);
            end
        end
    end
end

%CAR for EOG Thinking and Baseline lengths
if selectSource(2)==1 %eog
    if ~isempty(eog_thinking.filtered)
        
        dimisionnumber=length(size( eog_thinking.filtered));
        if dimisionnumber==2
            eog_thinking.filtered=eog_thinking.filtered-mean(eog_thinking.filtered,1);
            eog_baseline.filtered=eog_baseline.filtered-mean(eog_baseline.filtered,1);
        elseif dimisionnumber==3
            for k=1:size(eog_thinking.filtered,3)
                eog_thinking.filtered(:,:,k)=eog_thinking.filtered(:,:,k)-mean(eog_thinking.filtered(:,:,k),1);
                eog_baseline.filtered(:,:,k)=eog_baseline.filtered(:,:,k)-mean(eog_baseline.filtered(:,:,k),1);
            end
        end
    end
end

%CAR for EMG Thinking and Baseline lengths
if selectSource(3)==1 %eog
    if ~isempty(emg_thinking.filtered)
        
        dimisionnumber=length(size(emg_thinking.filtered));
        if dimisionnumber==2
            emg_thinking.filtered=emg_thinking.filtered-mean(emg_thinking.filtered,1);
            emg_thinking.filtered= emg_thinking.filtered-mean(emg_thinking.filtered,1);
        elseif dimisionnumber==3
            for k=1:size(emg_thinking.filtered,3)
                emg_thinking.filtered(:,:,k)=emg_thinking.filtered(:,:,k)-mean(emg_thinking.filtered(:,:,k),1);
                emg_baseline.filtered(:,:,k)=emg_baseline.filtered(:,:,k)-mean(emg_baseline.filtered(:,:,k),1);
            end
        end
    end
end

end