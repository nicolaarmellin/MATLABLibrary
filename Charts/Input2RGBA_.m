%% Nicola Armellin - RaceUP Hybrid

function RGBMat = Input2RGBA_(color)

    % no color provided → 0*4 empty vector
    if isempty(color), RGBMat = zeros(0,4); return; end

    % color passed in RGB(A) form → stack alpha if needed
    if isnumeric(color)
        if size(color,2)==4, RGBMat = color;
        else,                RGBMat = [color,0.8*ones(size(color,1),1)];
        end
        return;
    end

    % fallback → let MATLAB handle conversion to RGB and stack alpha
    RGBMat = validatecolor(color,"multiple");
    RGBMat = [RGBMat,0.8*ones(size(RGBMat,1),1)];
end