classdef Device_LPTport < Device

    properties (Access = private)
    end
    
    properties (Access = public)
        parallelPort;
    end
    
    methods
        function obj = Device_LPTport(parallelPort)
            if nargin < 1
                parallelPort = '3ff8';
            end
            %config_io;
            obj.parallelPort = parallelPort;
        end
        
        function obj = set.parallelPort(obj,value)
            obj.parallelPort = hex2dec(value);
        end
        
        function value = get.parallelPort(obj)
            value = dec2hex(obj.parallelPort);
        end
                
        function sendTrigger(obj,trigger)
            if ~isnumeric(trigger)
                trigger = str2double(trigger);
            end
            outp(hex2dec(obj.parallelPort),trigger);
            WaitSecs(0.02);
            outp(hex2dec(obj.parallelPort),0);
        end
        
        function err = exit(obj)
            err = [];
            try
                % I don't know what to do here
                %delete(obj);
            catch ME
                err = ME.message;
                warning(err);
            end
        end
    end
end