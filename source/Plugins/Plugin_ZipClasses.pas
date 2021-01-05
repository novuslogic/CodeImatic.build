unit Plugin_ZipClasses;

interface

uses Classes,Plugin,  uPSComponent, uPSRuntime,  uPSCompiler, API_Zip, NovusPlugin,
    uPSI_API_Zip, API_Output, SysUtils, Zip, System.Generics.Defaults,
    APIBase ;


type
  tPlugin_ZipBase = class(Tplugin)
  private
  protected
    foAPI_Zip: TAPI_Zip;
  public
    constructor Create(aAPI_Output: tAPI_Output; var aImp: TPSRuntimeClassImporter; aPluginName: String); override;
    destructor Destroy; override;

    function CustomOnUses(var aCompiler: TPSPascalCompiler): Boolean; override;
    procedure RegisterFunction(var aExec: TPSExec); override;
    procedure SetVariantToClass(var aExec: TPSExec); override;
    procedure RegisterImport; override;
  end;

  TPlugin_Zip = class( TSingletonImplementation, INovusPlugin, IExternalPlugin)
  private
  protected
    FPlugin_Zip: tPlugin_ZipBase;
  public
    function GetPluginName: string; safecall;

    procedure Initialize; safecall;
    procedure Finalize; safecall;

    property PluginName: string read GetPluginName;

    function CreatePlugin(aAPI_Output: tAPI_Output; aImp: TPSRuntimeClassImporter): TPlugin; safecall;

  end;

function GetPluginObject: INovusPlugin; stdcall;

implementation

var
  _Plugin_Zip: TPlugin_Zip = nil;

constructor tPlugin_ZipBase.Create(aAPI_Output: tAPI_Output;var  aImp: TPSRuntimeClassImporter; aPluginName: String);
begin
  Inherited;

  foAPI_Zip := TAPI_Zip.Create(foAPI_Output);
end;


destructor  tPlugin_ZipBase.Destroy;
begin
  Inherited;

  FreeandNIl(foAPI_Zip);
end;


function tPlugin_ZipBase.CustomOnUses(var aCompiler: TPSPascalCompiler): Boolean;
begin
  Result := True;

  foAPI_Zip.oCompiler := aCompiler;

  SIRegister_API_Zip(aCompiler);

  AddImportedClassVariable(aCompiler, 'Zip', 'TAPI_Zip');
end;

procedure tPlugin_ZipBase.RegisterFunction(var aExec: TPSExec);
begin
end;

procedure tPlugin_ZipBase.SetVariantToClass(var aExec: TPSExec);
begin
  foAPI_Zip.oExec := aExec;

  uPSRuntime.SetVariantToClass(aExec.GetVarNo(aExec.GetVar('ZIP')), foAPI_Zip);
end;

procedure tPlugin_ZipBase.RegisterImport;
begin
  RIRegister_API_Zip(FImp);
end;


// Plugin_Zip
function tPlugin_Zip.GetPluginName: string;
begin
  Result := 'Zip';
end;

procedure tPlugin_Zip.Initialize;
begin
end;

function tPlugin_Zip.CreatePlugin(aAPI_Output: tAPI_Output; aImp: TPSRuntimeClassImporter): TPlugin; safecall;
begin
  FPlugin_Zip := tPlugin_ZipBase.Create(aAPI_Output,aImp, PluginName);

  Result := FPlugin_Zip;
end;


procedure tPlugin_Zip.Finalize;
begin
  if Assigned(FPlugin_Zip) then FPlugin_Zip.Free;
end;

function GetPluginObject: INovusPlugin;
begin
  if (_Plugin_Zip = nil) then _Plugin_Zip := TPlugin_Zip.Create;
  result := _Plugin_Zip;
end;

exports
  GetPluginObject name func_GetPluginObject;

initialization
  begin
    _Plugin_Zip := nil;
  end;

finalization
  FreeAndNIL(_Plugin_Zip);

end.


