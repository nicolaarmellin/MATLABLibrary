%% Nicola Armellin — RaceUP Hybrid
%
%  LINEARFRF Compute frequency response and resonance peaks from the modal form of a mechanical system.
%
%  Usage:
%    [H,freqOut,peaks] = LinearFRF(modalSys)
%    [H,freqOut,peaks] = LinearFRF(modalSys,"MinProm",minProm)
%    [H,freqOut,peaks] = LinearFRF(modalSys,"FreqIn",freqIn)
%
%  Inputs:
%    modalSys —  Modal system (from LinearAnalysis.m)                    [N/A]
%    minProm  —  Minimum peak prominence (default = 3)                   [dB]
%    freqIn   —  Frequency vector (increasing, replaces automatic grid)  [Hz]
%
%  Outputs:
%    H        —  Complex frequency response                              [y/u]
%    freqOut  —  Frequency vector                                        [Hz]
%    peaks    —  Resonance peaks                                         [N/A]
%     .name   —  Output name                                             [N/A]
%     .idx    —  Index of the peak in freqOut                            [N/A]
%     .freq   —  Frequency of the peak                                   [Hz]
%     .mag    —  Magnitude of the peak                                   [dB]
%     .prom   —  Prominence of the peak                                  [dB]
%
%  Notes:
%    —  u and y denote the units of the input signal and of the output signals, respectively.
%    —  The automatic grid spans 0.1*min(natFreq) to 10*max(natFreq) and includes the damped frequencies of the poles.
%       Rigid-body poles (flagged by LinearAnalysis.m) are ignored when building the grid.
 
 
 
function [H,freqOut,peaks] = LinearFRF(modalSys,opts)
 
    arguments (Input)
        modalSys     (1,1) struct
        opts.MinProm (1,1) double {mustBePositive} = 3
        opts.FreqIn  (1,:) double {mustBePositive} = []
    end

    % local constants
    numGridPoints = 2000;

    % build frequency vector
    freqOut = opts.FreqIn;
    if isempty(freqOut)
        natFreqs = abs(modalSys.poles(~modalSys.isRigid))/(2*pi);
        assert(~isempty(natFreqs),"No oscillatory mode detected: provide a frequency vector with ""FreqIn"".");
        dampedFreqs = abs(imag(modalSys.poles(~modalSys.isRigid)))/(2*pi);
        dampedFreqs = dampedFreqs(dampedFreqs>0);
        logGrid     = logspace(log10(0.1*min(natFreqs)),log10(10*max(natFreqs)),numGridPoints);
        freqOut     = unique([logGrid,dampedFreqs.']);
    end

    % compute frequency response
    jOmega   = 2i*pi*freqOut;
    residues = modalSys.Cm.*modalSys.Bm.';
    H        = residues*(1./(jOmega-modalSys.poles))+modalSys.D;

    % detect peaks
    magnitudeDb = 20*log10(max(abs(H),realmin));
    numOutputs  = size(H,1);
    peaks       = repmat(struct("name","","idx",[],"freq",[],"mag",[],"prom",[]),numOutputs,1);
    for ii = 1:numOutputs
        [peakMags,peakIdx,~,peakProms] = findpeaks(magnitudeDb(ii,:),"MinPeakProminence",opts.MinProm);
        if numel(modalSys.outNames)>=ii, peaks(ii).name = modalSys.outNames(ii); end
        peaks(ii).idx  = peakIdx;
        peaks(ii).freq = freqOut(peakIdx);
        peaks(ii).mag  = peakMags;
        peaks(ii).prom = peakProms;
    end
end
