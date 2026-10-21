%% Nicola Armellin — RaceUP Hybrid
%
%  OUTPUTANALYSIS Estimate natural frequencies and damping ratios of a mechanical system from the free response of one output.
%
%  Usage:
%    [natFreqs,dampRatios] = OutputAnalysis(sig,sampleFreq,nDOF)
%
%  Inputs:
%    sig         —  Free response of one system output (uniform sampling)  [y]
%    sampleFreq  —  Sample frequency of the input signal                   [Hz]
%    nDOF        —  Number of degrees of freedom                           [N/A]
%
%  Outputs:
%    natFreqs    —  Undamped natural frequencies                           [Hz]
%    dampRatios  —  Damping ratios                                         [-]
%
%  Notes:
%    —  y denotes the unit of the output signal.
%    —  Only the modes observable in sig are returned (at most nDOF).
%    —  Aliasing cannot be detected a posteriori: a mode above the Nyquist frequency appears as a lower-frequency mode.
%    —  Damping ratios include the numerical damping of the solver that generated the signal.



function [natFreqs,dampRatios] = OutputAnalysis(sig,sampleFreq,nDOF)
 
    arguments (Input)
        sig        (:,1) double
        sampleFreq (1,1) double {mustBePositive}
        nDOF       (1,1) double {mustBePositive,mustBeInteger}
    end
 
    % local constants
    relTolSV   = 1e-6; % singular values below this fraction of the largest —> noise
    relTolImag = 1e-6; % |Im| below this fraction of |pole| —> real pole
    relTolZero = 1e-4; % |pole| below this fraction of the Nyquist pulsation —> zero pole
    maxPencil  = 500;  % maximum pencil parameter [samples]
    minRatioHi = 10;   % minimum sampleFreq/max(natFreqs)
    maxRatioLo = 1e+3; % maximum sampleFreq/min(natFreqs)
    minCycles  = 2;    % minimum number of cycles of the slowest mode within the signal
 
    % validate signal
    nSamples = numel(sig);
    nOrder   = 2*nDOF+1; % 2*nDOF poles + constant offset
    assert(all(isfinite(sig)),"Signal contains non-finite values.");
    assert(max(sig)>min(sig),"Signal is constant.");
    assert(nSamples>=3*nOrder,"Signal has %d samples, fewer than 3*(2*nDOF+1) = %d.",nSamples,3*nOrder);
 
    % Hankel matrix of the signal
    nPencil = min(floor(nSamples/3),maxPencil);
    H       = hankel(sig(1:nSamples-nPencil),sig(nSamples-nPencil:nSamples));
 
    % model order: one significant singular value of H per pole in the signal (offset included)
    [~,S,rightVecs] = svd(H,"econ");
    singVals        = diag(S);
    sigOrder        = min(sum(singVals>relTolSV*singVals(1)),nOrder);
 
    % basis of the signal subspace: right singular vectors of the significant singular values
    sigBasis = rightVecs(:,1:sigOrder);
 
    % poles from the shift invariance of the basis (matrix pencil method)
    zPoles   = eig(sigBasis(1:end-1,:)\sigBasis(2:end,:));
    allPoles = log(zPoles)*sampleFreq; % discrete-time —> continuous-time
    absPoles = abs(allPoles);
 
    % classify poles
    isRigidPole = absPoles<=relTolZero*pi*sampleFreq;
    isRealPole  = (abs(imag(allPoles))<=relTolImag*absPoles)|isRigidPole;
    idxOscPole  = find((~isRealPole)&(imag(allPoles)>0));
    idxRealPole = find(isRealPole&~isRigidPole);
 
    % sort modes by ascending natural frequency
    idxModes = [idxOscPole;idxRealPole];
    [~,loc]  = sort(absPoles(idxModes));
    idxModes = idxModes(loc);
 
    % retain lowest-frequency modes up to 2*nDOF poles
    polesPerMode = 1+double(~isRealPole(idxModes)); % 2 for oscillatory modes, 1 for real ones
    isRetained   = cumsum(polesPerMode)<=2*nDOF;
    idxModes     = idxModes(isRetained);
    nRetained    = sum(polesPerMode(isRetained));
    if nRetained~=2*nDOF, warning("Identified %d poles instead of 2*nDOF = %d.",nRetained,2*nDOF); end
 
    % build outputs
    natFreqs   = absPoles(idxModes)/(2*pi);
    dampRatios = -real(allPoles(idxModes))./absPoles(idxModes);
 
    % check sampling and duration of the signal
    if isempty(natFreqs), return; end
    rRatioMin  = sampleFreq/max(natFreqs);
    rRatioMax  = sampleFreq/min(natFreqs);
    rCyclesMin = min(natFreqs)*nSamples/sampleFreq;
    if rRatioMin<minRatioHi, warning("Sample frequency too low (%.1f times the highest natural frequency): estimates may be unreliable.",rRatioMin);            end
    if rRatioMax>maxRatioLo, warning("Sample frequency too high (%.1e times the lowest natural frequency): signal subspace may be ill-conditioned.",rRatioMax); end
    if rCyclesMin<minCycles, warning("Signal spans only %.1f cycles of the slowest mode: estimates may be unreliable.",rCyclesMin);                             end
end
