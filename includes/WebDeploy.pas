unit WebDeploy;

interface

(*

Web Deploy error codes
https://docs.microsoft.com/en-us/iis/publish/troubleshooting-web-deploy/web-deploy-error-codes

Web Deploy PowerShell Cmdlets
https://docs.microsoft.com/en-us/iis/publish/using-web-deploy/packaging-and-restoring-a-web-site

Web Deploy runCommand Provider
https://docs.microsoft.com/en-us/previous-versions/windows/it-pro/windows-server-2008-R2-and-2008/ee619740(v=ws.10)

*)

Uses Windows, Cmd;

const 
  cMSdeploy = 'msdeploy.exe';

function GetWebDeployFolder: String;


implementation



function GetWebDeployFolder: String;
var 
  lsWebDeployFolder: string;
begin
  Result := '';

  // "%programfiles%\IIS\Microsoft Web Deploy V3\msdeploy.exe"

  lsWebDeployFolder := Environment.GetEnvironmentVar('programfiles') + 'IIS\Microsoft Web Deploy V3\' + cMSdeploy;

  if ProjectConfig.IsPropertyExists('webdeployfolder') then
    result := File.IncludeTrailingPathDelimiter(ProjectConfig.Getproperty('webdeployfolder'));

  If Result = '' then 
    begin
      if not IsWin64 then 
        Result := cvb6win32bin
      else
        Result := cvb6win64bin;
    end;       
end;









end.