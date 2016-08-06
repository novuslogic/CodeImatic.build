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

     procedure FinishBuild(const aProjectItem: TProjectItem; const aIncludeItemName: boolean = false);

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
  loProjectItem: tProjectItem;
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


  for I := 0 to foProject.oProjectItemList.Count - 1 do
    begin
      loProjectItem := tProjectItem(foProject.oProjectItemList.items[i]);

      FoMessagesLog.WriteLog('Project Item:' + loProjectItem.ItemName);


      if Not FileExists(loProjectItem.ProjectFileName) then
        begin
          FoMessagesLog.WriteLog('projectfilename ' + loProjectItem.ProjectFileName+ ' cannot be found.');

          Continue;
        end
     else
       begin
          FoMessagesLog.WriteLog('Project Filename:' + loProjectItem.ProjectFileName);

          loProjectItem.BuildStatus := TBuildStatus.bsSucceeded;
          FoMessagesLog.ProjectItem := loProjectItem;

          loProjectItem.StartBuild := Now;

          FoMessagesLog.WriteLog('Build started ' + FoMessagesLog.FormatedNow(loProjectItem.StartBuild));

          loScriptEngine := TScriptEngine.Create(FoMessagesLog, FImp, FoPlugins);

          loScriptEngine.LoadScript(loProjectItem.ProjectFileName);

          loScriptEngine.ExecuteScript(oConfig.CompileOnly);

          loProjectItem.EndBuild := Now;

          loProjectItem.Duration := loProjectItem.EndBuild-loProjectItem.StartBuild;

          if Integer(loProjectItem.BuildStatus) > Integer(BuildStatus) then
             BuildStatus := loProjectItem.BuildStatus;

          Duration := Duration +  loProjectItem.Duration;

          FinishBuild(loProjectItem);

          FoMessagesLog.ProjectItem := NIL;

          loScriptEngine.Free;
        end;
    end;

  // Build Time Report
  FoMessagesLog.WriteLog('Build time report');

  for I := 0 to foProject.oProjectItemList.Count - 1 do
    begin
      loProjectItem := tProjectItem(foProject.oProjectItemList.items[i]);
      FinishBuild(loProjectItem, true);
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


procedure tRuntime.FinishBuild(const aProjectItem: TProjectItem; const aIncludeItemName: boolean = false);
Var
  lsMessageLog: string;
begin

  if aProjectItem.BuildStatus <> TBuildStatus.bsFailed then
    begin
      if aProjectItem.BuildStatus <> TBuildStatus.bsErrors then
        lsMessageLog := 'Build succeeded: ' + FoMessagesLog.FormatedNow(aProjectItem.EndBuild)
      else
        lsMessageLog := 'Build with errors: ' + FoMessagesLog.FormatedNow(aProjectItem.EndBuild);
    end
  else
    lsMessageLog := 'Build failed: ' + FoMessagesLog.FormatedNow(aProjectItem.EndBuild);

  lsMessageLog := lsMessageLog + ' - duration: ' + FormatDateTime(cTimeformat, aProjectItem.Duration);

  if aIncludeItemName then
    FoMessagesLog.WriteLog(aProjectItem.ItemName + ': ' +lsMessageLog)
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
