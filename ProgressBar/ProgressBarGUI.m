%% Nicola Armellin - RaceUP Team - Hybrid Division - Vehicle Dynamics

classdef ProgressBarGUI < ProgressBar

    properties (Access = private)
        Handle; % handle to waitbar graphic object
    end

    methods (Access = public)
        function obj = ProgressBarGUI(totIter) % builder
            obj@ProgressBar(totIter);
            obj.Handle = waitbar(0,'Progress: 0.00 % | Remaining: NaN s');
        end
        function delete(obj) % destroyer
            if ~isempty(obj.Handle) && ishandle(obj.Handle)
                close(obj.Handle);
            end
        end
    end

    methods (Access = protected)
        function refresh(obj)
            progress = min(max(obj.CurrentIter/obj.BarLength,0),1);
            waitbar(progress,obj.Handle,sprintf('Progress: %.2f %% | Remaining: %.2f s',100*progress,obj.remaining()));
        end
    end
end