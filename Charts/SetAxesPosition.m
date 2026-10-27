%% Nicola Armellin — RaceUP Hybrid
%
%  SETAXESPOSITION Set position and span of an axes located inside a GridLayout or TiledChartLayout object.
%
%  Usage:
%    SetAxesPosition(ax,pos)
%
%  Inputs:
%    ax   —  Handle to axes/uiaxes object
%    pos  —  Position (2-elements cell array)



function SetAxesPosition(ax,pos)

    switch class(ax.Parent)
        case "matlab.ui.container.GridLayout"          % axes into uigridlayout
            ax.Layout.Row    = pos{1};
            ax.Layout.Column = pos{2};
        case "matlab.graphics.layout.TiledChartLayout" % axes into tiledlayout
            gridSize       = ax.Parent.GridSize;
            ax.Layout.Tile = (pos{1}-1)*gridSize(2)+pos{2};
    end
end