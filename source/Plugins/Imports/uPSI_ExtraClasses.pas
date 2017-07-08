unit uPSI_ExtraClasses;

interface

uses
  uPSCompiler, uPSUtils, SysUtils, ExtraClasses;

procedure SIRegisterTStringBuilder(Cl: TPSPascalCompiler);
procedure SIRegister_ExtraClasses(Cl: TPSPascalCompiler);

implementation

procedure SIRegisterTStringBuilder(Cl: TPSPascalCompiler);
begin
  with Cl.AddClassN(Cl.FindClass(''), 'TStringBuilder') do
  begin
    RegisterMethod('constructor Create;');
    RegisterMethod('procedure Free;');
    RegisterMethod('function ToString: string;');
    RegisterMethod('function Append(const Value: string): TStringBuilder;');
    RegisterMethod
      ('function AppendFormat(const Format: string; const Args: array of const): TStringBuilder;');
  end;
end;

procedure SIRegister_ExtraClasses(Cl: TPSPascalCompiler);
begin
  SIRegisterTStringBuilder(Cl);
end;

end.
