{$I CodeImatic.build.inc}
unit PluginsMapFactory;

interface

Uses Plugin, API_Output, uPSRuntime, uPSCompiler, Contnrs;

type
  TPluginsMapFactory = class(Tobject)
  public
    class procedure RegisterClass(AClass: TClass);
    class function FindClass(AClassName: string): TClass;
    class function FindPlugin(AClassName: String; aAPI_Output: tAPI_Output;
      aImp: TPSRuntimeClassImporter): tPlugin;
  end;

var
  PluginsMapFactoryClasses: TClassList;

implementation

class procedure TPluginsMapFactory.RegisterClass(AClass: TClass);
begin
  PluginsMapFactoryClasses.Add(AClass);
end;

class function TPluginsMapFactory.FindClass(AClassName: string): TClass;
var
  i: Integer;
  LClass: TClass;
begin
  i := 0;

  LClass := nil;

  while (i < PluginsMapFactoryClasses.Count) and (LClass = nil) do
  begin
    if PluginsMapFactoryClasses[i].ClassNameIs(AClassName) then
      LClass := PluginsMapFactoryClasses[i]
    else
      Inc(i);
  end;

  Result := LClass;
end;

class function TPluginsMapFactory.FindPlugin(AClassName: String;
  aAPI_Output: tAPI_Output; aImp: TPSRuntimeClassImporter): tPlugin;
Var
  fc: TPluginClass;
  f: tPlugin;
begin
  fc := TPluginClass(TPluginsMapFactory.FindClass(AClassName));
  f := fc.Create(aAPI_Output, aImp);

  Result := f;
end;

initialization

PluginsMapFactoryClasses := TClassList.Create;

finalization

begin
  PluginsMapFactoryClasses.Clear;
  PluginsMapFactoryClasses.Free;
end;

end.
