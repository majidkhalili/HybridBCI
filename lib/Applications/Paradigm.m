classdef Paradigm < handle
    properties
        PsychToolboxHandler
        freq = 44100;
        nrchannels = 2;
    end
    methods (Abstract)
        config = config(obj)
        % Configure the application
        
        stim = present_stimulus(obj)
        % Present a stimulus and return it as string
        
        fb = present_feedback(obj,decision)
        % Present the feedback and return it as string
        
        isFinish = next(obj, answer)
        % Process the decision and update the internal state. Return if is
        % the end or not
        
        state = getCurrentState(obj)
        % Return the current state
        
        log = getLog(obj)
        % Return the log of the paradigm from the start up to the current state
    end
    
    methods
        function obj = initializeAudio(obj)
            % Initialize Psychtoolbox
            InitializePsychSound();
            
            % Create a handler for Psychtoolbox
            obj.PsychToolboxHandler = PsychPortAudio('Open', [], [], 0, obj.freq, obj.nrchannels);
        end
        
        function playAudio(obj,wav)
            % Play the audio using Psychtoolbox
            PsychPortAudio('FillBuffer', obj.PsychToolboxHandler, wav);
            PsychPortAudio('Start', obj.PsychToolboxHandler, 1, 1, 0);
            psyStatus = PsychPortAudio('GetStatus', obj.PsychToolboxHandler);
            while psyStatus.State ~= 0
                pause(0.0001);
                psyStatus = PsychPortAudio('GetStatus', obj.PsychToolboxHandler);
            end
        end
        
        function stopAudio(obj)
            % Force the audio to stop
            PsychPortAudio('Stop', obj.PsychToolboxHandler, 2);
        end
        
        function quit(obj)
            PsychPortAudio('Close',obj.PsychToolboxHandler);
            obj.delete();
        end
    end
end