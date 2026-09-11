%% Nicola Armellin - RaceUP Hybrid



function pool = ParPool(opts)

    arguments
        opts.numWorkers  (1,1) double {mustBePositive,mustBeInteger}
        opts.freeWorkers (1,1) double {mustBeNonnegative,mustBeInteger}
    end
    
    % resolve number of workers
    numWorkersGiven  = isfield(opts,"numWorkers");
    freeWorkersGiven = isfield(opts,"freeWorkers");
    if (numWorkersGiven)&&(freeWorkersGiven), error("ParPool: specify only one of ""numWorkers"" or ""freeWorkers"".");
    elseif numWorkersGiven,                   numWorkers = opts.numWorkers;
    elseif freeWorkersGiven,                  numWorkers = max(feature("numcores")-opts.freeWorkers,1);
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