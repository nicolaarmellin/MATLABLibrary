%% Nicola Armellin — RaceUP Hybrid
%
%  PLOT_ Draw plot.
%
%  Usage:
%    ax = Plot_(parent,xData,yData,opts)
%
%  Inputs:
%    parent          —  Handle to parent object
%    xData           —  X-axis data vector
%    yData           —  Y-axis data vector/matrix
%    FontSize        —  Global font size of the plot (default = 18)
%    LayoutPos       —  Position of the plot inside a GridLayout/TiledChartLayout (optional, default = {1,1})
%    SkipNaN         —  Flag for ignoring all-NaN datasets (default = false)
%    XLabel          —  Label for x-axis (default = "X Data")
%    YLabel          —  Label for y-axis (default = "Y Data")
%    XLim            —  Limits for x-axis (2-elements row vector)
%    YLim            —  Limits for y-axis (2-elements row vector)
%    XTicks          —  Tick positions for x-axis
%    YTicks          —  Tick positions for y-axis
%    XTickLabels     —  Tick labels for x-axis
%    YTickLabels     —  Tick labels for y-axis
%    LineColors      —  Lines colors (string vector, numerical vector/matrix)
%    LineStyles      —  Lines styles (string vector)
%    LineWidths      —  Lines widths (default = 2)
%    GridOn          —  Flag for enabling background grid (default = true)
%    LegendOn        —  Flag for enabling legend (default = false)
%    LegendEntries   —  Legend entry labels (optional)
%    LegendLocation  —  Legend position (optional, default = "northeast")
%    MarkerOn        —  Flag for enabling markers (default = false)
%    MarkerFilled    —  Flag for filling markers (default = false)
%    MarkerShapes    —  Markers shapes (string vector, default = "o")
%    MarkerColors    —  Markers colors (string vector, numerical vector/matrix)
%
%  Outputs:
%    ax              —  Handle to axes/uiaxes object



function ax = Plot_(parent,xData,yData,opts)

    arguments (Input)
        parent              (1,1) handle
        xData               (:,1) {mustBeNumeric}
        yData               (:,:) {mustBeNumeric}
        opts.FontSize       (1,1) double                = 18
        opts.LayoutPos      (1,2) cell                  = {1,1}
        opts.SkipNaN        (1,1) logical               = false
        opts.XLabel         (1,1) string                = "X Data"
        opts.YLabel         (1,1) string                = "Y Data"
        opts.XLim           (1,2) double {mustBeSorted} = [0,0]
        opts.YLim           (1,2) double {mustBeSorted} = [0,0]
        opts.XTicks         (1,:) double {mustBeSorted} = zeros(1,0)
        opts.YTicks         (1,:) double {mustBeSorted} = zeros(1,0)
        opts.XTickLabels    (1,:) string                = strings(1,0)
        opts.YTickLabels    (1,:) string                = strings(1,0)
        opts.LineColors     (:,:)                       = []
        opts.LineStyles     (1,:) string                = strings(1,0)
        opts.LineWidths     (1,:) double                = 2
        opts.GridOn         (1,1) logical               = true
        opts.LegendOn       (1,1) logical               = false
        opts.LegendEntries  (1,:) string                = strings(1,0)
        opts.LegendLocation (1,1) string                = "northeast"
        opts.MarkerOn       (1,1) logical               = false
        opts.MarkerFilled   (1,1) logical               = false
        opts.MarkerShapes   (1,:) string                = "o"
        opts.MarkerColors   (:,:)                       = []
    end

    % create axes object
    ax = Axes_(parent,opts.FontSize);

    % mask all-NaN columns if requested
    mask = true(1,size(yData,2));
    if opts.SkipNaN, mask = ~all(isnan(yData),1); end
    yData   = yData(:,mask);
    nSeries = size(yData,2);

    % plot data
    pl = plot(ax,xData,yData);

    % resolve line/marker colors
    [lineColors,markerColors] = deal(ax.ColorOrder);
    hasL = ~isempty(opts.LineColors);
    hasM = ~isempty(opts.MarkerColors);
    if hasL,            lineColors   = Input2RGBA(opts.LineColors);   end
    if hasM,            markerColors = Input2RGBA(opts.MarkerColors); end
    if (hasL)&&(~hasM), markerColors = lineColors;                    end
    if (hasM)&&(~hasL), lineColors   = markerColors;                  end

    % per-series style options
    for ii = 1:nSeries
        pl(ii).LineWidth = opts.LineWidths(mod(ii-1,numel(opts.LineWidths))+1);
        pl(ii).Color     = lineColors(mod(ii-1,size(lineColors,1))+1,:);
        if ~isempty(opts.LineStyles), pl(ii).LineStyle = opts.LineStyles(mod(ii-1,numel(opts.LineStyles))+1); end
        if opts.MarkerOn
            color                  = markerColors(mod(ii-1,size(markerColors,1))+1,:);
            pl(ii).Marker          = opts.MarkerShapes(mod(ii-1,numel(opts.MarkerShapes))+1);
            pl(ii).MarkerEdgeColor = color;
            pl(ii).MarkerFaceColor = "none";
            if opts.MarkerFilled, pl(ii).MarkerFaceColor = color; end
        end
    end

    % global style options
    xlabel(ax,opts.XLabel);
    ylabel(ax,opts.YLabel);
    if (any(opts.XLim))&&(opts.XLim(1)<opts.XLim(2)), xlim(ax,opts.XLim);                                                                                    end
    if (any(opts.YLim))&&(opts.YLim(1)<opts.YLim(2)), ylim(ax,opts.YLim);                                                                                    end
    if ~isempty(opts.XTicks),                         xticks(ax,opts.XTicks);                                                                                end
    if ~isempty(opts.YTicks),                         yticks(ax,opts.YTicks);                                                                                end
    if ~isempty(opts.XTickLabels),                    xticklabels(ax,opts.XTickLabels);                                                                      end
    if ~isempty(opts.YTickLabels),                    yticklabels(ax,opts.YTickLabels);                                                                      end
    if opts.GridOn,                                   grid(ax,"on");                                                                                         end
    if opts.LegendOn,                                 Legend_(ax,opts.LegendEntries,nSeries,mask,"Location",opts.LegendLocation,"FontSize",opts.FontSize-2); end

    % set position if axes is inside a grid
    SetAxesPosition(ax,opts.LayoutPos);
end