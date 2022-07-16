{$I CodeImatic.build.inc}
program CodeImatic.build;

{$APPTYPE CONSOLE}
{$R *.res}

uses
  System.ShareMem,
  System.SysUtils,
  Config,
  Runtime,
  PluginsMapFactory in 'PluginsMapFactory.pas',
  APIBase in 'Plugins\API\APIBase.pas',
  API_ProjectConfig in 'Plugins\API\API_ProjectConfig.pas',
  Plugin_ProjectConfig in 'Plugins\Plugin_ProjectConfig.pas',
  uPSI_API_ProjectConfig in 'Plugins\Imports\uPSI_API_ProjectConfig.pas',
  Plugin_IniFile in 'Plugins\Plugin_IniFile.pas',
  uPSI_API_IniFile in 'Plugins\Imports\uPSI_API_IniFile.pas',
  API_IniFile in 'Plugins\API\API_IniFile.pas',
  API_Folder in 'Plugins\API\API_Folder.pas',
  Plugin_Folder in 'Plugins\Plugin_Folder.pas',
  uPSI_API_Folder in 'Plugins\Imports\uPSI_API_Folder.pas',
  uPSI_ExtraClasses in 'Plugins\Imports\uPSI_ExtraClasses.pas',
  uPSR_ExtraClasses in 'Plugins\Imports\uPSR_ExtraClasses.pas',
  Plugin_RegEx in 'Plugins\Plugin_RegEx.pas',
  API_RegEx in 'Plugins\API\API_RegEx.pas',
  uPSI_API_RegEx in 'Plugins\Imports\uPSI_API_RegEx.pas',
  API_Path in 'Plugins\API\API_Path.pas',
  uPSI_API_Path in 'Plugins\Imports\uPSI_API_Path.pas',
  Plugin_Path in 'Plugins\Plugin_Path.pas',
  Plugin_VariablesCmdLine in 'Plugins\Plugin_VariablesCmdLine.pas',
  API_VariablesCmdLine in 'Plugins\API\API_VariablesCmdLine.pas',
  uPSI_API_VariablesCmdLine in 'Plugins\Imports\uPSI_API_VariablesCmdLine.pas';

begin
  ExitCode := oConfig.LoadConfig;
  if ExitCode <> 0 then
    Exit;

  If Not oConfig.ParseParams then
    Exit;

  try
    ExitCode := oruntime.RunEnvironment;

  except
    on E: Exception do
      Writeln(E.ClassName, ': ', E.Message);
  end;

end.
