program Zautomatic;

{$APPTYPE CONSOLE}

{$R *.res}

uses
  System.SysUtils,
  Builder in 'Builder.pas',
  Config in 'Config.pas',
  Project in 'Project.pas',
  projectconfig in 'projectconfig.pas',
  XMLList in 'XMLList.pas';

var
  FBuilder: Tbuilder;

begin
  oConfig.LoadConfig;

  If Not oConfig.ParseParams then Exit;

  try


    FBuilder := tBuilder.Create;






    FBuilder.Free;

  except
    on E: Exception do
      Writeln(E.ClassName, ': ', E.Message);
  end;
end.
