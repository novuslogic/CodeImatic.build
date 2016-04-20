unit Plugin_RegIni;

interface

uses Classes,Plugin,  uPSRuntime,  uPSCompiler, PluginsMapFactory, API_RegIni,
    uPSI_API_RegIni, MessagesLog, SysUtils;


type
  tPlugin_RegIni = class(Tplugin)
  private
  protected
    foAPI_RegIni: TAPI_RegIni;
  public
    constructor Create(aMessagesLog: tMessagesLog; aImp: TPSRuntimeClassImporter); override;
    destructor Destroy; override;

    function CustomOnUses(aCompiler: TPSPascalCompiler): Boolean; override;
    procedure RegisterFunction(aExec: TPSExec); override;
    procedure SetVariantToClass(aExec: TPSExec); override;
    procedure RegisterImport; override;
  end;

implementation

constructor tPlugin_RegIni.Create(aMessagesLog: tMessagesLog; aImp: TPSRuntimeClassImporter);
begin
  Inherited;

  foAPI_RegIni := TAPI_RegIni.Create(foMessagesLog);

end;


destructor  tPlugin_RegIni.Destroy;
begin
  Inherited;

  FreeandNIl(foAPI_RegIni);
end;



function tPlugin_RegIni.CustomOnUses(aCompiler: TPSPascalCompiler): Boolean;
begin
  Result := True;

  foAPI_RegIni.oCompiler := aCompiler;

  SIRegister_API_RegIni(aCompiler);
  SIRegister_API_RegIni(aCompiler);
  AddImportedClassVariable(aCompiler, 'RegIni', 'TAPI_RegIni');


end;

procedure tPlugin_RegIni.RegisterFunction(aExec: TPSExec);
begin
end;

procedure tPlugin_RegIni.SetVariantToClass(aExec: TPSExec);
begin
  foAPI_RegIni.oExec := aExec;

  uPSRuntime.SetVariantToClass(aExec.GetVarNo(aExec.GetVar('RegIni')), foAPI_RegIni);
end;

procedure tPlugin_RegIni.RegisterImport;
begin
  RIRegister_API_RegIni(FImp);
  RIRegister_API_RegIni(FImp);
end;

Initialization
 begin
   tPluginsMapFactory.RegisterClass(tPlugin_RegIni);
 end;

end.


