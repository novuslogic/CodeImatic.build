unit Plugin_VariablesCmdLineClasses;

interface

uses Classes, Plugin, uPSRuntime, uPSCompiler, uPSI_API_VariablesCmdLine,
  PluginsMapFactory, api_Output, NovusPlugin, SysUtils;

type
  tPlugin_VariablesCmdLineBase = class(TPascalScriptPlugin)
  private
  protected
  public
    function CustomOnUses(var aCompiler: TPSPascalCompiler): Boolean; override;
    procedure RegisterFunction(var aExec: TPSExec); override;
    procedure SetVariantToClass(var aExec: TPSExec); override;
    procedure RegisterImport; override;
  end;

  tPlugin_VariablesCmdLine = class(TExternalPlugin)
  private
  protected
    FPlugin_VariablesCmdLine: tPlugin_VariablesCmdLineBase;
  public
    function GetPluginName: string; override; safecall;

    procedure Initialize; override; safecall;
    procedure Finalize; override;  safecall;

    function CreatePlugin(aAPI_Output: tAPI_Output; aImp: TPSRuntimeClassImporter): TPlugin; override; safecall;
  end;

implementation

var
  _Plugin_VariablesCmdLine: TPlugin_VariablesCmdLine = nil;

function tPlugin_VariablesCmdLineBase.CustomOnUses(var aCompiler: TPSPascalCompiler): Boolean;
begin
  Result := True;

  SIRegister_API_VariablesCmdLine(aCompiler);
  AddImportedClassVariable(aCompiler, 'VariablesCmdLine', 'TAPI_VariablesCmdLine');

end;

procedure tPlugin_VariablesCmdLineBase.RegisterFunction(var aExec: TPSExec);
begin
end;

procedure tPlugin_VariablesCmdLineBase.SetVariantToClass(var aExec: TPSExec);
begin
  uPSRuntime.SetVariantToClass(aExec.GetVarNo(aExec.GetVar('VariablesCmdLine')),
    foAPI_Output);
end;

procedure tPlugin_VariablesCmdLineBase.RegisterImport;
begin
  RIRegister_API_VariablesCmdLine(FImp);
end;

// Plugin_VariablesCmdLine
function tPlugin_VariablesCmdLine.GetPluginName: string;
begin
  Result := 'VariablesCmdLine';
end;

procedure tPlugin_VariablesCmdLine.Initialize;
begin
end;

function tPlugin_VariablesCmdLine.CreatePlugin(aAPI_Output: tAPI_Output; aImp: TPSRuntimeClassImporter): TPlugin; safecall;
begin
  FPlugin_VariablesCmdLine := tPlugin_VariablesCmdLineBase.Create(aAPI_Output,aImp,PluginName);

  Result := FPlugin_VariablesCmdLine;
end;

procedure tPlugin_VariablesCmdLine.Finalize;
begin
  if Assigned(FPlugin_VariablesCmdLine) then FPlugin_VariablesCmdLine.Free;
end;

function GetPluginObject: TNovusPlugin;
begin
  if (_Plugin_VariablesCmdLine = nil) then _Plugin_VariablesCmdLine := tPlugin_VariablesCmdLine.Create;
  result := _Plugin_VariablesCmdLine;
end;

exports
  GetPluginObject name func_GetPluginObject;

initialization
  begin
    _Plugin_VariablesCmdLine := nil;
  end;

finalization
  FreeAndNIL(_Plugin_VariablesCmdLine);



end.
