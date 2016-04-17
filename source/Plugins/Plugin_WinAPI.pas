unit Plugin_WinAPI;

interface

uses Classes,Plugin,  uPSRuntime,  uPSCompiler, PluginsMapFactory, API_WinAPI,
    uPSI_API_WinAPI, MessagesLog, SysUtils;


type
  tPlugin_WinAPI = class(Tplugin)
  private
  protected
    foAPI_WinAPI: TAPI_WinAPI;
  public
    constructor Create(aMessagesLog: tMessagesLog; aImp: TPSRuntimeClassImporter); override;
    destructor Destroy; override;

    function CustomOnUses(aCompiler: TPSPascalCompiler): Boolean; override;
    procedure RegisterFunction(aExec: TPSExec); override;
    procedure SetVariantToClass(aExec: TPSExec); override;
    procedure RegisterImport; override;
  end;

implementation

constructor tPlugin_WinAPI.Create(aMessagesLog: tMessagesLog; aImp: TPSRuntimeClassImporter);
begin
  Inherited;

  foAPI_WinAPI := TAPI_WinAPI.Create(foMessagesLog);

end;


destructor  tPlugin_WinAPI.Destroy;
begin
  Inherited;

  FreeandNIl(foAPI_WinAPI);
end;



function tPlugin_WinAPI.CustomOnUses(aCompiler: TPSPascalCompiler): Boolean;
begin
  Result := True;

  foAPI_WinAPI.oCompiler := aCompiler;

  SIRegister_API_WinAPI(aCompiler);
  SIRegister_API_WinAPI(aCompiler);
  AddImportedClassVariable(aCompiler, 'WinAPI', 'TAPI_WinAPI');


end;

procedure tPlugin_WinAPI.RegisterFunction(aExec: TPSExec);
begin
end;

procedure tPlugin_WinAPI.SetVariantToClass(aExec: TPSExec);
begin
  foAPI_WinAPI.oExec := aExec;

  uPSRuntime.SetVariantToClass(aExec.GetVarNo(aExec.GetVar('WinAPI')), foAPI_WinAPI);
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


