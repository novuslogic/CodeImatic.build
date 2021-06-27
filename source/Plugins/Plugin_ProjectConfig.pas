unit Plugin_ProjectConfig;

interface

uses Classes, Plugin, uPSRuntime, uPSCompiler, PluginsMapFactory,
  API_ProjectConfig,
  API_Output, SysUtils, uPSI_API_ProjectConfig;

type
  tPlugin_ProjectConfig = class(TPascalScriptInternalPlugin)
  private
  protected
    foAPI_ProjectConfig: TAPI_ProjectConfig;
  public
    constructor Create(aAPI_Output: tAPI_Output;
      var aImp: TPSRuntimeClassImporter;
      aPluginName: string); override;

    destructor Destroy; override;

    function CustomOnUses(var aCompiler: TPSPascalCompiler): Boolean; override;
    procedure RegisterFunction(var aExec: TPSExec); override;
    procedure SetVariantToClass(var aExec: TPSExec); override;
    procedure RegisterImport; override;
  end;

implementation

constructor tPlugin_ProjectConfig.Create(aAPI_Output: tAPI_Output;
  var aImp: TPSRuntimeClassImporter;aPluginName: string);
begin
  Inherited;

  foAPI_ProjectConfig := TAPI_ProjectConfig.Create(foAPI_Output);

end;

destructor tPlugin_ProjectConfig.Destroy;
begin
  Inherited;

  FreeandNIl(foAPI_ProjectConfig);
end;

function tPlugin_ProjectConfig.CustomOnUses(var aCompiler
  : TPSPascalCompiler): Boolean;
begin
  Result := True;

  foAPI_ProjectConfig.oCompiler := aCompiler;

  SIRegister_API_ProjectConfig(aCompiler);

  AddImportedClassVariable(aCompiler, 'ProjectConfig', 'TAPI_ProjectConfig');

end;

procedure tPlugin_ProjectConfig.RegisterFunction(var aExec: TPSExec);
begin
end;

procedure tPlugin_ProjectConfig.SetVariantToClass(var aExec: TPSExec);
begin
  foAPI_ProjectConfig.oExec := aExec;

  uPSRuntime.SetVariantToClass(aExec.GetVarNo(aExec.GetVar('ProjectConfig')),
    foAPI_ProjectConfig);
end;

procedure tPlugin_ProjectConfig.RegisterImport;
begin
  RIRegister_API_ProjectConfig(FImp);
  RIRegister_API_ProjectConfig(FImp);
end;

Initialization

begin
  tPluginsMapFactory.RegisterClass(tPlugin_ProjectConfig);
end;

end.
