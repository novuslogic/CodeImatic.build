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
  public
    constructor Create(aAPI_Output: tAPI_Output;
      var aImp: TPSRuntimeClassImporter); virtual;

    function CustomOnUses(var aCompiler: TPSPascalCompiler): Boolean; virtual;
    procedure RegisterFunction(var aExec: TPSExec); virtual;
    procedure SetVariantToClass(var aExec: TPSExec); virtual;
    procedure RegisterImport; virtual;

    property oAPI_Output: tAPI_Output read foAPI_Output write foAPI_Output;

    property _Imp: TPSRuntimeClassImporter read fImp write fImp;
  end;

  IExternalPlugin = interface(INovusPlugin)
    ['{838468EA-1750-4CB5-B6B3-E7078F59A46A}']
   
    function CreatePlugin(aAPI_Output: tAPI_Output;
      aImp: TPSRuntimeClassImporter): TPlugin safecall;
  end;

  TPluginClass = class of TPlugin;

implementation

constructor TPlugin.Create;
begin
  foAPI_Output := aAPI_Output;

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

end.
