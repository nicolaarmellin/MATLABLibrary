%% Nicola Armellin — RaceUP Hybrid
%
%  FOURIERSERIES Trigonometric Fourier series of a sampled periodic signal.
%
%  Usage:
%    [sigOut,a0,aN,bN] = FourierSeries(time,sigIn,fundT,nHarms)
%
%  Inputs:
%    time    —  Time vector                                   [s]
%    sigIn   —  Input signal                                  [u]
%    fundT   —  Fundamental period of the input signal        [s]
%    nHarms  —  Number of harmonics of the series             [-]
%
%  Outputs:
%    sigOut  —  Output signal recontructed by Fourier Series  [u]
%    a0      —  Constant-term Fourier coefficient (a0)        [u]
%    aN      —  Vector of Fourier cosine coefficients (aN)    [u]
%    bN      —  Vector of Fourier sine coefficients (bN)      [u]
%
%  Notes:
%    —  u denotes the unit of the generic input signal.



function [sigOut,a0,aN,bN] = FourierSeries(time,sigIn,fundT,nHarms)

    arguments (Input)
        time   (:,1) double
        sigIn  (:,1) double
        fundT  (1,1) double {mustBePositive}
        nHarms (1,1) double {mustBePositive,mustBeInteger}
    end

    % validate inputs
    assert(all(diff(time)>0),"Time vector must be strictly increasing.");
    assert(numel(time)==numel(sigIn),"Input signal and time vector must have the same number of elements.");

    % validate time window
    fundOmega = 2*pi/fundT;
    timeWin   = time(end)-time(1);
    nPeriods  = timeWin/fundT;
    assert(abs(nPeriods-round(nPeriods))<1e-3*min(diff(time)),"Time window must be an integer multiple of the fundamental period.");

    % build harmonic matrices
    harmIdx = 1:nHarms;
    cosMat  = cos(time*fundOmega*harmIdx);
    sinMat  = sin(time*fundOmega*harmIdx);

    % compute Fourier coefficients
    normFactor = 2/timeWin;
    a0 = normFactor*trapz(time,sigIn);
    aN = normFactor*trapz(time,sigIn.*cosMat,1)';
    bN = normFactor*trapz(time,sigIn.*sinMat,1)';

    % build output signal
    sigOut = a0/2+cosMat*aN+sinMat*bN;
end
