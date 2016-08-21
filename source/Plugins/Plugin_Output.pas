unit Plugin_Output;

interface

uses Classes,Plugin,  uPSRuntime,  uPSCompiler, uPSI_API_Output, PluginsMapFactory;

type
  tPlugin_Output= class(Tplugin)
  private
  protected
  public
    function CustomOnUses(var aCompiler: TPSPascalCompiler): Boolean; override;
    procedure RegisterFunction(var aExec: TPSExec); override;
    procedure SetVariantToClass(var aExec: TPSExec); override;
    procedure RegisterImport; override;
  end;

implementation

function tPlugin_Output.CustomOnUses(var aCompiler: TPSPascalCompiler): Boolean;
begin
  Result := True;

  SIRegister_API_Output(aCompiler);
  AddImportedClassVariable(aCompiler, 'Output', 'TAPI_Output');

end;

procedure tPlugin_Output.RegisterFunction(var aExec: TPSExec);
begin
end;

procedure tPlugin_Output.SetVariantToClass(var aExec: TPSExec);
begin
  uPSRuntime.SetVariantToClass(aExec.GetVarNo(aExec.GetVar('Output')), foAPI_Output);
end;

procedure tPlugin_Output.RegisterImport;
begin
  RIRegister_API_Output(FImp);
end;

Initialization
 begin
   tPluginsMapFactory.RegisterClass(tPlugin_Output);
 end;

end.
