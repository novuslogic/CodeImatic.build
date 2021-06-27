unit Plugin_VariablesCmdLine;

interface

uses Classes, Plugin, uPSRuntime, uPSCompiler, uPSI_API_VariablesCmdLine,
  PluginsMapFactory;

type
  tPlugin_VariablesCmdLine = class(TPascalScriptInternalPlugin)
  private
  protected
  public
    function CustomOnUses(var aCompiler: TPSPascalCompiler): Boolean; override;
    procedure RegisterFunction(var aExec: TPSExec); override;
    procedure SetVariantToClass(var aExec: TPSExec); override;
    procedure RegisterImport; override;
  end;

implementation

function tPlugin_VariablesCmdLine.CustomOnUses(var aCompiler: TPSPascalCompiler): Boolean;
begin
  Result := True;

  SIRegister_API_VariablesCmdLine(aCompiler);
  AddImportedClassVariable(aCompiler, 'VariablesCmdLine', 'TAPI_VariablesCmdLine');

end;

procedure tPlugin_VariablesCmdLine.RegisterFunction(var aExec: TPSExec);
begin
end;

procedure tPlugin_VariablesCmdLine.SetVariantToClass(var aExec: TPSExec);
begin
  uPSRuntime.SetVariantToClass(aExec.GetVarNo(aExec.GetVar('VariablesCmdLine')),
    foAPI_Output);
end;

procedure tPlugin_VariablesCmdLine.RegisterImport;
begin
  RIRegister_API_VariablesCmdLine(FImp);
end;

Initialization

begin
  tPluginsMapFactory.RegisterClass(tPlugin_VariablesCmdLine);
end;

end.
