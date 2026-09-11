%% Nicola Armellin - RaceUP Hybrid

function ax = Plot_(parent,xData,yData,opts)

    arguments (Input)
        parent              (1,1) handle
        xData               (:,1) {mustBeNumeric}
        yData               (:,:) {mustBeNumeric}
        opts.fontSize       (1,1) double  = 18
        opts.layoutPos      (1,2) cell    = {1,1}
        opts.skipNaN        (1,1) logical = false
        opts.xLabel         (1,1) string  = "X Data"
        opts.yLabel         (1,1) string  = "Y Data"
        opts.xLim           (1,2) double  = []
        opts.yLim           (1,2) double  = []
        opts.xTicks         (1,:) double  = []
        opts.yTicks         (1,:) double  = []
        opts.xTickLabels    (1,:) string  = string.empty
        opts.yTickLabels    (1,:) string  = string.empty
        opts.lineColors     (:,:)         = []
        opts.lineStyles     (1,:) string  = string.empty
        opts.lineWidths     (1,:) double  = 2
        opts.gridOn         (1,1) logical = true
        opts.legendOn       (1,1) logical = false
        opts.legendEntries  (1,:) string  = string.empty
        opts.legendLocation (1,1) string  = "northeast"
        opts.markerOn       (1,1) logical = false
        opts.markerFilled   (1,1) logical = false
        opts.markerShapes   (1,:) string  = "o"
        opts.markerColors   (:,:)         = []
    end

    % create axes object
    ax = Axes_(parent,opts.fontSize);

    % mask all-NaN columns if requested
    mask = true(1,size(yData,2));
    if opts.skipNaN, mask = ~all(isnan(yData),1); end
    yData   = yData(:,mask);
    nSeries = size(yData,2);

    % plot data
    pl = plot(ax,xData,yData);

    % resolve line/marker colors
    [lineColors,markerColors] = deal(ax.ColorOrder);
    switch [isempty(opts.lineColors),isempty(opts.markerColors)]
        case [false,false]
            lineColors   = Input2RGBA_(opts.lineColors);
            markerColors = Input2RGBA_(opts.markerColors);
        case [false,true]
            [lineColors,markerColors] = deal(Input2RGBA_(opts.lineColors));
        case [true,false]
            [lineColors,markerColors] = deal(Input2RGBA_(opts.markerColors));
    end

    % per-series style options
    for ii = 1:nSeries
        pl(ii).LineWidth = opts.lineWidths(mod(ii-1,numel(opts.lineWidths))+1);
        pl(ii).Color     = lineColors(mod(ii-1,size(lineColors,1))+1,:);
        if ~isempty(opts.lineStyles), pl(ii).LineStyle = opts.lineStyles(mod(ii-1,numel(opts.lineStyles))+1); end
        if opts.markerOn
            color                  = markerColors(mod(ii-1,size(markerColors,1))+1,:);
            pl(ii).Marker          = opts.markerShapes(mod(ii-1,numel(opts.markerShapes))+1);
            pl(ii).MarkerEdgeColor = color;
            pl(ii).MarkerFaceColor = "none";
            if opts.markerFilled, pl(ii).MarkerFaceColor = color; end
        end
    end

    % global style options
    xlabel(ax,opts.xLabel);
    ylabel(ax,opts.yLabel);
    if ~isempty(opts.xLim),        xlim(ax,opts.xLim);                                                                                    end
    if ~isempty(opts.yLim),        ylim(ax,opts.yLim);                                                                                    end
    if ~isempty(opts.xTicks),      xticks(ax,opts.xTicks);                                                                                end
    if ~isempty(opts.yTicks),      yticks(ax,opts.yTicks);                                                                                end
    if ~isempty(opts.xTickLabels), xticklabels(ax,opts.xTickLabels);                                                                      end
    if ~isempty(opts.yTickLabels), yticklabels(ax,opts.yTickLabels);                                                                      end
    if opts.gridOn,                grid(ax,"on");                                                                                         end
    if opts.legendOn,              Legend_(ax,opts.legendEntries,nSeries,mask,"location",opts.legendLocation,"fontSize",opts.fontSize-2); end

    % set position if axes is inside a grid
    SetAxesPosition_(ax,opts.layoutPos);
end