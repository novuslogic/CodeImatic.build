unit Plugin_VCLControlsClasses;

interface

uses Classes, Plugin, uPSComponent, uPSRuntime, uPSCompiler, NovusPlugin,
  API_Output, SysUtils, System.Generics.Defaults, uPSI_Dialogs, dialogs,
  APIBase,
  uPSR_stdctrls, uPSC_stdctrls,
  uPSR_forms, uPSC_forms,

  uPSC_graphics,
  uPSC_controls,
  uPSC_classes,
  uPSR_graphics,
  uPSR_controls;

type
  tPlugin_VCLControlsBase = class(Tplugin)
  private
  protected
  public
    constructor Create(aAPI_Output: tAPI_Output;
      var aImp: TPSRuntimeClassImporter); override;
    destructor Destroy; override;

    function CustomOnUses(var aCompiler: TPSPascalCompiler): Boolean; override;
    procedure RegisterFunction(var aExec: TPSExec); override;
    procedure SetVariantToClass(var aExec: TPSExec); override;
    procedure RegisterImport; override;
  end;

  TPlugin_VCLControls = class(TSingletonImplementation, INovusPlugin,
    IExternalPlugin)
  private
  protected
    FPlugin_VCLControls: tPlugin_VCLControlsBase;
  public
    function GetPluginName: string; safecall;

    procedure Initialize; safecall;
    procedure Finalize; safecall;

    property PluginName: string read GetPluginName;

    function CreatePlugin(aAPI_Output: tAPI_Output;
      aImp: TPSRuntimeClassImporter): Tplugin; safecall;

  end;

function GetPluginObject: INovusPlugin; stdcall;

implementation

var
  _Plugin_VCLControls: TPlugin_VCLControls = nil;

constructor tPlugin_VCLControlsBase.Create(aAPI_Output: tAPI_Output;
  var aImp: TPSRuntimeClassImporter);
begin
  Inherited;

  // foAPI_VCLControls := TAPI_VCLControls.Create(foAPI_Output);
end;

destructor tPlugin_VCLControlsBase.Destroy;
begin
  Inherited;

  // FreeandNIl(foAPI_VCLControls);
end;

function tPlugin_VCLControlsBase.CustomOnUses(var aCompiler
  : TPSPascalCompiler): Boolean;
begin
  Result := True;

  SIRegister_Graphics(aCompiler, True);
  SIRegister_Controls(aCompiler);

  SIRegister_stdctrls(aCompiler);
  SIRegister_Forms(aCompiler);

  SIRegister_Dialogs(aCompiler);

end;

procedure tPlugin_VCLControlsBase.RegisterFunction(var aExec: TPSExec);
begin
  RIRegister_Dialogs_Routines(aExec);
end;

procedure tPlugin_VCLControlsBase.SetVariantToClass(var aExec: TPSExec);
begin
end;

procedure tPlugin_VCLControlsBase.RegisterImport;
begin
  RIRegister_Graphics(FImp, True);
  RIRegister_Controls(FImp);
  RIRegister_stdctrls(Fimp);
  RIRegister_Forms(FImp);
  RIRegister_Dialogs(FImp);
end;

// Plugin_VCLControls
function TPlugin_VCLControls.GetPluginName: string;
begin
  Result := 'VCLControls';
end;

procedure TPlugin_VCLControls.Initialize;
begin
end;

function TPlugin_VCLControls.CreatePlugin(aAPI_Output: tAPI_Output;
  aImp: TPSRuntimeClassImporter): Tplugin; safecall;
begin
  FPlugin_VCLControls := tPlugin_VCLControlsBase.Create(aAPI_Output, aImp);

  Result := FPlugin_VCLControls;
end;

procedure TPlugin_VCLControls.Finalize;
begin
  // if Assigned(FPlugin_VCLControls) then FPlugin_VCLControls.Free;
end;

function GetPluginObject: INovusPlugin;
begin
  if (_Plugin_VCLControls = nil) then
    _Plugin_VCLControls := TPlugin_VCLControls.Create;
  Result := _Plugin_VCLControls;
end;

exports GetPluginObject name func_GetPluginObject;

initialization

begin
  _Plugin_VCLControls := nil;
end;

finalization

FreeAndNIL(_Plugin_VCLControls);

end.
