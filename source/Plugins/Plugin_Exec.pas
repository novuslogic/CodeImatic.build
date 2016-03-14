unit Plugin_Exec;

interface

uses Classes,Plugin,  uPSRuntime,  uPSCompiler, PluginsMapFactory, API_exec,
    MessagesLog, SysUtils, uPSI_API_Exec;


type
  tPlugin_Exec = class(Tplugin)
  private
  protected
     foAPI_exec: TAPI_Exec;
  public
    constructor Create(aMessagesLog: tMessagesLog; aImp: TPSRuntimeClassImporter); override;
    destructor Destroy; override;

    function CustomOnUses(aCompiler: TPSPascalCompiler): Boolean; override;
    procedure RegisterFunction(aExec: TPSExec); override;
    procedure SetVariantToClass(aExec: TPSExec); override;
    procedure RegisterImport; override;
  end;

implementation


constructor tPlugin_Exec.Create(aMessagesLog: tMessagesLog; aImp: TPSRuntimeClassImporter);
begin
  Inherited;

  foAPI_Exec := TAPI_Exec.Create(foMessagesLog);

end;


destructor  tPlugin_Exec.Destroy;
begin
  Inherited;

  FreeandNIl(foAPI_Exec);
end;



function tPlugin_Exec.CustomOnUses(aCompiler: TPSPascalCompiler): Boolean;
begin
  Result := True;

  foAPI_Exec.oCompiler := aCompiler;

  SIRegister_API_Exec(aCompiler);
  SIRegister_API_Exec(aCompiler);
  AddImportedClassVariable(aCompiler, 'Zip', 'TAPI_Exec');


end;

procedure tPlugin_Exec.RegisterFunction(aExec: TPSExec);
begin
end;

procedure tPlugin_Exec.SetVariantToClass(aExec: TPSExec);
begin
  foAPI_Exec.oExec := aExec;

  uPSRuntime.SetVariantToClass(aExec.GetVarNo(aExec.GetVar('ZIP')), foAPI_Exec);
end;

procedure tPlugin_Exec.RegisterImport;
begin
  RIRegister_API_Exec(FImp);
  RIRegister_API_Exec(FImp);
end;

Initialization
 begin
   tPluginsMapFactory.RegisterClass(tPlugin_Exec);
 end;




end.
