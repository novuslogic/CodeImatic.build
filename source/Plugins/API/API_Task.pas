unit API_Task;

interface

uses Classes, APIBase, SysUtils, NovusWindows, API_Output, Plugin_TaskRunner, uPSRuntime ;

type
  TTaskFailed = class(TPersistent)
  protected
    fiRetry: Integer;
    fbAbort: boolean;
    fbSkip: Boolean;
  private
  public
    constructor Create;
    destructor Destroy; override;

    property Retry: integer
       read fiRetry
       write fiRetry;

    property Abort: Boolean
      read fbAbort
      write fbAbort;

    property Skip: Boolean
      read fbSkip
      write fbSkip;
  end;

  TTaskCriteria = class(TPersistent)
  protected
     fFailed:  TTaskFailed;
  private
  public
    constructor Create;
    destructor Destroy; override;

    property Failed: TtaskFailed
       read fFailed
       write fFailed;
  end;

  TTask = class(TPersistent)
  protected
    fdtStartBuild: tdatetime;
    fdtEndBuild: tDatetime;
    fCriteria : TTaskCriteria;
    fDependencies: tStringList;
    fsProcedureName: String;
    fTaskRunner: TTaskRunner;
  private

  public
    constructor Create;
    destructor Destroy; override;

    function IsDependentOn(const aProcedureName: String): Boolean;

    property ProcedureName: String
      read fsProcedureName
      write fsProcedureName;

    property TaskRunner: TTaskRunner
      read fTaskRunner
      write fTaskRunner;

    property Dependencies: tStringList
      read fDependencies
      write fDependencies;

    property StartBuild: tdatetime
      read fdtStartBuild
      write fdtStartBuild;

    property  EndBuild: tDatetime
       read fdtEndBuild
       write fdtEndBuild;

  published
    property Criteria : TTaskCriteria
      read fCriteria
      write fCriteria;
  end;


   TFinishTasksEvent = procedure of object;

   TAPI_Task = class(TAPIBase)
   private
   protected
     fFinishedTasks: TFinishTasksEvent;
     fTaskRunner: TTaskRunner;
     function DoDependencies(const aTask: tTask): Boolean;
     function DoExec(const aProcedureName: string): Boolean;
     function DoRunTarget(const aTask: tTask): boolean;
   public
     constructor Create(aAPI_Output: tAPI_Output; aTaskRunner: TTaskRunner); overload;

     function AddTask(const aProcedureName: String): TTask;
     function RunTarget(const aProcedureName: String): boolean;

     procedure Buildreport;

   published
     property FinishedTasks: TFinishTasksEvent
      read fFinishedTasks write fFinishedTasks;


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
  If Self.oExec.GetProc(aProcedureName) = InvalidVal then Exit;

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

  Try
    FProc := oExec.GetProc(aProcedureName);

    If FProc = InvalidVal then Exit;

    oExec.RunProcP([], FProc);
  Except
    Result := False;

    Exit;
  End;

  Result := True;
end;

function TAPI_Task.DoDependencies(const aTask: tTask): Boolean;
var
  I: Integer;
  LTask: tTask;
begin
  Result := False;

  if Not Assigned(aTask) then Exit;


  if aTask.Dependencies.Count = 0 then
    begin
      Result := True;

      Exit;
    end;


  for I := 0 to aTask.Dependencies.Count - 1 do
    begin
      LTask := fTaskRunner.FindTask(aTask.Dependencies.Strings[i]) as Ttask;

      if Assigned(Ltask) then
        begin
          if not DoRunTarget(LTask) then
            begin


              Exit;
            end

        end;


    end;

  Result := True;

end;

function TAPI_Task.DoRunTarget(const aTask: tTask): boolean;
Var
  FTask: tTask;
  liRetry, I: Integer;
  fbRetry: Boolean;
begin
  Result := False;

  If Self.oExec.GetProc(aTask.ProcedureName)= InvalidVal then Exit;

  FTask := tTask(FTaskRunner.FindTask(aTask.ProcedureName));

  if Assigned(FTask) then
    begin
      Try
        if DoDependencies(FTask) then
          begin
            FTask.StartBuild := Now;

            fbRetry := False;
            liRetry := aTask.Criteria.Failed.Retry;
            if liRetry > 0 then fbRetry := True;

            if liRetry = 0 then liRetry := 1;

            for I := 1 to liRetry do
             begin
               Result := DoExec(aTask.ProcedureName);

               if not Result then
                  begin
                    oAPI_Output.WriteLog('[Runtime Error] : ' + TIFErrorToString(oExec.ExceptionCode, oExec.ExceptionString) +
                        ' in ' + IntToStr(oExec.ExceptionProcNo) + ' at ' + IntToSTr(oExec.ExceptionPos));

                    if fbRetry then
                       oAPI_Output.WriteLog('Retrying executing ... ' + IntToStr(I) + ' of ' + IntToStr(liRetry));

                    if aTask.Criteria.Failed.Skip then Result := True;
                    if aTask.Criteria.Failed.Abort then Result := False;

                  end
               else
                  break;


             end;
          end;

          FTask.EndBuild := Now;

          Except
            oAPI_Output.InternalError;
          end;
    end;
end;


function TAPI_Task.RunTarget(const aProcedureName: String): boolean;
var
  FTask: tTask;
begin
  Result := False;

  FTask := tTask(FTaskRunner.FindTask(aProcedureName));
  if Assigned(FTask) then
    Result := DoRunTarget(FTask);

  if assigned(fFinishedTasks) then
    fFinishedTasks();

end;

procedure TAPI_Task.Buildreport;
begin

end;


constructor TTask.Create;
begin
  fCriteria := TTaskCriteria.Create;

  fDependencies:= tStringList.Create;
end;

destructor TTask.Destroy;
begin
  fCriteria.Free;
  fDependencies.Free;
end;

function TTask.IsDependentOn(const aProcedureName: String): Boolean;
begin
  Result := False;

  if Uppercase(Trim(aProcedurename)) = Uppercase(Trim(Self.Procedurename)) then Exit;

  if fDependencies.IndexOf(aProcedureName) = -1 then
    fDependencies.Add(aProcedureName);
end;

 // TTaskCriteria
constructor TTaskCriteria.Create;
begin
  fFailed:= TtaskFailed.Create;
end;

destructor TTaskCriteria.Destroy;
begin
  fFailed.Free;
end;

//TTaskFailed
constructor TTaskFailed.Create;
begin
  fiRetry := 0;
  fbAbort  := False;
  fbSkip  := False;
end;

destructor TTaskFailed.Destroy;
begin
end;






end.
