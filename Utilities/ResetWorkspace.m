%% Nicola Armellin — RaceUP Hybrid
%
%  RESETWORKSPACE Clear base workspace and command window and close figures.
%
%  Usage:
%    ResetWorkspace()
%    ResetWorkspace("hidden")
%    ResetWorkspace("force")
%
%  Inputs:
%    "hidden"  —  Close hidden figures
%    "force"   —  Close hidden and protected figures



function ResetWorkspace(tag)

    arguments
        tag (1,1) string {mustBeMember(tag,["","hidden","force"])} = ""
    end

    % clear workspace
    evalin("base","clearvars;");

    % clear command window
    clc;

    % close figures
    if tag=="", close("all");
    else,       close("all",tag);
    end
end