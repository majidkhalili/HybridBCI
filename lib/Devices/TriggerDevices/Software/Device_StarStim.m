classdef Device_StarStim < Device
%     properties (Access = protected)
%         
%     end
    properties (Access = private)
        Outlet
    end
    
    properties (Access = public)
        Procol_name = 'lsl_command'
    end
    
    methods
        function obj = Device_StarStim()
            [ret, outlet] =  MatNICMarkerConnectLSL(obj.Procol_name);
            obj.Outlet = outlet;
        end
        
        function sendTrigger(obj,trigger,type)
            [ret, outlet] = MatNICMarkerSendLSL(trigger, obj.Outlet);
        end
        
        function err = exit(obj)
           err = [];
           
           try
              %[err] = MatNICMarkerCloseLSL(obj.Outlet); 
              disp('MatNIC Exited');
           catch ME
              err = ME.message;
              warning(err);
            end
        end
        
    end
end