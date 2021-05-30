{$I CodeImatic.build.inc}
unit Runtime;

interface

Uses Project, API_Output, Config, NovusVersionUtils, System.SysUtils,
  NovusStringUtils,   NovusFileUtils, vcl.dialogs, ProjectTask,
  uPSRuntime, Plugins, NovusDateStringUtils, uPSCompiler;

type
  tRuntime = class
  protected
  private
    fsWorkingdirectory: string;
    fImp: TPSRuntimeClassImporter;
    foAPI_Output: tAPI_Output;
    foProject: tProject;
    foPlugins: TPlugins;
    FdtDuration: TDateTime;
    fBuildStatus: TBuildStatus;
    function GetBuildStatus(aBuildStatus: TBuildStatus): String;

  public
    function RunEnvironment: Integer;

    function GetVersionCopyright: string;
    function GetVersion: string;

    procedure BuildTasksReport(const aprojecttask: Tprojecttask;
      const aIncludeItemName: boolean = false);

    property oAPI_Output: tAPI_Output read foAPI_Output write foAPI_Output;

    property oPlugins: TPlugins read foPlugins write foPlugins;

    property oProject: tProject read foProject write foProject;

    property Duration: TDateTime read FdtDuration write FdtDuration;

    property BuildStatus: TBuildStatus read fBuildStatus write fBuildStatus;

    property Workingdirectory: string read fsWorkingdirectory write fsWorkingdirectory;

  end;

Var
  oRuntime: tRuntime;

implementation

uses PascalScript;

function tRuntime.GetVersionCopyright: string;
begin
  Result := 'CodeImatic.build - © Copyright Novuslogic Software 2020 All Rights Reserved';
end;

function tRuntime.GetVersion: string;
begin
  Result := 'Version: ' +
      TNovusVersionUtils.GetFullVersionNumber;
end;


function tRuntime.RunEnvironment: Integer;
var
  liIndex, i, x: Integer;
  loprojecttask: Tprojecttask;
  loPascalScript: TPascalScript;
begin
  Try
    Result := -1;

    fsworkingdirectory := TNovusFileUtils.TrailingBackSlash
      (ExtractFilePath(oConfig.ProjectFileName));
    if Trim(fsworkingdirectory) = '' then
      fsworkingdirectory := TNovusFileUtils.TrailingBackSlash
        (TNovusFileUtils.AbsoluteFilePath(oConfig.ProjectFileName));

    foProject := tProject.Create;

    if not foProject.LoadProjectFile(oConfig.ProjectFileName,
       fsWorkingdirectory) then
    begin
      if Not FileExists(oConfig.ProjectFileName) then
      begin
        writeln('Project Filename missing: ' + oConfig.ProjectFileName);

        foProject.Free;

        Exit;
      end;

      writeln('Loading errror Project Filename: ' + oConfig.ProjectFileName);

      foProject.Free;

      Exit;
    end;

    if foProject.OutputPath = '' then
      foProject.OutputPath := foProject.GetWorkingdirectory;

    foAPI_Output := tAPI_Output.Create(foProject.OutputPath +
      oConfig.OutputFile, foProject.OutputConsole);

    foAPI_Output.DateTimeMask := FormatSettings.ShortDateFormat + ' ' +
      cTimeformat;


    if not foAPI_Output.OpenLog then
    begin
      writeln(foAPI_Output.Filename + ' log file cannot be created.');

      foProject.Free;

      Exit;
    end;

    foAPI_Output.WriteLog('Logging started');

    foAPI_Output.WriteLog
      (GetVersionCopyright);

    foAPI_Output.WriteLog('Project: ' + foProject.ProjectFileName);

    if Not FileExists(foProject.ProjectFileName) then
    begin
      writeln('Project : ' + foProject.ProjectFileName +
        ' project filename cannot be found.');

      foProject.Free;

      Exit;
    end;


    foAPI_Output.WriteLog('Output log file: ' + foAPI_Output.Filename);

    if oConfig.CompileOnly then
      foAPI_Output.WriteLog('Option:Compile Only.')
    else
      foAPI_Output.WriteLog('Option:Compile and Execute.');
    fImp := TPSRuntimeClassImporter.Create;
    foPlugins := TPlugins.Create(foAPI_Output, fImp);

    foPlugins.LoadPlugins;

    foPlugins.RegisterImports;

    Duration := 0;
    BuildStatus := TBuildStatus.bsSucceeded;

    for i := 0 to foProject.oprojecttaskList.Count - 1 do
    begin
      loprojecttask := Tprojecttask(foProject.oprojecttaskList.items[i]);

      foAPI_Output.WriteLog('Project Task: ' + loprojecttask.TaskName);

      if Trim(TNovusStringUtils.JustFilename(loprojecttask.ProjectFileName))
        = Trim(loprojecttask.ProjectFileName) then
        loprojecttask.ProjectFileName := foProject.GetWorkingdirectory +
          loprojecttask.ProjectFileName;

      if not FileExists(loprojecttask.ProjectFileName) then
      begin
        foAPI_Output.WriteLog('Filename:  ' + loprojecttask.ProjectFileName +
          ' cannot be found.');
        loprojecttask.BuildStatus := TBuildStatus.bsFailed;
        BuildStatus := loprojecttask.BuildStatus;

        if loprojecttask.Criteria.Failed.skip then
          Continue
        else if loprojecttask.Criteria.Failed.abort then
          break;

      end
      else
      begin
        foAPI_Output.WriteLog('Filename: ' + loprojecttask.ProjectFileName);

        loprojecttask.BuildStatus := TBuildStatus.bsSucceeded;
        foAPI_Output.projecttask := loprojecttask;

        loprojecttask.StartBuild := Now;

        foAPI_Output.WriteLog('Build started ' + foAPI_Output.FormatedNow
          (loprojecttask.StartBuild));

        Try
          loPascalScript := TPascalScript.Create(foAPI_Output, fImp, foPlugins);

          loPascalScript.LoadScript(loprojecttask.ProjectFileName);

          loPascalScript.ExecuteScript(loprojecttask, oConfig.CompileOnly);
        Finally
          loPascalScript.Free;
        End;

        loprojecttask.EndBuild := Now;

        Duration := Duration + loprojecttask.Duration;

        BuildTasksReport(loprojecttask);

        foAPI_Output.projecttask := NIL;

        if Integer(loprojecttask.BuildStatus) > Integer(BuildStatus) then
        begin
          BuildStatus := loprojecttask.BuildStatus;

          if (loprojecttask.Criteria.Failed.abort = true) and
            (loprojecttask.BuildStatus = TBuildStatus.bsFailed) then
          begin
            break;
          end
          else if (loprojecttask.Criteria.Failed.skip = true) and
            (loprojecttask.BuildStatus = TBuildStatus.bsFailed) then
            Continue;
        end;
      end;
    end;

    // Build Tasks Report
    foAPI_Output.WriteLog('Build Tasks Report');


    for i := 0 to foProject.oprojecttaskList.Count - 1 do
    begin
      loprojecttask := Tprojecttask(foProject.oprojecttaskList.items[i]);

      BuildTasksReport(loprojecttask, true);

    end;

    foAPI_Output.WriteLog('Total build duration: ' + FormatDateTime(cTimeformat,
      Duration));

    foAPI_Output.WriteLog('Build status: ' + GetBuildStatus(BuildStatus));


    Result := Integer(BuildStatus);

    fImp.Free;

    foPlugins.UnLoadPlugins;

    foAPI_Output.WriteLog('Logging finished');
    foAPI_Output.CloseLog;

    foAPI_Output.Free;

    foPlugins.Free;

  Finally
    foProject.Free;

  End;
end;

procedure tRuntime.BuildTasksReport(const aprojecttask: Tprojecttask;
  const aIncludeItemName: boolean = false);
Var
  lsMessageLog: string;
begin
  lsMessageLog := '';

  // if aprojecttask.EndBuild = 0 then Exit;

  if aprojecttask.BuildStatus <> TBuildStatus.bsFailed then
  begin
    if aprojecttask.BuildStatus <> TBuildStatus.bsErrors then
      lsMessageLog := 'Build succeeded: '
    else
      lsMessageLog := 'Build with errors: ';
  end
  else if aprojecttask.BuildStatus = TBuildStatus.bsFailed then
  begin
    if aprojecttask.Criteria.Failed.abort = true then
      lsMessageLog := 'Build failed/abort: '
    else if aprojecttask.Criteria.Failed.skip = true then
      lsMessageLog := 'Build failed/skip: '
    else
      lsMessageLog := 'Build failed: ';
  end;

  lsMessageLog := lsMessageLog + foAPI_Output.FormatedNow
    (aprojecttask.EndBuild);

  lsMessageLog := lsMessageLog + ' - duration: ' + FormatDateTime(cTimeformat,
    aprojecttask.Duration);

  if aIncludeItemName then
    foAPI_Output.WriteLog(aprojecttask.TaskName + ': ' + lsMessageLog)
  else
    foAPI_Output.WriteLog(lsMessageLog);

end;

function tRuntime.GetBuildStatus(aBuildStatus: TBuildStatus): String;
begin
  Result := '';

  case Integer(aBuildStatus) of
    0:
      Result := 'Succeeded';
    1:
      Result := 'Errors';
    2:
      Result := 'Failed';
    3:
      Result := 'None';
  end;
end;

Initialization

oRuntime := tRuntime.Create;

finalization

oRuntime.Free;

end.
