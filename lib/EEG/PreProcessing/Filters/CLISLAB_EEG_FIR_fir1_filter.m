function [eeg_thinking, eeg_baseline, eog_thinking, eog_baseline, emg_thinking, emg_baseline] = CLISLAB_EEG_FIR_fir1_filter(eeg_thinking, eeg_baseline, eog_thinking, eog_baseline, emg_thinking, emg_baseline, frequencyBands, fs)
%% Filtering EEG with FIR with Parks-McClellan optimal FIR filter order estimation
%Filtering Parameters
rp = 3;           % Passband ripple
rs = 40;          % Stopband ripple
gain = [1 0];     % Desired gaining amplitudes
% dev = [(10^(rp/20)-1)/(10^(rp/20)+1)  10^(-rs/20)];  %Maximum allowable deviation or ripples between the frequency response and the desired amplitude of the output filter for each band
dev = [0.05 0.01];  %Maximum allowable deviation or ripples between the frequency response and the desired amplitude of the output filter for each band

%% Calculationg Filter Order with the firpmord function
filter_order = []; fo = []; ao = [];  w = [];

% Calculating the filter order for the EEG thinking length
% [filter_order.eeg.thinking.wideband, fo.eeg.thinking.wideband, ao.eeg.thinking.wideband, w.eeg.thinking.wideband] = firpmord([0.5 30],gain,dev,fs);
% [filter_order.eeg.thinking.delta, fo.eeg.thinking.delta, ao.eeg.thinking.delta, w.eeg.thinking.delta] = firpmord([1 4],gain,dev,fs);
% [filter_order.eeg.thinking.theta, fo.eeg.thinking.theta, ao.eeg.thinking.theta, w.eeg.thinking.theta] = firpmord([4 7],gain,dev,fs);
% [filter_order.eeg.thinking.alpha, fo.eeg.thinking.alpha, ao.eeg.thinking.alpha, w.eeg.thinking.alpha] = firpmord([7 15],gain,dev,fs);
% [filter_order.eeg.thinking.beta, fo.eeg.thinking.beta, ao.eeg.thinking.beta, w.eeg.thinking.beta] = firpmord([15 30],gain,dev,fs);
[filter_order.eeg.thinking.wideband, fo.eeg.thinking.wideband, ao.eeg.thinking.wideband, w.eeg.thinking.wideband] =     firpmord([frequencyBands(1).low frequencyBands(1).high],gain,dev,fs);
[filter_order.eeg.thinking.delta, fo.eeg.thinking.delta, ao.eeg.thinking.delta, w.eeg.thinking.delta] =                 firpmord([frequencyBands(2).low frequencyBands(2).high],gain,dev,fs);
[filter_order.eeg.thinking.theta, fo.eeg.thinking.theta, ao.eeg.thinking.theta, w.eeg.thinking.theta] =                 firpmord([frequencyBands(3).low frequencyBands(3).high],gain,dev,fs);
[filter_order.eeg.thinking.alpha, fo.eeg.thinking.alpha, ao.eeg.thinking.alpha, w.eeg.thinking.alpha] =                 firpmord([frequencyBands(4).low frequencyBands(4).high],gain,dev,fs);
[filter_order.eeg.thinking.beta, fo.eeg.thinking.beta, ao.eeg.thinking.beta, w.eeg.thinking.beta] =                     firpmord([frequencyBands(5).low frequencyBands(5).high],gain,dev,fs);

% Calculating the filter order for the EEG baseline length
% [filter_order.eeg.baseline.wideband, fo.eeg.baseline.wideband, ao.eeg.baseline.wideband, w.eeg.baseline.wideband] = firpmord([0.5 30],gain,dev,fs);
% [filter_order.eeg.baseline.delta, fo.eeg.baseline.delta, ao.eeg.baseline.delta, w.eeg.baseline.delta] = firpmord([1 4],gain,dev,fs);
% [filter_order.eeg.baseline.theta, fo.eeg.baseline.theta, ao.eeg.baseline.theta, w.eeg.baseline.theta] = firpmord([4 7],gain,dev,fs);
% [filter_order.eeg.baseline.alpha, fo.eeg.baseline.alpha, ao.eeg.baseline.alpha, w.eeg.baseline.alpha] = firpmord([7 15],gain,dev,fs);
% [filter_order.eeg.baseline.beta, fo.eeg.baseline.beta, ao.eeg.baseline.beta, w.eeg.baseline.beta] = firpmord([15 30],gain,dev,fs);
[filter_order.eeg.baseline.wideband, fo.eeg.baseline.wideband, ao.eeg.baseline.wideband, w.eeg.baseline.wideband] =     firpmord([frequencyBands(1).low frequencyBands(1).high],gain,dev,fs);
[filter_order.eeg.baseline.delta, fo.eeg.baseline.delta, ao.eeg.baseline.delta, w.eeg.baseline.delta] =                 firpmord([frequencyBands(2).low frequencyBands(2).high],gain,dev,fs);
[filter_order.eeg.baseline.theta, fo.eeg.baseline.theta, ao.eeg.baseline.theta, w.eeg.baseline.theta] =                 firpmord([frequencyBands(3).low frequencyBands(3).high],gain,dev,fs);
[filter_order.eeg.baseline.alpha, fo.eeg.baseline.alpha, ao.eeg.baseline.alpha, w.eeg.baseline.alpha] =                 firpmord([frequencyBands(4).low frequencyBands(4).high],gain,dev,fs);
[filter_order.eeg.baseline.beta, fo.eeg.baseline.beta, ao.eeg.baseline.beta, w.eeg.baseline.beta] =                     firpmord([frequencyBands(5).low frequencyBands(5).high],gain,dev,fs);

% Calculating the filter order for the EOG thinking length
[filter_order.eog.thinking.filtered, fo.eog.thinking.filtered, ao.eog.thinking.filtered, w.eog.thinking.filtered] =     firpmord([0.5 50],gain,dev,fs);

% Calculating the filter order for the EOG baseline length
[filter_order.eog.baseline.filtered, fo.eog.baseline.filtered, ao.eog.baseline.filtered, w.eog.baseline.filtered] =     firpmord([0.5 50],gain,dev,fs);

% Calculating the filter order for the EMG thinking length
[filter_order.emg.thinking.filtered, fo.emg.thinking.filtered, ao.emg.thinking.filtered, w.emg.thinking.filtered] =     firpmord([50 200],gain,dev,fs);

% Calculating the filter order for the EMG baseline length
[filter_order.emg.baseline.filtered, fo.emg.baseline.filtered, ao.emg.baseline.filtered, w.emg.baseline.filtered] =     firpmord([50 200],gain,dev,fs);


%% Calculating the Filter Coefficients for EEG with the fir1 function
% Calculating the filters for EEG thinking length
b.eeg.thinking.wideband =   fir1(filter_order.eeg.thinking.wideband,[frequencyBands(1).low frequencyBands(1).high]/(fs/2),'bandpass',gausswin(filter_order.eeg.thinking.wideband+1));
b.eeg.thinking.delta =      fir1(filter_order.eeg.thinking.delta,   [frequencyBands(2).low frequencyBands(2).high]/(fs/2),'bandpass',gausswin(filter_order.eeg.thinking.delta+1));
b.eeg.thinking.theta =      fir1(filter_order.eeg.thinking.theta,   [frequencyBands(3).low frequencyBands(3).high]/(fs/2),'bandpass',gausswin(filter_order.eeg.thinking.theta+1));
b.eeg.thinking.alpha =      fir1(filter_order.eeg.thinking.alpha,   [frequencyBands(4).low frequencyBands(4).high]/(fs/2),'bandpass',gausswin(filter_order.eeg.thinking.alpha+1));
b.eeg.thinking.beta =       fir1(filter_order.eeg.thinking.beta,    [frequencyBands(5).low frequencyBands(5).high]/(fs/2),'bandpass',gausswin(filter_order.eeg.thinking.beta+1));
% freqz(b.eeg.thinking.wideband,1,1024,fs)
% freqz(b.eeg.thinking.delta,1,1024,fs)
% freqz(b.eeg.thinking.delta,1,1024,fs)
% freqz(b.eeg.thinking.alpha,1,1024,fs)
% freqz(b.eeg.thinking.beta,1,1024,fs)

% Calculating the filters for EEG baseline length
b.eeg.baseline.wideband =   fir1(filter_order.eeg.baseline.wideband,[frequencyBands(1).low frequencyBands(1).high]/(fs/2),'bandpass',gausswin(filter_order.eeg.baseline.wideband+1));
b.eeg.baseline.delta =      fir1(filter_order.eeg.baseline.delta,   [frequencyBands(2).low frequencyBands(2).high]/(fs/2),'bandpass',gausswin(filter_order.eeg.baseline.delta+1));
b.eeg.baseline.theta =      fir1(filter_order.eeg.baseline.theta,   [frequencyBands(3).low frequencyBands(3).high]/(fs/2),'bandpass',gausswin(filter_order.eeg.baseline.theta+1));
b.eeg.baseline.alpha =      fir1(filter_order.eeg.baseline.alpha,   [frequencyBands(4).low frequencyBands(4).high]/(fs/2),'bandpass',gausswin(filter_order.eeg.baseline.alpha+1));
b.eeg.baseline.beta =       fir1(filter_order.eeg.baseline.beta,    [frequencyBands(5).low frequencyBands(5).high]/(fs/2),'bandpass',gausswin(filter_order.eeg.baseline.beta+1));
% freqz(b.eeg.baseline.wideband,1,1024,fs)
% freqz(b.eeg.baseline.delta,1,1024,fs)
% freqz(b.eeg.baseline.delta,1,1024,fs)
% freqz(b.eeg.baseline.alpha,1,1024,fs)
% freqz(b.eeg.baseline.beta,1,1024,fs)

%% Calculating the Filter Coefficients for EOG with the fir1 function
b.eog.thinking.filtered =   fir1(filter_order.eog.thinking.filtered,[0.5 50]/(fs/2),'bandpass',gausswin(filter_order.eog.thinking.filtered+1));
% Calculating the filters for EEG baseline length
b.eog.baseline.filtered =   fir1(filter_order.eog.baseline.filtered,[0.5 50]/(fs/2),'bandpass',gausswin(filter_order.eog.baseline.filtered+1));

%% Calculating the Filter Coefficients for EMG with the fir1 function
% Calculating the filter for EMG thinking length: filter order manually increased by 10 taps to make it more efficient to the band 50-200 Hz
b.emg.thinking.filtered =   fir1(filter_order.emg.thinking.filtered+10,[50 200]/(fs/2),'bandpass',gausswin(filter_order.emg.thinking.filtered+10+1));
% Calculating the filters for EMG baseline length: filter order manually increased by 10 taps to make it more efficient to the band 50-200 Hz
b.emg.baseline.filtered =   fir1(filter_order.emg.baseline.filtered+10,[50 200]/(fs/2),'bandpass',gausswin(filter_order.emg.baseline.filtered+10+1));

%% Applying the filters
eeg_thinking.wideband = []; eeg_thinking.delta = []; eeg_thinking.theta = []; eeg_thinking.alpha = []; eeg_thinking.beta = [];
eeg_baseline.wideband = []; eeg_baseline.delta = []; eeg_baseline.theta = []; eeg_baseline.alpha = []; eeg_baseline.beta = [];

%Applying the filters to EEG the channels
if ~isempty(eeg_thinking.raw)
    %added by wu
    diminsionnumber=length(size(eeg_thinking.raw)); % feedback or training
    
    for i=1:1:size(eeg_thinking.raw,1)
        if diminsionnumber==2 % feedback
            %Applying the bandpass filter to the thinking length
            eeg_thinking.wideband(i,:) = filtfilt(b.eeg.thinking.wideband,1,double(eeg_thinking.raw(i,:)));
            eeg_thinking.delta(i,:) = filtfilt(b.eeg.thinking.delta,1,double(eeg_thinking.raw(i,:)));
            eeg_thinking.theta(i,:) = filtfilt(b.eeg.thinking.theta,1,double(eeg_thinking.raw(i,:)));
            eeg_thinking.alpha(i,:) = filtfilt(b.eeg.thinking.alpha,1,double(eeg_thinking.raw(i,:)));
            eeg_thinking.beta(i,:) = filtfilt(b.eeg.thinking.beta,1,double(eeg_thinking.raw(i,:)));
            
            %Applying the bandpass filter to the baseline length
            eeg_baseline.wideband(i,:) = filtfilt(b.eeg.baseline.wideband,1,double(eeg_baseline.raw(i,:)));
            eeg_baseline.delta(i,:) = filtfilt(b.eeg.baseline.delta,1,double(eeg_baseline.raw(i,:)));
            eeg_baseline.theta(i,:) = filtfilt(b.eeg.baseline.theta,1,double(eeg_baseline.raw(i,:)));
            eeg_baseline.alpha(i,:) = filtfilt(b.eeg.baseline.alpha,1,double(eeg_baseline.raw(i,:)));
            eeg_baseline.beta(i,:) = filtfilt(b.eeg.baseline.beta,1,double(eeg_baseline.raw(i,:)));
        elseif diminsionnumber==3
            for k=1:1:size(eeg_thinking.raw,3)
                %Applying the bandpass filter to the thinking length
                eeg_thinking.wideband(i,:,k) = filtfilt(b.eeg.thinking.wideband,1,double(eeg_thinking.raw(i,:,k)));
                eeg_thinking.delta(i,:,k) = filtfilt(b.eeg.thinking.delta,1,double(eeg_thinking.raw(i,:,k)));
                eeg_thinking.theta(i,:,k) = filtfilt(b.eeg.thinking.theta,1,double(eeg_thinking.raw(i,:,k)));
                eeg_thinking.alpha(i,:,k) = filtfilt(b.eeg.thinking.alpha,1,double(eeg_thinking.raw(i,:,k)));
                eeg_thinking.beta(i,:,k) = filtfilt(b.eeg.thinking.beta,1,double(eeg_thinking.raw(i,:,k)));
                
                %Applying the bandpass filter to the baseline length
                eeg_baseline.wideband(i,:,k) = filtfilt(b.eeg.baseline.wideband,1,double(eeg_baseline.raw(i,:,k)));
                eeg_baseline.delta(i,:,k) = filtfilt(b.eeg.baseline.delta,1,double(eeg_baseline.raw(i,:,k)));
                eeg_baseline.theta(i,:,k) = filtfilt(b.eeg.baseline.theta,1,double(eeg_baseline.raw(i,:,k)));
                eeg_baseline.alpha(i,:,k) = filtfilt(b.eeg.baseline.alpha,1,double(eeg_baseline.raw(i,:,k)));
                eeg_baseline.beta(i,:,k) = filtfilt(b.eeg.baseline.beta,1,double(eeg_baseline.raw(i,:,k)));
            end
        end
    end
end


%Applying the filters to EOG the channels
if ~isempty(eog_thinking.raw)
    %added by wu
    diminsionnumber=length(size(eog_thinking.raw)); % feedback or training
    
    for i=1:1:size(eog_thinking.raw,1)
        if diminsionnumber==2 % feedback
            %Applying the bandpass filter to the thinking length
            eog_thinking.filtered(i,:) = filtfilt(b.eog.thinking.filtered, 1, double(eog_thinking.raw(i,:)));
            
            %Applying the bandpass filter to the baseline length
            eog_baseline.filtered(i,:) = filtfilt(b.eog.baseline.filtered, 1, double(eog_baseline.raw(i,:)));
        elseif diminsionnumber==3
            for k=1:1:size(eog_thinking.raw,3)
                %Applying the bandpass filter to the thinking length
                eog_thinking.filtered(i,:,k) = filtfilt(b.eog.thinking.filtered, 1, double(eog_thinking.raw(i,:,k)));
                
                %Applying the bandpass filter to the baseline length
                eog_baseline.filtered(i,:,k) = filtfilt(b.eog.baseline.filtered, 1, double(eog_baseline.raw(i,:,k)));
            end
        end
    end
    
end


%Applying the filters to EMG the channels
%corrected by wu
if ~isempty(emg_thinking.raw)
    diminsionnumber=length(size(emg_thinking.raw)); % feedback or training
        
    for i=1:1:size(emg_thinking.raw,1)
        
        if diminsionnumber==2 % feedback
            %Applying the bandpass filter to the thinking length
            emg_thinking.filtered(i,:) = filtfilt(b.emg.thinking.filtered, 1, double(emg_thinking.raw(i,:)));
            
            %Applying the bandpass filter to the baseline length
            emg_baseline.filtered(i,:) = filtfilt(b.emg.baseline.filtered, 1, double(emg_baseline.raw(i,:)));
            
        elseif diminsionnumber==3
            for k=1:1:size(emg_thinking.raw,3)
                %Applying the bandpass filter to the thinking length
                emg_thinking.filtered(i,:,k) = filtfilt(b.emg.thinking.filtered, 1, double(emg_thinking.raw(i,:,k)));
                
                %Applying the bandpass filter to the baseline length
                emg_baseline.filtered(i,:,k) = filtfilt(b.emg.baseline.filtered, 1, double(emg_baseline.raw(i,:,k)));
            end
        end
    end
    
end

end