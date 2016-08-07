unit MessagesLog;

interface

Uses NovusLog, uPSRuntime, uPSUtils, Project;

type
  TMessagesLog = class(TNovusLogFile)
  private
  protected
    fprojecttask: Tprojecttask;
    fLastExError: TPSError;
    fsLastExParam: tbtstring;
 //   fbFailed: Boolean;
 //   fbErrors: Boolean;
  public
    constructor Create(AFilename: String;aOutputConsole: Boolean);  virtual;

    procedure Log(AMsg: string);
    procedure LogError;

    procedure InternalError;

    property projecttask: Tprojecttask
      read fprojecttask
      write fprojecttask;

    property LastExError: TPSError
      read fLastExError
      write fLastExError;

    property LastExParam: tbtstring
      read fsLastExParam
      write fsLastExParam;

    end;

implementation

constructor TMessagesLog.Create(AFilename: String;aOutputConsole: Boolean);
begin
  OutputConsole := aOutputConsole;

  //Failed := False;
  //Errors := False;

  inherited Create(AFilename);
end;

procedure TMessagesLog.Log(AMsg: string);
begin
  WriteLog(AMsg);
end;

procedure TMessagesLog.LogError;
begin
  WriteLog(fsLastExParam);
  if fLastExError = TPSError.erCustomError then
     fprojecttask.BuildStatus := TBuildStatus.bsErrors
  else
    fprojecttask.BuildStatus := TBuildStatus.bsFailed;
end;


procedure TMessagesLog.InternalError;
begin
   Log(WriteExceptLog);
   fprojecttask.BuildStatus := TBuildStatus.bsFailed;
end;


end.



