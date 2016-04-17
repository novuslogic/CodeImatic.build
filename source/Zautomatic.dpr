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
  Plugin_Zip in 'Plugins\Plugin_Zip.pas',
  API_Zip in 'Plugins\API\API_Zip.pas',
  APIBase in 'Plugins\API\APIBase.pas',
  uPSI_MessagesLog in 'Plugins\Imports\uPSI_MessagesLog.pas',
  uPSI_API_Zip in 'Plugins\Imports\uPSI_API_Zip.pas',
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
  uPSI_API_WinAPI in 'Plugins\Imports\uPSI_API_WinAPI.pas';

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
