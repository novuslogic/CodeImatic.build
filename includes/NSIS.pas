unit NSIS;

interface

Uses Windows, Cmd;


// http://nsis.sourceforge.net/Docs/Chapter3.html


function FindNSISFolder: string;
function MakeNSIS(const aFilename: string;const aOption: string): Integer;

implementation

function MakeNSIS(const aFilename: string;const aOption: string): Integer;
var
  SB: TStringBuilder;
begin
   Result := -1;
   

   Try
     SB:= TStringBuilder.Create;
     SB.Append('"' + FindNSISFolder + 'MakeNSIS.exe'  + '" ');

  
     if Trim(aOption) <> '' then SB.Append(aOption + ' ');

     SB.Append('"' + aFilename  + '"');

     Output.logformat('Running: %s', [SB.ToString]);

     result := Exec(sb.ToString);
  
  finally
    SB.Free;
  End;
 
end;


function FindNSISFolder: string;
begin
  result := Files.IncludeTrailingPathDelimiter(Program_FilesFolder) + 'NSIS\';

  if not Folders.Exists(result) then 
    begin
      Result := Files.IncludeTrailingPathDelimiter(Program_Filesx86Folder) + 'NSIS\';
      if not Folders.Exists(result) then
        begin
          if ProjectConfig.IsPropertyExists('NSISDIR') then 
               result := Files.IncludeTrailingPathDelimiter(ProjectConfig.Getproperty('NSISDIR'));
          if not Folders.Exists(result) then
             RaiseException(erCustomError, 'NSIS folder cannot be found ['+ result + ']');      
        end;      
    end;
    
end;

end.
