unit Plugin_Registry;

interface

uses Classes, Plugin, uPSRuntime, uPSCompiler, PluginsMapFactory, API_Registry,
  uPSI_API_Registry, API_Output, SysUtils;

type
  tPlugin_Registry = class(Tplugin)
  private
  protected
    foAPI_Registry: TAPI_Registry;
  public
    constructor Create(aAPI_Output: tAPI_Output;
      var aImp: TPSRuntimeClassImporter;aPluginName: String); override;
    destructor Destroy; override;

    function CustomOnUses(var aCompiler: TPSPascalCompiler): Boolean; override;
    procedure RegisterFunction(var aExec: TPSExec); override;
    procedure SetVariantToClass(var aExec: TPSExec); override;
    procedure RegisterImport; override;
  end;

implementation

constructor tPlugin_Registry.Create(aAPI_Output: tAPI_Output;
  var aImp: TPSRuntimeClassImporter;aPluginName: String);
begin
  Inherited;

  foAPI_Registry := TAPI_Registry.Create(foAPI_Output);

end;

destructor tPlugin_Registry.Destroy;
begin
  Inherited;

  FreeandNIl(foAPI_Registry);
end;

function tPlugin_Registry.CustomOnUses(var aCompiler
  : TPSPascalCompiler): Boolean;
begin
  Result := True;

  foAPI_Registry.oCompiler := aCompiler;

  SIRegister_API_Registry(aCompiler);

  AddImportedClassVariable(aCompiler, 'Registry', 'TAPI_Registry');
end;

procedure tPlugin_Registry.RegisterFunction(var aExec: TPSExec);
begin
end;

procedure tPlugin_Registry.SetVariantToClass(var aExec: TPSExec);
begin
  foAPI_Registry.oExec := aExec;

  uPSRuntime.SetVariantToClass(aExec.GetVarNo(aExec.GetVar('Registry')),
    foAPI_Registry);
end;

procedure tPlugin_Registry.RegisterImport;
begin
  RIRegister_API_Registry(FImp);
  RIRegister_API_Registry(FImp);
end;

Initialization

begin
  tPluginsMapFactory.RegisterClass(tPlugin_Registry);
end;

end.
