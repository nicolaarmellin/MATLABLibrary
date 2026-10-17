%% Nicola Armellin — RaceUP Hybrid
%
%  ONESIDEDFFT Compute one-sided Fourier Transform of a signal.
%
%  Usage:
%    [ampSpectrum,freqVec] = OneSidedFFT(signal,sampleFreq)
%
%  Inputs:
%    signal       —  Input signal                          [u]
%    sampleFreq   —  Sample frequency of the input signal  [Hz]
%
%  Outputs:
%    ampSpectrum  —  One-sided amplitude spectrum          [u]
%    freqVec      —  One-sided frequency vector            [Hz]
%
%  Note: u denotes the unit of the generic input signal.



function [amp1,f] = OneSidedFFT(sig,fs)

    arguments (Input)
        sig (:,1) double
        fs  (1,1) double {mustBePositive,mustBeInteger}
    end

    % compute Fourier Transform
    x = fft(sig);
    
    % compute amplitude spectra
    n    = numel(sig);
    amp2 = abs(x)/n;             % two-sided spectrum
    amp1 = amp2(1:floor(n/2)+1); % one-sided spectrum (non-doubled)

    % double non-constant, non-Nyquist bins
    amp1(2:end-1) = 2*amp1(2:end-1);
    if mod(n,2)~=0, amp1(end) = 2*amp1(end); end

    % build frequency vector
    f = fs*(0:floor(n/2))'/n;
end