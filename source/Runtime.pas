unit Runtime;

interface

Uses Project, MessagesLog, Config, NovusVersionUtils, System.SysUtils,
     uPSRuntime,  Plugins ;

type
   tRuntime = class
   protected
   private
     fImp:  TPSRuntimeClassImporter;
     foMessagesLog: tMessagesLog;
     foProject: tProject;
     foPlugins: TPlugins;
   public
     function RunEnvironment: Boolean;

     property oMessagesLog: tMessagesLog
       read foMessagesLog
       write foMessagesLog;

     property oPlugins: TPlugins
       read foPlugins
       write foPlugins;

     property oProject: tProject
       read foProject
       write foProject;
   end;

   Var
     oRuntime: tRuntime;



implementation

uses ScriptEngine;

function tRuntime.RunEnvironment: Boolean;
var
  liIndex, i, x: integer;
  bOK: Boolean;
  loProjectItem: tProjectItem;
  loScriptEngine: TScriptEngine;
begin
  foProject := tProject.Create;

  foProject.LoadProjectFile(oConfig.ProjectFileName, oConfig.ProjectConfigFileName);

  FoMessagesLog := tMessagesLog.Create(foProject.MessageslogPath + oConfig.MessageslogFile, foProject.OutputConsole);

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

  FImp := TPSRuntimeClassImporter.Create;
  foPlugins := TPlugins.Create(FoMessagesLog, FImp);

  foPlugins.LoadPlugins;

  foPlugins.RegisterImports;

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

          FoMessagesLog.WriteLog('Build started ' + FoMessagesLog.FormatedNow);

          loScriptEngine := TScriptEngine.Create(FoMessagesLog, FImp, FoPlugins);

          loScriptEngine.LoadScript(loProjectItem.ProjectFileName);

          loScriptEngine.ExecuteScript;

          if Not FoMessagesLog.Failed then
            begin
              if Not FoMessagesLog.Errors then
                FoMessagesLog.WriteLog('Build succeeded ' + FoMessagesLog.FormatedNow)
              else
                FoMessagesLog.WriteLog('Build with errors ' + FoMessagesLog.FormatedNow);
            end
          else
            FoMessagesLog.WriteLog('Build failed ' + FoMessagesLog.FormatedNow);

          loScriptEngine.Free;
        end;
    end;

  FImp.Free;

  FoMessagesLog.CloseLog;

  FoMessagesLog.Free;

  foPlugins.Free;

  foProject.Free;
end;

Initialization
  oRuntime := tRuntime.Create;

finalization
  oRuntime.Free;

end.
