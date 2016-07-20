unit Plugin_ZipClasses;

interface

uses Classes,Plugin,  uPSRuntime,  uPSCompiler, API_Zip, NovusPlugin,
    uPSI_API_Zip, MessagesLog, SysUtils, Zip, System.Generics.Defaults ;


type
  tPlugin_ZipBase = class(Tplugin)
  private
  protected
    foAPI_Zip: TAPI_Zip;
  public
    constructor Create(aMessagesLog: tMessagesLog; aImp: TPSRuntimeClassImporter); override;
    destructor Destroy; override;

    function CustomOnUses(aCompiler: TPSPascalCompiler): Boolean; override;
    procedure RegisterFunction(aExec: TPSExec); override;
    procedure SetVariantToClass(aExec: TPSExec); override;
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

    procedure InitializeEx(aMessagesLog: tMessagesLog; aImp: TPSRuntimeClassImporter); safecall;

    function CustomOnUses(aCompiler: TPSPascalCompiler): Boolean;safecall;
    procedure RegisterFunction(aExec: TPSExec);safecall;
    procedure SetVariantToClass(aExec: TPSExec);safecall;
    procedure RegisterImport; safecall;
  end;

function GetPluginObject: INovusPlugin; stdcall;

implementation

var
  _Plugin_Zip: TPlugin_Zip = nil;

constructor tPlugin_ZipBase.Create(aMessagesLog: tMessagesLog; aImp: TPSRuntimeClassImporter);
begin
  Inherited;

  foAPI_Zip := TAPI_Zip.Create(foMessagesLog);
end;


destructor  tPlugin_ZipBase.Destroy;
begin
  Inherited;

  FreeandNIl(foAPI_Zip);
end;



function tPlugin_ZipBase.CustomOnUses(aCompiler: TPSPascalCompiler): Boolean;
begin
  Result := True;

  foAPI_Zip.oCompiler := aCompiler;

  SIRegister_API_Zip(aCompiler);
  SIRegister_API_Zip(aCompiler);
  AddImportedClassVariable(aCompiler, 'Zip', 'TAPI_Zip');


end;

procedure tPlugin_ZipBase.RegisterFunction(aExec: TPSExec);
begin
end;

procedure tPlugin_ZipBase.SetVariantToClass(aExec: TPSExec);
begin
  foAPI_Zip.oExec := aExec;

  uPSRuntime.SetVariantToClass(aExec.GetVarNo(aExec.GetVar('ZIP')), foAPI_Zip);
end;

procedure tPlugin_ZipBase.RegisterImport;
begin
  RIRegister_API_Zip(FImp);
  RIRegister_API_Zip(FImp);
end;

function tPlugin_Zip.GetPluginName: string;
begin
  Result := 'Plugin_Zip';
end;

procedure tPlugin_Zip.Initialize;
begin
end;

procedure tPlugin_Zip.InitializeEx(aMessagesLog: tMessagesLog; aImp: TPSRuntimeClassImporter); safecall;
begin
  FPlugin_Zip := tPlugin_ZipBase.Create(aMessagesLog,aImp);
end;


procedure tPlugin_Zip.Finalize;
begin
  if Assigned(FPlugin_Zip) then FPlugin_Zip.Free;
end;

function tPlugin_Zip.CustomOnUses(aCompiler: TPSPascalCompiler): Boolean;
begin

end;

procedure tPlugin_Zip.RegisterFunction(aExec: TPSExec);
begin

end;
procedure tPlugin_Zip.SetVariantToClass(aExec: TPSExec);
begin

end;
procedure tPlugin_Zip.RegisterImport;
begin

end;


function GetPluginObject: INovusPlugin;
begin
  if (_Plugin_Zip = nil) then _Plugin_Zip := TPlugin_Zip.Create;
  result := _Plugin_Zip;
end;

exports
  GetPluginObject name func_GetPluginObject;

initialization
  _Plugin_Zip := nil;

finalization
  FreeAndNIL(_Plugin_Zip);

(*
Initialization
 begin
   tPluginsMapFactory.RegisterClass(tPlugin_ZipBase);
 end;
*)

end.


