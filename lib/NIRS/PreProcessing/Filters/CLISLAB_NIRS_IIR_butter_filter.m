function [baseline,thinking] = CLISLAB_NIRS_IIR_butter_filter(inputSignalBaseline,inputSignalThinking,fs,filteringParam)
%UNTITLED Butterworth filtering the input signal 
%   Please specify the mode
% mode = 'low'
% mode = 'high'
% mode = 'bandpass'
% mode = 'stop'
% fs : sample frequency [Hz]
% The filtering will have a passband ripple of no more than Rp dB and a stopband attenuation of at least Rs dB. Wp and Ws are
% the passband and stopband edge frequencies, in Hz.
%     (where 1 corresponds to pi radians/sample). For example,
%         Lowpass:    Wp = 10,      Ws = 20
%         Highpass:   Wp = 20,      Ws = 10
%         Bandpass:   Wp = [20 70], Ws = [10 80]
%         Bandstop:   Wp = [10 80], Ws = [20  70]




%WpNormalized = filteringParam.passingHertz*2/fs;


WpNormalized = [filteringParam(1)*2/fs,filteringParam(2)*2/fs];

%WsNormalized = filteringParam.stoppingHertz*2/fs;

%Stopband edge frequencies are automatically calculate from the bandpass
%edges as follows 

WsNormalized = [WpNormalized(1)/2 ,  WpNormalized(2)*2];


%Rp = filteringParam.ripplePassBand; 
Rp = 1; %[db]
%Rs = filteringParam.rippleStopBand;
Rs = 10; %[db]
%mode = filteringParam.mode;
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

