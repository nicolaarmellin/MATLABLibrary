%% Nicola Armellin - RaceUP Hybrid

function SetAxesPosition_(ax,position)

    switch class(ax.Parent)
        case "matlab.ui.container.GridLayout"          % axes into uigridlayout
            ax.Layout.Row    = position{1};
            ax.Layout.Column = position{2};
        case "matlab.graphics.layout.TiledChartLayout" % axes into tiledlayout
            gridSize       = ax.Parent.GridSize;
            ax.Layout.Tile = (position{1}-1)*gridSize(2)+position{2};
    end
end