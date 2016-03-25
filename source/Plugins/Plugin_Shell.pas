unit Plugin_Shell;

interface

uses Classes,Plugin,  uPSRuntime,  uPSCompiler, PluginsMapFactory, API_Shell,
    MessagesLog, SysUtils, uPSI_API_Shell;


type
  tPlugin_Shell = class(Tplugin)
  private
  protected
     foAPI_Shell: TAPI_Shell;
  public
    constructor Create(aMessagesLog: tMessagesLog; aImp: TPSRuntimeClassImporter); override;
    destructor Destroy; override;

    function CustomOnUses(aCompiler: TPSPascalCompiler): Boolean; override;
    procedure RegisterFunction(aExec: TPSExec); override;
    procedure SetVariantToClass(aExec: TPSExec); override;
    procedure RegisterImport; override;
  end;

implementation


constructor tPlugin_Shell.Create(aMessagesLog: tMessagesLog; aImp: TPSRuntimeClassImporter);
begin
  Inherited;

  foAPI_Shell := TAPI_Shell.Create(foMessagesLog);

end;


destructor  tPlugin_Shell.Destroy;
begin
  Inherited;

  FreeandNIl(foAPI_Shell);
end;



function tPlugin_Shell.CustomOnUses(aCompiler: TPSPascalCompiler): Boolean;
begin
  Result := True;

  foAPI_Shell.oCompiler := aCompiler;

  SIRegister_API_Shell(aCompiler);
  SIRegister_API_Shell(aCompiler);
  AddImportedClassVariable(aCompiler, 'Shell', 'TAPI_Shell');


end;

procedure tPlugin_Shell.RegisterFunction(aExec: TPSExec);
begin
end;

procedure tPlugin_Shell.SetVariantToClass(aExec: TPSExec);
begin
  foAPI_Shell.oExec := aExec;

  uPSRuntime.SetVariantToClass(aExec.GetVarNo(aExec.GetVar('Shell')), foAPI_Shell);
end;

procedure tPlugin_Shell.RegisterImport;
begin
  RIRegister_API_Shell(FImp);
  RIRegister_API_Shell(FImp);
end;

Initialization
 begin
   tPluginsMapFactory.RegisterClass(tPlugin_Shell);
 end;




end.
