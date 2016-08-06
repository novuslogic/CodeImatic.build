unit MessagesLog;

interface

Uses NovusLog, uPSRuntime, uPSUtils, Project;

type
  TMessagesLog = class(TNovusLogFile)
  private
  protected
    fProjectItem: TProjectItem;
    fLastExError: TPSError;
    fsLastExParam: tbtstring;
 //   fbFailed: Boolean;
 //   fbErrors: Boolean;
  public
    constructor Create(AFilename: String;aOutputConsole: Boolean);  virtual;

    procedure Log(AMsg: string);
    procedure LogError;

    procedure InternalError;

    property ProjectItem: TProjectItem
      read fProjectItem
      write fProjectItem;

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
     fProjectItem.BuildStatus := TBuildStatus.bsErrors
  else
    fProjectItem.BuildStatus := TBuildStatus.bsFailed;
end;


procedure TMessagesLog.InternalError;
begin
   Log(WriteExceptLog);
   fProjectItem.BuildStatus := TBuildStatus.bsFailed;
end;


end.



