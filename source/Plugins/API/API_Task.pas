unit API_Task;

interface

uses APIBase, SysUtils, NovusWindows, API_Output, Plugin_TaskRunner, uPSRuntime ;

type
   TAPI_Task = class(TAPIBase)
   private
   protected
     fTaskRunner: TTaskRunner;
   public
     constructor Create(aAPI_Output: tAPI_Output; aTaskRunner: TTaskRunner); overload;

     function AddTask(const aProcedureName: String): boolean;
     function RunTarget(const aProcedureName: String): boolean;
   end;

implementation



constructor TAPI_Task.create(aAPI_Output: tAPI_Output; aTaskRunner: TTaskRunner);
begin
  inherited Create(aAPI_Output);

  fTaskRunner := aTaskRunner;
end;


function TAPI_Task.AddTask(const aProcedureName: String): Boolean;
Var
  FTask: tTask;
begin
  Result := False;
  If Self.oExec.GetProc(aProcedureName)= InvalidVal then Exit;

  Try
    FTask := tTask.Create;
    FTask.ProcedureName := aProcedureName;

    FTaskRunner.add( FTask);

  Finally
    Result := True;
  End;
end;


function TAPI_Task.RunTarget(const aProcedureName: String): boolean;
Var
  FTask: tTask;
  FProc: Cardinal;
begin
  Result := False;

  If Self.oExec.GetProc(aProcedureName)= InvalidVal then Exit;

  FTask := FTaskRunner.FindTask(aProcedureName);
  if Assigned(FTask) then
    begin
      Try
        FProc := Self.oExec.GetProc(aProcedureName);

        Self.oExec.RunProcP([], FProc);
      Except
        oAPI_Output.InternalError;
      End;
    end;

end;


end.
