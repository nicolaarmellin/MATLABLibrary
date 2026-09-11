%% Nicola Armellin - RaceUP Hybrid

function ax = Hist_(parent,data,opts)

    arguments (Input)
        parent              (1,1) handle
        data                (:,:) {mustBeNumeric}
        opts.fontSize       (1,1) double  = 18
        opts.layoutPos      (1,2) cell    = {1,1}
        opts.skipNaN        (1,1) logical = false
        opts.normMethod     (1,1) string  = "count"
        opts.binNumber      (1,1) double  = 11
        opts.xLabel         (1,1) string  = "X Data"
        opts.yLabel         (1,1) string  = "Y Data"
        opts.xLim           (1,2) double  = []
        opts.yLim           (1,2) double  = []
        opts.xTicks         (1,:) double  = []
        opts.yTicks         (1,:) double  = []
        opts.xTickLabels    (1,:) string  = string.empty
        opts.yTickLabels    (1,:) string  = string.empty
        opts.faceColors     (:,:)         = []
        opts.edgeColors     (:,:)         = []
        opts.edgeWidths     (1,:) double  = []
        opts.gridOn         (1,1) logical = true
        opts.axisHighlight  (1,1) logical = false
        opts.legendOn       (1,1) logical = false
        opts.legendEntries  (1,:) string  = string.empty
        opts.legendLocation (1,1) string  = "northeast"
    end

    % create axes object
    ax = Axes_(parent,opts.fontSize);

    % mask all-NaN columns if requested
    mask = true(1,size(data,2));
    if opts.skipNaN, mask = ~all(isnan(data),1); end
    data    = data(:,mask);
    nSeries = size(data,2);

    % plot data
    hold(ax,"on");
    hg = gobjects(1,nSeries);
    for ii = 1:nSeries, hg(ii) = histogram(ax,data(:,ii),"Normalization",opts.normMethod,"NumBins",opts.binNumber); end
    hold(ax,"off");

    % resolve face/edge colors
    [faceColors,edgeColors] = deal(ax.ColorOrder);
    switch [isempty(opts.faceColors),isempty(opts.edgeColors)]
        case [false,false]
            faceColors = Input2RGBA_(opts.faceColors);
            edgeColors = Input2RGBA_(opts.edgeColors);
        case [false,true]
            [faceColors,edgeColors] = deal(Input2RGBA_(opts.faceColors));
        case [true,false]
            [faceColors,edgeColors] = deal(Input2RGBA_(opts.edgeColors));
    end

    % per-series style options
    for ii = 1:nSeries
        fColor = faceColors(mod(ii-1,size(faceColors,1))+1,:);
        eColor = edgeColors(mod(ii-1,size(edgeColors,1))+1,:);
        hg(ii).FaceColor = fColor(1:3);
        hg(ii).EdgeColor = eColor(1:3);
        if numel(fColor)==4,          hg(ii).FaceAlpha = fColor(4);                                           end
        if numel(eColor)==4,          hg(ii).EdgeAlpha = eColor(4);                                           end
        if ~isempty(opts.edgeWidths), hg(ii).LineWidth = opts.edgeWidths(mod(ii-1,numel(opts.edgeWidths))+1); end
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
    if opts.axisHighlight,         AxisHighlight_(ax);                                                                                    end

    % set position if axes is inside a grid
    SetAxesPosition_(ax,opts.layoutPos);
end