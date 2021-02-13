{$I CodeImatic.build.inc}
unit Plugins;

interface

uses API_Output, uPSRuntime, uPSI_API_Output, uPSCompiler, PluginsMapFactory,
  Plugin,
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

constructor TPlugins.Create;
begin
  foAPI_Output := aAPI_Output;

  FExternalPlugins := TNovusPlugins.Create;

  fPluginsList := TList.Create;

  fImp := aImp;
end;

destructor TPlugins.Destroy;
begin
  Inherited;

  // UnloadPlugins;

  FExternalPlugins.Free;

  fPluginsList.Free;
end;

procedure TPlugins.UnloadPlugins;
Var
  I: Integer;
  loPlugin: tPlugin;
  fPluginInfo: PPluginInfo;
begin
  foAPI_Output.Log('Unload Plugins');

  Try

    for I := 0 to fPluginsList.Count - 1 do
    begin
      if Assigned(fPluginsList.Items[I]) then
      begin
        Try
          loPlugin := tPlugin(fPluginsList.Items[I]);

          foAPI_Output.Log('Unload: ' + loPlugin.PluginName);

          if loPlugin is TInternalplugin then
            begin
              loPlugin.Free;
              loPlugin := nil;
            end;
        Except
          foAPI_Output.InternalError;
        End;
      end;
    end;

   fPluginsList.Clear;

   for I := FExternalPlugins.PluginCount - 1 downto 0 do
      begin
        fPluginInfo := FExternalPlugins.GetPluginList(i);
        foAPI_Output.Log('Unload: ' +fPluginInfo^.PluginName);

        FExternalPlugins.UnloadPlugin(I);
      end;

    //fPluginsList.Clear;
  Except

    foAPI_Output.InternalError;
  End;
    // FExternalPlugins.UnloadAllPlugins;
end;

procedure TPlugins.LoadPlugins;
Var
  I: Integer;
  FPlugin: tPlugin;
  FExternalPlugin: IExternalPlugin;
  loConfigPlugin: TConfigPlugin;
begin
  // Internal Plugin Class

  I := 0;

  while (I < PluginsMapFactoryClasses.Count) do
  begin
    FPlugin := TPluginsMapFactory.FindPlugin(PluginsMapFactoryClasses.Items[I]
      .ClassName, foAPI_Output, fImp);

    fPluginsList.Add(FPlugin);

    Inc(I);
  end;

  // External Plugin
  foAPI_Output.Log('Loading plugins');

  if oConfig.oConfigPluginsList.Count > 0 then
  begin
    for I := 0 to oConfig.oConfigPluginsList.Count - 1 do
    begin
      loConfigPlugin := TConfigPlugin(oConfig.oConfigPluginsList.Items[I]);

      if FileExists(loConfigPlugin.PluginFilenamePathname) then
      begin
        if FExternalPlugins.LoadPlugin(loConfigPlugin.PluginFilenamePathname)
        then
        begin
          FExternalPlugin :=
            IExternalPlugin(FExternalPlugins.Plugins
            [FExternalPlugins.PluginCount - 1]);

          fPluginsList.Add(FExternalPlugin.CreatePlugin(foAPI_Output, fImp));

          foAPI_Output.Log('Loaded: ' + FExternalPlugin.PluginName);
        end;
      end
      else
        foAPI_Output.Log('Missing: ' + loConfigPlugin.PluginFilenamePathname);
    end;

  end;

end;

function TPlugins.CustomOnUses(aCompiler: TPSPascalCompiler): Boolean;
Var
  I: Integer;
  loPlugin: tPlugin;
begin
  Try
    for I := 0 to fPluginsList.Count - 1 do
    begin
      loPlugin := tPlugin(fPluginsList.Items[I]);
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
  I: Integer;
  loPlugin: tPlugin;
  FExternalPlugin: IExternalPlugin;
begin
  for I := 0 to fPluginsList.Count - 1 do
  begin
    loPlugin := tPlugin(fPluginsList.Items[I]);
    loPlugin.RegisterFunction(aExec);
  end;

  RegisterClassLibraryRuntime(aExec, fImp);
end;

procedure TPlugins.RegisterImports;
var
  loPlugin: tPlugin;
  I: Integer;
  FExternalPlugin: IExternalPlugin;
begin
  for I := 0 to fPluginsList.Count - 1 do
  begin
    loPlugin := tPlugin(fPluginsList.Items[I]);
    loPlugin.RegisterImport;
  end;
end;

procedure TPlugins.SetVariantToClasses(aExec: TPSExec);
var
  loPlugin: tPlugin;
  I: Integer;
  FExternalPlugin: IExternalPlugin;
begin
  for I := 0 to fPluginsList.Count - 1 do
  begin
    loPlugin := tPlugin(fPluginsList.Items[I]);
    loPlugin.SetVariantToClass(aExec);
  end;
end;

end.
