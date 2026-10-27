%% Nicola Armellin — RaceUP Hybrid
%
%  INPUT2RGBA Convert input colors to RGB + transparency format.
%
%  Usage:
%    RGBA = Input2RGBA(in)
%
%  Inputs:
%    in    —  Numeric matrix (N-by-3 or N-by-4) or string vector
%
%  Outputs:
%    RGBA  —  RGB + transparency vector/matrix

function RGBA = Input2RGBA(in)

    % no color provided → 0*4 empty vector
    if isempty(in), RGBA = zeros(0,4); return; end

    % color passed in RGB(A) form → stack alpha if needed
    if isnumeric(in)
        if size(in,2)==4, RGBA = in;
        else,                 RGBA = [in,0.8*ones(size(in,1),1)];
        end
        return;
    end

    % fallback → let MATLAB handle conversion to RGB and stack alpha
    RGBA = validatecolor(in,"multiple");
    RGBA = [RGBA,0.8*ones(size(RGBA,1),1)];
end