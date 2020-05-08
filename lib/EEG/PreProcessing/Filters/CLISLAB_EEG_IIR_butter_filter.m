function [eeg_thinking, eeg_baseline, eog_thinking, eog_baseline, emg_thinking, emg_baseline] = CLISLAB_EEG_IIR_butter_filter(eeg_thinking, eeg_baseline, eog_thinking, eog_baseline, emg_thinking, emg_baseline, frequencyBands, fs)
%% Filtering EEG with IIR Butterwort (using highpass and lowpass)
%Filtering Parameters
rp = 3; % Passband ripple
rs = 40; % Stopband ripple

%% Calculationg Filter Order
filter_order = []; Wn = [];

% Calculating the filter order for the EEG thinking length
[filter_order.eeg.thinking.wideband.low, Wn.eeg.thinking.wideband.low] =    buttord(frequencyBands(1).low/(fs/2),   45/(fs/2),rp,rs);
[filter_order.eeg.thinking.wideband.high, Wn.eeg.thinking.wideband.high] =  buttord(frequencyBands(1).high/(fs/2),  0.01/(fs/2),rp,rs);
[filter_order.eeg.thinking.delta.low, Wn.eeg.thinking.delta.low] =          buttord(frequencyBands(2).low/(fs/2),   10/(fs/2),rp,rs);
[filter_order.eeg.thinking.delta.high, Wn.eeg.thinking.delta.high] =        buttord(frequencyBands(2).high/(fs/2),  0.01/(fs/2),rp,rs);
[filter_order.eeg.thinking.theta.low, Wn.eeg.thinking.theta.low] =          buttord(frequencyBands(3).low/(fs/2),   20/(fs/2),rp,rs);
[filter_order.eeg.thinking.theta.high, Wn.eeg.thinking.theta.high] =        buttord(frequencyBands(3).high/(fs/2),  1/(fs/2),rp,rs);
[filter_order.eeg.thinking.alpha.low, Wn.eeg.thinking.alpha.low] =          buttord(frequencyBands(4).low/(fs/2),   25/(fs/2),rp,rs);
[filter_order.eeg.thinking.alpha.high, Wn.eeg.thinking.alpha.high] =        buttord(frequencyBands(4).high/(fs/2),  2/(fs/2),rp,rs);
[filter_order.eeg.thinking.beta.low, Wn.eeg.thinking.beta.low] =            buttord(frequencyBands(5).low/(fs/2),   50/(fs/2),rp,rs);
[filter_order.eeg.thinking.beta.high, Wn.eeg.thinking.beta.high] =          buttord(frequencyBands(5).high/(fs/2),  6/(fs/2),rp,rs);

% Calculating the filter order for the EEG baseline length
[filter_order.eeg.baseline.wideband.low,Wn.eeg.baseline.wideband.low] =     buttord(frequencyBands(1).low/(fs/2),   45/(fs/2),rp,rs);
[filter_order.eeg.baseline.wideband.high,Wn.eeg.baseline.wideband.high] =   buttord(frequencyBands(1).high/(fs/2),  0.01/(fs/2),rp,rs);
[filter_order.eeg.baseline.delta.low, Wn.eeg.baseline.delta.low] =          buttord(frequencyBands(2).low/(fs/2),   10/(fs/2),rp,rs);
[filter_order.eeg.baseline.delta.high,Wn.eeg.baseline.delta.high] =         buttord(frequencyBands(2).high/(fs/2),  0.01/(fs/2),rp,rs);
[filter_order.eeg.baseline.theta.low, Wn.eeg.baseline.theta.low] =          buttord(frequencyBands(3).low/(fs/2),   20/(fs/2),rp,rs);
[filter_order.eeg.baseline.theta.high, Wn.eeg.baseline.theta.high] =        buttord(frequencyBands(3).high/(fs/2),  1/(fs/2),rp,rs);
[filter_order.eeg.baseline.alpha.low, Wn.eeg.baseline.alpha.low] =          buttord(frequencyBands(4).low/(fs/2),   25/(fs/2),rp,rs);
[filter_order.eeg.baseline.alpha.high,Wn.eeg.baseline.alpha.high] =         buttord(frequencyBands(4).high/(fs/2),  2/(fs/2),rp,rs);
[filter_order.eeg.baseline.beta.low, Wn.eeg.baseline.beta.low] =            buttord(frequencyBands(5).low/(fs/2),   50/(fs/2),rp,rs);
[filter_order.eeg.baseline.beta.high, Wn.eeg.baseline.beta.high] =          buttord(frequencyBands(5).high/(fs/2),  6/(fs/2),rp,rs);

% Calculating the filter order for the EOG thinking length
[filter_order.eog.thinking.filtered.low, Wn.eog.thinking.filtered.low] =    buttord(50/fs,65/fs,rp,rs);
[filter_order.eog.thinking.filtered.high,Wn.eog.thinking.filtered.high] =   buttord(0.5/fs,0.01/fs,rp,rs);

% Calculating the filter order for the EOG baseline length
[filter_order.eog.baseline.filtered.low,Wn.eog.baseline.filtered.low] =     buttord(50/fs,65/fs,rp,rs);
[filter_order.eog.baseline.filtered.high,Wn.eog.baseline.filtered.high] =   buttord(0.5/fs,0.01/fs,rp,rs);

% Calculating the filter order for the EMG thinking length
[filter_order.emg.thinking.filtered.low, Wn.emg.thinking.filtered.low] =    buttord(200/fs,240/fs,rp,rs);
[filter_order.emg.thinking.filtered.high,Wn.emg.thinking.filtered.high] =   buttord(50/fs,5/fs,rp,rs);

% Calculating the filter order for the EMG baseline length
[filter_order.emg.baseline.filtered.low,Wn.emg.baseline.filtered.low] =     buttord(200/fs,240/fs,rp,rs);
[filter_order.emg.baseline.filtered.high,Wn.emg.baseline.filtered.high] =   buttord(50/fs,5/fs,rp,rs);

%% Calculating the filters for EEG
a = []; b =[];
% Calculating the filter for the EEG thinking length
[b.eeg.thinking.wideband.low, a.eeg.thinking.wideband.low] =    butter(filter_order.eeg.thinking.wideband.low, Wn.eeg.thinking.wideband.low, 'low');       %filter_order.eeg.thinking
[b.eeg.thinking.wideband.high, a.eeg.thinking.wideband.high] =  butter(filter_order.eeg.thinking.wideband.high, Wn.eeg.thinking.wideband.high, 'high');    %filter_order.eeg.thinking
[b.eeg.thinking.delta.low, a.eeg.thinking.delta.low] =          butter(filter_order.eeg.thinking.delta.low, Wn.eeg.thinking.delta.low, 'low');     %filter_order.eeg.thinking
[b.eeg.thinking.delta.high, a.eeg.thinking.delta.high] =        butter(filter_order.eeg.thinking.delta.high, Wn.eeg.thinking.delta.high, 'high');  %filter_order.eeg.thinking
[b.eeg.thinking.theta.low, a.eeg.thinking.theta.low] =          butter(filter_order.eeg.thinking.theta.low, Wn.eeg.thinking.theta.low, 'low'); 	%filter_order.eeg.thinking
[b.eeg.thinking.theta.high, a.eeg.thinking.theta.high] =        butter(filter_order.eeg.thinking.theta.high, Wn.eeg.thinking.theta.high, 'high');  %filter_order.eeg.thinking
[b.eeg.thinking.alpha.low, a.eeg.thinking.alpha.low] =          butter(filter_order.eeg.thinking.alpha.low, Wn.eeg.thinking.alpha.low, 'low');     %filter_order.eeg.thinking
[b.eeg.thinking.alpha.high, a.eeg.thinking.alpha.high] =        butter(filter_order.eeg.thinking.alpha.high, Wn.eeg.thinking.alpha.high, 'high');  %filter_order.eeg.thinking
[b.eeg.thinking.beta.low, a.eeg.thinking.beta.low] =            butter(filter_order.eeg.thinking.beta.low, Wn.eeg.thinking.beta.low, 'low');       %filter_order.eeg.thinking
[b.eeg.thinking.beta.high, a.eeg.thinking.beta.high] =          butter(filter_order.eeg.thinking.beta.high, Wn.eeg.thinking.beta.high, 'high');    %filter_order.eeg.thinking
% figure,freqz(b.eeg.thinking.wideband.low,a.eeg.thinking.wideband.low);
% figure,freqz(b.eeg.thinking.wideband.high,a.eeg.thinking.wideband.high);
% figure,freqz(b.eeg.thinking.delta.low,a.eeg.thinking.delta.low);
% figure,freqz(b.eeg.thinking.delta.high,a.eeg.thinking.delta.high);
% figure,freqz(b.eeg.thinking.theta.low,a.eeg.thinking.theta.low);
% figure,freqz(b.eeg.thinking.theta.high,a.eeg.thinking.theta.high);
% figure,freqz(b.eeg.thinking.alpha.low,a.eeg.thinking.alpha.low);
% figure,freqz(b.eeg.thinking.alpha.high,a.eeg.thinking.alpha.high);
% figure,freqz(b.eeg.thinking.beta.low,a.eeg.thinking.beta.low);
% figure,freqz(b.eeg.thinking.beta.high,a.eeg.thinking.beta.high);

% Calculating the filter for the EEG baseline length
[b.eeg.baseline.wideband.low, a.eeg.baseline.wideband.low] =    butter(filter_order.eeg.baseline.wideband.low, Wn.eeg.baseline.wideband.low, 'low');       %filter_order.eeg.baseline
[b.eeg.baseline.wideband.high, a.eeg.baseline.wideband.high] =  butter(filter_order.eeg.baseline.wideband.high, Wn.eeg.baseline.wideband.high, 'high');    %filter_order.eeg.baseline
[b.eeg.baseline.delta.low, a.eeg.baseline.delta.low] =          butter(filter_order.eeg.baseline.delta.low, Wn.eeg.baseline.delta.low, 'low');     %filter_order.eeg.baseline
[b.eeg.baseline.delta.high, a.eeg.baseline.delta.high] =        butter(filter_order.eeg.baseline.delta.high, Wn.eeg.baseline.delta.high, 'high');  %filter_order.eeg.baseline
[b.eeg.baseline.theta.low, a.eeg.baseline.theta.low] =          butter(filter_order.eeg.baseline.theta.low, Wn.eeg.baseline.theta.low, 'low'); 	%filter_order.eeg.baseline
[b.eeg.baseline.theta.high, a.eeg.baseline.theta.high] =        butter(filter_order.eeg.baseline.theta.high, Wn.eeg.baseline.theta.high, 'high');  %filter_order.eeg.baseline
[b.eeg.baseline.alpha.low, a.eeg.baseline.alpha.low] =          butter(filter_order.eeg.baseline.alpha.low, Wn.eeg.baseline.alpha.low, 'low');     %filter_order.eeg.baseline
[b.eeg.baseline.alpha.high, a.eeg.baseline.alpha.high] =        butter(filter_order.eeg.baseline.alpha.high, Wn.eeg.baseline.alpha.high, 'high');  %filter_order.eeg.baseline
[b.eeg.baseline.beta.low, a.eeg.baseline.beta.low] =            butter(filter_order.eeg.baseline.beta.low, Wn.eeg.baseline.beta.low, 'low');       %filter_order.eeg.baseline
[b.eeg.baseline.beta.high, a.eeg.baseline.beta.high] =          butter(filter_order.eeg.baseline.beta.high, Wn.eeg.baseline.beta.high, 'high');    %filter_order.eeg.baseline
% figure,freqz(b.eeg.baseline.wideband.low,a.eeg.baseline.wideband.low);
% figure,freqz(b.eeg.baseline.wideband.high,a.eeg.baseline.wideband.high);
% figure,freqz(b.eeg.baseline.delta.low,a.eeg.baseline.delta.low);
% figure,freqz(b.eeg.baseline.delta.high,a.eeg.baseline.delta.high);
% figure,freqz(b.eeg.baseline.theta.low,a.eeg.baseline.theta.low);
% figure,freqz(b.eeg.baseline.theta.high,a.eeg.baseline.theta.high);
% figure,freqz(b.eeg.baseline.alpha.low,a.eeg.baseline.alpha.low);
% figure,freqz(b.eeg.baseline.alpha.high,a.eeg.baseline.alpha.high);
% figure,freqz(b.eeg.baseline.beta.low,a.eeg.baseline.beta.low);
% figure,freqz(b.eeg.baseline.beta.high,a.eeg.baseline.beta.high);

%% Calculating the filters for EOG
% Calculating the IIR filter for the EOG thinking length
[b.eog.thinking.filtered.low, a.eog.thinking.filtered.low] =    butter(filter_order.eog.thinking.filtered.low, Wn.eog.thinking.filtered.low, 'low');       %filter_order.eeg.thinking
[b.eog.thinking.filtered.high, a.eog.thinking.filtered.high] =  butter(filter_order.eog.thinking.filtered.high, Wn.eog.thinking.filtered.high, 'high');    %filter_order.eeg.thinking
% Calculating the filter for the EOG baseline length
[b.eog.baseline.filtered.low, a.eog.baseline.filtered.low] =    butter(filter_order.eog.baseline.filtered.low, Wn.eog.baseline.filtered.low, 'low');       %filter_order.eeg.thinking
[b.eog.baseline.filtered.high, a.eog.baseline.filtered.high] =  butter(filter_order.eog.baseline.filtered.high, Wn.eog.baseline.filtered.high, 'high');    %filter_order.eeg.thinking

%% Calculating the filters for EMG
% Calculating the IIR filter for the EMG thinking length
[b.emg.thinking.filtered.low, a.emg.thinking.filtered.low] =    butter(filter_order.emg.thinking.filtered.low, Wn.emg.thinking.filtered.low, 'low');       %filter_order.eeg.thinking
[b.emg.thinking.filtered.high, a.emg.thinking.filtered.high] =  butter(filter_order.emg.thinking.filtered.high, Wn.emg.thinking.filtered.high, 'high');    %filter_order.eeg.thinking
% Calculating the filter for the EMG baseline length
[b.emg.baseline.filtered.low, a.emg.baseline.filtered.low] =    butter(filter_order.emg.baseline.filtered.low, Wn.emg.baseline.filtered.low, 'low');       %filter_order.eeg.thinking
[b.emg.baseline.filtered.high, a.emg.baseline.filtered.high] =  butter(filter_order.emg.baseline.filtered.high, Wn.emg.baseline.filtered.high, 'high');    %filter_order.eeg.thinking


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
            eeg_thinking.wideband(i,:) = filtfilt(b.eeg.thinking.wideband.high, a.eeg.thinking.wideband.high, double(eeg_thinking.raw(i,:)));
            eeg_thinking.wideband(i,:) = filtfilt(b.eeg.thinking.wideband.low, a.eeg.thinking.wideband.low, double(eeg_thinking.wideband(i,:)));
            eeg_thinking.delta(i,:) = filtfilt(b.eeg.thinking.delta.high, a.eeg.thinking.delta.high, double(eeg_thinking.raw(i,:)));
            eeg_thinking.delta(i,:) = filtfilt(b.eeg.thinking.delta.low, a.eeg.thinking.delta.low, double(eeg_thinking.delta(i,:)));
            eeg_thinking.theta(i,:) = filtfilt(b.eeg.thinking.theta.high, a.eeg.thinking.theta.high, double(eeg_thinking.raw(i,:)));
            eeg_thinking.theta(i,:) = filtfilt(b.eeg.thinking.theta.low, a.eeg.thinking.theta.low, double(eeg_thinking.theta(i,:)));
            eeg_thinking.alpha(i,:) = filtfilt(b.eeg.thinking.alpha.high, a.eeg.thinking.alpha.high, double(eeg_thinking.raw(i,:)));
            eeg_thinking.alpha(i,:) = filtfilt(b.eeg.thinking.alpha.low, a.eeg.thinking.alpha.low, double(eeg_thinking.alpha(i,:)));
            eeg_thinking.beta(i,:) = filtfilt(b.eeg.thinking.beta.high, a.eeg.thinking.beta.high, double(eeg_thinking.raw(i,:)));
            eeg_thinking.beta(i,:) = filtfilt(b.eeg.thinking.beta.low, a.eeg.thinking.beta.low, double(eeg_thinking.beta(i,:)));
            
            %Applying the bandpass filter to the baseline length
            eeg_baseline.wideband(i,:) = filtfilt(b.eeg.baseline.wideband.high, a.eeg.baseline.wideband.high, double(eeg_baseline.raw(i,:)));
            eeg_baseline.wideband(i,:) = filtfilt(b.eeg.baseline.wideband.low, a.eeg.baseline.wideband.low, double(eeg_baseline.wideband(i,:)));
            eeg_baseline.delta(i,:) = filtfilt(b.eeg.baseline.delta.high, a.eeg.baseline.delta.high, double(eeg_baseline.raw(i,:)));
            eeg_baseline.delta(i,:) = filtfilt(b.eeg.baseline.delta.low, a.eeg.baseline.delta.low, double(eeg_baseline.delta(i,:)));
            eeg_baseline.theta(i,:) = filtfilt(b.eeg.baseline.theta.high, a.eeg.baseline.theta.high, double(eeg_baseline.raw(i,:)));
            eeg_baseline.theta(i,:) = filtfilt(b.eeg.baseline.theta.low, a.eeg.baseline.theta.low, double(eeg_baseline.theta(i,:)));
            eeg_baseline.alpha(i,:) = filtfilt(b.eeg.baseline.alpha.high, a.eeg.baseline.alpha.high, double(eeg_baseline.raw(i,:)));
            eeg_baseline.alpha(i,:) = filtfilt(b.eeg.baseline.alpha.low, a.eeg.baseline.alpha.low, double(eeg_baseline.alpha(i,:)));
            eeg_baseline.beta(i,:) = filtfilt(b.eeg.baseline.beta.high, a.eeg.baseline.beta.high, double(eeg_baseline.raw(i,:)));
            eeg_baseline.beta(i,:) = filtfilt(b.eeg.baseline.beta.low, a.eeg.baseline.beta.low, double(eeg_baseline.beta(i,:)));
        elseif diminsionnumber==3%training
            for k=1:1:size(eeg_thinking.raw,3)
                
                %Applying the bandpass filter to the thinking length
                eeg_thinking.wideband(i,:,k) = filtfilt(b.eeg.thinking.wideband.high, a.eeg.thinking.wideband.high, double(eeg_thinking.raw(i,:,k)));
                eeg_thinking.wideband(i,:,k) = filtfilt(b.eeg.thinking.wideband.low, a.eeg.thinking.wideband.low, double(eeg_thinking.wideband(i,:,k)));
                eeg_thinking.delta(i,:,k) = filtfilt(b.eeg.thinking.delta.high, a.eeg.thinking.delta.high, double(eeg_thinking.raw(i,:,k)));
                eeg_thinking.delta(i,:,k) = filtfilt(b.eeg.thinking.delta.low, a.eeg.thinking.delta.low, double(eeg_thinking.delta(i,:,k)));
                eeg_thinking.theta(i,:,k) = filtfilt(b.eeg.thinking.theta.high, a.eeg.thinking.theta.high, double(eeg_thinking.raw(i,:,k)));
                eeg_thinking.theta(i,:,k) = filtfilt(b.eeg.thinking.theta.low, a.eeg.thinking.theta.low, double(eeg_thinking.theta(i,:,k)));
                eeg_thinking.alpha(i,:,k) = filtfilt(b.eeg.thinking.alpha.high, a.eeg.thinking.alpha.high, double(eeg_thinking.raw(i,:,k)));
                eeg_thinking.alpha(i,:,k) = filtfilt(b.eeg.thinking.alpha.low, a.eeg.thinking.alpha.low, double(eeg_thinking.alpha(i,:,k)));
                eeg_thinking.beta(i,:,k) = filtfilt(b.eeg.thinking.beta.high, a.eeg.thinking.beta.high, double(eeg_thinking.raw(i,:,k)));
                eeg_thinking.beta(i,:,k) = filtfilt(b.eeg.thinking.beta.low, a.eeg.thinking.beta.low, double(eeg_thinking.beta(i,:,k)));
                
                %Applying the bandpass filter to the baseline length
                eeg_baseline.wideband(i,:,k) = filtfilt(b.eeg.baseline.wideband.high, a.eeg.baseline.wideband.high, double(eeg_baseline.raw(i,:,k)));
                eeg_baseline.wideband(i,:,k) = filtfilt(b.eeg.baseline.wideband.low, a.eeg.baseline.wideband.low, double(eeg_baseline.wideband(i,:,k)));
                eeg_baseline.delta(i,:,k) = filtfilt(b.eeg.baseline.delta.high, a.eeg.baseline.delta.high, double(eeg_baseline.raw(i,:,k)));
                eeg_baseline.delta(i,:,k) = filtfilt(b.eeg.baseline.delta.low, a.eeg.baseline.delta.low, double(eeg_baseline.delta(i,:,k)));
                eeg_baseline.theta(i,:,k) = filtfilt(b.eeg.baseline.theta.high, a.eeg.baseline.theta.high, double(eeg_baseline.raw(i,:,k)));
                eeg_baseline.theta(i,:,k) = filtfilt(b.eeg.baseline.theta.low, a.eeg.baseline.theta.low, double(eeg_baseline.theta(i,:,k)));
                eeg_baseline.alpha(i,:,k) = filtfilt(b.eeg.baseline.alpha.high, a.eeg.baseline.alpha.high, double(eeg_baseline.raw(i,:,k)));
                eeg_baseline.alpha(i,:,k) = filtfilt(b.eeg.baseline.alpha.low, a.eeg.baseline.alpha.low, double(eeg_baseline.alpha(i,:,k)));
                eeg_baseline.beta(i,:,k) = filtfilt(b.eeg.baseline.beta.high, a.eeg.baseline.beta.high, double(eeg_baseline.raw(i,:,k)));
                eeg_baseline.beta(i,:,k) = filtfilt(b.eeg.baseline.beta.low, a.eeg.baseline.beta.low, double(eeg_baseline.beta(i,:,k)));
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
            %Applying the bandpass filter to eog (thinking and baseline)
            eog_thinking.filtered(i,:) = filtfilt(b.eog.thinking.filtered.high, a.eog.thinking.filtered.high, double(eog_thinking.raw(i,:)));
            eog_thinking.filtered(i,:) = filtfilt(b.eog.thinking.filtered.low, a.eog.thinking.filtered.low, double(eog_thinking.filtered(i,:)));
            
            eog_baseline.filtered(i,:) = filtfilt(b.eog.baseline.filtered.high, a.eog.baseline.filtered.high, double(eog_baseline.raw(i,:)));
            eog_baseline.filtered(i,:) = filtfilt(b.eog.baseline.filtered.low, a.eog.baseline.filtered.low, double(eog_baseline.filtered(i,:)));
        elseif diminsionnumber==3 %training
            for k=1:1:size(eog_thinking.raw,3)
                
                %Applying the bandpass filter to eog (thinking and baseline)
                eog_thinking.filtered(i,:,k) = filtfilt(b.eog.thinking.filtered.high, a.eog.thinking.filtered.high, double(eog_thinking.raw(i,:,k)));
                eog_thinking.filtered(i,:,k) = filtfilt(b.eog.thinking.filtered.low, a.eog.thinking.filtered.low, double(eog_thinking.filtered(i,:,k)));
                
                eog_baseline.filtered(i,:,k) = filtfilt(b.eog.baseline.filtered.high, a.eog.baseline.filtered.high, double(eog_baseline.raw(i,:,k)));
                eog_baseline.filtered(i,:,k) = filtfilt(b.eog.baseline.filtered.low, a.eog.baseline.filtered.low, double(eog_baseline.filtered(i,:,k)));
            end
        end
    end
    
end


%Applying the filters to EMG the channels
if ~isempty(emg_thinking.raw)
    diminsionnumber=length(size(emg_thinking.raw)); % feedback or training
    for i=1:1:size(emg_thinking.raw,1)
        if diminsionnumber==2 % feedback
            %Applying the bandpass filter to emg (thinking and baseline)
            emg_thinking.filtered(i,:) = filtfilt(b.emg.thinking.filtered.high, a.emg.thinking.filtered.high, double(emg_thinking.raw(i,:)));
            emg_thinking.filtered(i,:) = filtfilt(b.emg.thinking.filtered.low, a.emg.thinking.filtered.low, double(emg_thinking.filtered(i,:)));
            
            emg_baseline.filtered(i,:) = filtfilt(b.emg.baseline.filtered.high, a.emg.baseline.filtered.high, double(emg_baseline.raw(i,:)));
            emg_baseline.filtered(i,:) = filtfilt(b.emg.baseline.filtered.low, a.emg.baseline.filtered.low, double(emg_baseline.filtered(i,:)));
        elseif diminsionnumber==3
            for k=1:1:size(emg_thinking.raw,3)
                
                %Applying the bandpass filter to emg (thinking and baseline)
                emg_thinking.filtered(i,:,k) = filtfilt(b.emg.thinking.filtered.high, a.emg.thinking.filtered.high, double(emg_thinking.raw(i,:,k)));
                emg_thinking.filtered(i,:,k) = filtfilt(b.emg.thinking.filtered.low, a.emg.thinking.filtered.low, double(emg_thinking.filtered(i,:,k)));
                
                emg_baseline.filtered(i,:,k) = filtfilt(b.emg.baseline.filtered.high, a.emg.baseline.filtered.high, double(emg_baseline.raw(i,:,k)));
                emg_baseline.filtered(i,:,k) = filtfilt(b.emg.baseline.filtered.low, a.emg.baseline.filtered.low, double(emg_baseline.filtered(i,:,k)));
                
            end
        end
    end
end

end
