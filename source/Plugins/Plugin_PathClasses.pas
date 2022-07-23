unit Plugin_PathClasses;

interface

uses Classes, Plugin, uPSRuntime, uPSCompiler, PluginsMapFactory, API_Path,
  API_Output, SysUtils, uPSI_API_Path, NovusPlugin;

type
  tPlugin_PathBase = class(TPascalScriptPlugin)
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

  tPlugin_Path = class(TExternalPlugin)
  private
  protected
    FPlugin_Path: tPlugin_PathBase;
  public
    function GetPluginName: string; override; safecall;

    procedure Initialize; override; safecall;
    procedure Finalize; override;  safecall;

    function CreatePlugin(aAPI_Output: tAPI_Output; aImp: TPSRuntimeClassImporter): TPlugin; override; safecall;
  end;


implementation

var
  _Plugin_Path: TPlugin_Path = nil;

constructor tPlugin_PathBase.Create(aAPI_Output: tAPI_Output;
  var aImp: TPSRuntimeClassImporter;aPluginName: String);
begin
  Inherited;

  foAPI_Path := TAPI_Path.Create(aAPI_Output);

end;

destructor tPlugin_PathBase.Destroy;
begin
  Inherited;

  FreeandNIl(foAPI_Path);
end;

function tPlugin_PathBase.CustomOnUses(var aCompiler: TPSPascalCompiler): Boolean;
begin
  Result := True;

  foAPI_Path.oCompiler := aCompiler;

  SIRegister_API_Path(aCompiler);

  AddImportedClassVariable(aCompiler, 'Path', 'TAPI_Path');

end;

procedure tPlugin_PathBase.RegisterFunction(var aExec: TPSExec);
begin
end;

procedure tPlugin_PathBase.SetVariantToClass(var aExec: TPSExec);
begin
  foAPI_Path.oExec := aExec;

  uPSRuntime.SetVariantToClass(aExec.GetVarNo(aExec.GetVar('Path')),
    foAPI_Path);
end;

procedure tPlugin_PathBase.RegisterImport;
begin
  RIRegister_API_Path(FImp);
  RIRegister_API_Path(FImp);
end;

// Plugin_Path
function tPlugin_Path.GetPluginName: string;
begin
  Result := 'Path';
end;

procedure tPlugin_Path.Initialize;
begin
end;

function tPlugin_Path.CreatePlugin(aAPI_Output: tAPI_Output; aImp: TPSRuntimeClassImporter): TPlugin; safecall;
begin
  FPlugin_Path := tPlugin_PathBase.Create(aAPI_Output,aImp,PluginName);

  Result := FPlugin_Path;
end;

procedure tPlugin_Path.Finalize;
begin
  if Assigned(FPlugin_Path) then FPlugin_Path.Free;
end;

function GetPluginObject: TNovusPlugin;
begin
  if (_Plugin_Path = nil) then _Plugin_Path := tPlugin_Path.Create;
  result := _Plugin_Path;
end;

exports
  GetPluginObject name func_GetPluginObject;

initialization
  begin
    _Plugin_Path := nil;
  end;

finalization
  FreeAndNIL(_Plugin_Path);

end.
