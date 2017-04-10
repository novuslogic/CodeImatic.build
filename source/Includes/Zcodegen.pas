unit Zcodegen;

interface

Uses cmd;

function Zcodegen(aProject: string; aProjectconfig: string; aVariables: string; aOptions: string): Integer;
function GetZodegenPath: String;


implementation


function GetZodegenPath: String;
begin
  Result := File.IncludeTrailingPathDelimiter(Environment.GetEnvironmentVar('ZCODE'));
end;

function Zcodegen(aProject: string; aProjectconfig: string; aVariables: string; aOptions: string): Integer;
var
  SB: TStringBuilder;
begin
  Result := -1;

  
  if not Folder.Exists(GetZodegenPath) then 
    begin
      RaiseException(erCustomError, 'Zcodegen Configured path [' + GetZodegenPath +'] cannot not be found.');

      Exit;
    end;

  try
    SB:= TStringBuilder.Create;

    SB.Append(GetZodegenPath + 'zcodegen.exe ');

    SB.Append('-project ' + aProject + ' ');
    SB.Append('-projectconfig ' + aProjectconfig + ' ');
    SB.Append('-consoleoutputonly ');

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
