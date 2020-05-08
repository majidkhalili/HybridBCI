function [sentence,Fh,label] = CLISLAB_BuildSentences(subpath,sentenceNum,repeatNum,blockNr,balancedSentences)

if nargin < 5
    balancedSentences = 1;
end

prefixT = '001_';
prefixF = '002_';

% this will be removed
blankhead = [pwd filesep '001_blank.wav'];

wavpath      = fullfile(subpath,'Audios', 'Questions');

% find the sentences
allT = dir([wavpath filesep prefixT '*.wav']);
allT = string({allT.name});
allF = dir([wavpath filesep prefixF '*.wav']);
allF = string({allF.name});

% use only the sentences which name exist for both true and false
allT = allT(contains(allT.extractAfter(prefixT),allF.extractAfter(prefixF)));
allF = allF(contains(allF.extractAfter(prefixF),allT.extractAfter(prefixT)));
allTF = [allT allF];

% load sentences already presented in the same day
oldTF = strings(1,0);
for i = 1:blockNr-1
    sentenceList = strings(1,0);
    load(fullfile(subpath,date,['config_Block' num2str(i) '.mat']),'sentenceList');
    oldTF = [oldTF sentenceList];
end
% caluclate how many time each sentences was presented
oldTFCountIdx = cellfun(@(x) sum(ismember(oldTF,x)),allTF,'un',0);
oldTFCountIdx = cell2mat(oldTFCountIdx);

% discard the sentences that were presented more
oldTF = allTF(oldTFCountIdx == max(oldTFCountIdx));
newTF = allTF(~contains(allTF,oldTF));
if isempty(newTF)
    newTF = allTF;
end

% separate true and false new sentences
newT = newTF(newTF.startsWith(prefixT));
newF = newTF(newTF.startsWith(prefixF));
newT = shuffle(newT);
newF = shuffle(newF);

% if balanced for the false sentences use the same selected for the true
if balancedSentences
    newF = newT.extractAfter(prefixT);
    newF = newF.insertBefore(1,prefixF);
    nonExistingAudioF = ~contains(newF,allF);
    newF(nonExistingAudioF) = [];
    newT(nonExistingAudioF) = [];
end
% check if there are enough sentences
otherT = strings(1,0);
otherF = strings(1,0);
if length(newT)+length(newF) < sentenceNum
    otherT = allT(~contains(allT,newT));
    otherT = Shuffle(otherT);
    
    if balancedSentences
        otherF = otherT.extractAfter(prefixT);
        otherF = otherF.insertBefore(1,prefixF);
        nonExistingAudioF = ~contains(otherF,allF);
        otherF(nonExistingAudioF) = [];
        otherT(nonExistingAudioF) = [];
    else
        otherF = allF(~contains(allF,newF));
        otherF = Shuffle(otherF);
    end
end
newT = [newT otherT];
newF = [newF otherF];

% Select the sentences
T = newT(1:ceil(sentenceNum/2));
F = newF(1:ceil(sentenceNum/2));
TF = [T F];
TF = TF(1:sentenceNum);

% Check the repetition and form the final list of sentences
sentenceList = strings(1,length(TF)*repeatNum);
for i = 1:repeatNum
    tempTF = Shuffle(TF);
    sentenceList((i-1)*sentenceNum+1:i*sentenceNum) = tempTF;
end

% Load the audiofile
sentence = cell(1,sentenceNum*repeatNum);
Fh = cell(1,sentenceNum*repeatNum);
label = zeros(1,sentenceNum*repeatNum);

for i = 1:sentenceNum*repeatNum
    
    [sentence{i},Fh{i}]=audioread(fullfile(wavpath, sentenceList(i)));
    
    if sentenceList(i).startsWith(prefixT)
        label(i) = 1;
    elseif sentenceList(i).startsWith(prefixF)
        label(i) = 0;
    else
        label(i) = 2;
    end
end

% Save the sentence list
blockname = fullfile(subpath,date,['config_Block' num2str(blockNr) '.mat']);
save(blockname,'sentenceList','-append');



% %WavPath
% %sentenceNum
% if blockNr == 1
%     rng shuffle
%     randfilename = [cdate(1:4) 'S1randlist'];
%     Rnumber = randperm(size(LWname_True,1));
%     TSenNum = Rnumber(1:sentenceNum/2);
%     FSenNum = Rnumber(end-sentenceNum/2+1:end);
%     save(randfilename,'Rnumber');
%     
% else
%     randfilename = [cdate(1:4) 'S1randlist'];
%     load(randfilename);
%     TSenNum = Rnumber((blockNr-1)*sentenceNum/2+1:blockNr*sentenceNum/2);
%     FSenNum = Rnumber(end-blockNr*sentenceNum/2+1:end-(blockNr-1)*sentenceNum/2);
% end
% 
% TotalSenNum = sentenceNum;
% 
% 
% HeadName = {};
% LWName = {};
% Trigger = {};
% 
% TempOrder = [];
% 
% 
% for i=1:length(TSenNum)
%     
%     LWName{end+1}  = LWname_True(TSenNum(i)).name;
%     TempOrder      = [TempOrder 1];
%     Trigger{end+1} = 1;
%     LWName{end+1}  = LWname_False(FSenNum(i)).name;
%     Trigger{end+1} = 0;
%     TempOrder      = [TempOrder 0];
%     
% end
% 
% AllHeadName  = {};
% AllLWName    = {};
% AllTrigger   = {};
% for j=1:repeatNum
%     
%     RandOrder = randperm(size(LWName,2));
%     TempOrder = TempOrder(RandOrder);
%     AllLWName = [AllLWName LWName(RandOrder)];
%     AllTrigger = [AllTrigger Trigger(RandOrder)];
% end;
% 
% 
% 
% sentence = {};
% Fh = {};
% time_length  = {};
% 
% 
% for k = 1: length(AllLWName)
%     
%     [sentence{end+1},Fh{end+1}]=audioread(blankhead);
%     time_length{end+1}= length(sentence{end})/Fh{end};
%     [sentence{end+1},Fh{end+1}]=audioread([wavpath AllLWName{k}]);
%     time_length{end+1}= length(sentence{end})/Fh{end};
%     
%     fprintf(fid,[AllLWName{k} '\r\n']);
%     fprintf(fid,[num2str(AllTrigger{k}) '\r\n']);
%     label = [label AllTrigger{k}];
%     
% end
% fclose(fid);
% 
