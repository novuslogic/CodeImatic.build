unit powershell;

interface

Uses cmd, Windows;

function IsPowerShellInstalled: Boolean;
function PSExecCommand(aCommand: string): Integer;
function PSExecCommandEx(aCommand: string; var Output: string): Integer;
function PSExecFilename(aFilename: string): Integer;
function IsExecutionPolicyRestricted: boolean;
function IsChocolateyInstalled: boolean;

implementation


function IsChocolateyInstalled: boolean;
begin
   Result := Files.Exists(Files.IncludeTrailingPathDelimiter(ProgramDataFolder) +'chocolatey\choco.exe');
end;

function IsPowerShellInstalled: Boolean;
begin
  Result := Registry.KeyExists(HKEY_LOCAL_MACHINE, 'SOFTWARE\Microsoft\PowerShell\1\');
end;

function PSExecCommand(aCommand: string): Integer;
begin
  if not IsPowerShellInstalled then
    RaiseException(erCustomError, 'Powershell not installed'); 
  
  result := Exec('powershell.exe "' + aCommand +'"');
end;

function PSExecCommandEx(aCommand: string; var Output: string): Integer;
begin
  if not IsPowerShellInstalled then
    RaiseException(erCustomError, 'Powershell not installed'); 

  result := ExecEx('powershell.exe "' + aCommand +'"', Output);
end;

function PSExecFilename(aFilename: string): Integer;
begin
  Result := -1;

  if not IsPowerShellInstalled then
    RaiseException(erCustomError, 'Powershell not installed'); 

  if IsExecutionPolicyRestricted then 
    RaiseException(erCustomError, 'Execution Policy is Restricted');  
  
  if not Files.Exists(aFilename) then
    RaiseException(erCustomError, 'Powershell Filename cannot be found ['+ aFilename + ']');

  result := Exec('powershell.exe -File ' + aFilename);
end;

function IsExecutionPolicyRestricted: boolean;
var 
  lsOutput: string;
begin
  if PSExecCommandEx('Get-ExecutionPolicy', lsOutput) <> 0 then
     RaiseException(erCustomError, 'Error execute Powershell command.');

  Result := (lowercase(trim(lsOutput)) = 'restricted');   
end;

end.


