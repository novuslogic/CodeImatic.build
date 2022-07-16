unit CodeImatic;

interface

Uses cmd;

  
function codegen(aProject: string;  aWorkingdirectory: string;aOptions: string): Integer;
function codegenex(aProject: string;  aVariableCmdLineList: TVariableCmdLineList; aWorkingdirectory: string;aOptions: string; aPreCompatible: boolean; aProjectConfig: string): Integer;
function GetcodegenPath(aPreCompatible: boolean): String;

implementation


function GetcodegenPath(aPreCompatible: boolean): String;
begin
  if not aPreCompatible then
    begin
      Result := Files.IncludeTrailingPathDelimiter(Environment.GetEnvironmentVar('CODEIMATIC_CODEGEN'));
      if Trim(Result) = '' then Result := Files.IncludeTrailingPathDelimiter(Environment.GetEnvironmentVar('ZCODE'));
    end
  else
    Result := Files.IncludeTrailingPathDelimiter(Environment.GetEnvironmentVar('ZCODE'));
 
  If Trim(Result) = '' then
    RaiseException(erCustomError, 'Environment variable "CODEIMATIC_CODEGEN" - codeimatic.codegen.exe path. cannot be found.')
end;

function codegen(aProject: string; aWorkingdirectory: string;aOptions: string): Integer;
begin
  result := codegenex(aProject,  NIL, aWorkingdirectory,aOptions, false, '');
end;

function codegenex(aProject: string; aVariableCmdLineList: TVariableCmdLineList; aWorkingdirectory: string;aOptions: string; aPreCompatible: boolean; aProjectConfig: string): Integer;
var
  SB: TStringBuilder;
  lsVarCmdLines: string;
begin
  Result := -1;

  lsVarCmdLines := '';
Try
  if not Folder.Exists(GetcodegenPath(aPreCompatible)) then 
    begin
      if not aPreCompatible then 
        RaiseException(erCustomError, 'CodeImatic.codegen Configured path [' + GetcodegenPath(aPreCompatible) +'] cannot not be found.')
      else  
        RaiseException(erCustomError, 'zcodegen Configured path [' + GetcodegenPath(aPreCompatible) +'] cannot not be found.');
    end;


    SB:= TStringBuilder.Create;


    if not aPreCompatible then 
       SB.Append(GetcodegenPath(aPreCompatible) + 'codeimatic.codegen.exe ')
    else
       SB.Append(GetcodegenPath(aPreCompatible) + 'zcodegen.exe ');
    

    SB.Append('-project ' + aProject + ' ');

    if Trim(aProjectConfig) <> '' then
       SB.Append('-projectconfig ' + aProjectConfig + ' ');  

    if not aPreCompatible then  SB.Append('-consoleoutputonly ');

    if aWorkingdirectory <> '' then 
      SB.Append('-workingdirectory '+  aWorkingdirectory+ ' ');   

    If Assigned(aVariableCmdLineList) then
        lsVarCmdLines := aVariableCmdLineList.ToVarCmdLines;
    if lsVarCmdLines <> '' then
       SB.Append(lsVarCmdLines + ' ');


    if aOptions <> '' then
      SB.Append(aOptions + ' ');   
  
    //Output.logformat('Running: %s', [SB.ToString]);

    Output.log('Running: ' + SB.ToString);

    result := Exec(sb.ToString);
 
  finally
    SB.Free;
  end;
 
   Result := 0;
end;    
  

end.
