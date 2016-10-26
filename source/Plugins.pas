{$I Zautomatic.inc}
unit Plugins;

interface

uses  API_Output, uPSRuntime, uPSI_API_Output, uPSCompiler, PluginsMapFactory, Plugin,
      Classes, SysUtils, NovusPlugin, Config;

type
   TPlugins = class
   private
   protected
     FExternalPlugins: TNovusPlugins;
     fPluginsList: TList;
     foAPI_Output: tAPI_Output;
     fImp: TPSRuntimeClassImporter;
   public
     constructor Create(aAPI_Output: tAPI_Output; aImp: TPSRuntimeClassImporter);
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
  foAPI_Output:= aAPI_Output;

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
  loConfigPlugins: TConfigPlugins;
begin
  // Internal Plugin Class

  I := 0;

  while (i < PluginsMapFactoryClasses.Count) do
    begin
      FPlugin := TPluginsMapFactory.FindPlugin(PluginsMapFactoryClasses.Items[i].ClassName,
         foAPI_Output,fImp );

      fPluginsList.Add(FPlugin);

      Inc(i);
    end;

  //External Plugin
  foAPI_Output.Log('Loading plugins');

  if oConfig.oConfigPluginsList.Count > 0 then
    begin
      for I := 0 to oConfig.oConfigPluginsList.Count - 1do
        begin
          loConfigPlugins := tConfigPlugins(oConfig.oConfigPluginsList.Items[i]);

          if FileExists(loConfigPlugins.PluginFilenamePathname) then
            begin
              if FExternalPlugins.LoadPlugin(loConfigPlugins.PluginFilenamePathname) then
                begin
                  FExternalPlugin := IExternalPlugin(FExternalPlugins.Plugins[FExternalPlugins.PluginCount-1]);

                  fPluginsList.Add(FExternalPlugin.CreatePlugin(foAPI_Output,fImp));

                  foAPI_Output.Log('Loaded: ' + FExternalPlugin.PluginName);
                end;
            end
          else foAPI_Output.Log('Missing: ' + loConfigPlugins.PluginFilenamePathname);
        end;

    end;


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
    foAPI_Output.WriteExceptLog;

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
