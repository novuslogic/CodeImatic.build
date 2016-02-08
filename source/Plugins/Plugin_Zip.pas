unit Plugin_Zip;

interface

uses Classes,Plugin,  uPSRuntime,  uPSCompiler, PluginsMapFactory, API_Zip,
    uPSI_API_Zip, MessagesLog, SysUtils, ZIp ;


type
  tPlugin_Zip = class(Tplugin)
  private
  protected
    foAPI_Zip: TAPI_Zip;
  public
    constructor Create(aMessagesLog: tMessagesLog; aImp: TPSRuntimeClassImporter); override;
    destructor Destroy; override;

    function CustomOnUses(aCompiler: TPSPascalCompiler): Boolean; override;
    procedure RegisterFunction(aExec: TPSExec); override;
    procedure SetVariantToClass(aExec: TPSExec); override;
    procedure RegisterImport; override;
  end;

implementation

constructor tPlugin_Zip.Create(aMessagesLog: tMessagesLog; aImp: TPSRuntimeClassImporter);
begin
  Inherited;

  foAPI_Zip := TAPI_Zip.Create(foMessagesLog);

end;


destructor  tPlugin_Zip.Destroy;
begin
  Inherited;

  FreeandNIl(foAPI_Zip);
end;



function tPlugin_Zip.CustomOnUses(aCompiler: TPSPascalCompiler): Boolean;
begin
  Result := True;

  foAPI_Zip.oCompiler := aCompiler;

  SIRegister_API_Zip(aCompiler);
  AddImportedClassVariable(aCompiler, 'Zip', 'TAPI_Zip');


end;

procedure tPlugin_Zip.RegisterFunction(aExec: TPSExec);
begin
end;

procedure tPlugin_Zip.SetVariantToClass(aExec: TPSExec);
begin
  foAPI_Zip.oExec := aExec;

  uPSRuntime.SetVariantToClass(aExec.GetVarNo(aExec.GetVar('ZIP')), foAPI_Zip);
end;

procedure tPlugin_Zip.RegisterImport;
begin
  RIRegister_API_Zip(FImp);
end;

Initialization
 begin
   tPluginsMapFactory.RegisterClass(tPlugin_Zip);
 end;

end.


