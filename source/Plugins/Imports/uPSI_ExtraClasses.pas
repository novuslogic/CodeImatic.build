unit uPSI_ExtraClasses;

interface
uses
  uPSCompiler, uPSUtils, JSONParser;

procedure SIRegisterTJSON(Cl: TPSPascalCompiler);
procedure SIRegisterTJSONParser(Cl: TPSPascalCompiler);
procedure SIRegister_ExtraClasses(Cl: TPSPascalCompiler);

implementation

procedure SIRegisterTJSON(Cl: TPSPascalCompiler);
begin
  with Cl.AddClassN(cl.FindClass('TPersistent'), 'TJSON') do
  begin
    RegisterMethod('constructor Create;');
    RegisterMethod('function IsJSONArray: Boolean;');
  end;
end;


procedure SIRegisterTJSONParser(Cl: TPSPascalCompiler);
begin
  with Cl.AddClassN(cl.FindClass('TPersistent'), 'TJSONParser') do
  begin
    RegisterMethod('constructor Create;');
    RegisterMethod('function ToString: String;');
    RegisterMethod('procedure ParseJSONString(aJSONString: String);');
    RegisterMethod('function GetValue(aParName: string): TJSON;');
  end;
end;


procedure SIRegister_ExtraClasses(Cl: TPSPascalCompiler);
begin
  SIRegisterTJSON(Cl);
  SIRegisterTJSONParser(Cl);
end;

end.
