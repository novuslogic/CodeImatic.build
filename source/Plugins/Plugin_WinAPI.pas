unit Plugin_WinAPI;

interface

uses Classes, Plugin, uPSRuntime, uPSCompiler, PluginsMapFactory, API_WinAPI,
  uPSI_API_WinAPI, API_Output, SysUtils;

type
  tPlugin_WinAPI = class(Tplugin)
  private
  protected
    foAPI_WinAPI: TAPI_WinAPI;
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

constructor tPlugin_WinAPI.Create(aAPI_Output: tAPI_Output;
  var aImp: TPSRuntimeClassImporter);
begin
  Inherited;

  foAPI_WinAPI := TAPI_WinAPI.Create(foAPI_Output);

end;

destructor tPlugin_WinAPI.Destroy;
begin
  Inherited;

  FreeandNIl(foAPI_WinAPI);
end;

function tPlugin_WinAPI.CustomOnUses(var aCompiler: TPSPascalCompiler): Boolean;
begin
  Result := True;

  foAPI_WinAPI.oCompiler := aCompiler;

  SIRegister_API_WinAPI(aCompiler);

  AddImportedClassVariable(aCompiler, 'WinAPI', 'TAPI_WinAPI');

end;

procedure tPlugin_WinAPI.RegisterFunction(var aExec: TPSExec);
begin
end;

procedure tPlugin_WinAPI.SetVariantToClass(var aExec: TPSExec);
begin
  foAPI_WinAPI.oExec := aExec;

  uPSRuntime.SetVariantToClass(aExec.GetVarNo(aExec.GetVar('WinAPI')),
    foAPI_WinAPI);
end;

procedure tPlugin_WinAPI.RegisterImport;
begin
  RIRegister_API_WinAPI(FImp);
  RIRegister_API_WinAPI(FImp);
end;

Initialization

begin
  tPluginsMapFactory.RegisterClass(tPlugin_WinAPI);
end;

end.
