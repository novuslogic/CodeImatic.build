{$I Zautomatic.inc}
unit Runtime;

interface

Uses Project, API_Output, Config, NovusVersionUtils, System.SysUtils, NovusStringUtils,
     uPSRuntime,  Plugins, dialogs, NovusDateStringUtils, uPSCompiler, Solution;

type
   tRuntime = class
   protected
   private
     foSolution: tSolution;
     fImp:  TPSRuntimeClassImporter;
     foAPI_Output: tAPI_Output;
     foProject: tProject;
     foPlugins: TPlugins;
     FdtDuration: TDateTime;
     fBuildStatus: TBuildStatus;
     function GetBuildStatus(aBuildStatus: TBuildStatus): String;
   public
     function RunEnvironment: Integer;

     procedure BuildTasksReport(const aprojecttask: Tprojecttask; const aIncludeItemName: boolean = false);

     property oAPI_Output: tAPI_Output
       read foAPI_Output
       write foAPI_Output;

     property oPlugins: TPlugins
       read foPlugins
       write foPlugins;

     property oProject: tProject
       read foProject
       write foProject;

     property Duration: TDateTime
      read FdtDuration
      write FdtDuration;

     property BuildStatus: TBuildStatus
       read fBuildStatus
       write fBuildStatus;
   end;

Var
  oRuntime: tRuntime;


implementation

uses ScriptEngine;

function tRuntime.RunEnvironment: Integer;
var
  liIndex, i, x: integer;
  loprojecttask: tprojecttask;
  loScriptEngine: TScriptEngine;
begin
  Try
    Result := 0;

    foSolution:= tSolution.Create;

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
                  writeln ('Solution Filename missing: ' +  oConfig.SolutionFilename);

                  Exit;
                end;

              writeln ('Loading errror Solution Filename: ' +  oConfig.SolutionFilename);

              Exit;
            end;
       end;

    foProject := tProject.Create;

    if not foProject.LoadProjectFile(oConfig.ProjectFileName, oConfig.ProjectConfigFileName, foSolution.Workingdirectory) then
      begin
        if Not FileExists(oConfig.ProjectFileName) then
          begin
            writeln ('Project Filename missing: ' +  oConfig.ProjectFileName);

            foProject.Free;

            Exit;
          end;

        writeln ('Loading errror Project Filename: ' +  oConfig.ProjectFileName);

        foProject.Free;

        Exit;
      end;

    if foProject.OutputPath = '' then foProject.OutputPath := foProject.GetWorkingdirectory;

    FoAPI_Output := tAPI_Output.Create(foProject.OutputPath + oConfig.OutputFile, foProject.OutputConsole);

    FoAPI_Output.DateTimeMask := FormatSettings.ShortDateFormat + ' '+ cTimeformat;

    FoAPI_Output.OpenLog(true);

    if not FoAPI_Output.IsFileOpen then
      begin
        WriteLn(FoAPI_Output.Filename + ' log file cannot be created.');

        Exit;
      end;

    FoAPI_Output.WriteLog('Zautomatic - © Copyright Novuslogic Software 2017 All Rights Reserved');
    FoAPI_Output.WriteLog('Version: ' + TNovusVersionUtils.GetFullVersionNumber);

    FoAPI_Output.WriteLog('Project: ' + foProject.ProjectFileName);

    if Not FileExists(foProject.ProjectFileName) then
      begin
        writeln ('Internal error: ' + foProject.ProjectFileName + ' project filename cannot be found.');

        Exit;
      end;


    if (foProject.oProjectConfig.ProjectConfigFileName <> '') then
      FoAPI_Output.WriteLog('Project Config: ' + foProject.oProjectConfig.ProjectConfigFileName);

     if Not FileExists(foProject.oProjectConfig.ProjectConfigFileName) then
       begin
         writeln ('Internal error: ' + foProject.oProjectConfig.ProjectConfigFileName + ' projectconfig filename cannot be found.');

         Exit;
       end;

    FoAPI_Output.WriteLog('Output log file: ' + FoAPI_Output.Filename);

    if oConfig.CompileOnly then
      FoAPI_Output.WriteLog('Option:Compile Only.')
    else
      FoAPI_Output.WriteLog('Option:Compile and Execute.');
    FImp := TPSRuntimeClassImporter.Create;
    foPlugins := TPlugins.Create(FoAPI_Output, FImp);

    foPlugins.LoadPlugins;

    foPlugins.RegisterImports;

    Duration := 0;
    BuildStatus := TBuildStatus.bsSucceeded;

    for I := 0 to foProject.oprojecttaskList.Count - 1 do
      begin
        loprojecttask := tprojecttask(foProject.oprojecttaskList.items[i]);

        FoAPI_Output.WriteLog('Project Task: ' + loprojecttask.TaskName);

        if Trim(TNovusStringUtils.JustFilename(loprojecttask.ProjectFileName)) = trim(loprojecttask.ProjectFileName) then
            loprojecttask.ProjectFileName := foproject.Getworkingdirectory + loprojecttask.ProjectFileName;

        if not FileExists(loprojecttask.ProjectFileName) then
          begin
            FoAPI_Output.WriteLog('Filename:  ' + loprojecttask.ProjectFileName+ ' cannot be found.');
            loprojecttask.BuildStatus := TBuildStatus.bsFailed;
            BuildStatus := loprojecttask.BuildStatus;

            if loprojecttask.Criteria.Failed.skip then
               Continue
            else
            if loprojecttask.Criteria.Failed.abort then
              break;

          end
       else
         begin
            FoAPI_Output.WriteLog('Filename: ' + loprojecttask.ProjectFileName);

            loprojecttask.BuildStatus := TBuildStatus.bsSucceeded;
            FoAPI_Output.projecttask := loprojecttask;

            loprojecttask.StartBuild := Now;

            FoAPI_Output.WriteLog('Build started ' + FoAPI_Output.FormatedNow(loprojecttask.StartBuild));


            Try
              loScriptEngine := TScriptEngine.Create(FoAPI_Output, FImp, FoPlugins);

              loScriptEngine.LoadScript(loprojecttask.ProjectFileName);

              loScriptEngine.ExecuteScript(loprojecttask, oConfig.CompileOnly);
            Finally
              loScriptEngine.Free;
            End;

            loprojecttask.EndBuild := Now;

            Duration := Duration +  loprojecttask.Duration;

            BuildTasksReport(loprojecttask);

            FoAPI_Output.projecttask := NIL;

            if Integer(loprojecttask.BuildStatus) > Integer(BuildStatus) then
               begin
                 BuildStatus := loprojecttask.BuildStatus;

                 if (loprojecttask.Criteria.Failed.abort = true) and (loprojecttask.BuildStatus = TBuildStatus.bsFailed) then
                   begin
                     Break;
                   end
                 else
                 if (loprojecttask.Criteria.Failed.skip = true) and (loprojecttask.BuildStatus = TBuildStatus.bsFailed) then
                   continue;
               end;
          end;
      end;

    // Build Tasks Report
    FoAPI_Output.WriteLog('Build Tasks Report');

    for I := 0 to foProject.oprojecttaskList.Count - 1 do
      begin
        loprojecttask := tprojecttask(foProject.oprojecttaskList.items[i]);
        BuildTasksReport(loprojecttask, true);
      end;

    FoAPI_Output.WriteLog('Total build duration: ' + FormatDateTime(cTimeformat, Duration));
    FoAPI_Output.WriteLog('Build status: ' +  GetBuildStatus(BuildStatus));

    ExitCode := Integer(BuildStatus);

    FImp.Free;

    foPlugins.UnLoadPlugins;

    FoAPI_Output.CloseLog;

    FoAPI_Output.Free;

    foPlugins.Free;
  Finally
    foProject.Free;
    foSolution.Free;
  End;
end;


procedure tRuntime.BuildTasksReport(const aprojecttask: Tprojecttask; const aIncludeItemName: boolean = false);
Var
  lsMessageLog: string;
begin
  lsMessageLog := '';

  //if aprojecttask.EndBuild = 0 then Exit;

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

end;

function tRuntime.GetBuildStatus(aBuildStatus: TBuildStatus): String;
begin
  Result := '';

  case Integer(aBuildStatus) of
    0: Result := 'Succeeded';
    1: Result := 'Errors';
    2: Result := 'Failed';
    3: result := 'None';
  end;
end;

Initialization
  oRuntime := tRuntime.Create;

finalization
  oRuntime.Free;

end.
