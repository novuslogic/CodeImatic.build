unit Plugin_cURLClasses;

interface

uses Classes,Plugin,  uPSComponent, uPSRuntime,  uPSCompiler, API_cURL, NovusPlugin,
    uPSI_API_cURL, API_Output, SysUtils,  System.Generics.Defaults,
    APIBase ;


type
  tPlugin_cURLBase = class(Tplugin)
  private
  protected
    foAPI_cURL: TAPI_cURL;
  public
    constructor Create(aAPI_Output: tAPI_Output; var aImp: TPSRuntimeClassImporter); override;
    destructor Destroy; override;

    function CustomOnUses(var aCompiler: TPSPascalCompiler): Boolean; override;
    procedure RegisterFunction(var aExec: TPSExec); override;
    procedure SetVariantToClass(var aExec: TPSExec); override;
    procedure RegisterImport; override;
  end;

  TPlugin_cURL = class( TSingletonImplementation, INovusPlugin, IExternalPlugin)
  private
  protected
    FPlugin_cURL: tPlugin_cURLBase;
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
  _Plugin_cURL: TPlugin_cURL = nil;

constructor tPlugin_cURLBase.Create(aAPI_Output: tAPI_Output;var  aImp: TPSRuntimeClassImporter);
begin
  Inherited;

  foAPI_cURL := TAPI_cURL.Create(foAPI_Output);
end;


destructor  tPlugin_cURLBase.Destroy;
begin
  Inherited;

  FreeandNIl(foAPI_cURL);
end;


function tPlugin_cURLBase.CustomOnUses(var aCompiler: TPSPascalCompiler): Boolean;
begin
  Result := True;

  foAPI_cURL.oCompiler := aCompiler;

  SIRegister_API_cURL(aCompiler);

  AddImportedClassVariable(aCompiler, 'cURL', 'TAPI_cURL');
end;

procedure tPlugin_cURLBase.RegisterFunction(var aExec: TPSExec);
begin
end;

procedure tPlugin_cURLBase.SetVariantToClass(var aExec: TPSExec);
begin
  foAPI_cURL.oExec := aExec;

  uPSRuntime.SetVariantToClass(aExec.GetVarNo(aExec.GetVar('CURL')), foAPI_cURL);
end;

procedure tPlugin_cURLBase.RegisterImport;
begin
  RIRegister_API_cURL(FImp);
end;


// Plugin_cURL
function tPlugin_cURL.GetPluginName: string;
begin
  Result := 'cURL';
end;

procedure tPlugin_cURL.Initialize;
begin
end;

function tPlugin_cURL.CreatePlugin(aAPI_Output: tAPI_Output; aImp: TPSRuntimeClassImporter): TPlugin; safecall;
begin
  FPlugin_cURL := tPlugin_cURLBase.Create(aAPI_Output,aImp);

  Result := FPlugin_cURL;
end;


procedure tPlugin_cURL.Finalize;
begin
  //if Assigned(FPlugin_cURL) then FPlugin_cURL.Free;
end;

function GetPluginObject: INovusPlugin;
begin
  if (_Plugin_cURL = nil) then _Plugin_cURL := TPlugin_cURL.Create;
  result := _Plugin_cURL;
end;

exports
  GetPluginObject name func_GetPluginObject;

initialization
  begin
    _Plugin_cURL := nil;
  end;

finalization
  FreeAndNIL(_Plugin_cURL);

end.


