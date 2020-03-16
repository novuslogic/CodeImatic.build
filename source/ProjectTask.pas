unit ProjectTask;

interface

Uses NovusBO;

Type
  TBuildStatus = (bsSucceeded, bsErrors, bsFailed);

  TProjectTaskFailed = class(TNovusBO)
  protected
    firetry: integer;
    fbSkip: Boolean;
    fbAbort: Boolean;
  private
  public
    property Retry: integer read firetry write firetry;

    property skip: Boolean read fbSkip write fbSkip;

    property abort: Boolean read fbAbort write fbAbort;
  end;

  TProjectTaskCriteria = class(TNovusBO)
  protected
    fFailed: TProjectTaskFailed;
  private
  public
    constructor Create; override;
    destructor Destroy; override;

    property Failed: TProjectTaskFailed read fFailed write fFailed;
  end;

  Tprojecttask = class(TNovusBO)
  protected
  private
    fdtStartBuild: tdatetime;
    fdtEndBuild: tdatetime;
    fsTaskName: String;
    fsProjectFilename: String;
    fBuildStatus: TBuildStatus;
    FdtDuration: tdatetime;
    FCriteria: TProjectTaskCriteria;
    function GetDuration: tdatetime;
  Public
    constructor Create; override;
    destructor Destroy; override;

    property ProjectFilename: String read fsProjectFilename
      write fsProjectFilename;

    property TaskName: String read fsTaskName write fsTaskName;

    property StartBuild: tdatetime read fdtStartBuild write fdtStartBuild;

    property EndBuild: tdatetime read fdtEndBuild write fdtEndBuild;

    property BuildStatus: TBuildStatus read fBuildStatus write fBuildStatus;

    property Duration: tdatetime read GetDuration;

    property Criteria: TProjectTaskCriteria read FCriteria write FCriteria;
  end;

implementation

constructor Tprojecttask.Create;
begin
  inherited Create;

  FCriteria := TProjectTaskCriteria.Create;
end;

destructor Tprojecttask.Destroy;
begin
  FCriteria.Free;

  inherited;
end;

function Tprojecttask.GetDuration: tdatetime;
begin
  Result := EndBuild - StartBuild;
end;

constructor TProjectTaskCriteria.Create;
begin
  inherited Create;

  fFailed := TProjectTaskFailed.Create;
end;

destructor TProjectTaskCriteria.Destroy;
begin
  fFailed.Free;

  inherited;
end;

end.
