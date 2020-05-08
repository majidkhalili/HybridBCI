classdef Device_BrainVision < Device
%     properties (Access = protected)
%         
%     end
    properties (Access = private)
        Workspace
        VRapp
    end
    
    methods
        function obj = Device_BrainVision()
            obj.VRapp = actxserver('VisionRecorder.Application');
            obj.Workspace = obj.VRapp.CurrentWorkspace.FullName();
        end
        
        function sendTrigger(obj,trigger,type)
            if nargin < 3 || ~ischar(type)
                type = 'Comments';
            end
            if isnumeric(trigger)
                trigger = ['S ' num2str(trigger)];
            elseif isstring(trigger)
                trigger = char(trigger);
            end
            try
                obj.VRapp.Acquisition.SetMarker(trigger,type);
            catch
                [~,state] = obj.getState;
                if state ~= 1
                    obj.viewData()
                    obj.VRapp.Acquisition.SetMarker(trigger,type);
                end
            end
        end
        
        function err = exit(obj)
            err = [];
            try
                obj.VRapp.Quit()
                obj.VRapp.release()
            catch ME
                err = ME.message;
                warning(err)
            end
                
        end
        
        function [state,numState] = getState(obj)
            state = obj.VRapp.State;
            switch state
                case 'vrStateOff'
                    numState = 0;
                case 'vrStateMonitoring'
                    numState = 1;
                case 'vrStateTestsignal'
                    numState = 2;
                case 'vrStateImpedanceCheck'
                    numState = 3;
                case 'vrStateSaving'
                    numState = 4;
                case 'vrStateSavingTestsignal'
                    numState = 5;
                case 'vrStatePause'
                    numState = 6;
                case 'vrStatePauseTestsignal'
                    numState = 7;
                case 'vrStatePauseImpedanceCheck'
                    numState = 8;
                otherwise
                    numState = -1;
            end
        end
        
        function err = viewData(obj)
            err = [];
            try
                obj.VRapp.Acquisition.ViewData();
            catch ME
                err = obj.getError();
                if isempty(err)
                    err = ME.message;
                end
                warning(err)
            end
        end
        
        function err = getError(obj)
            err = obj.VRapp.Acquisition.GetLastAcquisitonError();
        end
        
        function err = startRecord(obj,filename)
            err = [];
            [~,state] = obj.getState();
            if state ~= 1
                err = obj.viewData();
                if ~isempty(err)
                    return
                end
            end
            obj.VRapp.Acquisition.StartRecording(char(filename));
        end
        
        function stopRecord(obj)
            obj.VRapp.Acquisition.StopRecording()
        end
        
        
    end
end