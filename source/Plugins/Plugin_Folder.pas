unit Plugin_Folder;

interface

uses Classes, Plugin, uPSRuntime, uPSCompiler, PluginsMapFactory, API_Folder,
  API_Output, SysUtils, uPSI_API_Folder;

type
  tPlugin_Folder = class(TPascalScriptInternalPlugin)
  private
  protected
    foAPI_Folder: TAPI_Folder;
  public
    constructor Create(aAPI_Output: tAPI_Output;
      var aImp: TPSRuntimeClassImporter; aPluginName: String); override;
    destructor Destroy; override;

    function CustomOnUses(var aCompiler: TPSPascalCompiler): Boolean; override;
    procedure RegisterFunction(var aExec: TPSExec); override;
    procedure SetVariantToClass(var aExec: TPSExec); override;
    procedure RegisterImport; override;
  end;

implementation

constructor tPlugin_Folder.Create(aAPI_Output: tAPI_Output;
  var aImp: TPSRuntimeClassImporter;aPluginName: String);
begin
  Inherited;

  foAPI_Folder := TAPI_Folder.Create(foAPI_Output);

end;

destructor tPlugin_Folder.Destroy;
begin
  Inherited;

  FreeandNIl(foAPI_Folder);
end;

function tPlugin_Folder.CustomOnUses(var aCompiler: TPSPascalCompiler): Boolean;
begin
  Result := True;

  foAPI_Folder.oCompiler := aCompiler;

  SIRegister_API_Folder(aCompiler);

  AddImportedClassVariable(aCompiler, 'Folder', 'TAPI_Folder');
end;

procedure tPlugin_Folder.RegisterFunction(var aExec: TPSExec);
begin
end;

procedure tPlugin_Folder.SetVariantToClass(var aExec: TPSExec);
begin
  foAPI_Folder.oExec := aExec;

  uPSRuntime.SetVariantToClass(aExec.GetVarNo(aExec.GetVar('Folder')),
    foAPI_Folder);
end;

procedure tPlugin_Folder.RegisterImport;
begin
  RIRegister_API_Folder(FImp);
  RIRegister_API_Folder(FImp);
end;

Initialization

begin
  tPluginsMapFactory.RegisterClass(tPlugin_Folder);
end;

end.
