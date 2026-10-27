%% Nicola Armellin — RaceUP Hybrid
%
%  LEGEND_ Create a legend linked to an axes/uiaxes object.
%
%  Usage:
%    l = Legend_(ax,entries,nSeries,mask)
%    l = Legend_(ax,[],nSeries,mask)
%    l = Legend_(ax,entries,nSeries,mask,"Location",location)
%    l = Legend_(ax,entries,nSeries,mask,"FontSize",fontSize)
%
%  Inputs:
%    ax        —  Handle to axes/uiaxes object
%    entries   —  Legend labels (string vector, optional)
%    nSeries   —  Number of datasets
%    mask      —  Indexes of labels/datasets to skip
%    Location  —  Position (cardinal, default = "northeast")
%    FontSize  —  Font size (default = 16)
%
%  Outputs:
%    l         —  Handle to legend object



function l = Legend_(ax,entries,nSeries,mask,opts)

    arguments (Input)
        ax            (1,1) {mustBeA(ax,["matlab.graphics.axis.Axes","matlab.ui.control.UIAxes"])}
        entries       (1,:) string
        nSeries       (1,1) double
        mask          (1,:) logical
        opts.Location (1,1) string = "northeast"
        opts.FontSize (1,1) double = 16
    end

    % process entries
    legEntries = "Dataset #"+string(1:nSeries);
    if ~isempty(entries)
        assert(numel(entries)>=numel(mask),"The number of legend entries must be greater than or equal to the number of datasets.");
        legEntries = entries(mask);
    end

    % create legend
    l = legend(ax,legEntries,"Location",opts.Location,"FontSize",opts.FontSize);
end