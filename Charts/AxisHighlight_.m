%% Nicola Armellin - RaceUP Hybrid

function AxisHighlight_(ax,opts)

    arguments (Input)
        ax             (1,1) {mustBeA(ax,["matlab.graphics.axis.Axes","matlab.ui.control.UIAxes"])} = gca
        opts.is2D      (1,1) logical = true
        opts.lineWidth (1,1) double  = 1.5
        opts.lineStyle (1,1) string  = "-"
    end

    % build line style
    args  = {"Color",ax.GridColor,"LineWidth",opts.lineWidth,"LineStyle",opts.lineStyle};

    % draw lines over each axis
    hold(ax,"on");
    if opts.is2D
        xline(ax,0,args{:});
        yline(ax,0,args{:});
    else
        xLim = ax.XLim;
        yLim = ax.YLim;
        zLim = ax.ZLim;
        plot3(ax,[0,0],[0,0],zLim,args{:});
        plot3(ax,[0,0],yLim,[0,0],args{:});
        plot3(ax,xLim,[0,0],[0,0],args{:});
    end
    hold(ax,"off");
end