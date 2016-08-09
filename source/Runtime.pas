unit Runtime;

interface

Uses Project, MessagesLog, Config, NovusVersionUtils, System.SysUtils,
     uPSRuntime,  Plugins, dialogs, NovusDateStringUtils, uPSCompiler ;

type
   tRuntime = class
   protected
   private
     fImp:  TPSRuntimeClassImporter;
     foMessagesLog: tMessagesLog;
     foProject: tProject;
     foPlugins: TPlugins;
     FdtDuration: TDateTime;
     fBuildStatus: TBuildStatus;
     function GetBuildStatus(aBuildStatus: TBuildStatus): String;
   public
     function RunEnvironment: Boolean;

     procedure FinishBuild(const aprojecttask: Tprojecttask; const aIncludeItemName: boolean = false);

     property oMessagesLog: tMessagesLog
       read foMessagesLog
       write foMessagesLog;

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
  foProject := tProject.Create;

  foProject.LoadProjectFile(oConfig.ProjectFileName, oConfig.ProjectConfigFileName);

  if foProject.MessageslogPath = '' then foProject.MessageslogPath := foProject.GetWorkingdirectory;

  FoMessagesLog := tMessagesLog.Create(foProject.MessageslogPath + oConfig.MessageslogFile, foProject.OutputConsole);

  FoMessagesLog.DateTimeMask := FormatSettings.ShortDateFormat + ' '+ cTimeformat;

  FoMessagesLog.OpenLog(true);

  if not FoMessagesLog.IsFileOpen then
    begin
      foProject.Free;

      WriteLn(FoMessagesLog.Filename + ' log file cannot be created.');

      Exit;
    end;

  FoMessagesLog.WriteLog('Zautomatic - © Copyright Novuslogic Software 2016 All Rights Reserved');
  FoMessagesLog.WriteLog('Version: ' + TNovusVersionUtils.GetFullVersionNumber);

  FoMessagesLog.WriteLog('Project:' + foProject.ProjectFileName);
  if (foProject.oProjectConfig.ProjectConfigFileName <> '') then
    FoMessagesLog.WriteLog('Projectconfig:' + foProject.oProjectConfig.ProjectConfigFileName);

  FoMessagesLog.WriteLog('Messagelog file: ' + FoMessagesLog.Filename);

  if oConfig.CompileOnly then
    FoMessagesLog.WriteLog('Option:Compile Only.')
  else
    FoMessagesLog.WriteLog('Option:Compile and Execute.');
  FImp := TPSRuntimeClassImporter.Create;
  foPlugins := TPlugins.Create(FoMessagesLog, FImp);

  foPlugins.LoadPlugins;

  foPlugins.RegisterImports;

  Duration := 0;
  BuildStatus := TBuildStatus.bsSucceeded;


  for I := 0 to foProject.oprojecttaskList.Count - 1 do
    begin
      loprojecttask := tprojecttask(foProject.oprojecttaskList.items[i]);

      FoMessagesLog.WriteLog('Project Task:' + loprojecttask.TaskName);


      if Not FileExists(loprojecttask.ProjectFileName) then
        begin
          FoMessagesLog.WriteLog('projectfilename ' + loprojecttask.ProjectFileName+ ' cannot be found.');

          Continue;
        end
     else
       begin
          FoMessagesLog.WriteLog('Project Filename:' + loprojecttask.ProjectFileName);

          loprojecttask.BuildStatus := TBuildStatus.bsSucceeded;
          FoMessagesLog.projecttask := loprojecttask;

          loprojecttask.StartBuild := Now;

          FoMessagesLog.WriteLog('Build started ' + FoMessagesLog.FormatedNow(loprojecttask.StartBuild));

          loScriptEngine := TScriptEngine.Create(FoMessagesLog, FImp, FoPlugins);

          loScriptEngine.LoadScript(loprojecttask.ProjectFileName);

          loScriptEngine.ExecuteScript(loprojecttask, oConfig.CompileOnly);

           if Integer(loprojecttask.BuildStatus) > Integer(BuildStatus) then
             BuildStatus := loprojecttask.BuildStatus;

          loprojecttask.EndBuild := Now;

          loprojecttask.Duration := loprojecttask.EndBuild-loprojecttask.StartBuild;



          Duration := Duration +  loprojecttask.Duration;

          FinishBuild(loprojecttask);

          FoMessagesLog.projecttask := NIL;

          loScriptEngine.Free;
        end;
    end;

  // Build Time Report
  FoMessagesLog.WriteLog('Build time report');

  for I := 0 to foProject.oprojecttaskList.Count - 1 do
    begin
      loprojecttask := tprojecttask(foProject.oprojecttaskList.items[i]);
      FinishBuild(loprojecttask, true);
    end;

  FoMessagesLog.WriteLog('Total build duration: ' + FormatDateTime(cTimeformat, Duration));
  FoMessagesLog.WriteLog('Build status: ' +  GetBuildStatus(BuildStatus));

  if BuildStatus <> TBuildStatus.bsSucceeded then
    ExitCode := Integer(BuildStatus);


  FImp.Free;

  FoMessagesLog.CloseLog;

  FoMessagesLog.Free;

  foPlugins.Free;

  foProject.Free;
end;


procedure tRuntime.FinishBuild(const aprojecttask: Tprojecttask; const aIncludeItemName: boolean = false);
Var
  lsMessageLog: string;
begin

  if aprojecttask.BuildStatus <> TBuildStatus.bsFailed then
    begin
      if aprojecttask.BuildStatus <> TBuildStatus.bsErrors then
        lsMessageLog := 'Build succeeded: ' + FoMessagesLog.FormatedNow(aprojecttask.EndBuild)
      else
        lsMessageLog := 'Build with errors: ' + FoMessagesLog.FormatedNow(aprojecttask.EndBuild);
    end
  else
    lsMessageLog := 'Build failed: ' + FoMessagesLog.FormatedNow(aprojecttask.EndBuild);

  lsMessageLog := lsMessageLog + ' - duration: ' + FormatDateTime(cTimeformat, aprojecttask.Duration);

  if aIncludeItemName then
    FoMessagesLog.WriteLog(aprojecttask.TaskName + ': ' +lsMessageLog)
  else
    FoMessagesLog.WriteLog(lsMessageLog);

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
