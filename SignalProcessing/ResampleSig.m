%% Nicola Armellin — RaceUP Hybrid
%
%  RESAMPLESIG Resample signal on a uniform grid.
%
%  Usage:
%    [yOut,xOut] = ResampleSig(yIn,xIn,dx)
%    [yOut,xOut] = ResampleSig(yIn,xIn,dx,"XRange",xRange)
%    [yOut,xOut] = ResampleSig(yIn,xIn,dx,"InterpMethod",interpMethod)
%    [yOut,xOut] = ResampleSig(yIn,xIn,dx,"ExtrapMethod",extrapMethod)
%    [yOut,xOut] = ResampleSig(yIn,xIn,dx,"ExtrapMethod","linear","LinExtrapMode",linExtrapMode)
%
%  Inputs:
%    yIn            —  Input signal (vector or column-wise matrix)                                    [u]
%    xIn            —  Sampling vector                                                                [v]
%    dx             —  Sampling step of the output signal                                             [v]
%    XRange         —  Sampling range of the output signal (2-elements row vector)                    [v]
%    InterpMethod   —  Interpolation method ("linear","nearest","pchip","cubic","spline","makima")    [N/A]
%    ExtrapMethod   —  Extrapolation method ("none" or any InterpMethod)                              [N/A]
%    LinExtrapMode  —  Extrapolation mode, valid for ExtrapMethod="linear" only ("secant","tangent")  [N/A]
%
%  Outputs:
%    yOut           —  Resampled output signal                                                        [u]
%    xOut           —  Output sampling vector                                                         [v]
%
%  Notes:
%    —  u and v denote the generic units of the signal(s) and sampling vector, respectively.
%    —  linExtrapMode="tangent" extends the signal(s) with the slope of the first/last two in-range output samples
%       (finite-difference estimate, accuracy depends on dx); the slope is 0 for interpMethod="nearest".



function [yOut,xOut] = ResampleSig(yIn,xIn,dx,opts)

    arguments (Input)
        yIn                (:,:) double
        xIn                (:,1) double {mustBeFinite,mustBeSorted}
        dx                 (1,1) double {mustBePositive}
        opts.XRange        (1,2) double {mustBeSorted}                                                                                  = [min(xIn),max(xIn)]
        opts.InterpMethod  (1,1) string {mustBeMember(opts.InterpMethod,["linear","nearest","pchip","cubic","spline","makima"])}        = "linear"
        opts.ExtrapMethod  (1,1) string {mustBeMember(opts.ExtrapMethod,["linear","nearest","pchip","cubic","spline","makima","none"])} = "none"
        opts.LinExtrapMode (1,1) string {mustBeMember(opts.LinExtrapMode,["secant","tangent"])}                                         = "secant"
    end

    % validate inputs
    [nSamples,nSigs] = size(yIn);
    assert(nSamples==numel(xIn),"Input signal(s) and sampling vector must have the same number of elements.");

    % average duplicates
    [xUnq,~,idx] = unique(xIn);
    nUnq         = numel(xUnq);
    assert(nUnq>=2,"At least two distinct sampling points are required.");
    subs = [repmat(idx,nSigs,1),repelem(1:nSigs,nSamples)'];
    yAvg = accumarray(subs,yIn(:),[nUnq,nSigs],@(v)mean(v,"omitmissing"));

    % build sampling vector
    xOut = (opts.XRange(1):dx:opts.XRange(2))';
    oorL = xOut<xUnq(1); % out-of-range points
    oorR = xOut>xUnq(end);
    if (opts.ExtrapMethod=="none")&&(any(oorL|oorR)), warning("Out-of-range values detected (NaN-filled). Resampling requires extrapolation."); end

    % interp/extrap
    func = griddedInterpolant(xUnq,yAvg,opts.InterpMethod,opts.ExtrapMethod);
    yOut = func(xOut);

    % linear tangent extrapolation (override out-of-range points)
    if (opts.ExtrapMethod=="linear")&&(opts.LinExtrapMode=="tangent")
        idx = find((~oorL)&(~oorR)); % in-range output samples
        assert(numel(idx)>=2,"At least 2 in-range samples are required for tangent extrapolation.");
        slopeL = (yOut(idx(2),:)-yOut(idx(1),:))/dx;
        slopeR = (yOut(idx(end),:)-yOut(idx(end-1),:))/dx;
        if opts.InterpMethod=="nearest", [slopeL,slopeR] = deal(0); end % force null slopes
        yOut(oorL,:) = yOut(idx(1),:)+(xOut(oorL)-xOut(idx(1)))*slopeL;
        yOut(oorR,:) = yOut(idx(end),:)+(xOut(oorR)-xOut(idx(end)))*slopeR;
    end
end