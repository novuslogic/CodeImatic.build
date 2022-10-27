unit Docto;

interface

Uses Windows, Cmd;

// https://tobya.github.io/DocTo/
// choco install docto
// https://docs.microsoft.com/en-us/dotnet/api/microsoft.office.interop.word.wdsaveformat?view=word-pia


function FindDocToFolder: string;
function DocTo(const aInputFilename: string;const aOutputFilename: string; const aSaveFormat: string;const aOption: string): Integer;

implementation

function FindDocToFolder: string;
begin
  result := '';
   
  
  result := Files.IncludeTrailingPathDelimiter('C:\ProgramData\chocolatey\bin');
end;

function DocTo(const aInputFilename: string;const aOutputFilename: string; const aSaveFormat: string;const aOption: string): Integer;
var
  SB: TStringBuilder;
begin
   Result := -1;
   

   Try
     SB:= TStringBuilder.Create;
     SB.Append('"' + FindDocToFolder + 'DocTo.exe'  + '" ');
  
     if Trim(aOption) <> '' then SB.Append(aOption + ' ');
 
     SB.Append('-f "' + aInputFilename + '" -O "' + aOutputFilename +'" ');
     SB.Append('-t '+ aSaveFormat)

     Output.logformat('Running: %s', [SB.ToString]);

     result := Exec(sb.ToString); 
  finally
    SB.Free;
  End;
 
end;


end.




