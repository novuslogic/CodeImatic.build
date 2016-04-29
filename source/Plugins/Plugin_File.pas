unit Plugin_File;

interface

uses Classes,Plugin,  uPSRuntime,  uPSCompiler, PluginsMapFactory, API_File,
    MessagesLog, SysUtils, uPSI_API_File ;


type
  tPlugin_File = class(Tplugin)
  private
  protected
     foAPI_File: TAPI_File;
  public
    constructor Create(aMessagesLog: tMessagesLog; aImp: TPSRuntimeClassImporter); override;
    destructor Destroy; override;

    function CustomOnUses(aCompiler: TPSPascalCompiler): Boolean; override;
    procedure RegisterFunction(aExec: TPSExec); override;
    procedure SetVariantToClass(aExec: TPSExec); override;
    procedure RegisterImport; override;
  end;



implementation


constructor tPlugin_File.Create(aMessagesLog: tMessagesLog; aImp: TPSRuntimeClassImporter);
begin
  Inherited;

  foAPI_File := TAPI_File.Create(foMessagesLog);

end;


destructor  tPlugin_File.Destroy;
begin
  Inherited;

  FreeandNIl(foAPI_File);
end;



function tPlugin_File.CustomOnUses(aCompiler: TPSPascalCompiler): Boolean;
begin
  Result := True;

  foAPI_File.oCompiler := aCompiler;

  SIRegister_API_File(aCompiler);
  SIRegister_API_File(aCompiler);
  AddImportedClassVariable(aCompiler, 'File', 'TAPI_File');


end;

procedure tPlugin_File.RegisterFunction(aExec: TPSExec);
begin
end;

procedure tPlugin_File.SetVariantToClass(aExec: TPSExec);
begin
  foAPI_File.oExec := aExec;

  uPSRuntime.SetVariantToClass(aExec.GetVarNo(aExec.GetVar('File')), foAPI_File);
end;

procedure tPlugin_File.RegisterImport;
begin
  RIRegister_API_File(FImp);
  RIRegister_API_File(FImp);
end;

Initialization
 begin
   tPluginsMapFactory.RegisterClass(tPlugin_File);
 end;




end.

