function [baseline, preproc_thinking] = CLISLAB_NIRS_Online_Preprocessing(wl_baseline, wl_thinking, fs, conversion_type, baseline_reference, filter_type, filter_cut_freqs, interprocess)

oxydeoxyConversion = str2func(conversion_type);
filterFunction = str2func(filter_type);
%baselineCorrection = str2func(baseline_reference);

[od_thinking, od_baseline] = oxydeoxyConversion(wl_thinking, wl_baseline,fs, baseline_reference);

%baselineCorr_thinking = baselineCorrection(od_thinking,od_baseline);

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