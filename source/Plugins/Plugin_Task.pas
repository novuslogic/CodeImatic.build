unit Plugin_Task;


interface

uses Classes,Plugin,  uPSRuntime,  uPSCompiler, PluginsMapFactory, API_Task,
    MessagesLog, SysUtils, uPSI_API_Task;


type
  tPlugin_Task = class(Tplugin)
  private
  protected
     foAPI_Task: TAPI_Task;
  public
    constructor Create(aMessagesLog: tMessagesLog; var aImp: TPSRuntimeClassImporter); override;
    destructor Destroy; override;

    function CustomOnUses(var aCompiler: TPSPascalCompiler): Boolean; override;
    procedure RegisterFunction(var aExec: TPSExec); override;
    procedure SetVariantToClass(var aExec: TPSExec); override;
    procedure RegisterImport; override;
  end;

implementation


constructor tPlugin_Task.Create(aMessagesLog: tMessagesLog; var aImp: TPSRuntimeClassImporter);
begin
  Inherited;

  foAPI_Task := TAPI_Task.Create(foMessagesLog);

end;


destructor  tPlugin_Task.Destroy;
begin
  Inherited;

  FreeandNIl(foAPI_Task);
end;



function tPlugin_Task.CustomOnUses(var aCompiler: TPSPascalCompiler): Boolean;
begin
  Result := True;

  foAPI_Task.oCompiler := aCompiler;

  SIRegister_API_Task(aCompiler);

  AddImportedClassVariable(aCompiler, 'Task', 'TAPI_Task');


end;

procedure tPlugin_Task.RegisterFunction(var aExec: TPSExec);
begin
end;

procedure tPlugin_Task.SetVariantToClass(var aExec: TPSExec);
begin
  foAPI_Task.oExec := aExec;

  uPSRuntime.SetVariantToClass(aExec.GetVarNo(aExec.GetVar('Task')), foAPI_Task);
end;

procedure tPlugin_Task.RegisterImport;
begin
  RIRegister_API_Task(FImp);
  RIRegister_API_Task(FImp);
end;

Initialization
 begin
   tPluginsMapFactory.RegisterClass(tPlugin_Task);
 end;




end.
