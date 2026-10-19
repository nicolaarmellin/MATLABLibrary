%% Nicola Armellin — RaceUP Hybrid
%
%  LINEARIZEMDL Linearize a Simscape mechanical model (translational, rotational, or Multibody) around an operating point.
%
%  Usage:
%    [sys,op] = LinearizeMDL(mdl,io,time)
%    [sys,op] = LinearizeMDL(mdl,io,0,"trim")
%
%  Inputs:
%    mdl     —  Model name (without extension)                       [N/A]
%    io      —  Linearization I/O object                             [N/A]
%    time    —  Snapshot time for the operating point (default = 0)  [s]
%    "trim"  —  Solve static equilibrium (time is ignored)           [N/A]
%
%  Outputs:
%    sys     —  State-space system object                            [N/A]
%    op      —  Operating point object                               [N/A]



function [sys,op] = LinearizeMDL(mdl,io,time,trimOn)

    arguments (Input)
        mdl    (1,1) string
        io     = [] % FIX
        time   (1,1) double = 0
        trimOn (1,1) string = ""
    end

    % validate inputs
    assert(any(strcmpi(trimOn,["","trim"])),"Invalid value for input #4 (trimOn). Accepted values are """" or ""trim""");

    % load system into memory
    load_system(mdl);

    % define operating point
    if strcmpi(trimOn,"trim")
        spec = operspec(mdl);
        for ii = 1:numel(spec.States), spec.States(ii).SteadyState(:) = true; end
        op = findop(mdl,spec,findopOptions("DisplayReport","off"));
    else
        op = findop(mdl,time);
    end

    % linearize model
    if isempty(io), sys = linearize(mdl,op);
    else,           sys = linearize(mdl,io,op);
    end
end
