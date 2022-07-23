{$I CodeImatic.build.inc}
program CodeImatic.build;

{$APPTYPE CONSOLE}
{$R *.res}

uses
  System.ShareMem,
  System.SysUtils,
  Config,
  Runtime,
  APIBase in 'Plugins\API\APIBase.pas';

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
