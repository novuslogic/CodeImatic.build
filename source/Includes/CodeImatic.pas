unit CodeImatic;

interface

Uses cmd;

function codegen(aProject: string; aProjectconfig: string; aVariables: string; aWorkingdirectory: string;aOptions: string): Integer;
function GetcodegenPath: String;


implementation


function GetcodegenPath: String;
begin
  Result := File.IncludeTrailingPathDelimiter(Environment.GetEnvironmentVar('ZCODE'));
end;

function ccodegen(aProject: string; aProjectconfig: string; aVariables: string; aWorkingdirectory: string;aOptions: string): Integer;
var
  SB: TStringBuilder;
begin
  Result := -1;

  
  if not Folder.Exists(GetcodegenPath) then 
    begin
      RaiseException(erCustomError, 'CodeImatic.codegen Configured path [' + GetcodegenPath +'] cannot not be found.');

      Exit;
    end;

  try
    SB:= TStringBuilder.Create;

    SB.Append(GetcodegenPath + 'codeitmatic.codegen.exe ');

    SB.Append('-project ' + aProject + ' ');
    SB.Append('-projectconfig ' + aProjectconfig + ' ');
    SB.Append('-consoleoutputonly ');

    if aWorkingdirectory <> '' then 
      SB.Append('-workingdirectory '+  aWorkingdirectory+ ' ');   

    if aVariables <> '' then 
       SB.Append('-var ' + aVariables + ' ');

    if aOptions <> '' then
      SB.Append(aOptions + ' ');   

  
    Output.logformat('Running: %s', [SB.ToString]);

    result := Exec(sb.ToString);
  finally
    SB.Free;
  end;
end;    
  

end.
