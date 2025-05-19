function ss_exportgraphics(FileName, FigHandle, Res)
%
% Exports a matlab figure in the desired format.
%
%-------------------------------------------------------------------------------
% Inputs
%-------------------------------------------------------------------------------
% FileName   - File name including extension [char]
% FigHandle  - Figure handle [graphics object]
% Res        - Resolution [char] 
%-------------------------------------------------------------------------------
% Outputs
%-------------------------------------------------------------------------------
% -/-
% ------------------------------------------------------------------------------
% 20/12/2024: Generated (SS)
% 20/12/2024: Last modified (SS)

%% .............................................................................Determine content type 

if contains(FileName, '.pdf')
    ContentType = 'vector'; 
else
    ContentType = 'auto'; 
end 

%% .............................................................................Export 

exportgraphics(FigHandle, FileName, 'Resolution', Res, 'ContentType', ContentType);

end
