unit Plugin_API_ProjectConfig;

interface

uses Classes,Plugin,  uPSRuntime,  uPSCompiler, PluginsMapFactory, API_ProjectConfig,
    MessagesLog, SysUtils, uPSI_API_ProjectConfig ;


type
  tPlugin_ProjectConfig = class(Tplugin)
  private
  protected
     foAPI_ProjectConfig: TAPI_ProjectConfig;
  public
    constructor Create(aMessagesLog: tMessagesLog; aImp: TPSRuntimeClassImporter); override;
    destructor Destroy; override;

    function CustomOnUses(aCompiler: TPSPascalCompiler): Boolean; override;
    procedure RegisterFunction(aExec: TPSExec); override;
    procedure SetVariantToClass(aExec: TPSExec); override;
    procedure RegisterImport; override;
  end;

implementation


constructor tPlugin_ProjectConfig.Create(aMessagesLog: tMessagesLog; aImp: TPSRuntimeClassImporter);
begin
  Inherited;

  foAPI_ProjectConfig := TAPI_ProjectConfig.Create(foMessagesLog);

end;


destructor  tPlugin_ProjectConfig.Destroy;
begin
  Inherited;

  FreeandNIl(foAPI_ProjectConfig);
end;



function tPlugin_ProjectConfig.CustomOnUses(aCompiler: TPSPascalCompiler): Boolean;
begin
  Result := True;

  foAPI_ProjectConfig.oCompiler := aCompiler;

  SIRegister_API_ProjectConfig(aCompiler);
  SIRegister_API_ProjectConfig(aCompiler);
  AddImportedClassVariable(aCompiler, 'ProjectConfig', 'TAPI_ProjectConfig');


end;

procedure tPlugin_ProjectConfig.RegisterFunction(aExec: TPSExec);
begin
end;

procedure tPlugin_ProjectConfig.SetVariantToClass(aExec: TPSExec);
begin
  foAPI_ProjectConfig.oExec := aExec;

  uPSRuntime.SetVariantToClass(aExec.GetVarNo(aExec.GetVar('ProjectConfig')), foAPI_ProjectConfig);
end;

procedure tPlugin_ProjectConfig.RegisterImport;
begin
  RIRegister_API_ProjectConfig(FImp);
  RIRegister_API_ProjectConfig(FImp);
end;

Initialization
 begin
   tPluginsMapFactory.RegisterClass(tPlugin_ProjectConfig);
 end;




end.

