{$I Zautomatic.inc}
program Zautomatic;

{$APPTYPE CONSOLE}

{$R *.res}

uses
  System.SysUtils,
  ScriptEngine in 'ScriptEngine.pas',
  Config in 'Config.pas',
  Project in 'Project.pas',
  projectconfig in 'projectconfig.pas',
  XMLList in 'XMLList.pas',
  Runtime in 'Runtime.pas',
  MessagesLog in 'Plugins\API\MessagesLog.pas',
  Plugins in 'Plugins.pas',
  Plugin in 'Plugin.pas',
  PluginsMapFactory in 'PluginsMapFactory.pas',
  Plugin_Messageslog in 'Plugins\Plugin_Messageslog.pas',
  Plugin_Commands in 'Plugins\Plugin_Commands.pas',
  APIBase in 'Plugins\API\APIBase.pas',
  uPSI_MessagesLog in 'Plugins\Imports\uPSI_MessagesLog.pas',
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
  uPSI_API_RegEx in 'Plugins\Imports\uPSI_API_RegEx.pas';

begin
  oConfig.LoadConfig;

  If Not oConfig.ParseParams then Exit;

  try
    oruntime.RunEnvironment;

  except
    on E: Exception do
      Writeln(E.ClassName, ': ', E.Message);
  end;
end.
