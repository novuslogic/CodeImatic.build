unit API_Task;

interface

uses Classes, APIBase, SysUtils, NovusWindows, API_Output, Plugin_TaskRunner, uPSRuntime, Project ;

type
  TTaskEvent = procedure of object;


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
    fFinishedTask: TTaskEvent;
    fdtStartBuild: tdatetime;
    fdtEndBuild: tDatetime;
    fCriteria : TTaskCriteria;
    fDependencies: tStringList;
    fsProcedureName: String;
    fTaskRunner: TTaskRunner;
    fBuildStatus: TBuildStatus;
    function GetDuration: TdateTime;
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

    property Duration: TDateTime
      read GetDuration;

    property  EndBuild: tDatetime
       read fdtEndBuild
       write fdtEndBuild;

    property BuildStatus: TBuildStatus
       read fBuildStatus
       write fBuildStatus;

  published
    property Criteria : TTaskCriteria
      read fCriteria
      write fCriteria;

    property FinishedTask: TTaskEvent
      read fFinishedTask write fFinishedTask;

  end;




   TAPI_Task = class(TAPIBase)
   private
   protected
     fFinishedTasks: TTaskEvent;
     fTaskRunner: TTaskRunner;
     function DoDependencies(const aTask: tTask): Boolean;
     function DoExec(const aProcedureName: string): Boolean;
     function DoRunTarget(const aTask: tTask): boolean;
   public
     constructor Create(aAPI_Output: tAPI_Output; aTaskRunner: TTaskRunner); overload;

     function AddTask(const aProcedureName: String): TTask;
     function RunTarget(const aProcedureName: String): boolean;

     procedure BuildReport;

   published
     property FinishedTasks: TTaskEvent
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
                    Ftask.BuildStatus := tBuildStatus.bsFailed;

                    oAPI_Output.WriteLog('[Runtime Error] : ' + TIFErrorToString(oExec.ExceptionCode, oExec.ExceptionString) +
                        ' in ' + IntToStr(oExec.ExceptionProcNo) + ' at ' + IntToSTr(oExec.ExceptionPos));

                    if fbRetry then
                       oAPI_Output.WriteLog('Retrying executing ... ' + IntToStr(I) + ' of ' + IntToStr(liRetry));

                    if aTask.Criteria.Failed.Skip then
                      begin
                        Result := True;
                      end;
                    if aTask.Criteria.Failed.Abort then
                      begin
                        Result := False;

                      end;

                  end
               else
                 begin
                   FTask.BuildStatus := tBuildStatus.bsSucceeded;

                   break;
                 end;


               end;
            end;

            FTask.EndBuild := Now;

            if assigned(FTask.FinishedTask) then
                FTask.FinishedTask();

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
Var
  lsMessageLog: string;
  I: INteger;
  FTask: tTask;
begin
  oAPI_Output.WriteLog('Task Procedure Report');

  lsMessageLog := '';

  for I := 0 to fTaskRunner.Count - 1 do
    begin
      fTask := fTaskRunner.Items[i] as Ttask;

      lsMessageLog := fTask.ProcedureName;

      if fTask .BuildStatus <> TBuildStatus.bsFailed then
       begin
         if ftask.BuildStatus <> TBuildStatus.bsErrors then
            lsMessageLog := lsMessageLog + ' - Executed succeeded: '
         else
           lsMessageLog := lsMessageLog +  ' - Executed with errors: ' ;
       end
      else
      if ftask.BuildStatus = TBuildStatus.bsFailed then
        begin
          if ftask.Criteria.Failed.abort = true then
            lsMessageLog := lsMessageLog + ' - Executed failed/abort: '
          else
          if ftask.Criteria.Failed.skip = true then
            lsMessageLog := lsMessageLog + ' - Executed failed/skip: '
          else
            lsMessageLog := lsMessageLog + ' - Executed failed: ';
        end;

       lsMessageLog := lsMessageLog + oAPI_Output.FormatedNow(ftask.EndBuild);

       lsMessageLog := lsMessageLog + ' - duration: ' + FormatDateTime(cTimeformat, ftask.Duration);

      oAPI_Output.WriteLog(lsMessageLog);
    end;




  (*
  if aprojecttask.BuildStatus <> TBuildStatus.bsFailed then
    begin
      if aprojecttask.BuildStatus <> TBuildStatus.bsErrors then
        lsMessageLog := 'Build succeeded: '
      else
        lsMessageLog := 'Build with errors: ' ;
    end
  else
  if aprojecttask.BuildStatus = TBuildStatus.bsFailed then
    begin
      if aprojecttask.Criteria.Failed.abort = true then
        lsMessageLog := 'Build failed/abort: '
      else
      if aprojecttask.Criteria.Failed.skip = true then
        lsMessageLog := 'Build failed/skip: '
      else
        lsMessageLog := 'Build failed: ';
    end;

  lsMessageLog := lsMessageLog + FoAPI_Output.FormatedNow(aprojecttask.EndBuild);

  lsMessageLog := lsMessageLog + ' - duration: ' + FormatDateTime(cTimeformat, aprojecttask.Duration);

  if aIncludeItemName then
    FoAPI_Output.WriteLog(aprojecttask.TaskName + ': ' +lsMessageLog)
  else
    FoAPI_Output.WriteLog(lsMessageLog);


  *)


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

function TTask.GetDuration: TdateTime;
begin
  Result := EndBuild-StartBuild;
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

