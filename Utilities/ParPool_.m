%% Nicola Armellin — RaceUP Hybrid
%
%  PARPOOL_ Create/retrieve parallel pool.
%
%  Usage:
%    pool = ParPool_("NumWorkers",numWorkers)
%    pool = ParPool_("FreeWorkers",freeWorkers)
%
%  Inputs:
%    NumWorkers   —  Number of physical cores to use in the pool
%    FreeWorkers  —  Number of physical cores to be left unused
%
%  Outputs:
%    pool         —  Handle to parallel pool
%
%  Requires Parallel Computing Toolbox.



function pool = ParPool_(opts)

    arguments
        opts.NumWorkers  (1,1) double {mustBePositive,mustBeInteger}
        opts.FreeWorkers (1,1) double {mustBeNonnegative,mustBeInteger}
    end
    
    % resolve number of workers
    numWorkersGiven  = isfield(opts,"NumWorkers");
    freeWorkersGiven = isfield(opts,"FreeWorkers");
    if (numWorkersGiven)&&(freeWorkersGiven), error("ParPool: specify only one of ""numWorkers"" or ""freeWorkers"".");
    elseif numWorkersGiven,                   numWorkers = opts.NumWorkers;
    elseif freeWorkersGiven,                  numWorkers = max(feature("numcores")-opts.FreeWorkers,1);
    else,                                     numWorkers = max(feature("numcores")-1,1); % fallback to max-1 workers
    end
    
    % check for existing pools
    pool = gcp("nocreate");
    if ~isempty(pool)
        if pool.NumWorkers==numWorkers, return;
        else,                           delete(pool);
        end
    end
    
    % create pool
    pool = parpool("Processes",numWorkers);
end