unit Docto

interface

Uses Windows, Cmd, Powrshell;

function FindDocToFolder: string;


implementation


function FindDocToFolder: string;
begin
  result := '';
   
  
  result := File.IncludeTrailingPathDelimiter(Program_FilesFolder) + 'DocTo\';
end;





