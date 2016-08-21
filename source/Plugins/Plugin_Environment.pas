unit Plugin_Environment;

interface

uses Classes,Plugin,  uPSRuntime,  uPSCompiler, PluginsMapFactory, API_Environment,
    API_Output, SysUtils, uPSI_API_Environment ;


type
  tPlugin_Environment = class(Tplugin)
  private
  protected
     foAPI_Environment: TAPI_Environment;
  public
    constructor Create(aAPI_Output: tAPI_Output; var aImp: TPSRuntimeClassImporter); override;
    destructor Destroy; override;

    function CustomOnUses(var aCompiler: TPSPascalCompiler): Boolean; override;
    procedure RegisterFunction(var aExec: TPSExec); override;
    procedure SetVariantToClass(var aExec: TPSExec); override;
    procedure RegisterImport; override;
  end;



implementation


constructor tPlugin_Environment.Create(aAPI_Output: tAPI_Output; var aImp: TPSRuntimeClassImporter);
begin
  Inherited;

  foAPI_Environment := TAPI_Environment.Create(foAPI_Output);

end;


destructor  tPlugin_Environment.Destroy;
begin
  Inherited;

  FreeandNIl(foAPI_Environment);
end;



function tPlugin_Environment.CustomOnUses(var aCompiler: TPSPascalCompiler): Boolean;
begin
  Result := True;

  foAPI_Environment.oCompiler := aCompiler;

  SIRegister_API_Environment(aCompiler);

  AddImportedClassVariable(aCompiler, 'Environment', 'TAPI_Environment');


end;

procedure tPlugin_Environment.RegisterFunction(var aExec: TPSExec);
begin
end;

procedure tPlugin_Environment.SetVariantToClass(var aExec: TPSExec);
begin
  foAPI_Environment.oExec := aExec;

  uPSRuntime.SetVariantToClass(aExec.GetVarNo(aExec.GetVar('Environment')), foAPI_Environment);
end;

procedure tPlugin_Environment.RegisterImport;
begin
  RIRegister_API_Environment(FImp);
  RIRegister_API_Environment(FImp);
end;

Initialization
 begin
   tPluginsMapFactory.RegisterClass(tPlugin_Environment);
 end;




end.

