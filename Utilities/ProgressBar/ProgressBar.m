%% Nicola Armellin — RaceUP Hybrid
%
%  PROGRESSBAR Create progress bar with estimated remaining time.
%
%  Usage:
%    pb = ProgressBar(totIter)  —  Instantiate object
%    pb.step()                  —  Incremental update (+1)
%    pb.update(iter)            —  Explicit update (+iter)
%    pb.delete()                —  Destroy object
%
%  Inputs:
%    totIter  —  Total number of iteration
%    iter     —  Number of iterations to advance
%
%  Outputs:
%    pb       —  Handle to object



classdef (Abstract) ProgressBar < handle

    properties (Access = protected)
        BarLength;                          % total number of iterations
        CurrentIter;                        % current iteration
        StartTime;                          % time of creation of the object
    end

    methods (Access = public)
        function obj = ProgressBar(totIter) % builder
            obj.BarLength   = totIter;
            obj.CurrentIter = 0;
            obj.StartTime   = tic;
        end
        function step(obj)                  % incremental update
            obj.CurrentIter = obj.CurrentIter+1;
            obj.refresh();
            obj.checkFinish();
        end
        function update(obj,iter)           % explicit update
            obj.CurrentIter = iter;
            obj.refresh();
            obj.checkFinish();
        end
    end

    methods (Access = protected)
        function progressFrac = progress(obj)
            progressFrac = min(max(obj.CurrentIter/obj.BarLength,0),1);
        end
        function remainingTime = remaining(obj)
            remainingTime = NaN;
            if obj.CurrentIter>0
                remainingTime = (obj.BarLength-obj.CurrentIter)*(toc(obj.StartTime)/obj.CurrentIter);
            end
        end
        function checkFinish(obj)           % auto-delete on finish
            if obj.CurrentIter>=obj.BarLength
                obj.delete();               % defined in sub-classes
            end
        end
    end

    methods (Abstract, Access = protected)
        refresh(obj);
    end
end