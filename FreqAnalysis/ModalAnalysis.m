%% Nicola Armellin — RaceUP Hybrid
%
%  MODALANALYSIS Compute modal form of a linearized mechanical state-space model.
%
%  Usage:
%    [natFreqs,dampRatios,modalSys] = ModalAnalysis(sys,nDOF)
%
%  Inputs:
%    sys         —  Continuous-time, state-space system with a single input  [N/A]
%    nDOF        —  Number of degrees of freedom                             [N/A]
%
%  Outputs:
%    natFreqs    —  Undamped natural frequencies                             [Hz]
%    dampRatios  —  Damping ratios                                           [-]
%    modalSys    —  Modal-form system                                        [N/A]
%     .lambda    —  Retained poles                                           [rad/s]
%     .Bm        —  Modal input matrix                                       [x/(s*u)]
%     .Cm        —  Modal output matrix                                      [y/x]
%     .D         —  Feed-through matrix                                      [y/u]
%     .eig       —  Eigenvectors of the retained poles (unit 2-norm)         [-]
%     .condV     —  Condition number of the full eigenvector matrix          [-]
%     .outNames  —  Names of the system outputs                              [N/A]
%
%  Notes:
%    —  u, y and x denote the units of the input signal, of the output signals and of the system states, respectively.
%    —  If condV is close to 1, eigenvectors are nearly orthogonal and the decomposition is well conditioned; when condV is
%       above 1e+8, eigenvectors are nearly linearly dependent and the modal form is unreliable.



function [natFreqs,dampRatios,modalSys] = ModalAnalysis(sys,nDOF)
 
    arguments (Input)
        sys  (1,1) ss
        nDOF (1,1) double {mustBeInteger,mustBePositive}
    end
 
    % validate system type
    assert(sys.Ts==0,"System must be continuous-time.");
    sys = ss(sys,"explicit"); % descriptor —> standard form (E = I); errors if E is singular

    % validate system's matrices
    [A,B,C,D] = ssdata(sys);
    assert(size(B,2)==1,"System must have exactly one input (found %d).",size(B,2));
    assert(size(A,1)>=2*nDOF,"System has %d states, fewer than 2*nDOF = %d.",size(A,1),2*nDOF);
 
    % eigendecomposition
    [eigVecs,eigVals] = eig(A);
    allPoles = diag(eigVals);
    absPoles = abs(allPoles);
 
    % classify poles (real or oscillatory)
    relTolImag = 1e-6; % |Im| below this fraction of |pole| —> real pole
    relTolZero = 1e-8; % |pole| below this fraction of the largest —> rigid-body (zero) pole
    isRealPole = (abs(imag(allPoles))<=relTolImag*absPoles)|(absPoles<=relTolZero*max(absPoles));
    idxPosImag = find((~isRealPole)&(imag(allPoles)>0));
    idxNegImag = find((~isRealPole)&(imag(allPoles)<0));
    assert(numel(idxPosImag)==numel(idxNegImag),"Complex poles do not form conjugate pairs.");
    idxRealPole = find(isRealPole);

    % sort modes by ascending natural frequency
    idxModes = [idxPosImag;idxRealPole];
    [~,loc]  = sort(absPoles(idxModes));
    idxModes = idxModes(loc);
 
    % retain lowest-frequency modes up to 2*nDOF poles
    polesPerMode = 1+double(~isRealPole(idxModes)); % 2 for oscillatory modes, 1 for real ones
    isRetained   = cumsum(polesPerMode)<=2*nDOF;
    idxModes     = idxModes(isRetained);
    nRetained    = sum(polesPerMode(isRetained));
    if nRetained~=2*nDOF, warning("Retained %d poles instead of 2*nDOF = %d.",nRetained,2*nDOF); end
 
    % indices of retained poles (conjugate pairs adjacent)
    idxRetPoles = zeros(0,1);
    for iMode = 1:numel(idxModes)
        idxPole = idxModes(iMode);
        if isRealPole(idxPole)
            idxRetPoles = [idxRetPoles;idxPole]; %#ok<AGROW>
        else
            % find the conjugate partner among the negative-imaginary poles
            [~,iConj]   = min(abs(allPoles(idxNegImag)-conj(allPoles(idxPole))));
            idxRetPoles = [idxRetPoles;idxPole;idxNegImag(iConj)]; %#ok<AGROW>
        end
    end
 
    % build outputs
    retainPoles = allPoles(idxRetPoles);
    natFreqs    = absPoles(idxModes)/(2*pi);
    dampRatios  = -real(allPoles(idxModes))./absPoles(idxModes);
 
    % modal form
    BmAll = eigVecs\B;
    condV = cond(eigVecs);
    modalSys = struct("lambda",   retainPoles, ...
                      "Bm",       BmAll(idxRetPoles,:), ...
                      "Cm",       C*eigVecs(:,idxRetPoles), ...
                      "D",        D, ...
                      "eig",      eigVecs(:,idxRetPoles), ...
                      "condV",    condV, ...
                      "outNames", string(sys.OutputName));

    % check conditioning of eigenvector matrix
    maxCondV = 1e+8;
    if condV>maxCondV, warning("Eigenvector matrix is ill-conditioned (cond = %.2e): modal form may be unreliable.",condV); end
end
