unit uPSR_ExtraClasses;

interface
uses
  uPSRuntime, uPSUtils, SysUtils;

 procedure RIRegisterTStringBuilder(Cl: TPSRuntimeClassImporter);

 procedure RIRegister_ExtraClasses(Cl: TPSRuntimeClassImporter);

implementation

uses
  Classes, ExtraClasses;


procedure RIRegisterTStringBuilder(Cl: TPSRuntimeClassImporter);
begin
  with Cl.Add(TStringBuilder) do
  begin
    RegisterConstructor(@TStringBuilder.CREATE, 'CREATE');
    RegisterMethod(@TStringBuilder.FREE, 'FREE');
    RegisterMethod(@TStringBuilder.ToString,'ToString');
    RegisterMethod(@TStringBuilder.AppendasString, 'Append');
    RegisterMethod(@TStringBuilder.AppendFormat, 'AppendFormat');
  end;
end;

           (*
procedure RIRegisterTJSONParser(Cl: TPSRuntimeClassImporter);
begin
  with Cl.Add(TJSONParser) do
  begin
    RegisterConstructor(@TJSONParser.CREATE, 'CREATE');
    RegisterMethod(@TJSONParser.ToString, 'TOSTRING');
    RegisterMethod(@TJSONParser.ParseJSONString, 'PARSEJSONSTRING');
    RegisterMethod(@TJSONParser.GetValue, 'GETVALUE');

  end;
end;
*)
procedure RIRegister_ExtraClasses(Cl: TPSRuntimeClassImporter);
begin
  RIRegisterTStringBuilder(Cl);
  //RIRegisterTJSONParser(Cl);
end;

end.
