%% Nicola Armellin - RaceUP Hybrid
%
% logger = CMDLogger(filePath) — start mirroring cmd window to file
% logger.delete()              — stop diary and destroy
%
% NOTE
%  MATLAB's diary() is a single global stream — there is only ever one active diary target for the whole MATLAB session. This class guards against
%  two CMDLogger instances fighting over it: if one instance's diary is active, a second instance's call will warn and refuse rather than silently
%  hijacking the stream. This guard only covers CMDLogger instances — it cannot detect or prevent code outside this class calling the diary(...)
%  function directly. 



classdef CMDWindow_Logger < handle

    properties (Access = private)
        filePath    (1,1) string  = ""
        diaryActive (1,1) logical = false
    end

    methods (Access = public)

        % constructor
        function obj = CMDWindow_Logger(filePath)
            if (nargin<1)||(isempty(filePath)||(strlength(filePath)<1)), warning("CMDLogger: empty or undefined filepath."); return; end
            obj.filePath = string(filePath);
            folder = fileparts(obj.filePath);
            if (strlength(folder)>0)&&(~isfolder(folder)), mkdir(folder); end
            owner = CMDWindow_Logger.diaryOwner();
            if strlength(owner)>0, warning("CMDLogger: diary logging is already active for another CMDLogger (""%s"").",owner); return; end
            fid = fopen(obj.filePath,"a","n","UTF-8");
            if fid==-1, error("CMDLogger: could not open/create file: %s.",obj.filePath); end
            fprintf(fid,"\n\n\n=== LOGGING ACTIVE — %s ===\n\n",string(datetime("now")));
            fclose(fid);
            diary(obj.filePath);
            diary("on");
            obj.diaryActive = true;
            CMDWindow_Logger.diaryOwner(obj.filePath); % claim diary stream
        end

        % destructor
        function delete(obj)
            if ~obj.diaryActive, return; end
            diary("off");
            obj.diaryActive = false;
            if CMDWindow_Logger.diaryOwner()==obj.filePath, CMDWindow_Logger.diaryOwner(""); end % release diary stream claim only if the class holds it
        end
    end

    methods (Static, Access = private)

        % tracks which CMDLogger owns the diary stram
        function owner = diaryOwner(newOwner)
            persistent currentOwner
            if isempty(currentOwner), currentOwner = "";       end
            if nargin>0,              currentOwner = newOwner; end
            owner = currentOwner;
        end
    end
end