unit uPSI_ExtraClasses;

interface

uses
  uPSCompiler, uPSUtils, SysUtils, ExtraClasses;

procedure SIRegisterTStringBuilder(Cl: TPSPascalCompiler);
procedure SIRegisterTVariableCmdLine(Cl: TPSPascalCompiler);
procedure SIRegister_ExtraClasses(Cl: TPSPascalCompiler);
procedure SIRegisterTVariableCmdLineList(Cl: TPSPascalCompiler);


implementation

procedure SIRegisterTStringBuilder(Cl: TPSPascalCompiler);
begin
  with Cl.AddClassN(Cl.FindClass('TStringBuilderExtra'), 'TStringBuilder') do
  begin
    RegisterMethod('constructor Create;');
    RegisterMethod('procedure Free;');
    RegisterMethod('function ToString: string;');
    RegisterMethod('function Append(const Value: string): TStringBuilder;');

    RegisterMethod
      ('function AppendFormat(const Format: string; const Args: array of const): TStringBuilder;');
  end;
end;

procedure SIRegisterTVariableCmdLine(Cl: TPSPascalCompiler);
begin
  with Cl.AddClassN(Cl.FindClass(''), 'TVariableCmdLine') do
  begin
    RegisterMethod('constructor Create;');
    RegisterMethod('procedure Free;');
    RegisterMethod('function ToVarCmdLine: String;');
    RegisterProperty('VariableName', 'String', iptrw);
    RegisterProperty('Value', 'String', iptrw);
  end;
end;

procedure SIRegisterTVariableCmdLineList(Cl: TPSPascalCompiler);
begin
  with Cl.AddClassN(Cl.FindClass(''), 'TVariableCmdLineList') do
  begin
    RegisterMethod('constructor Create;');
    RegisterMethod('procedure Free;');
    RegisterMethod('function ToVarCmdLines: String;');
    RegisterMethod('procedure Add(aItem: TVariableCmdLine);');
    RegisterProperty('Count', 'Integer', iptrw);
    RegisterProperty('Items', 'TVariableCmdLine Integer', iptrw);
  end;
end;


procedure SIRegister_ExtraClasses(Cl: TPSPascalCompiler);
begin
  SIRegisterTStringBuilder(Cl);
  SIRegisterTVariableCmdLine(Cl);
  SIRegisterTVariableCmdLineList(Cl);
end;

end.
