classdef Device_NIRSport < Device
    
    properties (Access = private)
        commandpath
        nirxpath_private
    end
    
    properties (Dependent)
        nirxpath
    end
    
    methods
        function obj = Device_NIRSport(nirxpath)
            if nargin < 1
                nirxpath = 'C:\NIRx\';
            end
            obj.nirxpath = nirxpath;
            %obj.commandpath = fullfile(nirxpath,'Commands');
            if exist(obj.commandpath,'dir') ~= 7
                mkdir(obj.commandpath)
            end
        end
        
        function obj = set.nirxpath(obj,nirxpath)
            obj.nirxpath_private = nirxpath;
            obj.commandpath = fullfile(nirxpath,'Commands');
            if exist(obj.commandpath,'dir') ~= 7
                mkdir(obj.commandpath)
            end
        end
        
        function nirxpath = get.nirxpath(obj)
            nirxpath = obj.nirxpath_private;
        end
        
        function sendTrigger(obj,marker)
            filename = 'Trigger.nrx';
            if ~isnumeric(marker)
                marker = str2double(marker);
            end
            fid = fopen([obj.commandpath filesep filename],'at');
            fprintf(fid,'%d\n',marker);
            fclose(fid);
        end
        
        function NIRStar_Control(obj,cmd_trigger)
            filename = [cmd_trigger '.nrx'];
            fid = fopen([obj.commandpath filesep filename],'w');
            fclose(fid);
        end
        
        function calibrate(obj)
            obj.NIRStar_Control('Calibrate');
        end
        
        function record(obj)
            obj.NIRStar_Control('Record');
        end
        
        function stop(obj)
            obj.NIRStar_Control('Stop');
        end
        
        function err = exit(obj)
            err = [];
            try
                obj.NIRStar_Control('Exit');
            catch ME
                err = ME.message;
                warning(err);
            end
        end
        
    end
end