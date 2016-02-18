unit MessagesLog;

interface

Uses NovusLog, uPSRuntime, uPSUtils;

type
  TMessagesLog = class(TNovusLogFile)
  private
  protected
    fLastExError: TPSError;
    fsLastExParam: tbtstring;
    fbFailed: Boolean;
    fbErrors: Boolean;
  public
    constructor Create(AFilename: String;aOutputConsole: Boolean);  virtual;

    procedure Log(AMsg: string);
    procedure LogError;

    procedure InternalError;

    property LastExError: TPSError
      read fLastExError
      write fLastExError;

    property LastExParam: tbtstring
      read fsLastExParam
      write fsLastExParam;

    property Failed: Boolean
      read fbFailed
      write fbFailed;

    property Errors: Boolean
      read fbErrors
      write fbErrors;
  end;

implementation

constructor TMessagesLog.Create(AFilename: String;aOutputConsole: Boolean);
begin
  OutputConsole := aOutputConsole;

  Failed := False;
  Errors := False;

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
    Errors := true
  else
    Failed := True;
end;


procedure TMessagesLog.InternalError;
begin
   Log(WriteExceptLog);
   Failed := False;
end;


end.



