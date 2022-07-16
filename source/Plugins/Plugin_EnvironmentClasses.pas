unit Plugin_EnvironmentClasses;

interface

uses Classes, Plugin, uPSRuntime, uPSCompiler, PluginsMapFactory,
  API_Environment, NovusPlugin,
  API_Output, SysUtils, uPSI_API_Environment;

type
  tPlugin_EnvironmentBase = class(TPascalScriptPlugin)
  private
  protected
    foAPI_Environment: TAPI_Environment;
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

  TPlugin_Environment = class(TExternalPlugin)
  private
  protected
    FPlugin_Environment: tPlugin_EnvironmentBase;
  public
    function GetPluginName: string; override; safecall;

    procedure Initialize; override; safecall;
    procedure Finalize; override;  safecall;

    function CreatePlugin(aAPI_Output: tAPI_Output; aImp: TPSRuntimeClassImporter): TPlugin; override; safecall;
  end;


implementation

var
  _Plugin_Environment: TPlugin_Environment = nil;

constructor tPlugin_EnvironmentBase.Create(aAPI_Output: tAPI_Output;
  var aImp: TPSRuntimeClassImporter;aPluginName: string);
begin
  Inherited;

  foAPI_Environment := TAPI_Environment.Create(aAPI_Output);
end;

destructor tPlugin_EnvironmentBase.Destroy;
begin
  Inherited;

  FreeandNIl(foAPI_Environment);
end;

function tPlugin_EnvironmentBase.CustomOnUses(var aCompiler
  : TPSPascalCompiler): Boolean;
begin
  Result := True;

  foAPI_Environment.oCompiler := aCompiler;

  SIRegister_API_Environment(aCompiler);

  AddImportedClassVariable(aCompiler, 'Environment', 'TAPI_Environment');

end;

procedure tPlugin_EnvironmentBase.RegisterFunction(var aExec: TPSExec);
begin
end;

procedure tPlugin_EnvironmentBase.SetVariantToClass(var aExec: TPSExec);
begin
  foAPI_Environment.oExec := aExec;

  uPSRuntime.SetVariantToClass(aExec.GetVarNo(aExec.GetVar('Environment')),
    foAPI_Environment);
end;

procedure tPlugin_EnvironmentBase.RegisterImport;
begin
  RIRegister_API_Environment(FImp);
  RIRegister_API_Environment(FImp);
end;

// Plugin_Environment
function tPlugin_Environment.GetPluginName: string;
begin
  Result := 'Environment';
end;

procedure tPlugin_Environment.Initialize;
begin
end;

function tPlugin_Environment.CreatePlugin(aAPI_Output: tAPI_Output; aImp: TPSRuntimeClassImporter): TPlugin; safecall;
begin
  FPlugin_Environment := tPlugin_EnvironmentBase.Create(aAPI_Output,aImp,PluginName);

  Result := FPlugin_Environment;
end;

procedure tPlugin_Environment.Finalize;
begin
  if Assigned(FPlugin_Environment) then FPlugin_Environment.Free;
end;

function GetPluginObject: TNovusPlugin;
begin
  if (_Plugin_Environment = nil) then _Plugin_Environment := tPlugin_Environment.Create;
  result := _Plugin_Environment;
end;

exports
  GetPluginObject name func_GetPluginObject;

initialization
  begin
    _Plugin_Environment := nil;
  end;

finalization
  FreeAndNIL(_Plugin_Environment);


end.
