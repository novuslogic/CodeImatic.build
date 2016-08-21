unit Plugin_Shell;

interface

uses Classes,Plugin,  uPSRuntime,  uPSCompiler, PluginsMapFactory, API_Shell,
    API_Output, SysUtils, uPSI_API_Shell;


type
  tPlugin_Shell = class(Tplugin)
  private
  protected
     foAPI_Shell: TAPI_Shell;
  public
    constructor Create(aAPI_Output: tAPI_Output; var aImp: TPSRuntimeClassImporter); override;
    destructor Destroy; override;

    function CustomOnUses(var aCompiler: TPSPascalCompiler): Boolean; override;
    procedure RegisterFunction(var aExec: TPSExec); override;
    procedure SetVariantToClass(var aExec: TPSExec); override;
    procedure RegisterImport; override;
  end;

implementation


constructor tPlugin_Shell.Create(aAPI_Output: tAPI_Output; var aImp: TPSRuntimeClassImporter);
begin
  Inherited;

  foAPI_Shell := TAPI_Shell.Create(foAPI_Output);

end;


destructor  tPlugin_Shell.Destroy;
begin
  Inherited;

  FreeandNIl(foAPI_Shell);
end;



function tPlugin_Shell.CustomOnUses(var aCompiler: TPSPascalCompiler): Boolean;
begin
  Result := True;

  foAPI_Shell.oCompiler := aCompiler;

  SIRegister_API_Shell(aCompiler);

  AddImportedClassVariable(aCompiler, 'Shell', 'TAPI_Shell');


end;

procedure tPlugin_Shell.RegisterFunction(var aExec: TPSExec);
begin
end;

procedure tPlugin_Shell.SetVariantToClass(var aExec: TPSExec);
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
