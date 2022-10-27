unit Plugin_ProjectConfigClasses;

interface

uses Classes, Plugin, uPSRuntime, uPSCompiler, PluginsMapFactory,
  API_ProjectConfig, NovusPlugin,
  API_Output, SysUtils, uPSI_API_ProjectConfig;

type
  tPlugin_ProjectConfigBase = class(TPascalScriptPlugin)
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

  tPlugin_ProjectConfig = class(TExternalPlugin)
  private
  protected
    FPlugin_ProjectConfig: tPlugin_ProjectConfigBase;
  public
    function GetPluginName: string; override; safecall;

    procedure Initialize; override; safecall;
    procedure Finalize; override;  safecall;

    function CreatePlugin(aAPI_Output: tAPI_Output; aImp: TPSRuntimeClassImporter): TPlugin; override; safecall;
  end;


implementation

var
  _Plugin_ProjectConfig: TPlugin_ProjectConfig = nil;

constructor tPlugin_ProjectConfigBase.Create(aAPI_Output: tAPI_Output;
  var aImp: TPSRuntimeClassImporter;aPluginName: string);
begin
  Inherited;

  foAPI_ProjectConfig := TAPI_ProjectConfig.Create(aAPI_Output);
end;

destructor tPlugin_ProjectConfigBase.Destroy;
begin
  Inherited;

  FreeandNIl(foAPI_ProjectConfig);
end;

function tPlugin_ProjectConfigBase.CustomOnUses(var aCompiler
  : TPSPascalCompiler): Boolean;
begin
  Result := True;

  foAPI_ProjectConfig.oCompiler := aCompiler;

  SIRegister_API_ProjectConfig(aCompiler);

  AddImportedClassVariable(aCompiler, 'ProjectConfig', 'TAPI_ProjectConfig');
end;

procedure tPlugin_ProjectConfigBase.RegisterFunction(var aExec: TPSExec);
begin
end;

procedure tPlugin_ProjectConfigBase.SetVariantToClass(var aExec: TPSExec);
begin
  foAPI_ProjectConfig.oExec := aExec;

  uPSRuntime.SetVariantToClass(aExec.GetVarNo(aExec.GetVar('ProjectConfig')),
    foAPI_ProjectConfig);
end;

procedure tPlugin_ProjectConfigBase.RegisterImport;
begin
  RIRegister_API_ProjectConfig(FImp);
  RIRegister_API_ProjectConfig(FImp);
end;

// Plugin_ProjectConfig
function tPlugin_ProjectConfig.GetPluginName: string;
begin
  Result := 'ProjectConfig';
end;

procedure tPlugin_ProjectConfig.Initialize;
begin
end;

function tPlugin_ProjectConfig.CreatePlugin(aAPI_Output: tAPI_Output; aImp: TPSRuntimeClassImporter): TPlugin; safecall;
begin
  FPlugin_ProjectConfig := tPlugin_ProjectConfigBase.Create(aAPI_Output,aImp,PluginName);

  Result := FPlugin_ProjectConfig;
end;

procedure tPlugin_ProjectConfig.Finalize;
begin
  if Assigned(FPlugin_ProjectConfig) then FPlugin_ProjectConfig.Free;
end;

function GetPluginObject: TNovusPlugin;
begin
  if (_Plugin_ProjectConfig = nil) then _Plugin_ProjectConfig := tPlugin_ProjectConfig.Create;
  result := _Plugin_ProjectConfig;
end;

exports
  GetPluginObject name func_GetPluginObject;

initialization
  begin
    _Plugin_ProjectConfig := nil;
  end;

finalization
  FreeAndNIL(_Plugin_ProjectConfig);


end.
