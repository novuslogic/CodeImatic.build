unit API_Output;

interface

Uses NovusLog, uPSRuntime, uPSUtils,  Classes, NovusVariants, ProjectTask;

type
  TAPI_Output = class(TNovusLogFile)
  private
  protected
    fprojecttask: Tprojecttask;
    fLastExError: TPSError;
    fsLastExParam: tbtstring;
  public
    constructor Create(AFilename: String; aOutputConsole: Boolean); virtual;

    procedure Log(const aMsg: string);
    procedure LogFormat(const aFormat: string; const Args: array of variant);
    procedure LogError;

    procedure LogAppendFilename(const AFilename: String);

    procedure InternalError;

    property projecttask: Tprojecttask read fprojecttask write fprojecttask;

    property LastExError: TPSError read fLastExError write fLastExError;

    property LastExParam: tbtstring read fsLastExParam write fsLastExParam;

  end;

implementation

Uses SysUtils, ExtraClasses;

constructor TAPI_Output.Create(AFilename: String; aOutputConsole: Boolean);
begin
  OutputConsole := aOutputConsole;

  inherited Create(AFilename);
end;

procedure TAPI_Output.Log(const aMsg: string);
begin
  WriteLog(aMsg);
end;

procedure TAPI_Output.LogFormat(const aFormat: string;
  const Args: array of variant);
begin
  WriteLog(InternalFormat(aFormat, Args));
end;

procedure TAPI_Output.LogError;
begin
  WriteLog(fsLastExParam);
  if fLastExError = TPSError.erCustomError then
    fprojecttask.BuildStatus := TBuildStatus.bsErrors
  else
    fprojecttask.BuildStatus := TBuildStatus.bsFailed;
end;

procedure TAPI_Output.InternalError;
begin
  Log(WriteExceptLog);
  fprojecttask.BuildStatus := TBuildStatus.bsFailed;
end;

procedure TAPI_Output.LogAppendFilename(const aFilename: String);
var
  FTmpStringList: tStringList;
begin
  if Not FileExists(AFilename) then
  begin
    LogFormat('Append Filename cannot be found [%s] add to log.', [AFilename]);

    if fLastExError = TPSError.erCustomError then
      fprojecttask.BuildStatus := TBuildStatus.bsErrors
    else
      fprojecttask.BuildStatus := TBuildStatus.bsFailed;

    Exit;
  end;

  Try
    Try
      FTmpStringList:= tStringList.Create;

      FTmpStringList.LoadFromFile(aFilename);

      Log(FTmpStringList.Text);

    Finally
      FTmpStringList.Free;
    End;
  Except
    InternalError;
  End;
end;

end.
