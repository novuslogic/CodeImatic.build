unit Plugin_Zip;

interface

uses Classes,Plugin,  uPSRuntime,  uPSCompiler, PluginsMapFactory, Zip,
    uPSI_Zip, MessagesLog, SysUtils ;


type
  tPlugin_Zip = class(Tplugin)
  private
  protected
    foZip: TZip;
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

  foZip := TZip.Create;

end;


destructor  tPlugin_Zip.Destroy;
begin
  Inherited;

  FreeandNIl(foZip);
end;



function tPlugin_Zip.CustomOnUses(aCompiler: TPSPascalCompiler): Boolean;
begin
  Result := True;

  SIRegister_Zip(aCompiler);
  AddImportedClassVariable(aCompiler, 'Zip', 'TZip');

end;

procedure tPlugin_Zip.RegisterFunction(aExec: TPSExec);
begin
end;

procedure tPlugin_Zip.SetVariantToClass(aExec: TPSExec);
begin
  uPSRuntime.SetVariantToClass(aExec.GetVarNo(aExec.GetVar('ZIP')), foZip);
end;

procedure tPlugin_Zip.RegisterImport;
begin
  RIRegister_Zip(FImp);
end;

Initialization
 begin
   tPluginsMapFactory.RegisterClass(tPlugin_Zip);
 end;

end.


