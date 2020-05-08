classdef Device
    methods (Abstract)
        sendTrigger(obj,trigger)
        % Send a trigger to the device
        err = exit(obj)
    end
end