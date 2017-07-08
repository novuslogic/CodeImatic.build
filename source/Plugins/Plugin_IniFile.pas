unit Plugin_IniFile;

interface

uses Classes, Plugin, uPSRuntime, uPSCompiler, PluginsMapFactory, API_IniFile,
  uPSI_API_IniFile, API_Output, SysUtils;

type
  tPlugin_RegIni = class(Tplugin)
  private
  protected
    foAPI_IniFile: TAPI_IniFile;
  public
    constructor Create(aAPI_Output: tAPI_Output;
      var aImp: TPSRuntimeClassImporter); override;
    destructor Destroy; override;

    function CustomOnUses(var aCompiler: TPSPascalCompiler): Boolean; override;
    procedure RegisterFunction(var aExec: TPSExec); override;
    procedure SetVariantToClass(var aExec: TPSExec); override;
    procedure RegisterImport; override;
  end;

implementation

constructor tPlugin_RegIni.Create(aAPI_Output: tAPI_Output;
  var aImp: TPSRuntimeClassImporter);
begin
  Inherited;

  foAPI_IniFile := TAPI_IniFile.Create(foAPI_Output);

end;

destructor tPlugin_RegIni.Destroy;
begin
  Inherited;

  FreeandNIl(foAPI_IniFile);
end;

function tPlugin_RegIni.CustomOnUses(var aCompiler: TPSPascalCompiler): Boolean;
begin
  Result := True;

  foAPI_IniFile.oCompiler := aCompiler;

  SIRegister_API_IniFile(aCompiler);

  AddImportedClassVariable(aCompiler, 'IniFile', 'TAPI_IniFile');
end;

procedure tPlugin_RegIni.RegisterFunction(var aExec: TPSExec);
begin
end;

procedure tPlugin_RegIni.SetVariantToClass(var aExec: TPSExec);
begin
  foAPI_IniFile.oExec := aExec;

  uPSRuntime.SetVariantToClass(aExec.GetVarNo(aExec.GetVar('IniFile')),
    foAPI_IniFile);
end;

procedure tPlugin_RegIni.RegisterImport;
begin
  RIRegister_API_IniFile(FImp);
  RIRegister_API_IniFile(FImp);
end;

Initialization

begin
  tPluginsMapFactory.RegisterClass(tPlugin_RegIni);
end;

end.
