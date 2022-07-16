unit Plugin_FilesClasses;

interface

uses Classes, Plugin, uPSRuntime, uPSCompiler, PluginsMapFactory, API_Files,
  API_Output, SysUtils, uPSI_API_Files, NovusPlugin;

type
  tPlugin_FilesBase = class(TPascalScriptPlugin)
  private
  protected
    foAPI_Files: TAPI_Files;
  public
    constructor Create(aAPI_Output: tAPI_Output;
      var aImp: TPSRuntimeClassImporter;aPluginName: String); override;
    destructor Destroy; override;

    function CustomOnUses(var aCompiler: TPSPascalCompiler): Boolean; override;
    procedure RegisterFunction(var aExec: TPSExec); override;
    procedure SetVariantToClass(var aExec: TPSExec); override;
    procedure RegisterImport; override;
  end;

  TPlugin_Files = class(TExternalPlugin)
  private
  protected
    FPlugin_Files: tPlugin_FilesBase;
  public
    function GetPluginName: string; override; safecall;

    procedure Initialize; override; safecall;
    procedure Finalize; override;  safecall;

    function CreatePlugin(aAPI_Output: tAPI_Output; aImp: TPSRuntimeClassImporter): TPlugin; override; safecall;
  end;

implementation

var
  _Plugin_Files: TPlugin_Files = nil;

constructor tPlugin_Filesbase.Create(aAPI_Output: tAPI_Output;
  var aImp: TPSRuntimeClassImporter;aPluginName: String);
begin
  Inherited;

  foAPI_Files := TAPI_Files.Create(aAPI_Output);

end;

destructor tPlugin_FilesBase.Destroy;
begin
  Inherited;

  FreeandNIl(foAPI_Files);
end;

function tPlugin_FilesBase.CustomOnUses(var aCompiler: TPSPascalCompiler): Boolean;
begin
  Result := True;

  foAPI_Files.oCompiler := aCompiler;

  SIRegister_API_Files(aCompiler);

  AddImportedClassVariable(aCompiler, 'Files', 'TAPI_Files');

end;

procedure tPlugin_Filesbase.RegisterFunction(var aExec: TPSExec);
begin
end;

procedure tPlugin_FilesBase.SetVariantToClass(var aExec: TPSExec);
begin
  foAPI_Files.oExec := aExec;

  uPSRuntime.SetVariantToClass(aExec.GetVarNo(aExec.GetVar('Files')),
    foAPI_Files);
end;

procedure tPlugin_Filesbase.RegisterImport;
begin
  RIRegister_API_Files(FImp);
  RIRegister_API_Files(FImp);
end;


// Plugin_Files
function tPlugin_Files.GetPluginName: string;
begin
  Result := 'Files';
end;

procedure tPlugin_Files.Initialize;
begin
end;

function tPlugin_Files.CreatePlugin(aAPI_Output: tAPI_Output; aImp: TPSRuntimeClassImporter): TPlugin; safecall;
begin
  FPlugin_Files := tPlugin_FilesBase.Create(aAPI_Output,aImp,PluginName);

  Result := FPlugin_Files;
end;

procedure tPlugin_Files.Finalize;
begin
  if Assigned(FPlugin_Files) then FPlugin_Files.Free;
end;

function GetPluginObject: TNovusPlugin;
begin
  if (_Plugin_Files = nil) then _Plugin_Files := tPlugin_Files.Create;
  result := _Plugin_Files;
end;

exports
  GetPluginObject name func_GetPluginObject;

initialization
  begin
    _Plugin_Files := nil;
  end;

finalization
  FreeAndNIL(_Plugin_Files);


end.
