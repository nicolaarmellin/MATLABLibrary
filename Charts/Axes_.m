%% Nicola Armellin — RaceUP Hybrid
%
%  AXES_ Create axes/uiaxes object based on root figure type.
%
%  Usage:
%    ax = Axes_(parent,fontSize)
%
%  Inputs:
%    parent    —  Handle to parent object
%    fontSize  —  Global font size of the axes
%
%  Outputs:
%    ax        —  Handle to axes/uiaxes object



function ax = Axes_(parent,fontSize)

    arguments (Input)
        parent   (1,1) handle
        fontSize (1,1) double = 18
    end

    % define function arguments
    args = {parent,"FontSize",fontSize};

    % create axes/uiaxes object based on figure
    fig = ancestor(parent,"figure");
    if isprop(fig,"AutoResizeChildren"), ax = uiaxes(args{:});
    else,                                ax = axes(args{:});
    end
end