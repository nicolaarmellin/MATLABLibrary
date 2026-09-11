%% Nicola Armellin - RaceUP Hybrid

function Legend_(ax,entries,nSeries,mask,opts)

    arguments (Input)
        ax            (1,1) {mustBeA(ax,["matlab.graphics.axis.Axes","matlab.ui.control.UIAxes"])}
        entries       (1,:) string
        nSeries       (1,1) double
        mask          (1,:) logical
        opts.location (1,1) string = "northeast"
        opts.fontSize (1,1) double = 16
    end

    % process entries
    legEntries = "Dataset #"+string(1:nSeries);
    if ~isempty(entries)
        assert(numel(entries)>=numel(mask),"The number of legend entries must be greater than or equal to the number of datasets.");
        legEntries = entries(mask);
    end

    % create legend
    legend(ax,legEntries,"Location",opts.location,"FontSize",opts.fontSize);
end