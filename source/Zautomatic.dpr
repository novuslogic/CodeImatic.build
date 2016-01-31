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
  MessagesLog in 'MessagesLog.pas',
  uPSI_MessagesLog in 'Imports\uPSI_MessagesLog.pas',
  Plugins in 'Plugins.pas',
  Plugin in 'Plugin.pas',
  PluginsMapFactory in 'PluginsMapFactory.pas',
  Plugin_Messageslog in 'Plugins\Plugin_Messageslog.pas',
  Plugin_Commands in 'Plugins\Plugin_Commands.pas';

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
