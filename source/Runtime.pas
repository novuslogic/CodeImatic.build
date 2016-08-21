unit Runtime;

interface

Uses Project, API_Output, Config, NovusVersionUtils, System.SysUtils,
     uPSRuntime,  Plugins, dialogs, NovusDateStringUtils, uPSCompiler ;

type
   tRuntime = class
   protected
   private
     fImp:  TPSRuntimeClassImporter;
     foAPI_Output: tAPI_Output;
     foProject: tProject;
     foPlugins: TPlugins;
     FdtDuration: TDateTime;
     fBuildStatus: TBuildStatus;
     function GetBuildStatus(aBuildStatus: TBuildStatus): String;
   public
     function RunEnvironment: Boolean;

     procedure FinishBuild(const aprojecttask: Tprojecttask; const aIncludeItemName: boolean = false);

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


   const cTimeformat = 'hh:mm:ss.zzz';


implementation

uses ScriptEngine;

function tRuntime.RunEnvironment: Boolean;
var
  liIndex, i, x: integer;
  loprojecttask: tprojecttask;
  loScriptEngine: TScriptEngine;
begin
  Try
    foProject := tProject.Create;

    foProject.LoadProjectFile(oConfig.ProjectFileName, oConfig.ProjectConfigFileName);

    if foProject.OutputPath = '' then foProject.OutputPath := foProject.GetWorkingdirectory;

    FoAPI_Output := tAPI_Output.Create(foProject.OutputPath + oConfig.OutputFile, foProject.OutputConsole);

    FoAPI_Output.DateTimeMask := FormatSettings.ShortDateFormat + ' '+ cTimeformat;

    FoAPI_Output.OpenLog(true);

    if not FoAPI_Output.IsFileOpen then
      begin
        WriteLn(FoAPI_Output.Filename + ' log file cannot be created.');

        Exit;
      end;

    FoAPI_Output.WriteLog('Zautomatic - © Copyright Novuslogic Software 2016 All Rights Reserved');
    FoAPI_Output.WriteLog('Version: ' + TNovusVersionUtils.GetFullVersionNumber);

    FoAPI_Output.WriteLog('Project:' + foProject.ProjectFileName);
    if (foProject.oProjectConfig.ProjectConfigFileName <> '') then
      FoAPI_Output.WriteLog('Projectconfig:' + foProject.oProjectConfig.ProjectConfigFileName);

    FoAPI_Output.WriteLog('Messagelog file: ' + FoAPI_Output.Filename);

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

        FoAPI_Output.WriteLog('Project Task:' + loprojecttask.TaskName);


        if Not FileExists(loprojecttask.ProjectFileName) then
          begin
            FoAPI_Output.WriteLog('projectfilename ' + loprojecttask.ProjectFileName+ ' cannot be found.');

            Continue;
          end
       else
         begin
            FoAPI_Output.WriteLog('Project Filename:' + loprojecttask.ProjectFileName);

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

            loprojecttask.Duration := loprojecttask.EndBuild-loprojecttask.StartBuild;

            Duration := Duration +  loprojecttask.Duration;

            FinishBuild(loprojecttask);

            FoAPI_Output.projecttask := NIL;

            if Integer(loprojecttask.BuildStatus) > Integer(BuildStatus) then
               begin
                 BuildStatus := loprojecttask.BuildStatus;

                 if (loprojecttask.Criteria.abort = true) and (loprojecttask.BuildStatus = TBuildStatus.bsFailed) then
                   begin
                     Break;
                   end
                 else
                 if (loprojecttask.Criteria.skip = true) and (loprojecttask.BuildStatus = TBuildStatus.bsFailed) then
                   continue;
               end;
          end;
      end;

    // Build Time Report
    FoAPI_Output.WriteLog('Build time report');

    for I := 0 to foProject.oprojecttaskList.Count - 1 do
      begin
        loprojecttask := tprojecttask(foProject.oprojecttaskList.items[i]);
        FinishBuild(loprojecttask, true);
      end;

    FoAPI_Output.WriteLog('Total build duration: ' + FormatDateTime(cTimeformat, Duration));
    FoAPI_Output.WriteLog('Build status: ' +  GetBuildStatus(BuildStatus));

    ExitCode := Integer(BuildStatus);

    FImp.Free;

    FoAPI_Output.CloseLog;

    FoAPI_Output.Free;

    foPlugins.Free;
  Finally
    foProject.Free;
  End;
end;


procedure tRuntime.FinishBuild(const aprojecttask: Tprojecttask; const aIncludeItemName: boolean = false);
Var
  lsMessageLog: string;
begin
  lsMessageLog := '';

  if aprojecttask.EndBuild = 0 then Exit;

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
      if aprojecttask.Criteria.abort = true then
        lsMessageLog := 'Build failed/abort: '
      else
      if aprojecttask.Criteria.skip = true then
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
