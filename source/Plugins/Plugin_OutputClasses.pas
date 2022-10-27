unit Plugin_OutputClasses;

interface

uses Classes, Plugin, uPSRuntime, uPSCompiler, uPSI_API_Output,
  PluginsMapFactory, API_output, NovusPlugin, System.SysUtils;

type
  tPlugin_OutputBase = class(TPascalScriptPlugin)
  private
  protected
  public
    function CustomOnUses(var aCompiler: TPSPascalCompiler): Boolean; override;
    procedure RegisterFunction(var aExec: TPSExec); override;
    procedure SetVariantToClass(var aExec: TPSExec); override;
    procedure RegisterImport; override;
  end;

  TPlugin_Output = class(TExternalPlugin)
  private
  protected
    FPlugin_Output: tPlugin_OutputBase;
  public
    function GetPluginName: string; override; safecall;

    procedure Initialize; override; safecall;
    procedure Finalize; override;  safecall;

    function CreatePlugin(aAPI_Output: tAPI_Output; aImp: TPSRuntimeClassImporter): TPlugin; override; safecall;
  end;

implementation

var
  _Plugin_Output: TPlugin_Output  = nil;

function tPlugin_OutputBase.CustomOnUses(var aCompiler: TPSPascalCompiler): Boolean;
begin
  Result := True;

  SIRegister_API_Output(aCompiler);
  AddImportedClassVariable(aCompiler, 'Output', 'TAPI_Output');
end;

procedure tPlugin_OutputBase.RegisterFunction(var aExec: TPSExec);
begin
end;

procedure tPlugin_OutputBase.SetVariantToClass(var aExec: TPSExec);
begin
  uPSRuntime.SetVariantToClass(aExec.GetVarNo(aExec.GetVar('Output')),
    foAPI_Output);
end;

procedure tPlugin_OutputBase.RegisterImport;
begin
  RIRegister_API_Output(FImp);
end;

// Plugin_Output
function tPlugin_Output.GetPluginName: string;
begin
  Result := 'Output';
end;

procedure tPlugin_Output.Initialize;
begin
end;

function tPlugin_Output.CreatePlugin(aAPI_Output: tAPI_Output; aImp: TPSRuntimeClassImporter): TPlugin; safecall;
begin
  FPlugin_Output := tPlugin_OutputBase.Create(aAPI_Output,aImp,PluginName);

  Result := FPlugin_Output;
end;

procedure tPlugin_Output.Finalize;
begin
  if Assigned(FPlugin_Output) then FPlugin_Output.Free;
end;

function GetPluginObject: TNovusPlugin;
begin
  if (_Plugin_Output = nil) then _Plugin_Output := tPlugin_Output.Create;
  result := _Plugin_Output;
end;

exports
  GetPluginObject name func_GetPluginObject;

initialization
  begin
    _Plugin_Output := nil;
  end;

finalization
   FreeAndNIL(_Plugin_Output);
end.
