%% Nicola Armellin — RaceUP Hybrid
%
%  HIST_ Draw histogram.
%
%  Usage:
%    ax = Hist_(parent,data,opts)
%
%  Inputs:
%    parent          —  Handle to parent object
%    data            —  Data vector/matrix
%    FontSize        —  Global font size of the histogram (default = 18)
%    LayoutPos       —  Position of the histogram inside a GridLayout/TiledChartLayout (optional, default = {1,1})
%    SkipNaN         —  Flag for ignoring all-NaN datasets (default = false)
%    NormMethod      —  Normalization method for histogram bins (default = "count")
%    BinNumber       —  Number of histogram bins (default = 11)
%    XLabel          —  Label for x-axis (default = "X Data")
%    YLabel          —  Label for y-axis (default = "Y Data")
%    XLim            —  Limits for x-axis (2-elements row vector)
%    YLim            —  Limits for y-axis (2-elements row vector)
%    XTicks          —  Tick positions for x-axis
%    YTicks          —  Tick positions for y-axis
%    XTickLabels     —  Tick labels for x-axis
%    YTickLabels     —  Tick labels for y-axis
%    FaceColors      —  Bins face colors (string vector, numerical vector/matrix)
%    EdgeColors      —  Bins edge colors (string vector, numerical vector/matrix)
%    EdgeWidths      —  Bins edge width
%    GridOn          —  Flag for enabling background grid (default = true)
%    AxisHighlight   —  Flag for highlighting zero axis (default = false)
%    LegendOn        —  Flag for enabling legend (default = false)
%    LegendEntries   —  Legend entry labels (optional)
%    LegendLocation  —  Legend position (optional, default = "northeast")
%
%  Outputs:
%    ax              —  Handle to axes/uiaxes object



function ax = Hist_(parent,data,opts)

    arguments (Input)
        parent              (1,1) handle
        data                (:,:) {mustBeNumeric}
        opts.FontSize       (1,1) double                = 18
        opts.LayoutPos      (1,2) cell                  = {1,1}
        opts.SkipNaN        (1,1) logical               = false
        opts.NormMethod     (1,1) string                = "count"
        opts.BinNumber      (1,1) double                = 11
        opts.XLabel         (1,1) string                = "X Data"
        opts.YLabel         (1,1) string                = "Y Data"
        opts.XLim           (1,2) double {mustBeSorted} = [0,0]
        opts.YLim           (1,2) double {mustBeSorted} = [0,0]
        opts.XTicks         (1,:) double {mustBeSorted} = zeros(1,0)
        opts.YTicks         (1,:) double {mustBeSorted} = zeros(1,0)
        opts.XTickLabels    (1,:) string                = strings(1,0)
        opts.YTickLabels    (1,:) string                = strings(1,0)
        opts.FaceColors     (:,:)                       = []
        opts.EdgeColors     (:,:)                       = []
        opts.EdgeWidths     (1,:) double                = zeros(1,0)
        opts.GridOn         (1,1) logical               = true
        opts.AxisHighlight  (1,1) logical               = false
        opts.LegendOn       (1,1) logical               = false
        opts.LegendEntries  (1,:) string                = strings(1,0)
        opts.LegendLocation (1,1) string                = "northeast"
    end

    % create axes object
    ax = Axes_(parent,opts.FontSize);

    % mask all-NaN columns if requested
    mask = true(1,size(data,2));
    if opts.SkipNaN, mask = ~all(isnan(data),1); end
    data    = data(:,mask);
    nSeries = size(data,2);

    % plot data
    hold(ax,"on");
    hg = gobjects(1,nSeries);
    for ii = 1:nSeries, hg(ii) = histogram(ax,data(:,ii),"Normalization",opts.NormMethod,"NumBins",opts.BinNumber); end
    hold(ax,"off");

    % resolve face/edge colors
    [faceColors,edgeColors] = deal(ax.ColorOrder);
    hasF = ~isempty(opts.FaceColors);
    hasE = ~isempty(opts.EdgeColors);
    if hasF,            faceColors = Input2RGBA(opts.FaceColors); end
    if hasE,            edgeColors = Input2RGBA(opts.EdgeColors); end
    if (hasF)&&(~hasE), edgeColors = faceColors;                  end
    if (hasE)&&(~hasF), faceColors = edgeColors;                  end

    % per-series style options
    for ii = 1:nSeries
        fColor = faceColors(mod(ii-1,size(faceColors,1))+1,:);
        eColor = edgeColors(mod(ii-1,size(edgeColors,1))+1,:);
        hg(ii).FaceColor = fColor(1:3);
        hg(ii).EdgeColor = eColor(1:3);
        if numel(fColor)==4,          hg(ii).FaceAlpha = fColor(4);                                           end
        if numel(eColor)==4,          hg(ii).EdgeAlpha = eColor(4);                                           end
        if ~isempty(opts.EdgeWidths), hg(ii).LineWidth = opts.EdgeWidths(mod(ii-1,numel(opts.EdgeWidths))+1); end
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
    if opts.AxisHighlight,                            AxisHighlight(ax);                                                                                     end

    % set position if axes is inside a grid
    SetAxesPosition(ax,opts.LayoutPos);
end