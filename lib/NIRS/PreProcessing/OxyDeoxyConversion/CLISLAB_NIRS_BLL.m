function [od_thinking,od_baseline] = CLISLAB_NIRS_BLL(wl_thinking, wl_baseline,fs,baselineReference)
% CLISLAB_NIRS_BLL Calculates 
% INPUTS:
%   wl_thinking         :   Array containing the thinking data. [Channels X Timepoints X Trials].
%   wl_baseline         :   Array containing the baseline data. [Channels X Timepoints X Trials].
%   fs                  :   Sampling rate value.
%   baseline_reference  :   String with the name of the baseline reference selection. Selected by user.
%
% OUTPUTS:
%   od_thinking         :   Array with the processed thinking data with shape as [Channels X Timepoints X Trials].
%   od_baseline         :   Array with the processed baseline data with shape as [Channels X Timepoints X Trials].

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                                                      %
% The original code was written by Paul Koch, BNIC2007 %
% and has been adapted by NIRx Medical Technologies.   %
% Current version (below) as of November 16th, 2016    %
%                                                      %
% Questions can be submitted to the NIRx Help Center.  %
%                                                      %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


% Modified by Giovanni

% The Lambert beer law doesn't allow to calculate absolute values of
% Hbo/Hbr concentration, but just a difference of concentration instead.
% For this reason a "baseline" must be chosen as a reference. In this
% function  the average values depends from the 'baselineReference' The output values are thus 
% intended as difference of concentration from the above mentioned
% reference. The 'self' value is DEPRECATED,has been implemented just for consistency with previous
% functions.

%       Available values for baselineReference:
%       'self' DEPRECATED !!!
%       'baseline' 
%       'baseline&thinking' 


% define param
taskLength = size(wl_thinking,2);
baselineLength = size(wl_baseline,2);

% preallocations

oxy_baseline = zeros(size(wl_thinking,1)/2,size(wl_thinking,2),size(wl_thinking,3));
deoxy_baseline = zeros(size(wl_thinking,1)/2,size(wl_thinking,2),size(wl_thinking,3));
oxy_thinking = zeros(size(wl_thinking,1)/2,size(wl_thinking,2),size(wl_thinking,3));
deoxy_thinking = zeros(size(wl_thinking,1)/2,size(wl_thinking,2),size(wl_thinking,3));


% Data rearranged as timepoints ( base + task period) X channels ([w1, w2]) X trials
wholeDataRearranged = [permute(wl_baseline,[2,1,3])  ;permute(wl_thinking,[2,1,3])];


for currentTrial = 1 : size(wl_thinking,3)
    
        
    dat =wholeDataRearranged(:,:,currentTrial);
    s1=size(dat,1);
    s2=size(dat,2);
    dat=dat+eps;
    
    switch baselineReference
        case 'Self'
            % Baseline reference will be baseline average
            % Thinking reference will be thinking average
            [convertedDataBaseline] = CLISLAB_NIRS_BLL(wl_baseline, wl_baseline,fs,'Baseline');
            [convertedDataThinking] = CLISLAB_NIRS_BLL(wl_thinking, wl_thinking,fs,'Baseline');
            convertedData.baselineHbo = convertedDataBaseline(1:s2/2,:,:);
            convertedData.thinkingHbo = convertedDataThinking(1:s2/2,:,:);
            convertedData.baselineHbr = convertedDataBaseline(s2/2+1:end,:,:);
            convertedData.thinkingHbr = convertedDataThinking(s2/2+1:end,:,:);
            warning (['The ''self'' method as reference for oxy/deoxy conversion is deprecated'])
            % ReshapingForNewHybridBci
            od_thinking = cat(1,convertedData.thinkingHbo,convertedData.thinkingHbr);
            od_baseline = cat(1,convertedData.baselineHbo,convertedData.baselineHbr);
            return
            
            
        case 'Baseline'
            % Baseline reference will be baseline average
            % Thinking reference will be baseline average
            
            bl_loweWL =    mean(dat(1:s1/2,1     :  s2/2));%lower Wavelength
            bl_highWL =    mean(dat(1:s1/2,s2/2+1:  end));%higher Wavelength
            
            
            
        case 'Whole Signal'
            % Baseline reference will be [baseline,thinking] average
            % Thinking reference will be [baseline,thinking] average
            
            bl_loweWL =    mean(dat(:,1:s2/2));%lower Wavelength
            bl_highWL =    mean(dat(:,s2/2+1:  end));%higher Wavelength
            
            
            
            %case 'blockBaseline'
            
    end
    
    
    notFiltered_highWL = dat(:,s2/2+1:end);
    notFiltered_loweWL = dat(:,1:s2/2);
    
    %Initialize variables
    Att_highWL = zeros(s1,s2/2);
    Att_loweWL = zeros(s1,s2/2);
    oxy = zeros(s1,s2/2);
    deoxy = zeros(s1,s2/2);
    

    for i=1:s2/2
        Att_highWL(:,i)= real(-log( notFiltered_highWL(:,i) / bl_highWL(1,i) ))    ;
        Att_loweWL(:,i)= real(-log( notFiltered_loweWL(:,i) / bl_loweWL(1,i) ))    ;
        C= [Att_highWL;Att_loweWL];
    end
    
    A=C;
    
    %Absorption Coefficients
    e = [2.5264 1.7986; %850nm-oxy ; 850nm-deoxy
        1.4866 3.8437]; %760nm-oxy ; 760nm-deoxy
    
    %Differential Pathlength Factor
    DPF = [6.38 7.25]; %Essenpreis et al 1993 - 850nm and 760nm, respectively
    %Alternative calculation: https://www.ncbi.nlm.nih.gov/pubmed/24121731
    
    %Inter-optode distance (mm)
    Loptoddistance  = 30;
    
    %modified Beer-Lambert Law
    e=e/10;
    e2=   e.* [DPF' DPF']  .*  Loptoddistance;
    
    B = A;
    clear A
    
    %Compute oxy and deoxy
    for i=1:s1
        A(1,:) = B(i,:); A(2,:) = B(s1+i,:);
        c= ( inv(e2)*A  )' ;
        oxy(i,:)       =c(:,1)'; %in mmol/l
        deoxy(i,:)       =c(:,2)'; %in mmol/l
    end
    
    oxy_baseline(:,1:baselineLength,currentTrial) = oxy(1:baselineLength,:)';
    deoxy_baseline(:,1:baselineLength,currentTrial) = deoxy(1:baselineLength,:)';
    oxy_thinking(:,1:taskLength,currentTrial) = oxy(baselineLength+1:end,:)'; 
    deoxy_thinking(:,1:taskLength,currentTrial) = deoxy(baselineLength+1:end,:)'; 
 
    
end

convertedData.baselineHbo = oxy_baseline;
convertedData.thinkingHbo = oxy_thinking;
convertedData.baselineHbr = deoxy_baseline;
convertedData.thinkingHbr = deoxy_thinking;


%Output Reshaping for newHybridBCI

od_thinking = cat(1,convertedData.thinkingHbo,convertedData.thinkingHbr);
od_baseline = cat(1,convertedData.baselineHbo,convertedData.baselineHbr);



 

end
