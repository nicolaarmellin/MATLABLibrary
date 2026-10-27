# MATLABLibrary

MATLAB utilities for signal processing, mechanical-system analysis, plotting, and common workflows. Each function's header comments describe its detailed usage.

## Getting started

Add the library folders to the MATLAB path once per session (replace the placeholder with your checkout location):

```matlab
repo = "path/to/MATLABLibrary";
addpath(genpath(repo));
```

## Signal processing

- [`OneSidedFFT`](SignalProcessing/OneSidedFFT.m): Computes a signal's one-sided amplitude spectrum and frequency vector.
- [`ResampleSig`](SignalProcessing/ResampleSig.m): Interpolates a signal onto evenly spaced samples.
- [`FourierSeries`](SignalProcessing/FourierSeries.m): Reconstructs a periodic signal from a chosen number of harmonics.

## Mechanical-systems analysis

- [`LinearizeMDL`](SimscapeMechanical/LinearizeMDL.m): Linearizes a Simscape mechanical model around an operating point.
- [`LinearAnalysis`](SimscapeMechanical/LinearAnalysis.m): Computes natural frequencies, damping ratios, and modal form from a state-space model.
- [`OutputAnalysis`](SimscapeMechanical/OutputAnalysis.m): Estimates natural frequencies and damping ratios from one free-response signal.
- [`LinearFRF`](SimscapeMechanical/LinearFRF.m): Evaluates the modal frequency response and identifies resonance peaks.

For a model-based analysis, the typical sequence is `LinearizeMDL` -> `LinearAnalysis` -> `LinearFRF`. Use `OutputAnalysis` when you have a free-response signal instead of a state-space model.

## Plotting and display

- [`Plot_`](Charts/Plot_.m): Creates configurable line plots.
- [`Scatter_`](Charts/Scatter_.m): Creates configurable 2D or 3D scatter plots.
- [`Hist_`](Charts/Hist_.m): Creates configurable histograms.
- [`Axes_`](Charts/Axes_.m): Creates axes for standard figures or app UI figures.
- [`Legend_`](Charts/Legend_.m): Creates a legend for an axes object.
- [`SetAxesPosition`](Charts/SetAxesPosition.m): Positions axes within a grid or tiled layout.
- [`AxisEqual`](Charts/AxisEqual.m): Applies equal axis scaling and optional limits.
- [`AxisHighlight`](Charts/AxisHighlight.m): Highlights the zero axes.
- [`Input2RGBA`](Charts/Input2RGBA.m): Converts MATLAB color inputs to RGBA values.

## Workflow utilities

- [`ProgressBar`](Utilities/ProgressBar/ProgressBar.m): Base class for the progress-bar implementations.
  - [`ProgressBarCLI`](Utilities/ProgressBar/ProgressBarCLI.m): Displays progress in the command window.
  - [`ProgressBarGUI`](Utilities/ProgressBar/ProgressBarGUI.m): Displays progress in a graphical waitbar.
- [`CMDWindow_Logger`](Utilities/CMDWindow_Logger.m): Mirrors MATLAB command-window output to a file.
- [`ParPool_`](Utilities/ParPool_.m): Starts or reuses a process-based parallel pool with a chosen worker count.
