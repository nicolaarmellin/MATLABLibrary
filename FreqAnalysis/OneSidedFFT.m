%% Nicola Armellin — RaceUP Hybrid
%
%  ONESIDEDFFT Compute one-sided Fourier Transform of a signal.
%
%  Usage:
%    [amp1,freq] = OneSidedFFT(sig,sampleFreq)
%
%  Inputs:
%    signal      —  Input signal                          [u]
%    sampleFreq  —  Sample frequency of the input signal  [Hz]
%
%  Outputs:
%    amp1        —  One-sided amplitude spectrum          [u]
%    freq        —  One-sided frequency vector            [Hz]
%
%  Notes:
%    —  u denotes the unit of the generic input signal.



function [amp1,freq] = OneSidedFFT(sig,sampleFreq)

    arguments (Input)
        sig        (:,1) double
        sampleFreq (1,1) double {mustBePositive}
    end

    % compute Fourier Transform
    x = fft(sig);
    
    % compute amplitude spectra
    nSamples = numel(sig);
    amp2     = abs(x)/nSamples;             % two-sided spectrum
    amp1     = amp2(1:floor(nSamples/2)+1); % one-sided spectrum (non-doubled)

    % double non-constant, non-Nyquist bins
    amp1(2:end-1) = 2*amp1(2:end-1);
    if mod(nSamples,2)~=0, amp1(end) = 2*amp1(end); end

    % build frequency vector
    freq = sampleFreq*(0:floor(nSamples/2))'/nSamples;
end
