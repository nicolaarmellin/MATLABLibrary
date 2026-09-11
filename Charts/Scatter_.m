%% Nicola Armellin - RaceUP Hybrid

function ax = Scatter_(parent,xData,yData,zData,cData,opts)

    arguments (Input)
        parent                (1,1) handle
        xData                 (:,1) {mustBeNumeric}
        yData                 (:,1) {mustBeNumeric}
        zData                 (:,1) {mustBeNumeric}
        cData                 (:,1) {mustBeNumeric}
        opts.fontSize         (1,1) double  = 18
        opts.layoutPos        (1,2) cell    = {1,1}
        opts.colormap         (1,1) string  = "turbo"
        opts.colorbarLocation (1,1) string  = "eastoutside"
        opts.markerFilled     (1,1) logical = false
        opts.markerSize       (1,1) double  = 30
        opts.markerShape      (1,1) string  = "o"
        opts.xLabel           (1,1) string  = "X Data"
        opts.yLabel           (1,1) string  = "Y Data"
        opts.zLabel           (1,1) string  = "Z Data"
        opts.cLabel           (1,1) string  = "Color Data"
        opts.xLim             (1,2) double  = []
        opts.yLim             (1,2) double  = []
        opts.zLim             (1,2) double  = []
        opts.cLim             (1,2) double  = []
        opts.xTicks           (1,:) double  = []
        opts.yTicks           (1,:) double  = []
        opts.zTicks           (1,:) double  = []
        opts.cTicks           (1,:) double  = []
        opts.xTickLabels      (1,:) string  = string.empty
        opts.yTickLabels      (1,:) string  = string.empty
        opts.zTickLabels      (1,:) string  = string.empty
        opts.cTickLabels      (1,:) string  = string.empty
        opts.gridOn           (1,1) logical = true
        opts.axisHighlight    (1,1) logical = false
        opts.axisEqual        (1,1) logical = false
        opts.axisMargin       (1,1) double  = 0
        opts.centerOrigin     (1,1) logical = false
        opts.tightLimits      (1,1) logical = false
    end

    % 2D scatter if zData is empty or NaN
    is2D = (isempty(zData))||(all(isnan(zData),"all"));

    % create axes object
    ax = Axes_(parent,opts.fontSize);

    % plot data
    args = {opts.markerSize,cData,opts.markerShape};
    if is2D, sc = scatter(ax,xData,yData,args{:});
    else,    sc = scatter3(ax,xData,yData,zData,args{:});
    end

    % create colorbar
    colormap(ax,opts.colormap);
    cb = colorbar(ax,"Location",opts.colorbarLocation,"FontSize",opts.fontSize-2);
    cb.Label.String   = opts.cLabel;
    cb.Label.FontSize = opts.fontSize-2;
    if ~isempty(opts.cLim),        clim(ax,opts.cLim);               end
    if ~isempty(opts.cTicks),      cb.Ticks      = opts.cTicks;      end
    if ~isempty(opts.cTickLabels), cb.TickLabels = opts.cTickLabels; end

    % global style options
    xlabel(ax,opts.xLabel);
    ylabel(ax,opts.yLabel);
    if ~isempty(opts.xLim),        xlim(ax,opts.xLim);               end
    if ~isempty(opts.yLim),        ylim(ax,opts.yLim);               end
    if ~isempty(opts.xTicks),      xticks(ax,opts.xTicks);           end
    if ~isempty(opts.yTicks),      yticks(ax,opts.yTicks);           end
    if ~isempty(opts.xTickLabels), xticklabels(ax,opts.xTickLabels); end
    if ~isempty(opts.yTickLabels), yticklabels(ax,opts.yTickLabels); end
    if ~is2D
        zlabel(ax,opts.zLabel);
        if ~isempty(opts.zLim),        zlim(ax,opts.zLim);               end
        if ~isempty(opts.zTicks),      zticks(ax,opts.zTicks);           end
        if ~isempty(opts.zTickLabels), zticklabels(ax,opts.zTickLabels); end
    end
    sc.MarkerEdgeColor = "flat";
    if opts.markerFilled, sc.MarkerFaceColor = "flat";
    else,                 sc.MarkerFaceColor = "none";
    end
    if opts.gridOn,        grid(ax,"on");                                                                                           end
    if opts.axisEqual,     AxisEqual_(ax,"margin",opts.axisMargin,"centerOrigin",opts.centerOrigin,"tightLimits",opts.tightLimits); end
    if opts.axisHighlight, AxisHighlight_(ax,is2D);                                                                                 end

    % set position if axes is inside a grid
    SetAxesPosition_(ax,opts.layoutPos);
end