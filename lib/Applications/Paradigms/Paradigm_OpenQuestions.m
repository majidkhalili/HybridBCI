classdef Paradigm_OpenQuestions < Paradigm
    properties
        FigHybridBCI;
        wavPath = '';
        wavYes = [];
        wavNo = [];
        wavNC = [];
        selectedQuestions = {};
        numQuestions = 0;
        numRepetition = 1;
        order = 'Random';
        totalQuestions = {};
        totalNumQuestions = 0;
        currentQuestions = 0;
        
        logParadigm = [];
    end
    
    methods
        function obj = Paradigm_OpenQuestions(configApp)
            obj.initializeAudio();
            
            obj.FigHybridBCI = configApp.FigHybridBCI;
            obj.wavPath = fullfile(fileparts(mfilename('fullpath')), 'OpenQuestions','wav','Questions');
            
            fbPath = fullfile(fileparts(mfilename('fullpath')), 'OpenQuestions','wav', 'Feedback');
            [audiodata,~]       = audioread([fbPath filesep 'Ja.wav']);
            [~, ninchannels]    = size(audiodata);
            obj.wavYes          = repmat(transpose(audiodata), obj.nrchannels / ninchannels, 1);
            [audiodata,~]       = audioread([fbPath filesep 'Nein.wav']);
            [~, ninchannels]    = size(audiodata);
            obj.wavNo           = repmat(transpose(audiodata), obj.nrchannels / ninchannels, 1);
            [audiodata,~]       = audioread([fbPath filesep 'NC.wav']);
            [~, ninchannels]    = size(audiodata);
            obj.wavNC           = repmat(transpose(audiodata), obj.nrchannels / ninchannels, 1);
            
           
        end
        
        function config = config(obj)
            % Configure the application
            selectQuestions(obj);
            
            % Save config
            config.order = obj.order;
            config.selectedQuestions = obj.selectedQuestions;
            config.numQuestions = obj.numQuestions;
            config.numRepetition = obj.numRepetition;
            config.totalQuestions = obj.totalQuestions;
            config.totalNumQuestions = obj.totalNumQuestions;
        end
        
        function stim = present_stimulus(obj)
            % Present a stimulus and return it as string
            stim = obj.totalQuestions{obj.currentQuestions};
            [audiodata,~]       = audioread([obj.wavPath filesep stim]);
            [~, ninchannels]    = size(audiodata);
            audiodata           = repmat(transpose(audiodata), obj.nrchannels / ninchannels, 1);
            obj.playAudio(audiodata);
        end
        
        function fb = present_feedback(obj,answer)
            switch answer
                case 1
                    obj.playAudio(obj.wavYes);
                    fb = 'Yes';
                case 0
                    obj.playAudio(obj.wavNo);
                    fb = 'No';
                otherwise
                    obj.playAudio(obj.wavNC);
                    fb = 'Not classified';
            end
        end
        
        function isFinish = next(obj, answer)
            % Process the answer and update the internal state. Return if is
            % the end or not
            if obj.currentQuestions >= obj.totalNumQuestions
                isFinish = true;
            else
                obj.currentQuestions = obj.currentQuestions+1;
                isFinish = false;
                % Save log
                obj.logParadigm{end+1} = obj.totalQuestions{obj.currentQuestions};
            end
        end
        
        function state = getCurrentState(obj)
            % Return the current state
            state = obj.totalQuestions{obj.currentQuestions};
        end
        
        function logParadigm = getLog(obj)
            % Return the log of the paradigm from the start up to the current state
            logParadigm = obj.logParadigm;
        end
        
        function setQuestions(obj,questions,repetition,order)
            obj.numQuestions = length(questions);
            obj.selectedQuestions = questions;
            obj.numRepetition = repetition;
            obj.order = order;
            
            switch order
                case 'Random'
                    totQuestions = repmat(questions,[repetition,1]);
                    totQuestions = totQuestions(randperm(length(totQuestions)));
                case 'Sequential'
                    rndQuest = questions(randperm(length(questions)));
                    totQuestions = repelem(rndQuest,repetition);
                case 'Stacked'
                    totQuestions = cell(obj.numQuestions*repetition,1);
                    for i = 1:repetition
                        startIdx = (i-1)*obj.numQuestions+1;
                        endIdx   = (i)*obj.numQuestions;
                        totQuestions(startIdx:endIdx) = questions(randperm(length(questions)));
                    end
            end
                
            obj.totalQuestions = totQuestions;
            obj.totalNumQuestions = length(totQuestions);
        end
    end

end