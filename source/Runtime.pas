{$I CodeImatic.build.inc}
unit Runtime;

interface

Uses Project, API_Output, Config, NovusVersionUtils, System.SysUtils,
  NovusStringUtils,
  uPSRuntime, Plugins, NovusDateStringUtils, uPSCompiler, Solution;

type
  tRuntime = class
  protected
  private
    foSolution: tSolution;
    fImp: TPSRuntimeClassImporter;
    foAPI_Output: tAPI_Output;
    foProject: tProject;
    foPlugins: TPlugins;
    FdtDuration: TDateTime;
    fBuildStatus: TBuildStatus;
    function GetBuildStatus(aBuildStatus: TBuildStatus): String;
  public
    function RunEnvironment: Integer;

    procedure BuildTasksReport(const aprojecttask: Tprojecttask;
      const aIncludeItemName: boolean = false);

    property oAPI_Output: tAPI_Output read foAPI_Output write foAPI_Output;

    property oPlugins: TPlugins read foPlugins write foPlugins;

    property oProject: tProject read foProject write foProject;

    property Duration: TDateTime read FdtDuration write FdtDuration;

    property BuildStatus: TBuildStatus read fBuildStatus write fBuildStatus;
  end;

Var
  oRuntime: tRuntime;

implementation

uses ScriptEngine;

function tRuntime.RunEnvironment: Integer;
var
  liIndex, i, x: Integer;
  loprojecttask: Tprojecttask;
  loScriptEngine: TScriptEngine;
begin
  Try
    Result := -1;

    foSolution := tSolution.Create;

    if Trim(oConfig.SolutionFilename) <> '' then
    begin
      if foSolution.LoadSolutionFile(oConfig.SolutionFilename) then
      begin
        oConfig.ProjectFileName := foSolution.ProjectFileName;
        oConfig.ProjectConfigFileName := foSolution.ProjectConfigFileName;
      end
      else
      begin
        if Not FileExists(oConfig.SolutionFilename) then
        begin
          writeln('Solution Filename missing: ' + oConfig.SolutionFilename);

          Exit;
        end;

        writeln('Loading errror Solution Filename: ' +
          oConfig.SolutionFilename);

        Exit;
      end;
    end;

    foProject := tProject.Create;

    if not foProject.LoadProjectFile(oConfig.ProjectFileName,
      oConfig.ProjectConfigFileName, foSolution.Workingdirectory) then
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

    foAPI_Output.OpenLog(true);

    if not foAPI_Output.IsFileOpen then
    begin
      writeln(foAPI_Output.Filename + ' log file cannot be created.');

      Exit;
    end;

    foAPI_Output.WriteLog
      ('CodeImatic.build - © Copyright Novuslogic Software 2018 All Rights Reserved');
    foAPI_Output.WriteLog('Version: ' +
      TNovusVersionUtils.GetFullVersionNumber);

    foAPI_Output.WriteLog('Project: ' + foProject.ProjectFileName);

    if Not FileExists(foProject.ProjectFileName) then
    begin
      writeln('Internal error: ' + foProject.ProjectFileName +
        ' project filename cannot be found.');

      Exit;
    end;

    if (foProject.oProjectConfig.ProjectConfigFileName <> '') then
      foAPI_Output.WriteLog('Project Config: ' +
        foProject.oProjectConfig.ProjectConfigFileName);

    if Not FileExists(foProject.oProjectConfig.ProjectConfigFileName) then
    begin
      writeln('Internal error: ' + foProject.oProjectConfig.
        ProjectConfigFileName + ' projectconfig filename cannot be found.');

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
          loScriptEngine := TScriptEngine.Create(foAPI_Output, fImp, foPlugins);

          loScriptEngine.LoadScript(loprojecttask.ProjectFileName);

          loScriptEngine.ExecuteScript(loprojecttask, oConfig.CompileOnly);
        Finally
          loScriptEngine.Free;
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

    foAPI_Output.CloseLog;

    foAPI_Output.Free;

    foPlugins.Free;
  Finally
    foProject.Free;
    foSolution.Free;
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
