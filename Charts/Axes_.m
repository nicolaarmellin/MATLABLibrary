%% Nicola Armellin - RaceUP Hybrid

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