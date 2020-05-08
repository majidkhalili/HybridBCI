function [sentence,Fh,trigger,time_length] = CLISLAB_BuildSentences(subpath,sentenceNum,repeatNum,blockNr)
    WavPath      = [subpath 'wav' filesep ];
    filelistname = [subpath date filesep 'Block_' num2str(blockNr) '_senlist'];

    filename = [filelistname '.txt'];
    fid      = fopen(filename,'w+');
    trigger  = [];
    cdate    = date;
    freq     = 44100;

    blankhead = [pwd filesep '001_blank.wav'];

    LWname_True  = dir([WavPath '001_*.wav']);
    LWname_False = dir([WavPath '002_*.wav']);

    blockname = filelistname(end-1:end);

    %WavPath
    %sentenceNum
    if blockNr == 1
        rng shuffle
        randfilename = [cdate(1:4) 'S1randlist'];
        Rnumber = randperm(size(LWname_True,1));
        TSenNum = Rnumber(1:sentenceNum/2);
        FSenNum = Rnumber(end-sentenceNum/2+1:end);
        save(randfilename,'Rnumber');

    else
        randfilename = [cdate(1:4) 'S1randlist'];
        load(randfilename);
        TSenNum = Rnumber((blockNr-1)*sentenceNum/2+1:blockNr*sentenceNum/2);
        FSenNum = Rnumber(end-blockNr*sentenceNum/2+1:end-(blockNr-1)*sentenceNum/2);
    end

    TotalSenNum = sentenceNum;


    HeadName = {};
    LWName = {};
    Trigger = {};

    TempOrder = [];


    for i=1:length(TSenNum)

        LWName{end+1}  = LWname_True(TSenNum(i)).name;
        TempOrder      = [TempOrder 1];
        Trigger{end+1} = 1;
        LWName{end+1}  = LWname_False(FSenNum(i)).name;
        Trigger{end+1} = 0;
        TempOrder      = [TempOrder 0];

    end
    
    AllHeadName  = {};
AllLWName    = {};
AllTrigger   = {};
for j=1:repeatNum

        RandOrder = randperm(size(LWName,2));
        TempOrder = TempOrder(RandOrder);
        AllLWName = [AllLWName LWName(RandOrder)];
        AllTrigger = [AllTrigger Trigger(RandOrder)];
end;

       
        
sentence = {};
Fh = {};
time_length  = {};


for k = 1: length(AllLWName)
    
    [sentence{end+1},Fh{end+1}]=audioread(blankhead);
    time_length{end+1}= length(sentence{end})/freq;
    [sentence{end+1},Fh{end+1}]=audioread([WavPath AllLWName{k}]);
    time_length{end+1}= length(sentence{end})/freq;

    fprintf(fid,[AllLWName{k} '\r\n']);
    fprintf(fid,[num2str(AllTrigger{k}) '\r\n']);
    trigger = [trigger AllTrigger{k}];

end
