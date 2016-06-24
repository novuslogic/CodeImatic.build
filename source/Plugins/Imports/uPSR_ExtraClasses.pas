unit uPSR_ExtraClasses;

interface
uses
  uPSRuntime, uPSUtils{, JSONParser};

(*
procedure RIRegisterTJSON(Cl: TPSRuntimeClassImporter);
procedure RIRegisterTJSONParser(Cl: TPSRuntimeClassImporter);
*)
procedure RIRegister_ExtraClasses(Cl: TPSRuntimeClassImporter);

implementation

uses
  Classes;

  (*
procedure RIRegisterTJSON(Cl: TPSRuntimeClassImporter);
begin
  with Cl.Add(TJSON) do
  begin
    RegisterConstructor(@TJSON.CREATE, 'CREATE');
    RegisterMethod(@TJSON.IsJSONArray, 'ISJSONARRAY');
  end;
end;
    *)
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
  //RIRegisterTJSON(Cl);
  //RIRegisterTJSONParser(Cl);
end;

end.
