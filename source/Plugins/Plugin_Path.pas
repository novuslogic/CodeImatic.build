unit Plugin_Path;

interface

uses Classes, Plugin, uPSRuntime, uPSCompiler, PluginsMapFactory, API_Path,
  API_Output, SysUtils, uPSI_API_Path;

type
  tPlugin_Path = class(TPascalScriptInternalPlugin)
  private
  protected
    foAPI_Path: TAPI_Path;
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

constructor tPlugin_Path.Create(aAPI_Output: tAPI_Output;
  var aImp: TPSRuntimeClassImporter;aPluginName: String);
begin
  Inherited;

  foAPI_Path := TAPI_Path.Create(foAPI_Output);

end;

destructor tPlugin_Path.Destroy;
begin
  Inherited;

  FreeandNIl(foAPI_Path);
end;

function tPlugin_Path.CustomOnUses(var aCompiler: TPSPascalCompiler): Boolean;
begin
  Result := True;

  foAPI_Path.oCompiler := aCompiler;

  SIRegister_API_Path(aCompiler);

  AddImportedClassVariable(aCompiler, 'Path', 'TAPI_Path');

end;

procedure tPlugin_Path.RegisterFunction(var aExec: TPSExec);
begin
end;

procedure tPlugin_Path.SetVariantToClass(var aExec: TPSExec);
begin
  foAPI_Path.oExec := aExec;

  uPSRuntime.SetVariantToClass(aExec.GetVarNo(aExec.GetVar('Path')),
    foAPI_Path);
end;

procedure tPlugin_Path.RegisterImport;
begin
  RIRegister_API_Path(FImp);
  RIRegister_API_Path(FImp);
end;

Initialization

begin
  tPluginsMapFactory.RegisterClass(tPlugin_Path);
end;

end.
