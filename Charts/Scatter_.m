%% Nicola Armellin — RaceUP Hybrid
%
%  SCATTER_ Draw scatter.
%
%  Usage:
%    ax = Scatter_(parent,xData,yData,zData,cData,opts)
%
%  Inputs:
%    parent            —  Handle to parent object
%    xData             —  X-axis data vector
%    yData             —  Y-axis data vector
%    zData             —  Z-axis data vector (zeros(0,1) or all-NaN for 2D scatter)
%    cData             —  Color data vector
%    FontSize          —  Global font size of the scatter (default = 18)
%    LayoutPos         —  Position of the scatter inside a GridLayout/TiledChartLayout (optional, default = {1,1})
%    Colormap          —  Colormap name (default = "turbo")
%    ColorbarLocation  —  Colorbar position (default = "eastoutside")
%    MarkerFilled      —  Flag for filling markers (default = false)
%    MarkerSize        —  Markers size (default = 30)
%    MarkerShape       —  Markers shape (default = "o")
%    XLabel            —  Label for x-axis (default = "X Data")
%    YLabel            —  Label for y-axis (default = "Y Data")
%    ZLabel            —  Label for z-axis (default = "Z Data")
%    CLabel            —  Label for colorbar (default = "Color Data")
%    XLim              —  Limits for x-axis (2-elements row vector)
%    YLim              —  Limits for y-axis (2-elements row vector)
%    ZLim              —  Limits for z-axis (2-elements row vector)
%    CLim              —  Limits for colorbar (2-elements row vector)
%    XTicks            —  Tick positions for x-axis
%    YTicks            —  Tick positions for y-axis
%    ZTicks            —  Tick positions for z-axis
%    CTicks            —  Tick positions for colorbar
%    XTickLabels       —  Tick labels for x-axis
%    YTickLabels       —  Tick labels for y-axis
%    ZTickLabels       —  Tick labels for z-axis
%    CTickLabels       —  Tick labels for colorbar
%    GridOn            —  Flag for enabling background grid (default = true)
%    AxisHighlight     —  Flag for highlighting zero axis (default = false)
%    AxisEqual         —  Flag for enforcing equal axis scaling (default = false)
%    AxisMargin        —  Padding around axes/uiaxes area (default = 0)
%    CenterOrigin      —  Flag for enforcing symmetric axis limits (default = false)
%    TightLimits       —  Flag for forcing axis limits to match data range (default = false)
%
%  Outputs:
%    ax                —  Handle to axes/uiaxes object



function ax = Scatter_(parent,xData,yData,zData,cData,opts)

    arguments (Input)
        parent                (1,1) handle
        xData                 (:,1) {mustBeNumeric}
        yData                 (:,1) {mustBeNumeric}
        zData                 (:,1) {mustBeNumeric}
        cData                 (:,1) {mustBeNumeric}
        opts.FontSize         (1,1) double                = 18
        opts.LayoutPos        (1,2) cell                  = {1,1}
        opts.Colormap         (1,1) string                = "turbo"
        opts.ColorbarLocation (1,1) string                = "eastoutside"
        opts.MarkerFilled     (1,1) logical               = false
        opts.MarkerSize       (1,1) double                = 30
        opts.MarkerShape      (1,1) string                = "o"
        opts.XLabel           (1,1) string                = "X Data"
        opts.YLabel           (1,1) string                = "Y Data"
        opts.ZLabel           (1,1) string                = "Z Data"
        opts.CLabel           (1,1) string                = "Color Data"
        opts.XLim             (1,2) double {mustBeSorted} = [0,0]
        opts.YLim             (1,2) double {mustBeSorted} = [0,0]
        opts.ZLim             (1,2) double {mustBeSorted} = [0,0]
        opts.CLim             (1,2) double {mustBeSorted} = [0,0]
        opts.XTicks           (1,:) double {mustBeSorted} = zeros(1,0)
        opts.YTicks           (1,:) double {mustBeSorted} = zeros(1,0)
        opts.ZTicks           (1,:) double {mustBeSorted} = zeros(1,0)
        opts.CTicks           (1,:) double {mustBeSorted} = zeros(1,0)
        opts.XTickLabels      (1,:) string                = strings(1,0)
        opts.YTickLabels      (1,:) string                = strings(1,0)
        opts.ZTickLabels      (1,:) string                = strings(1,0)
        opts.CTickLabels      (1,:) string                = strings(1,0)
        opts.GridOn           (1,1) logical               = true
        opts.AxisHighlight    (1,1) logical               = false
        opts.AxisEqual        (1,1) logical               = false
        opts.AxisMargin       (1,1) double                = 0
        opts.CenterOrigin     (1,1) logical               = false
        opts.TightLimits      (1,1) logical               = false
    end

    % 2D scatter if zData is empty or NaN
    is2D = (isempty(zData))||(all(isnan(zData),"all"));

    % create axes object
    ax = Axes_(parent,opts.FontSize);

    % plot data
    args = {opts.MarkerSize,cData,opts.MarkerShape};
    if is2D, sc = scatter(ax,xData,yData,args{:});
    else,    sc = scatter3(ax,xData,yData,zData,args{:});
    end

    % create colorbar
    colormap(ax,opts.Colormap);
    cb = colorbar(ax,"Location",opts.ColorbarLocation,"FontSize",opts.FontSize-2);
    cb.Label.String   = opts.CLabel;
    cb.Label.FontSize = opts.FontSize-2;
    if (any(opts.CLim))&&(opts.CLim(1)<opts.CLim(2)), clim(ax,opts.CLim);               end
    if ~isempty(opts.CTicks),                         cb.Ticks      = opts.CTicks;      end
    if ~isempty(opts.CTickLabels),                    cb.TickLabels = opts.CTickLabels; end

    % global style options
    xlabel(ax,opts.XLabel);
    ylabel(ax,opts.YLabel);
    if (any(opts.XLim))&&(opts.XLim(1)<opts.XLim(2)), xlim(ax,opts.XLim);               end
    if (any(opts.YLim))&&(opts.YLim(1)<opts.YLim(2)), ylim(ax,opts.YLim);               end
    if ~isempty(opts.XTicks),                         xticks(ax,opts.XTicks);           end
    if ~isempty(opts.YTicks),                         yticks(ax,opts.YTicks);           end
    if ~isempty(opts.XTickLabels),                    xticklabels(ax,opts.XTickLabels); end
    if ~isempty(opts.YTickLabels),                    yticklabels(ax,opts.YTickLabels); end
    if ~is2D
        zlabel(ax,opts.ZLabel);
        if (any(opts.ZLim))&&(opts.ZLim(1)<opts.ZLim(2)), zlim(ax,opts.ZLim);               end
        if ~isempty(opts.ZTicks),                         zticks(ax,opts.ZTicks);           end
        if ~isempty(opts.ZTickLabels),                    zticklabels(ax,opts.ZTickLabels); end
    end
    sc.MarkerEdgeColor = "flat";
    if opts.MarkerFilled, sc.MarkerFaceColor = "flat";
    else,                 sc.MarkerFaceColor = "none";
    end
    if opts.GridOn,        grid(ax,"on");                                                                                          end
    if opts.AxisEqual,     AxisEqual(ax,"Margin",opts.AxisMargin,"CenterOrigin",opts.CenterOrigin,"TightLimits",opts.TightLimits); end
    if opts.AxisHighlight, AxisHighlight(ax,"Is2D",is2D);                                                                          end

    % set position if axes is inside a grid
    SetAxesPosition(ax,opts.LayoutPos);
end