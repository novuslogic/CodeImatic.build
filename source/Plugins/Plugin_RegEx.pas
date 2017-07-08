unit Plugin_RegEx;

interface

uses Classes, Plugin, uPSRuntime, uPSCompiler, PluginsMapFactory, API_RegEx,
  API_Output, SysUtils, uPSI_API_RegEx;

type
  tPlugin_RegEx = class(Tplugin)
  private
  protected
    foAPI_RegEx: TAPI_RegEx;
  public
    constructor Create(aAPI_Output: tAPI_Output;
      var aImp: TPSRuntimeClassImporter); override;
    destructor Destroy; override;

    function CustomOnUses(var aCompiler: TPSPascalCompiler): Boolean; override;
    procedure RegisterFunction(var aExec: TPSExec); override;
    procedure SetVariantToClass(var aExec: TPSExec); override;
    procedure RegisterImport; override;
  end;

implementation

constructor tPlugin_RegEx.Create(aAPI_Output: tAPI_Output;
  var aImp: TPSRuntimeClassImporter);
begin
  Inherited;

  foAPI_RegEx := TAPI_RegEx.Create(foAPI_Output);

end;

destructor tPlugin_RegEx.Destroy;
begin
  Inherited;

  FreeandNIl(foAPI_RegEx);
end;

function tPlugin_RegEx.CustomOnUses(var aCompiler: TPSPascalCompiler): Boolean;
begin
  Result := True;

  foAPI_RegEx.oCompiler := aCompiler;

  SIRegister_API_RegEx(aCompiler);

  AddImportedClassVariable(aCompiler, 'RegEx', 'TAPI_RegEx');
end;

procedure tPlugin_RegEx.RegisterFunction(var aExec: TPSExec);
begin
end;

procedure tPlugin_RegEx.SetVariantToClass(var aExec: TPSExec);
begin
  foAPI_RegEx.oExec := aExec;

  uPSRuntime.SetVariantToClass(aExec.GetVarNo(aExec.GetVar('RegEx')),
    foAPI_RegEx);
end;

procedure tPlugin_RegEx.RegisterImport;
begin
  RIRegister_API_RegEx(FImp);
  RIRegister_API_RegEx(FImp);
end;

Initialization

begin
  tPluginsMapFactory.RegisterClass(tPlugin_RegEx);
end;

end.
