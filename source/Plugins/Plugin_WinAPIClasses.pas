unit Plugin_WinAPIClasses;

interface

uses Classes, Plugin, uPSRuntime, uPSCompiler, PluginsMapFactory, API_WinAPI,
  uPSI_API_WinAPI, API_Output, SysUtils, NovusPlugin;

type
  tPlugin_WinAPIBase = class(TPascalScriptPlugin)
  private
  protected
    foAPI_WinAPI: TAPI_WinAPI;
  public
    constructor Create(aAPI_Output: tAPI_Output;
      var aImp: TPSRuntimeClassImporter;aPluginName: string); override;
    destructor Destroy; override;

    function CustomOnUses(var aCompiler: TPSPascalCompiler): Boolean; override;
    procedure RegisterFunction(var aExec: TPSExec); override;
    procedure SetVariantToClass(var aExec: TPSExec); override;
    procedure RegisterImport; override;
  end;

  TPlugin_WinAPI = class(TExternalPlugin)
  private
  protected
    FPlugin_WinAPI: tPlugin_WinAPIBase;
  public
    function GetPluginName: string; override; safecall;

    procedure Initialize; override; safecall;
    procedure Finalize; override;  safecall;

    function CreatePlugin(aAPI_Output: tAPI_Output; aImp: TPSRuntimeClassImporter): TPlugin; override; safecall;
  end;

implementation

var
  _Plugin_WinAPI: TPlugin_WinAPI = nil;


constructor tPlugin_WinAPIBase.Create(aAPI_Output: tAPI_Output;
  var aImp: TPSRuntimeClassImporter;aPluginName: string);
begin
  Inherited;

  foAPI_WinAPI := TAPI_WinAPI.Create(foAPI_Output);

end;

destructor tPlugin_WinAPIBase.Destroy;
begin
  Inherited;

  FreeandNIl(foAPI_WinAPI);
end;

function tPlugin_WinAPIBase.CustomOnUses(var aCompiler: TPSPascalCompiler): Boolean;
begin
  Result := True;

  foAPI_WinAPI.oCompiler := aCompiler;

  SIRegister_API_WinAPI(aCompiler);

  AddImportedClassVariable(aCompiler, 'WinAPI', 'TAPI_WinAPI');

end;

procedure tPlugin_WinAPIBase.RegisterFunction(var aExec: TPSExec);
begin
end;

procedure tPlugin_WinAPIBase.SetVariantToClass(var aExec: TPSExec);
begin
  foAPI_WinAPI.oExec := aExec;

  uPSRuntime.SetVariantToClass(aExec.GetVarNo(aExec.GetVar('WinAPI')),
    foAPI_WinAPI);
end;

procedure tPlugin_WinAPIBase.RegisterImport;
begin
  RIRegister_API_WinAPI(FImp);
  RIRegister_API_WinAPI(FImp);
end;

// Plugin_WinAPI
function tPlugin_WinAPI.GetPluginName: string;
begin
  Result := 'WinAPI';
end;

procedure tPlugin_WinAPI.Initialize;
begin
end;

function tPlugin_WinAPI.CreatePlugin(aAPI_Output: tAPI_Output; aImp: TPSRuntimeClassImporter): TPlugin; safecall;
begin
  FPlugin_WinAPI := tPlugin_WinAPIBase.Create(aAPI_Output,aImp,PluginName);

  Result := FPlugin_WinAPI;
end;

procedure tPlugin_WinAPI.Finalize;
begin
  if Assigned(FPlugin_WinAPI) then FPlugin_WinAPI.Free;
end;

function GetPluginObject: TNovusPlugin;
begin
  if (_Plugin_WinAPI = nil) then _Plugin_WinAPI := tPlugin_WinAPI.Create;
  result := _Plugin_WinAPI;
end;

exports
  GetPluginObject name func_GetPluginObject;

initialization
  begin
    _Plugin_WinAPI := nil;
  end;

finalization
  FreeAndNIL(_Plugin_WinAPI);

end.
