unit uPSI_ExtraClasses;

{$I PascalScript.inc}
interface
uses
  uPSCompiler, uPSUtils, JSON;

procedure SIRegisterTJSON(Cl: TPSPascalCompiler);
procedure SIRegister_ExtraClasses(Cl: TPSPascalCompiler);

implementation


procedure SIRegisterTJSON(Cl: TPSPascalCompiler);
begin
  with Cl.AddClassN(cl.FindClass('TPersistent'), 'TJSON') do
  begin
     RegisterMethod('constructor Create;');

  end;
end;


procedure SIRegister_ExtraClasses(Cl: TPSPascalCompiler);
begin
  SIRegisterTJSON(Cl);
end;

end.
