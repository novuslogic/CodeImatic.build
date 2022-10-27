unit Plugin_WebClasses;

interface

uses Classes,Plugin,  uPSComponent, uPSRuntime,  uPSCompiler, API_Web, NovusPlugin,
    uPSI_API_Web, API_Output, SysUtils,  System.Generics.Defaults,
    APIBase ;


type
  tPlugin_WebBase = class(TPascalScriptPlugin)
  private
  protected
    foAPI_Web: TAPI_Web;
  public
    constructor Create(aAPI_Output: tAPI_Output; var aImp: TPSRuntimeClassImporter; aPluginName: String); override;
    destructor Destroy; override;

    function CustomOnUses(var aCompiler: TPSPascalCompiler): Boolean; override;
    procedure RegisterFunction(var aExec: TPSExec); override;
    procedure SetVariantToClass(var aExec: TPSExec); override;
    procedure RegisterImport; override;
  end;

  TPlugin_Web = class(TExternalPlugin)
  private
  protected
    FPlugin_Web: tPlugin_WebBase;
  public
    function GetPluginName: string; override; safecall;

    procedure Initialize; override; safecall;
    procedure Finalize; override;  safecall;

    function CreatePlugin(aAPI_Output: tAPI_Output; aImp: TPSRuntimeClassImporter): TPlugin; override; safecall;
  end;

function GetPluginObject: TNovusPlugin; stdcall;

implementation

var
  _Plugin_Web: TPlugin_Web = nil;

constructor tPlugin_WebBase.Create(aAPI_Output: tAPI_Output;var  aImp: TPSRuntimeClassImporter; aPluginName: String);
begin
  Inherited;

  foAPI_Web := TAPI_Web.Create(foAPI_Output);
end;


destructor  tPlugin_WebBase.Destroy;
begin
  Inherited;

  FreeandNIl(foAPI_Web);
end;


function tPlugin_WebBase.CustomOnUses(var aCompiler: TPSPascalCompiler): Boolean;
begin
  Result := True;

  foAPI_Web.oCompiler := aCompiler;

  SIRegister_API_Web(aCompiler);

  AddImportedClassVariable(aCompiler, 'Web', 'TAPI_Web');
end;

procedure tPlugin_WebBase.RegisterFunction(var aExec: TPSExec);
begin
end;

procedure tPlugin_WebBase.SetVariantToClass(var aExec: TPSExec);
begin
  foAPI_Web.oExec := aExec;

  uPSRuntime.SetVariantToClass(aExec.GetVarNo(aExec.GetVar('Web')), foAPI_Web);
end;

procedure tPlugin_WebBase.RegisterImport;
begin
  RIRegister_API_Web(FImp);
end;


// Plugin_Web
function tPlugin_Web.GetPluginName: string;
begin
  Result := 'Web';
end;

procedure tPlugin_Web.Initialize;
begin
end;

function tPlugin_Web.CreatePlugin(aAPI_Output: tAPI_Output; aImp: TPSRuntimeClassImporter): TPlugin; safecall;
begin
  FPlugin_Web := tPlugin_WebBase.Create(aAPI_Output,aImp,PluginName);

  Result := FPlugin_Web;
end;

procedure tPlugin_Web.Finalize;
begin
  if Assigned(FPlugin_Web) then FPlugin_Web.Free;
end;

function GetPluginObject: TNovusPlugin;
begin
  if (_Plugin_Web = nil) then _Plugin_Web := TPlugin_Web.Create;
  result := _Plugin_Web;
end;

exports
  GetPluginObject name func_GetPluginObject;

initialization
  begin
    _Plugin_Web := nil;
  end;

finalization
  FreeAndNIL(_Plugin_Web);

end.


