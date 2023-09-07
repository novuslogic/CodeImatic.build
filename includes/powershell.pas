unit powershell;

interface

Uses cmd, Windows;

type 
  TPowerShellVersion = (POWERSHELL, POWERSHELL7);

function GetPowershellFullpathname(aPowerShellVersion: TPowerShellVersion): string;
function IsPowerShellInstalled(aPowerShellVersion: TPowerShellVersion): Boolean;
function PSExecCommand(aPowerShellVersion: TPowerShellVersion; aCommand: string): Integer;
function PSExecCommandEx(aPowerShellVersion: TPowerShellVersion; aCommand: string; var aOutput: string): Integer;
function PSExecScript(aPowerShellVersion: TPowerShellVersion; aFilename: string; var aOutput: string): Integer;
function IsExecutionPolicyRestricted(aPowerShellVersion: TPowerShellVersion): boolean;
function IsChocolateyInstalled: boolean;

implementation


function IsChocolateyInstalled: boolean;
begin
   Result := Files.Exists(Files.IncludeTrailingPathDelimiter(ProgramDataFolder) +'chocolatey\choco.exe');
end;

function IsPowerShellInstalled(aPowerShellVersion: TPowerShellVersion): Boolean;
begin
  Result := Registry.KeyExists(HKEY_LOCAL_MACHINE, 'SOFTWARE\Microsoft\PowerShell\1\');

  case aPowerShellVersion of
    POWERSHELL7 : Result := Files.Exists(GetPowershellFullpathname(aPowerShellVersion));
  end;
end;

function PSExecCommand(aPowerShellVersion: TPowerShellVersion; aCommand: string): Integer;
begin
  if not IsPowerShellInstalled(aPowerShellVersion) then
    RaiseException(erCustomError, 'Powershell not installed'); 
  
  result := Exec(GetPowershellFullpathname(aPowerShellVersion) + ' -Command "' + aCommand +'"');
end;

function PSExecCommandEx(aPowerShellVersion: TPowerShellVersion; aCommand: string; var Output: string): Integer;
begin
  if not IsPowerShellInstalled(aPowerShellVersion) then
    RaiseException(erCustomError, 'Powershell not installed'); 

  result := ExecEx(GetPowershellFullpathname(aPowerShellVersion) +' -Command "' + aCommand +'"', aOutput);
end;

function PSExecScript(aPowerShellVersion: TPowerShellVersion; aFilename: string): Integer;
begin
  Result := -1;

  if not IsPowerShellInstalled(aPowerShellVersion) then
    RaiseException(erCustomError, 'Powershell not installed'); 

  if IsExecutionPolicyRestricted(aPowerShellVersion)  then 
    RaiseException(erCustomError, 'Execution Policy is Restricted');  
  
  if not Files.Exists(aFilename) then
    RaiseException(erCustomError, 'Powershell Filename cannot be found ['+ aFilename + ']');

  result := Exec(GetPowershellFullpathname(aPowerShellVersion) + ' -File ' + aFilename);
end;

function IsExecutionPolicyRestricted(aPowerShellVersion: TPowerShellVersion): boolean;
var 
  lsOutput: string;
begin
  if PSExecCommandEx(aPowerShellVersion, 'Get-ExecutionPolicy', lsOutput) <> 0 then
     RaiseException(erCustomError, 'Error execute Powershell command.');

  Result := (lowercase(trim(lsOutput)) = 'restricted');   
end;

function IsPowerShellInstalled7: Boolean;
begin
  result := Files.Exists(GetPowershellFullpathname(POWERSHELL7));
end;  

function GetPowershellFullpathname(aPowerShellVersion: TPowerShellVersion): string;
begin
  result := 'powershell.exe';

  case aPowerShellVersion of
    POWERSHELL7 : Result := 'C:\Program Files\PowerShell\7\pwsh.exe';
  end;
end;





end.


