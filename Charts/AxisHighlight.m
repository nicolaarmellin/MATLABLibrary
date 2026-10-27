%% Nicola Armellin — RaceUP Hybrid
%
%  AXISHIGHLIGHT Highlight axis of an axes/uiaxes object.
%
%  Usage:
%    AxisHighlight(ax)
%    AxisHighlight(ax,"Is2D",false)
%    AxisHighlight(ax,"LineWidth",lineWidth)
%    AxisHighlight(ax,"LineStyle",lineStyle)
%
%  Inputs:
%    ax         —  Handle to axes/uiaxes object
%    Is2D       —  Flag to mark bidimensional charts (default = true)
%    LineWidth  —  Width of axis lines (default = 1.5)
%    LineStyle  —  Style of axis lines (default = "-")



function AxisHighlight(ax,opts)

    arguments (Input)
        ax             (1,1) {mustBeA(ax,["matlab.graphics.axis.Axes","matlab.ui.control.UIAxes"])} = gca
        opts.Is2D      (1,1) logical = true
        opts.LineWidth (1,1) double  = 1.5
        opts.LineStyle (1,1) string  = "-"
    end

    % build line style
    args = {"Color",ax.GridColor,"LineWidth",opts.LineWidth,"LineStyle",opts.LineStyle};

    % draw lines over each axis
    hold(ax,"on");
    if opts.Is2D, h = [xline(ax,0,args{:}),yline(ax,0,args{:})];
    else,         h = [plot3(ax,[0,0],[0,0],ax.ZLim,args{:}),plot3(ax,[0,0],ax.YLim,[0,0],args{:}),plot3(ax,ax.XLim,[0,0],[0,0],args{:})];
    end
    hold(ax,"off");

    % exclude lines from legend
    for l = h, l.Annotation.LegendInformation.IconDisplayStyle = "off"; end
end