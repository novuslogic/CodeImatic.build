unit Plugin_RegExClasses;

interface

uses Classes, Plugin, uPSRuntime, uPSCompiler, PluginsMapFactory, API_RegEx,
  API_Output, SysUtils, uPSI_API_RegEx, NovusPlugin;

type
  tPlugin_RegExBase = class(TPascalScriptPlugin)
  private
  protected
    foAPI_RegEx: TAPI_RegEx;
  public
    constructor Create(aAPI_Output: tAPI_Output;
      var aImp: TPSRuntimeClassImporter;aPluginName: String); override;
    destructor Destroy; override;

    function CustomOnUses(var aCompiler: TPSPascalCompiler): Boolean; override;
    procedure RegisterFunction(var aExec: TPSExec); override;
    procedure SetVariantToClass(var aExec: TPSExec); override;
    procedure RegisterImport; override;
  end;

  tPlugin_RegEx = class(TExternalPlugin)
  private
  protected
    FPlugin_RegEx: tPlugin_RegExBase;
  public
    function GetPluginName: string; override; safecall;

    procedure Initialize; override; safecall;
    procedure Finalize; override;  safecall;

    function CreatePlugin(aAPI_Output: tAPI_Output; aImp: TPSRuntimeClassImporter): TPlugin; override; safecall;
  end;

implementation

var
  _Plugin_RegEx: TPlugin_RegEx = nil;

constructor tPlugin_RegExBase.Create(aAPI_Output: tAPI_Output;
  var aImp: TPSRuntimeClassImporter;aPluginName: String);
begin
  Inherited;

  foAPI_RegEx := TAPI_RegEx.Create(aAPI_Output);
end;

destructor tPlugin_RegExBase.Destroy;
begin
  Inherited;

  FreeandNIl(foAPI_RegEx);
end;

function tPlugin_RegExBase.CustomOnUses(var aCompiler: TPSPascalCompiler): Boolean;
begin
  Result := True;

  foAPI_RegEx.oCompiler := aCompiler;

  SIRegister_API_RegEx(aCompiler);

  AddImportedClassVariable(aCompiler, 'RegEx', 'TAPI_RegEx');
end;

procedure tPlugin_RegExBase.RegisterFunction(var aExec: TPSExec);
begin
end;

procedure tPlugin_RegExBase.SetVariantToClass(var aExec: TPSExec);
begin
  foAPI_RegEx.oExec := aExec;

  uPSRuntime.SetVariantToClass(aExec.GetVarNo(aExec.GetVar('RegEx')),
    foAPI_RegEx);
end;

procedure tPlugin_RegExBase.RegisterImport;
begin
  RIRegister_API_RegEx(FImp);
  RIRegister_API_RegEx(FImp);
end;


// Plugin_RegEx
function tPlugin_RegEx.GetPluginName: string;
begin
  Result := 'RegEx';
end;

procedure tPlugin_RegEx.Initialize;
begin
end;

function tPlugin_RegEx.CreatePlugin(aAPI_Output: tAPI_Output; aImp: TPSRuntimeClassImporter): TPlugin; safecall;
begin
  FPlugin_RegEx := tPlugin_RegExBase.Create(aAPI_Output,aImp,PluginName);

  Result := FPlugin_RegEx;
end;

procedure tPlugin_RegEx.Finalize;
begin
  if Assigned(FPlugin_RegEx) then FPlugin_RegEx.Free;
end;

function GetPluginObject: TNovusPlugin;
begin
  if (_Plugin_RegEx = nil) then _Plugin_RegEx := tPlugin_RegEx.Create;
  result := _Plugin_RegEx;
end;

exports
  GetPluginObject name func_GetPluginObject;

initialization
  begin
    _Plugin_RegEx := nil;
  end;

finalization
  FreeAndNIL(_Plugin_RegEx);

end.
