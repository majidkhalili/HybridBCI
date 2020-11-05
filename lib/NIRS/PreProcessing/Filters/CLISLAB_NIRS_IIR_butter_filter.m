function [baseline,thinking] = CLISLAB_NIRS_IIR_butter_filter(inputSignalBaseline,inputSignalThinking,fs,filteringParam)
% CLISLAB_NIRS_IIR_BUTTER_FILTER Calculates the filtered signal using IIR Butterworth filter.
% INPUTS:
%   inputSignalBaseline  :  Struct with the baseline signals to be filtered. The struct is divided in 3 structs: HbO, HbR and HbT.
%                           Some of these structs could not appear depending on user selection. 
%                             - HbO     : Struct with a shape as [Channels X Timepoints X Trials]. 
%                             - HbR     : Struct with a shape as [Channels X Timepoints X Trials]. 
%                             - HbT     : Struct with a shape as [Channels X Timepoints X Trials].
%   inputSignalThinking  :  Struct with the thinking signals to be filtered. The struct is divided in 3 structs: HbO, HbR and HbT.
%                           Some of these structs could not appear depending on user selection. 
%                             - HbO     : Struct with a shape as [Channels X Timepoints X Trials]. 
%                             - HbR     : Struct with a shape as [Channels X Timepoints X Trials]. 
%                             - HbT     : Struct with a shape as [Channels X Timepoints X Trials].
%   fs                   :  Sampling rate value.
%   filteringParam       :  Array with band's boundaries.
%      
% OUTPUTS:
%   feature  : Struct with the value of the correspondant feature. The struct is divided in 2 structs: featureLabels and features.
%               - featureLabels : String array with the name of the feature and the correspondant source with a shape as [(3 X Channels)].
%               - features      : Array with the feature values with shape [Trials X (3 X Channels)].

WpNormalized = [filteringParam(1)*2/fs,filteringParam(2)*2/fs];

WsNormalized = [WpNormalized(1)/2 ,  WpNormalized(2)*2];

Rp = 1; %[db]

Rs = 10; %[db]

mode = 'bandpass';

[N, Wn] = buttord(WpNormalized, WsNormalized, Rp, Rs);
[B,A] = butter(N,Wn,mode);

baselineHbo=inputSignalBaseline.hbo;
thinkingHbo=inputSignalThinking.hbo ;
baselineHbr=inputSignalBaseline.hbr;
thinkingHbr=inputSignalThinking.hbr;


% filtfilt operates just along the first dimension > 1
filteredSignal.baselineHbo = permute(filtfilt(B, A,permute(baselineHbo,[2,1,3])),[2,1,3]);
filteredSignal.thinkingHbo = permute(filtfilt(B, A,permute(thinkingHbo,[2,1,3])),[2,1,3]);
filteredSignal.baselineHbr = permute(filtfilt(B, A,permute(baselineHbr,[2,1,3])),[2,1,3]);
filteredSignal.thinkingHbr = permute(filtfilt(B, A,permute(thinkingHbr,[2,1,3])),[2,1,3]);

% Reshape for newHybridBci

baseline.hbo = filteredSignal.baselineHbo;
baseline.hbr = filteredSignal.baselineHbr;
thinking.hbo = filteredSignal.thinkingHbo;
thinking.hbr = filteredSignal.thinkingHbr;

end
