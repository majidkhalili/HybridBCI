classdef Paradigm_Speller < Paradigm
    properties
        wavPath = '';
        wavYes = [];
        wavNo = [];
        wavNC = [];
        wavFbCurrent = [];
        wavFbWord = [];
        voice = "";
        pace = 0;
        speller = [];
        numSectors = [];
        numLetters = [];
        startingString = "";
        bag1 = [];
        bag2 = [];
        bag3 = [];
        corpusPath = [];
        layoutPath = [];
        nYes = [];
        nNo = [];
        conflict = [];
        currentState = [];
        lastState = [];
        numTrial = 0;
        
        logParadigm = [];
    end
    
    methods
        function obj = Paradigm_Speller(configApp)
            obj.initializeAudio();
            
            obj.wavPath = fullfile(fileparts(mfilename('fullpath')),'Speller','wav');
            [audiodata,~]       = audioread([obj.wavPath filesep 'fb_current.wav']);
            [~, ninchannels]    = size(audiodata);
            obj.wavFbCurrent    = repmat(transpose(audiodata), obj.nrchannels / ninchannels, 1);
            [audiodata,~]       = audioread([obj.wavPath filesep 'fb_word.wav']);
            [~, ninchannels]    = size(audiodata);
            obj.wavFbWord       = repmat(transpose(audiodata), obj.nrchannels / ninchannels, 1);
            
            fbPath = fullfile(fileparts(mfilename('fullpath')),'Speller','wav', 'Feedback');
            [audiodata,~]       = audioread([fbPath filesep 'Yes.wav']);
            [~, ninchannels]    = size(audiodata);
            obj.wavYes          = repmat(transpose(audiodata), obj.nrchannels / ninchannels, 1);
            [audiodata,~]       = audioread([fbPath filesep 'No.wav']);
            [~, ninchannels]    = size(audiodata);
            obj.wavNo           = repmat(transpose(audiodata), obj.nrchannels / ninchannels, 1);
            [audiodata,~]       = audioread([fbPath filesep 'NC.wav']);
            [~, ninchannels]    = size(audiodata);
            obj.wavNC           = repmat(transpose(audiodata), obj.nrchannels / ninchannels, 1);
            
        end
        
        function config = config(obj)
            % Configure the application
            initializeSpeller(obj);
            
            % Save config
            config.voice = obj.voice;
            config.pace = obj.pace;
            config.speller = obj.speller;
            config.startingString = obj.startingString;
            config.corpusPath = obj.corpusPath;
            config.layoutPath = obj.layoutPath;
            config.nYes = obj.nYes;
            config.nNo = obj.nNo;
            config.conflict = obj.conflict;
            
        end
        
        function stim = present_stimulus(obj)
            % Present a stimulus and return it as string
            stim = obj.currentState.name;
            obj.playAudio(obj.currentState.wav);
        end
        
        function fb = present_feedback(obj,answer)
            switch answer
                case 0
                    obj.playAudio(obj.wavYes);
                    fb = 'Yes';
                case 1
                    obj.playAudio(obj.wavNo);
                    fb = 'No';
                otherwise
                    obj.playAudio(obj.wavNC);
                    fb = 'Not classified';
            end
            
            % Check if the new string is updated, in that case play the
            % current string
            if obj.lastState.string ~= obj.currentState.string
                audiodata_head      = obj.wavFbCurrent;
                
                pause_time          = 0.2;
                audiodata_pause     = zeros(2, floor(obj.freq*pause_time));
                
                % Spelling of the last word
                str = obj.currentState.string;
                str = str.split;
                last = str(end);
                last = replace(last, '', ', ');
                str(end) = last;
                str = str.join;
                
                audiodata_tail      = tts(char(str), obj.voice, obj.pace, obj.freq);
                [~, ninchannels]    = size(audiodata_tail);
                audiodata_tail      = repmat(transpose(audiodata_tail), obj.nrchannels / ninchannels, 1);
                
                obj.playAudio([audiodata_head, audiodata_pause, audiodata_tail]);
                
            end
            
        end
        
        function isFinish = next(obj, answer)
            % Process the answer and update the internal state. Return if is
            % the end or not
            
            if nargin < 2
                obj.currentState.type   = 'sector';
                obj.currentState.state  = [1,1];
                obj.currentState.numYes = 0;
                obj.currentState.numNo  = 0;
                obj.currentState.string = obj.startingString;
                obj.updateCurrentStateProperty();
                obj.numTrial = 1;
                isFinish = false;
                
                obj.logParadigm = obj.currentState;
                return
            end
            
            obj.numTrial = obj.numTrial + 1;
            
            % Save the current state as last state
            obj.lastState = obj.currentState;
            
            % Take a decision based on the answer
            decision = obj.takeDecision(answer);
            
            % If no decision repeat the last question with no updates
            if decision == -1
                isFinish = 0;
                obj.logParadigm(end+1) = obj.currentState;
                return
            end
            
            isFinish = obj.updateState(decision);
            
            if ~isFinish
                obj.logParadigm(end+1) = obj.currentState;
            end
        end
        
        function decision = takeDecision(obj,answer)
            % 0: yes, 1: no, -1: no decision
            
            % Update answer counter
            switch answer
                case 0
                    obj.currentState.numYes = obj.currentState.numYes+1;
                case 1
                    obj.currentState.numNo = obj.currentState.numNo+1;
            end
            
            % Take a decision
            if obj.currentState.numYes < obj.nYes && obj.currentState.numNo < obj.nNo
                decision = -1;
                
            elseif obj.currentState.numYes == obj.currentState.numNo
                switch obj.conflict
                    case 'last'
                        % Take the last answer
                        decision = answer;
                        obj.currentState.numYes = 0;
                        obj.currentState.numNo = 0;
                    case 'majority'
                        % Repeat the question to have a majority
                        decision = -1;
                end
                
            else
                % Last answer is the one that gives the final decision
                decision = answer;
                obj.currentState.numYes = 0;
                obj.currentState.numNo = 0;
            end
            
        end
        
        function isFinish = updateState(obj,decision)
            isFinish = 0;
            mostProbWord = '';
            switch decision
                case 1
                    % No case: skip to the following sector or letter
                    switch obj.currentState.type
                        case 'sector'
                            nextState = obj.currentState.state(1) + 1;
                            nextState = mod(nextState,obj.numSectors+1);
                            obj.currentState.state(1) = nextState;
                            
                        case 'letter'
                            currSector = obj.currentState.state(1);
                            nextState = obj.currentState.state(2) + 1;
                            nextState = mod(nextState,obj.numLetters(currSector)+1);
                            obj.currentState.state(2) = nextState;
                        case 'word'
                            if obj.currentState.string.endsWith(" ")
                                obj.currentState.type = 'sector';
                                obj.currentState.state = [0,1];
                            else
                                obj.currentState.type = 'sector';
                                obj.currentState.state = [1,1];
                            end
                    end
                case 0
                    % Check if it was an exit question
                    if obj.currentState.state(1) == 0
                        % Quit the program
                        isFinish = 1;
                        return
                    elseif obj.currentState.state(2) == 0
                        % Go back to sectors
                        obj.currentState.type = 'sector';
                        nextState = obj.currentState.state(1) + 1;
                        nextState = mod(nextState,obj.numSectors+1);
                        obj.currentState.state(1) = nextState;
                        obj.updateCurrentStateProperty();
                        return
                    end
                    
                    % Enter the sector, select a letter or a word
                    switch obj.currentState.type
                        case 'sector'
                            obj.currentState.type = 'letter';
                            obj.currentState.state(2) = 1;
                        case 'letter'
                            obj.updateString();
                            [allMostProbWords, isProbable] = obj.predictWord();
                            if isProbable
                                obj.currentState.type = 'word';
                                mostProbWord = allMostProbWords(1);
                            elseif obj.currentState.string.endsWith(" ")
                                obj.currentState.type = 'sector';
                                obj.currentState.state = [0,1];
                            else
                                obj.currentState.type = 'sector';
                                obj.currentState.state = [1,1];
                            end
                        case 'word'
                            obj.updateString();
                            [allMostProbWords, isProbable] = obj.predictWord();
                            if isProbable
                                obj.currentState.type = 'word';
                                mostProbWord = allMostProbWords(1);
                            else
                                obj.currentState.type = 'sector';
                                obj.currentState.state = [0,1];
                            end
                            
                    end
            end
            obj.updateCurrentStateProperty(mostProbWord);
        end
        
        function obj = updateCurrentStateProperty(obj,word)
            sector = obj.currentState.state(1);
            letter = obj.currentState.state(2);
            if sector == 0
                % Quit the program
                name    = 'Quit program';
                wavfile = obj.speller.exit.sector;
            elseif letter == 0
                % Exit letters and go back to sector
                name    = 'Exit sector';
                wavfile = obj.speller.exit.letter;
            else
                switch obj.currentState.type
                    case 'sector'
                        name = obj.speller.sector(sector).name{1};
                        wavfile = obj.speller.sector(sector).name_wav{1};
                    case 'letter'
                        name = obj.speller.sector(sector).letters{letter};
                        wavfile = obj.speller.sector(sector).letters_wav{letter};
                    case 'word'
                        name = char(word);
                        audiodata_head      = obj.wavFbWord;
                        
                        pause_time          = 0.2;
                        audiodata_pause     = zeros(2, floor(obj.freq*pause_time));
                        
                        audiodata_tail      = tts(name, obj.voice, obj.pace, obj.freq);
                        [~, ninchannels]    = size(audiodata_tail);
                        audiodata_tail      = repmat(transpose(audiodata_tail), obj.nrchannels / ninchannels, 1);
                        
                        wav = [audiodata_head, audiodata_pause, audiodata_tail];
                
                end
            end
            if exist('wavfile','var')
                [audiodata,~]       = audioread(wavfile);
                [~, ninchannels]    = size(audiodata);
                wav                 = repmat(transpose(audiodata), obj.nrchannels / ninchannels, 1);
            end
            
            obj.currentState.name = name;
            obj.currentState.wav = wav;
        end
        
        function obj = updateString(obj)
            currStr = obj.currentState.string;
            switch obj.currentState.type
                case 'letter'
                    switch obj.currentState.name
                        case 'space'
                            obj.currentState.string = currStr + " ";
                        case 'delete'
                            obj.currentState.string = currStr.extractBefore(currStr.strlength);
                        case 'deleteword'
                            str = currStr.split;
                            while ~isempty(str) && str(end).strlength==0
                                str(end) = [];
                            end
                            if isempty(str) || str(end).strlength==0
                                obj.currentState.string = "";
                            else
                                str(end) = [];
                                obj.currentState.string = str.join + " ";
                            end
                        otherwise
                            obj.currentState.string = currStr + obj.currentState.name;
                    end
                case 'word'
                    wordsInString = currStr.split;
                    selectedWord = string(obj.currentState.name);
                    if selectedWord.startsWith(wordsInString(end))
                        wordsInString(end) = selectedWord;
                    else
                        wordsInString(end+1) = selectedWord;
                    end
                    obj.currentState.string = wordsInString.join() + " ";
            end
        end
        
        function [mostProbWords, isProbable] = predictWord(obj,confidence,lengthVocabulary)
            if nargin < 2
                lengthVocabulary = 5;
                confidence = 0.5;
            elseif nargin < 3
                lengthVocabulary = 5;
            end
            
            isProbable = false;
            mostProbWords = [];
            mostProbValues = [];
            
            str = obj.currentState.string;
            allWords = str.split;
            maxSeed = min(length(allWords),3);
            for i = maxSeed:-1:1
                if i == 3
                    ng3 = obj.bag3(strcmp(allWords(end-2),obj.bag3.Ngram(:,1)),:);
                    ng3 = ng3(strcmp(allWords(end-1),ng3.Ngram(:,2)),:);
                    ng3 = ng3(startsWith(ng3.Ngram(:,3),allWords(end)),:);
                    mostProbWords = ng3.Ngram(:,3);
                    mostProbValues = ng3.Count;
                    
                elseif i == 2
                    ng2 = obj.bag2(strcmp(allWords(end-1),obj.bag2.Ngram(:,1)),:);
                    ng2 = ng2(startsWith(ng2.Ngram(:,2),allWords(end)),:);
                    mostProbWords = [mostProbWords; ng2.Ngram(:,2)];
                    mostProbValues = [mostProbValues; ng2.Count];
                    
                else
                    ng1 = obj.bag1(startsWith(obj.bag1.Ngram,allWords(end)),:);
                    mostProbWords = [mostProbWords; ng1.Ngram];
                    mostProbValues = [mostProbValues; ng1.Count];
                end
                
                if length(mostProbWords) >= lengthVocabulary
                    break
                end
                
            end
            
            if isempty(mostProbWords)
                return
            end
            
            numWords = length(mostProbWords);
            mostProbWords = mostProbWords(1:min(numWords,lengthVocabulary));
            mostProbValues = mostProbValues(1:min(numWords,lengthVocabulary));
            
            if mostProbValues(1) > confidence*sum(mostProbValues)
                isProbable = true;
            else
                isProbable = false;
            end
            
        end
        
        function state = getCurrentState(obj)
            % Return the current state
            state = [obj.currentState.type, ' - ' obj.currentState.name];
        end
        
        function log = getLog(obj)
            log = obj.logParadigm;
        end
    end
    
    
end