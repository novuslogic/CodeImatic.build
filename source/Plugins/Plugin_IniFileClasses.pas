unit Plugin_IniFileClasses;

interface

uses Classes, Plugin, uPSRuntime, uPSCompiler, PluginsMapFactory, API_IniFile,
  uPSI_API_IniFile, API_Output, SysUtils, NovusPlugin;

type
  tPlugin_RegIniBase = class(TPascalScriptPlugin)
  private
  protected
    foAPI_IniFile: TAPI_IniFile;
  public
    constructor Create(aAPI_Output: tAPI_Output;
      var aImp: TPSRuntimeClassImporter;aPluginName: string); override;
    destructor Destroy; override;

    function CustomOnUses(var aCompiler: TPSPascalCompiler): Boolean; override;
    procedure RegisterFunction(var aExec: TPSExec); override;
    procedure SetVariantToClass(var aExec: TPSExec); override;
    procedure RegisterImport; override;
  end;

  tPlugin_RegIni = class(TExternalPlugin)
  private
  protected
    FPlugin_RegIni: tPlugin_RegIniBase;
  public
    function GetPluginName: string; override; safecall;

    procedure Initialize; override; safecall;
    procedure Finalize; override;  safecall;

    function CreatePlugin(aAPI_Output: tAPI_Output; aImp: TPSRuntimeClassImporter): TPlugin; override; safecall;
  end;

implementation

var
  _Plugin_RegIni: TPlugin_RegIni = nil;


constructor tPlugin_RegIniBase.Create(aAPI_Output: tAPI_Output;
  var aImp: TPSRuntimeClassImporter;aPluginName: string);
begin
  Inherited;

  foAPI_IniFile := TAPI_IniFile.Create(aAPI_Output);

end;

destructor tPlugin_RegIniBase.Destroy;
begin
  Inherited;

  FreeandNIl(foAPI_IniFile);
end;

function tPlugin_RegIniBase.CustomOnUses(var aCompiler: TPSPascalCompiler): Boolean;
begin
  Result := True;

  foAPI_IniFile.oCompiler := aCompiler;

  SIRegister_API_IniFile(aCompiler);

  AddImportedClassVariable(aCompiler, 'IniFile', 'TAPI_IniFile');
end;

procedure tPlugin_RegIniBase.RegisterFunction(var aExec: TPSExec);
begin
end;

procedure tPlugin_RegIniBase.SetVariantToClass(var aExec: TPSExec);
begin
  foAPI_IniFile.oExec := aExec;

  uPSRuntime.SetVariantToClass(aExec.GetVarNo(aExec.GetVar('IniFile')),
    foAPI_IniFile);
end;

procedure tPlugin_RegIniBase.RegisterImport;
begin
  RIRegister_API_IniFile(FImp);
  RIRegister_API_IniFile(FImp);
end;


// Plugin_RegIni
function tPlugin_RegIni.GetPluginName: string;
begin
  Result := 'RegIni';
end;

procedure tPlugin_RegIni.Initialize;
begin
end;

function tPlugin_RegIni.CreatePlugin(aAPI_Output: tAPI_Output; aImp: TPSRuntimeClassImporter): TPlugin; safecall;
begin
  FPlugin_RegIni := tPlugin_RegIniBase.Create(aAPI_Output,aImp,PluginName);

  Result := FPlugin_RegIni;
end;

procedure tPlugin_RegIni.Finalize;
begin
  if Assigned(FPlugin_RegIni) then FPlugin_RegIni.Free;
end;

function GetPluginObject: TNovusPlugin;
begin
  if (_Plugin_RegIni = nil) then _Plugin_RegIni := tPlugin_RegIni.Create;
  result := _Plugin_RegIni;
end;

exports
  GetPluginObject name func_GetPluginObject;

initialization
  begin
    _Plugin_RegIni := nil;
  end;

finalization
  FreeAndNIL(_Plugin_RegIni);


end.
