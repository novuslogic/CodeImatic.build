{$I CodeImatic.build.inc}
program CodeImatic.build;

{$APPTYPE CONSOLE}
{$R *.res}

uses
  FastMM4,
  System.SysUtils,
  Config,
  Runtime,
  API_Output in 'Plugins\API\API_Output.pas',
  Plugins in 'Plugins.pas',
  PluginsMapFactory in 'PluginsMapFactory.pas',
  Plugin_Output in 'Plugins\Plugin_Output.pas',
  Plugin_SystemExt in 'Plugins\Plugin_SystemExt.pas',
  APIBase in 'Plugins\API\APIBase.pas',
  uPSI_API_Output in 'Plugins\Imports\uPSI_API_Output.pas',
  Plugin_Shell in 'Plugins\Plugin_Shell.pas',
  API_Shell in 'Plugins\API\API_Shell.pas',
  uPSI_API_Shell in 'Plugins\Imports\uPSI_API_Shell.pas',
  API_ProjectConfig in 'Plugins\API\API_ProjectConfig.pas',
  Plugin_ProjectConfig in 'Plugins\Plugin_ProjectConfig.pas',
  uPSI_API_ProjectConfig in 'Plugins\Imports\uPSI_API_ProjectConfig.pas',
  API_Environment in 'Plugins\API\API_Environment.pas',
  Plugin_Environment in 'Plugins\Plugin_Environment.pas',
  uPSI_API_Environment in 'Plugins\Imports\uPSI_API_Environment.pas',
  Plugin_WinAPI in 'Plugins\Plugin_WinAPI.pas',
  API_WinAPI in 'Plugins\API\API_WinAPI.pas',
  uPSI_API_WinAPI in 'Plugins\Imports\uPSI_API_WinAPI.pas',
  Plugin_IniFile in 'Plugins\Plugin_IniFile.pas',
  uPSI_API_IniFile in 'Plugins\Imports\uPSI_API_IniFile.pas',
  API_IniFile in 'Plugins\API\API_IniFile.pas',
  API_Folder in 'Plugins\API\API_Folder.pas',
  Plugin_Folder in 'Plugins\Plugin_Folder.pas',
  uPSI_API_Folder in 'Plugins\Imports\uPSI_API_Folder.pas',
  API_File in 'Plugins\API\API_File.pas',
  Plugin_File in 'Plugins\Plugin_File.pas',
  uPSI_API_File in 'Plugins\Imports\uPSI_API_File.pas',
  uPSI_ExtraClasses in 'Plugins\Imports\uPSI_ExtraClasses.pas',
  uPSR_ExtraClasses in 'Plugins\Imports\uPSR_ExtraClasses.pas',
  Plugin_RegEx in 'Plugins\Plugin_RegEx.pas',
  API_RegEx in 'Plugins\API\API_RegEx.pas',
  uPSI_API_RegEx in 'Plugins\Imports\uPSI_API_RegEx.pas',
  Plugin_Registry in 'Plugins\Plugin_Registry.pas',
  API_Registry in 'Plugins\API\API_Registry.pas',
  uPSI_API_Registry in 'Plugins\Imports\uPSI_API_Registry.pas',
  API_Path in 'Plugins\API\API_Path.pas',
  uPSI_API_Path in 'Plugins\Imports\uPSI_API_Path.pas',
  Plugin_Path in 'Plugins\Plugin_Path.pas',
  Plugin_VariablesCmdLine in 'Plugins\Plugin_VariablesCmdLine.pas',
  API_VariablesCmdLine in 'Plugins\API\API_VariablesCmdLine.pas',
  uPSI_API_VariablesCmdLine in 'Plugins\Imports\uPSI_API_VariablesCmdLine.pas',
  TagType in 'TagType.pas';

begin
  ExitCode := oConfig.LoadConfig;
  if ExitCode <> 0 then Exit;

  If Not oConfig.ParseParams then
    Exit;

  try
    ExitCode := oruntime.RunEnvironment;

  except
    on E: Exception do
      Writeln(E.ClassName, ': ', E.Message);
  end;

end.
