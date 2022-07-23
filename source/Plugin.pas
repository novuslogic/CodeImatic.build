{$I CodeImatic.build.inc}
unit Plugin;

interface

uses classes, uPSRuntime, uPSCompiler, API_Output, NovusPlugin;

type
  TPlugin = class(TPersistent)
  private
  protected
    foAPI_Output: tAPI_Output;
    fImp: TPSRuntimeClassImporter;
    fsPluginName: string;
  public
    constructor Create(aAPI_Output: tAPI_Output;
      var aImp: TPSRuntimeClassImporter;
      aPluginName: String); virtual;

    function CustomOnUses(var aCompiler: TPSPascalCompiler): Boolean; virtual;
    procedure RegisterFunction(var aExec: TPSExec); virtual;
    procedure SetVariantToClass(var aExec: TPSExec); virtual;
    procedure RegisterImport; virtual;

    property oAPI_Output: tAPI_Output read foAPI_Output write foAPI_Output;

    property _Imp: TPSRuntimeClassImporter read fImp write fImp;

    property PluginName: String
      read fsPluginName write fsPluginName;
  end;

  TPascalScriptPlugin = class(TPlugin)
  end;


  TExternalPlugin = class(TNovusPlugin)
  protected
  private
  public
    function CreatePlugin(aAPI_Output: tAPI_Output;
      aImp: TPSRuntimeClassImporter): TPlugin; virtual; safecall;
  end;

  TPluginClass = class of TPlugin;

implementation

constructor TPlugin.Create;
begin
  foAPI_Output := aAPI_Output;

  fsPluginName := aPluginName;

  fImp := aImp;
end;

function TPlugin.CustomOnUses(var aCompiler: TPSPascalCompiler): Boolean;
begin
  Result := False;
end;

procedure TPlugin.RegisterFunction(var aExec: TPSExec);
begin

end;

procedure TPlugin.SetVariantToClass(var aExec: TPSExec);
begin

end;

procedure TPlugin.RegisterImport;
begin

end;

//TExternalPlugin
function TExternalPlugin.CreatePlugin(aAPI_Output: tAPI_Output;
      aImp: TPSRuntimeClassImporter): TPlugin;
begin
  Result := nil;
end;

end.
