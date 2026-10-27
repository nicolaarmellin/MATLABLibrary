%% Nicola Armellin — RaceUP Hybrid
%
%  PROGRESSBARCLI Create command-line progress bar with estimated remaining time.
%
%  Usage:
%    pb = ProgressBarCLI(totIter)  —  Instantiate object
%    pb.step()                     —  Incremental update (+1)
%    pb.update(iter)               —  Explicit update (+iter)
%    pb.delete()                   —  Destroy object
%
%  Inputs:
%    totIter  —  Total number of iteration
%    iter     —  Number of iterations to advance
%
%  Outputs:
%    pb       —  Handle to object



classdef ProgressBarCLI < ProgressBar

    properties (Access = private)
        LastPrintLength;                                     % length of last printed line (for safety, should be constant)
    end

    methods (Access = public)
        function obj = ProgressBarCLI(totIter)               % builder
            obj@ProgressBar(totIter);
            obj.LastPrintLength = 0;
        end
        function delete(~)                                   % destroyer
            fprintf('\n');
        end
    end

    methods (Access = protected)
        function refresh(obj)
            if obj.LastPrintLength>0
                fprintf(repmat('\b',1,obj.LastPrintLength)); % erase previous output
            end
            progressFrac          = obj.progress();
            filled                = floor(100*progressFrac);
            bar                   = [repmat('-',1,filled),repmat(' ',1,100-filled)];
            bar([1,26,51,76,101]) = '|';
            out                   = sprintf('Progress: %.2f %%\nRemaining: %.2f s\n\n0 %%   %s   100 %%',100*progressFrac,obj.remaining(),bar);
            obj.LastPrintLength   = length(out);
            fprintf('%s',out);
        end
    end
end