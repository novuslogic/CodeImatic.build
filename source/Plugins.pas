{$I Zautomatic.inc}
unit Plugins;

interface

uses  MessagesLog, uPSRuntime, uPSI_MessagesLog, uPSCompiler, PluginsMapFactory, Plugin,
      Classes, SysUtils, NovusPlugin;

type
   TPlugins = class
   private
   protected
     FExternalPlugins: TNovusPlugins;
     fPluginsList: TList;
     foMessagesLog: tMessagesLog;
     fImp: TPSRuntimeClassImporter;
   public
     constructor Create(aMessagesLog: tMessagesLog; aImp: TPSRuntimeClassImporter);
     destructor Destroy; override;

     procedure LoadPlugins;
     procedure UnloadPlugins;

     function CustomOnUses(aCompiler: TPSPascalCompiler): Boolean;
     procedure RegisterFunctions(aExec: TPSExec);
     procedure SetVariantToClasses(aExec: TPSExec);
     procedure RegisterImports;
   end;

implementation

Uses Runtime;

constructor TPlugins.create;
begin
  foMessagesLog:= aMessagesLog;

  FExternalPlugins := TNovusPlugins.Create;

  fPluginsList := TList.Create;

  fImp:= aImp;
end;

destructor TPlugins.destroy;
begin
  Inherited;

  UnloadPlugins;

  FExternalPlugins.Free;

  fPluginsList.Free;
end;

procedure TPlugins.UnloadPlugins;
Var
  I: Integer;
  loPlugin: tPlugin;
begin
  for I := 0 to fPluginsList.Count -1 do
   begin
     loPlugin := TPlugin(fPluginsList.Items[i]);
     loPlugin.Free;
     loPlugin := nil;
   end;

  fPluginsList.Clear;

  FExternalPlugins.UnloadAllPlugins;
end;

procedure TPlugins.LoadPlugins;
Var
  I: Integer;
  FPlugin: tPlugin;
  FExternalPlugin: IExternalPlugin;
begin
  // Internal Plugin Class

  I := 0;

  while (i < PluginsMapFactoryClasses.Count) do
    begin
      FPlugin := TPluginsMapFactory.FindPlugin(PluginsMapFactoryClasses.Items[i].ClassName,
         foMessagesLog,fImp );

      fPluginsList.Add(FPlugin);

      Inc(i);
    end;

  //External Plugin

  {$IFDEF NEWZIP}
  foMessagesLog.Log('Loading plugins');
  if FExternalPlugins.LoadPlugin('D:\Projects\Zautomatic\build\plugins\Zip.dll') then
    begin
      FExternalPlugin := IExternalPlugin(FExternalPlugins.Plugins[FExternalPlugins.PluginCount-1]);

      fPluginsList.Add(FExternalPlugin.CreatePlugin(foMessagesLog,fImp));

      foMessagesLog.Log('Loaded: ' + FExternalPlugin.PluginName);
    end;
  {$ENDIF}


end;

function TPlugins.CustomOnUses(aCompiler: TPSPascalCompiler): Boolean;
Var
  I: Integer;
  loPlugin: TPlugin;
begin
  Try
    for I := 0 to fPluginsList.Count -1 do
      begin
        loPlugin := TPlugin(fPluginsList.Items[i]);
        loPlugin.CustomOnUses(aCompiler)
      end;

    Result := True;
  Except
    foMessagesLog.WriteExceptLog;

    Result := False;
  End;


end;

procedure TPlugins.RegisterFunctions(aExec: TPSExec);
var
  I: integer;
  loPlugin: TPlugin;
  FExternalPlugin: IExternalPlugin;
begin
  for I := 0 to fPluginsList.Count -1 do
   begin
     loPlugin := TPlugin(fPluginsList.Items[i]);
     loPlugin.RegisterFunction(aExec);
   end;

  RegisterClassLibraryRuntime(aExec, FImp);
end;

procedure TPlugins.RegisterImports;
var
  loPlugin: TPlugin;
  I: Integer;
  FExternalPlugin: IExternalPlugin;
begin
  for I := 0 to fPluginsList.Count -1 do
    begin
      loPlugin := TPlugin(fPluginsList.Items[i]);
      loPlugin.RegisterImport;
    end;
end;

procedure TPlugins.SetVariantToClasses(aExec: TPSExec);
var
  loPlugin: TPlugin;
  I: Integer;
  FExternalPlugin: IExternalPlugin;
begin
  for I := 0 to fPluginsList.Count -1 do
    begin
      loPlugin := TPlugin(fPluginsList.Items[i]);
      loPlugin.SetVariantToClass(aExec);
    end;

end;

end.
