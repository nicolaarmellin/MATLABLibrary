%% Nicola Armellin — RaceUP Hybrid
%
%  AXISEQUAL Set equal axis scaling and limits (optional) to axes/uiaxes object.
%
%  Usage:
%    AxisEqual(ax,"Margin",margin)
%    AxisEqual(ax,"TightLimits,true)
%    AxisEqual(ax,"CenterOrigin",true)
%
%  Inputs:
%    ax            —  Handle to axes/uiaxes object
%    Margin        —  Padding around axes/uiaxes area
%    TightLimits   —  Force axis limits to perfectly match data range (may conflict with CenterOrigin=true)
%    CenterOrigin  —  Enforce symmetric axis limits (may conflict with TightLimits=true)



function AxisEqual(ax,opts)

    arguments (Input)
        ax                (1,1) {mustBeA(ax,["matlab.graphics.axis.Axes","matlab.ui.control.UIAxes"])} = gca
        opts.Margin       (1,1) double  = 0
        opts.TightLimits  (1,1) logical = false
        opts.CenterOrigin (1,1) logical = false
    end

    % ensure automatic rendering is complete
    drawnow();

    % get original dimensions (uiaxes has no Units property — always pixels)
    hasUnits = isprop(ax,"Units");
    if hasUnits, origUnits = ax.Units; ax.Units  = "pixels"; end
    pos  = ax.Position;
    w    = pos(3);
    h    = pos(4);
    side = min(w,h);

    % get data ranges
    if opts.TightLimits
        [xMin,yMin] = deal(Inf);
        [xMax,yMax] = deal(-Inf);
        children    = ax.Children(:)';
        for ch = children
            if (isprop(ch,"XData"))&&(isprop(ch,"YData"))
                xd = double(ch.XData(isfinite(ch.XData)));
                yd = double(ch.YData(isfinite(ch.YData)));
                if ~isempty(xd), xMin = min(xMin,min(xd)); xMax = max(xMax,max(xd)); end
                if ~isempty(yd), yMin = min(yMin,min(yd)); yMax = max(yMax,max(yd)); end
            end
        end
        if all(isfinite([xMin,xMax,yMin,yMax]))&&(xMax>xMin)&&(yMax>yMin)
            xPadding = opts.Margin*(xMax-xMin);
            yPadding = opts.Margin*(yMax-yMin);
            ax.XLim  = [xMin-xPadding,xMax+xPadding];
            ax.YLim  = [yMin-yPadding,yMax+yPadding];
        end
    end
    xLim = ax.XLim;
    yLim = ax.YLim;
    xRng = abs(diff(xLim));
    yRng = abs(diff(yLim));
    if (xRng<=0)||(yRng<=0)||(~isfinite(xRng))||(~isfinite(yRng))
        if hasUnits, ax.Units = origUnits; end
        error("AxisEqual: XLim/YLim is negative or non-defined.");
    end

    % determine common square span and center
    if opts.CenterOrigin
        halfSpan = max(abs([xLim,yLim]));
        xCenter  = 0;
        yCenter  = 0;
        dataSpan = 2*halfSpan;
    else
        xCenter  = mean(xLim);
        yCenter  = mean(yLim);
        dataSpan = max(xRng,yRng);
    end

    % always equalize limits to a square span
    ax.XLim = xCenter+[-1,1]*dataSpan/2;
    ax.YLim = yCenter+[-1,1]*dataSpan/2;

    % set aspect ratio only if ax belongs to TiledChartLayout or GridLayout object
    if PositionFixed(ax)
        set(ax,"DataAspectRatioMode","manual","DataAspectRatio",[1,1,1],"PlotBoxAspectRatioMode","manual","PlotBoxAspectRatio",[1,1,1]);
    
    else
        % force axes footprint to a square
        newPos      = [pos(1)+(w-side)/2,pos(2)+(h-side)/2,side,side];
        ax.Position = newPos;

        % lock ratios explicitly
        set(ax,"DataAspectRatioMode","manual","DataAspectRatio",[1,1,1],"PlotBoxAspectRatioMode","manual","PlotBoxAspectRatio",[1,1,1]);
    end

    % restore units
    if hasUnits, ax.Units = origUnits; end

    % reapply automatically on resize
    fig = ax;
    while ~isempty(fig)&&(~isa(fig,"matlab.ui.Figure")), fig = fig.Parent; end
    if ~isempty(fig)
        lst = addlistener(fig,'SizeChanged',@(~,~)AxisEqual(ax,"tightLimits",opts.TightLimits,"margin",opts.Margin,"centerOrigin",opts.CenterOrigin));
        setappdata(ax,'AxisEqualListener',lst); % keep listener alive as long as ax exists
    end
end

function tf = PositionFixed(ax)
    p  = ax.Parent;
    tf = (isa(p,"matlab.graphics.layout.TiledChartLayout"))||(isa(p,"matlab.ui.container.GridLayout"));
end