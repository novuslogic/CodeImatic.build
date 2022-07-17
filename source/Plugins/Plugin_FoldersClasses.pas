unit Plugin_FoldersClasses;

interface

uses Classes, Plugin, uPSRuntime, uPSCompiler, PluginsMapFactory, API_Folders,
  API_Output, SysUtils, uPSI_API_Folders, NovusPlugin;

type
  tPlugin_Foldersbase = class(TPascalScriptPlugin)
  private
  protected
    foAPI_Folders: TAPI_Folders;
  public
    constructor Create(aAPI_Output: tAPI_Output;
      var aImp: TPSRuntimeClassImporter; aPluginName: String); override;
    destructor Destroy; override;

    function CustomOnUses(var aCompiler: TPSPascalCompiler): Boolean; override;
    procedure RegisterFunction(var aExec: TPSExec); override;
    procedure SetVariantToClass(var aExec: TPSExec); override;
    procedure RegisterImport; override;
  end;

  TPlugin_Folders = class(TExternalPlugin)
  private
  protected
    FPlugin_Folders: tPlugin_FoldersBase;
  public
    function GetPluginName: string; override; safecall;

    procedure Initialize; override; safecall;
    procedure Finalize; override;  safecall;

    function CreatePlugin(aAPI_Output: tAPI_Output; aImp: TPSRuntimeClassImporter): TPlugin; override; safecall;
  end;


implementation

var
  _Plugin_Folders: TPlugin_Folders = nil;

constructor tPlugin_Foldersbase.Create(aAPI_Output: tAPI_Output;
  var aImp: TPSRuntimeClassImporter;aPluginName: String);
begin
  Inherited;

  foAPI_Folders := TAPI_Folders.Create(foAPI_Output);

end;

destructor tPlugin_Foldersbase.Destroy;
begin
  Inherited;

  FreeandNIl(foAPI_Folders);
end;

function tPlugin_Foldersbase.CustomOnUses(var aCompiler: TPSPascalCompiler): Boolean;
begin
  Result := True;

  foAPI_Folders.oCompiler := aCompiler;

  SIRegister_API_Folders(aCompiler);

  AddImportedClassVariable(aCompiler, 'Folders', 'TAPI_Folders');
end;

procedure tPlugin_Foldersbase.RegisterFunction(var aExec: TPSExec);
begin
end;

procedure tPlugin_Foldersbase.SetVariantToClass(var aExec: TPSExec);
begin
  foAPI_Folders.oExec := aExec;

  uPSRuntime.SetVariantToClass(aExec.GetVarNo(aExec.GetVar('Folders')),
    foAPI_Folders);
end;

procedure tPlugin_Foldersbase.RegisterImport;
begin
  RIRegister_API_Folders(FImp);
  RIRegister_API_Folders(FImp);
end;


// Plugin_Folders
function tPlugin_Folders.GetPluginName: string;
begin
  Result := 'Folders';
end;

procedure tPlugin_Folders.Initialize;
begin
end;

function tPlugin_Folders.CreatePlugin(aAPI_Output: tAPI_Output; aImp: TPSRuntimeClassImporter): TPlugin; safecall;
begin
  FPlugin_Folders := tPlugin_FoldersBase.Create(aAPI_Output,aImp,PluginName);

  Result := FPlugin_Folders;
end;

procedure tPlugin_Folders.Finalize;
begin
  if Assigned(FPlugin_Folders) then FPlugin_Folders.Free;
end;

function GetPluginObject: TNovusPlugin;
begin
  if (_Plugin_Folders = nil) then _Plugin_Folders := tPlugin_Folders.Create;
  result := _Plugin_Folders;
end;

exports
  GetPluginObject name func_GetPluginObject;

initialization
  begin
    _Plugin_Folders := nil;
  end;

finalization
  FreeAndNIL(_Plugin_Folders);


end.
