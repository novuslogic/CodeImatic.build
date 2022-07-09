unit Plugin_RESTClientClasses;

Interface

uses Classes,Plugin,  uPSComponent, uPSRuntime,  uPSCompiler, API_RESTClient, NovusPlugin,
    uPSI_API_RESTClient, API_Output, SysUtils,  System.Generics.Defaults,
    APIBase ;


type
  tPlugin_RESTClientBase = class(Tplugin)
  private
  protected
    foAPI_RESTClient: TAPI_RESTClient;
  public
    constructor Create(aAPI_Output: tAPI_Output; var aImp: TPSRuntimeClassImporter;aPluginName: String); override;
    destructor Destroy; override;

    function CustomOnUses(var aCompiler: TPSPascalCompiler): Boolean; override;
    procedure RegisterFunction(var aExec: TPSExec); override;
    procedure SetVariantToClass(var aExec: TPSExec); override;
    procedure RegisterImport; override;
  end;

  TPlugin_RESTClient = class(TExternalPlugin)
  private
  protected
    FPlugin_RESTClient: tPlugin_RESTClientBase;
  public
    function GetPluginName: string; override; safecall;

    procedure Initialize; override; safecall;
    procedure Finalize; override; safecall;

    function CreatePlugin(aAPI_Output: tAPI_Output; aImp: TPSRuntimeClassImporter): TPlugin; override; safecall;
  end;

function GetPluginObject: TNovusPlugin; stdcall;

implementation

var
  _Plugin_RESTClient: TPlugin_RESTClient = nil;

constructor tPlugin_RESTClientBase.Create(aAPI_Output: tAPI_Output;var  aImp: TPSRuntimeClassImporter; aPluginName: String);
begin
  Inherited;

  foAPI_RESTClient := TAPI_RESTClient.Create(foAPI_Output);
end;


destructor  tPlugin_RESTClientBase.Destroy;
begin
  Inherited;

  FreeandNIl(foAPI_RESTClient);
end;


function tPlugin_RESTClientBase.CustomOnUses(var aCompiler: TPSPascalCompiler): Boolean;
begin
  Result := True;

  foAPI_RESTClient.oCompiler := aCompiler;

  SIRegister_API_RESTClient(aCompiler);

  AddImportedClassVariable(aCompiler, 'RESTClient', 'TAPI_RESTClient');
end;

procedure tPlugin_RESTClientBase.RegisterFunction(var aExec: TPSExec);
begin
end;

procedure tPlugin_RESTClientBase.SetVariantToClass(var aExec: TPSExec);
begin
  foAPI_RESTClient.oExec := aExec;

  uPSRuntime.SetVariantToClass(aExec.GetVarNo(aExec.GetVar('RESTClient')), foAPI_RESTClient);
end;

procedure tPlugin_RESTClientBase.RegisterImport;
begin
  RIRegister_API_RESTClient(FImp);
end;


// Plugin_RESTClient
function tPlugin_RESTClient.GetPluginName: string;
begin
  Result := 'RESTClient';
end;

procedure tPlugin_RESTClient.Initialize;
begin
end;

function tPlugin_RESTClient.CreatePlugin(aAPI_Output: tAPI_Output; aImp: TPSRuntimeClassImporter): TPlugin; safecall;
begin
  FPlugin_RESTClient := tPlugin_RESTClientBase.Create(aAPI_Output,aImp, PluginName);

  Result := FPlugin_RESTClient;
end;


procedure tPlugin_RESTClient.Finalize;
begin
  if Assigned(FPlugin_RESTClient) then FPlugin_RESTClient.Free;
end;

function GetPluginObject: TNovusPlugin;
begin
  if (_Plugin_RESTClient = nil) then _Plugin_RESTClient := TPlugin_RESTClient.Create;
  result := _Plugin_RESTClient;
end;

exports
  GetPluginObject name func_GetPluginObject;

initialization
  begin
    _Plugin_RESTClient := nil;
  end;

finalization
  FreeAndNIL(_Plugin_RESTClient);

end.


