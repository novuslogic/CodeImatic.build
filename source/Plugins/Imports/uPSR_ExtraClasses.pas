unit uPSR_ExtraClasses;

interface

uses
  uPSRuntime, uPSUtils, SysUtils, ExtraClasses;

procedure RIRegisterTStringBuilder(Cl: TPSRuntimeClassImporter);

procedure RIRegister_ExtraClasses(Cl: TPSRuntimeClassImporter);

implementation

uses
  Classes;

procedure RIRegisterTStringBuilder(Cl: TPSRuntimeClassImporter);
begin
  with Cl.Add(TStringBuilder) do
  begin
    RegisterConstructor(@TStringBuilder.CREATE, 'CREATE');
    RegisterMethod(@TStringBuilder.FREE, 'FREE');
    RegisterMethod(@TStringBuilder.ToString, 'ToString');
    RegisterMethod(@TStringBuilder.AppendasString, 'Append');
    RegisterMethod(@TStringBuilder.AppendFormat, 'AppendFormat');
  end;
end;

procedure RIRegister_ExtraClasses(Cl: TPSRuntimeClassImporter);
begin
  RIRegisterTStringBuilder(Cl);
end;

end.
