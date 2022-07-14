unit Plugin_TaskClasses;


interface

uses Classes,Plugin,  uPSRuntime,  uPSCompiler, API_Task, NovusList,
    API_Output, SysUtils, uPSI_API_Task, NovusPlugin, System.Generics.Defaults,
    Plugin_TaskRunner;


type
  tPlugin_TaskBase = class(TPascalScriptPlugin)
  private
  protected
    foTaskRunner: TTaskRunner;
    foAPI_Task: TAPI_Task;
  public
    constructor Create(aAPI_Output: tAPI_Output; var aImp: TPSRuntimeClassImporter;aPluginName: String); override;
    destructor Destroy; override;

    function CustomOnUses(var aCompiler: TPSPascalCompiler): Boolean; override;
    procedure RegisterFunction(var aExec: TPSExec); override;
    procedure SetVariantToClass(var aExec: TPSExec); override;
    procedure RegisterImport; override;
  end;

  TPlugin_Task = class(TExternalPlugin)
  private
  protected
    FPlugin_Task: tPlugin_TaskBase;
  public
    function GetPluginName: string; override; safecall;

    procedure Initialize; override; safecall;
    procedure Finalize; override; safecall;

    function CreatePlugin(aAPI_Output: tAPI_Output; aImp: TPSRuntimeClassImporter): TPlugin; override; safecall;
  end;

function GetPluginObject: TNovusPlugin; stdcall;

implementation

var
  _Plugin_Task: TPlugin_Task = nil;


constructor tPlugin_TaskBase.Create(aAPI_Output: tAPI_Output; var aImp: TPSRuntimeClassImporter; aPluginName: String);
begin
  Inherited;

  foTaskRunner := TTaskRunner.Create(TTask);


  foAPI_Task := TAPI_Task.Create(foAPI_Output, foTaskRunner);
end;


destructor  tPlugin_TaskBase.Destroy;
begin
  Inherited;

  FreeandNIl(foTaskRunner);

  FreeandNIl(foAPI_Task);
end;



function tPlugin_TaskBase.CustomOnUses(var aCompiler: TPSPascalCompiler): Boolean;
begin
  Result := True;

  foAPI_Task.oCompiler := aCompiler;

  SIRegister_API_Task(aCompiler);

  AddImportedClassVariable(aCompiler, 'Task', 'TAPI_Task');


end;

procedure tPlugin_TaskBase.RegisterFunction(var aExec: TPSExec);
begin
end;

procedure tPlugin_TaskBase.SetVariantToClass(var aExec: TPSExec);
begin
  foAPI_Task.oExec := aExec;

  uPSRuntime.SetVariantToClass(aExec.GetVarNo(aExec.GetVar('Task')), foAPI_Task);
end;

procedure tPlugin_TaskBase.RegisterImport;
begin
  RIRegister_API_Task(FImp);
//  RIRegister_API_Task(FImp);
end;

// Plugin_Task
function tPlugin_Task.GetPluginName: string;
begin
  Result := 'Task';
end;

procedure tPlugin_Task.Initialize;
begin
end;

function tPlugin_Task.CreatePlugin(aAPI_Output: tAPI_Output; aImp: TPSRuntimeClassImporter): TPlugin; safecall;
begin
  FPlugin_Task := tPlugin_TaskBase.Create(aAPI_Output,aImp, PluginName);

  Result := FPlugin_Task;
end;


procedure tPlugin_Task.Finalize;
begin
  if Assigned(FPlugin_Task) then FPlugin_Task.Free;
end;

function GetPluginObject: TNovusPlugin;
begin
  if (_Plugin_Task = nil) then _Plugin_Task := TPlugin_Task.Create;
  result := _Plugin_Task;
end;

exports
  GetPluginObject name func_GetPluginObject;

initialization
  begin
    _Plugin_Task := nil;
  end;

finalization
  FreeAndNIL(_Plugin_Task);



end.
