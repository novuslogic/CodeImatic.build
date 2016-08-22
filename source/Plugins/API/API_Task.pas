unit API_Task;

interface

uses Classes, APIBase, SysUtils, NovusWindows, API_Output, Plugin_TaskRunner, uPSRuntime ;

type
  TTask = class(TPersistent)
  protected
    fsProcedureName: String;
  private
  public
    function IsDependentOn(const aProcedureName: String): Boolean;

    property ProcedureName: String
      read fsProcedureName
      write fsProcedureName;
  end;


   TAPI_Task = class(TAPIBase)
   private
   protected
     fTaskRunner: TTaskRunner;
     function DoExec(const aProcedureName: string): Boolean;
     function DoRunTarget(const aProcedureName: String): boolean;
   public
     constructor Create(aAPI_Output: tAPI_Output; aTaskRunner: TTaskRunner); overload;

     function AddTask(const aProcedureName: String): TTask;
     function RunTarget(const aProcedureName: String): boolean;
   end;

implementation



constructor TAPI_Task.create(aAPI_Output: tAPI_Output; aTaskRunner: TTaskRunner);
begin
  inherited Create(aAPI_Output);

  fTaskRunner := aTaskRunner;
end;


function TAPI_Task.AddTask(const aProcedureName: String): TTask;
Var
  FTask: tTask;
begin
  Result := NIl;
  If Self.oExec.GetProc(aProcedureName)= InvalidVal then Exit;

  Try
    FTask := tTask.Create;
    FTask.ProcedureName := aProcedureName;

    FTaskRunner.add( FTask);

  Finally
    Result := FTask;
  End;
end;

function TAPI_Task.DoExec(const aProcedureName: string): Boolean;
var
  FProc: Cardinal;
begin
  Result := False;

  FProc := oExec.GetProc(aProcedureName);

  If FProc = InvalidVal then Exit;

  oExec.RunProcP([], FProc);
end;

function TAPI_Task.DoRunTarget(const aProcedureName: String): boolean;
Var
  FTask: tTask;

begin
  Result := False;

  If Self.oExec.GetProc(aProcedureName)= InvalidVal then Exit;

  FTask := tTask(FTaskRunner.FindTask(aProcedureName));
  if Assigned(FTask) then
    begin
      if True then



      Try
        Result := DoExec(aProcedureName);
      Except
        oAPI_Output.InternalError;
      End;
    end;
end;


function TAPI_Task.RunTarget(const aProcedureName: String): boolean;
begin
  Result := DoRunTarget(aProcedureName);
end;

function TTask.IsDependentOn(const aProcedureName: String): Boolean;
begin
  Result := False;
end;




end.
