function [baseline, preproc_thinking] = CLISLAB_NIRS_Online_Preprocessing(wl_baseline, wl_thinking, fs, conversion_type, baseline_reference, filter_type, filter_cut_freqs, interprocess)
% CLISLAB_NIRS_ONLINE_PREPROCESSING Calls to the correspondant NIRS preprocessing functions.
% INPUTS:
%   wl_baseline         :   Array containing the baseline data. [Channels X Timepoints X Trials].
%   wl_thinking         :   Array containing the thinking data. [Channels X Timepoints X Trials].
%   fs                  :   Sampling rate value.
%   conversion_type     :   String with the name of the conversion function to be applied. Selected by user.
%   baseline_reference  :   String with the name of the baseline reference selection. Selected by user.
%   filter_type         :   String with the name of the filter to be applied. Selected by user.
%   filter_cut_freqs    :   Array with filter range (lower and upper values). Selected by user.
%   interprocess        :   Cell array containing the name of the processing functions to be applied. Selected by user.
%
% OUTPUTS:
%   baseline            : Struct containing the processed baseline data. The struct is divided in 3 structs: HbO, HbR and HbT. Some of these structs 
%                         could not appear depending on user selection. Each struct has the shape as [Channels X Timepoints X Trials].
%   preproc_thinking    : Struct containing the processed thinking data. The struct is divided in 3 structs: HbO, HbR and HbT. Some of these structs 
%                         could not appear depending on user selection. Each struct has the shape as [Channels X Timepoints X Trials].

oxydeoxyConversion = str2func(conversion_type);
filterFunction = str2func(filter_type);

[od_thinking, od_baseline] = oxydeoxyConversion(wl_thinking, wl_baseline,fs, baseline_reference);

baseline.hbo = od_baseline(1:end/2,:,:);
baseline.hbr = od_baseline(end/2+1:end,:,:);
baseline.hbt = baseline.hbo+baseline.hbr;

thinking.hbo = od_thinking(1:end/2,:,:);
thinking.hbr = od_thinking(end/2+1:end,:,:);
thinking.hbt = thinking.hbo+thinking.hbr;

[filtered_baseline, filtered_thinking] = filterFunction(baseline,thinking,fs,filter_cut_freqs);
filtered_baseline.hbt = filtered_baseline.hbo+filtered_baseline.hbr;
filtered_thinking.hbt = filtered_thinking.hbo+filtered_thinking.hbr;

interprocess_baseline = filtered_baseline;
interprocess_thinking = filtered_thinking;
% Interprocess Functions
if ~isempty(interprocess)
    for k=1:length(interprocess)
        [interprocess_baseline, interprocess_thinking] = feval(char(interprocess{k}),interprocess_baseline, interprocess_thinking);
    end
end

baseline = interprocess_baseline;
preproc_thinking = interprocess_thinking;

end
