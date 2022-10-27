unit Plugin_ShellClasses;

interface

uses Classes, Plugin, uPSRuntime, uPSCompiler, PluginsMapFactory, API_Shell,
  API_Output, SysUtils, uPSI_API_Shell, NovusPlugin;

type
  tPlugin_ShellBase = class(TPascalScriptPlugin)
  private
  protected
    foAPI_Shell: TAPI_Shell;
  public
    constructor Create(aAPI_Output: tAPI_Output;
      var aImp: TPSRuntimeClassImporter;
      aPluginName: string); override;
    destructor Destroy; override;

    function CustomOnUses(var aCompiler: TPSPascalCompiler): Boolean; override;
    procedure RegisterFunction(var aExec: TPSExec); override;
    procedure SetVariantToClass(var aExec: TPSExec); override;
    procedure RegisterImport; override;
  end;

  TPlugin_Shell = class(TExternalPlugin)
  private
  protected
    FPlugin_Shell: tPlugin_ShellBase;
  public
    function GetPluginName: string; override; safecall;

    procedure Initialize; override; safecall;
    procedure Finalize; override;  safecall;

    function CreatePlugin(aAPI_Output: tAPI_Output; aImp: TPSRuntimeClassImporter): TPlugin; override; safecall;
  end;


implementation

var
  _Plugin_Shell: TPlugin_Shell = nil;

constructor tPlugin_ShellBase.Create(aAPI_Output: tAPI_Output;
  var aImp: TPSRuntimeClassImporter;aPluginName: string);
begin
  Inherited;

  foAPI_Shell := TAPI_Shell.Create(aAPI_Output);

end;

destructor tPlugin_ShellBase.Destroy;
begin
  Inherited;

  FreeandNIl(foAPI_Shell);
end;

function tPlugin_ShellBase.CustomOnUses(var aCompiler: TPSPascalCompiler): Boolean;
begin
  Result := True;

  foAPI_Shell.oCompiler := aCompiler;

  SIRegister_API_Shell(aCompiler);

  AddImportedClassVariable(aCompiler, 'Shell', 'TAPI_Shell');

end;

procedure tPlugin_ShellBase.RegisterFunction(var aExec: TPSExec);
begin
end;

procedure tPlugin_ShellBase.SetVariantToClass(var aExec: TPSExec);
begin
  foAPI_Shell.oExec := aExec;

  uPSRuntime.SetVariantToClass(aExec.GetVarNo(aExec.GetVar('Shell')),
    foAPI_Shell);
end;

procedure tPlugin_ShellBase.RegisterImport;
begin
  RIRegister_API_Shell(FImp);
  RIRegister_API_Shell(FImp);
end;

// Plugin_Shell
function tPlugin_Shell.GetPluginName: string;
begin
  Result := 'Shell';
end;

procedure tPlugin_Shell.Initialize;
begin
end;

function tPlugin_Shell.CreatePlugin(aAPI_Output: tAPI_Output; aImp: TPSRuntimeClassImporter): TPlugin; safecall;
begin
  FPlugin_Shell := tPlugin_ShellBase.Create(aAPI_Output,aImp,PluginName);

  Result := FPlugin_Shell;
end;

procedure tPlugin_Shell.Finalize;
begin
  if Assigned(FPlugin_Shell) then FPlugin_Shell.Free;
end;

function GetPluginObject: TNovusPlugin;
begin
  if (_Plugin_Shell = nil) then _Plugin_Shell := tPlugin_Shell.Create;
  result := _Plugin_Shell;
end;

exports
  GetPluginObject name func_GetPluginObject;

initialization
  begin
    _Plugin_Shell := nil;
  end;

finalization
  FreeAndNIL(_Plugin_Shell);


end.
