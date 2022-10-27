unit Plugin_RegistryClasses;

interface

uses Classes, Plugin, uPSRuntime, uPSCompiler, PluginsMapFactory, API_Registry,
  uPSI_API_Registry, API_Output, SysUtils, NovusPlugin;

type
  tPlugin_RegistryBase = class(TPascalScriptPlugin)
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

  TPlugin_Registry = class(TExternalPlugin)
  private
  protected
    FPlugin_Registry: tPlugin_RegistryBase;
  public
    function GetPluginName: string; override; safecall;

    procedure Initialize; override; safecall;
    procedure Finalize; override;  safecall;

    function CreatePlugin(aAPI_Output: tAPI_Output; aImp: TPSRuntimeClassImporter): TPlugin; override; safecall;
  end;


implementation

var
  _Plugin_Registry: TPlugin_Registry = nil;


constructor tPlugin_RegistryBase.Create(aAPI_Output: tAPI_Output;
  var aImp: TPSRuntimeClassImporter;aPluginName: String);
begin
  Inherited;

  foAPI_Registry := TAPI_Registry.Create(aAPI_Output);

end;

destructor tPlugin_RegistryBase.Destroy;
begin
  Inherited;

  FreeandNIl(foAPI_Registry);
end;

function tPlugin_RegistryBase.CustomOnUses(var aCompiler
  : TPSPascalCompiler): Boolean;
begin
  Result := True;

  foAPI_Registry.oCompiler := aCompiler;

  SIRegister_API_Registry(aCompiler);

  AddImportedClassVariable(aCompiler, 'Registry', 'TAPI_Registry');
end;

procedure tPlugin_RegistryBase.RegisterFunction(var aExec: TPSExec);
begin
end;

procedure tPlugin_RegistryBase.SetVariantToClass(var aExec: TPSExec);
begin
  foAPI_Registry.oExec := aExec;

  uPSRuntime.SetVariantToClass(aExec.GetVarNo(aExec.GetVar('Registry')),
    foAPI_Registry);
end;

procedure tPlugin_RegistryBase.RegisterImport;
begin
  RIRegister_API_Registry(FImp);
  RIRegister_API_Registry(FImp);
end;


// Plugin_Registry
function tPlugin_Registry.GetPluginName: string;
begin
  Result := 'Registry';
end;

procedure tPlugin_Registry.Initialize;
begin
end;

function tPlugin_Registry.CreatePlugin(aAPI_Output: tAPI_Output; aImp: TPSRuntimeClassImporter): TPlugin; safecall;
begin
  FPlugin_Registry := tPlugin_RegistryBase.Create(aAPI_Output,aImp,PluginName);

  Result := FPlugin_Registry;
end;

procedure tPlugin_Registry.Finalize;
begin
  if Assigned(FPlugin_Registry) then FPlugin_Registry.Free;
end;

function GetPluginObject: TNovusPlugin;
begin
  if (_Plugin_Registry = nil) then _Plugin_Registry := tPlugin_Registry.Create;
  result := _Plugin_Registry;
end;

exports
  GetPluginObject name func_GetPluginObject;

initialization
  begin
    _Plugin_Registry := nil;
  end;

finalization
  FreeAndNIL(_Plugin_Registry);



end.
