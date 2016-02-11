unit Plugin_Commands;

interface

uses Classes,runtime, Plugin,  uPSRuntime,  uPSCompiler, uPSI_MessagesLog, PluginsMapFactory,
     uPSC_classes,  uPSC_std;

type
  tPlugin_Commands = class(Tplugin)
  private
  protected
  public
    function CustomOnUses(aCompiler: TPSPascalCompiler): Boolean; override;
    procedure RegisterFunction(aExec: TPSExec); override;
    procedure SetVariantToClass(aExec: TPSExec); override;
    procedure RegisterImport; override;
  end;

  function InternalWriteln(Caller: TPSExec; p: TIFExternalProcRec; Global, Stack: TPSStack): Boolean;

implementation

function tPlugin_Commands.CustomOnUses(aCompiler: TPSPascalCompiler): Boolean;
begin
  Result := True;



 // SIRegister_Std(aCompiler);
 // SIRegister_Classes(aCompiler, True);
  SIRegisterTStrings(aCompiler, false);
  SIRegisterTStringList(aCompiler);


  TPSPascalCompiler(aCompiler).AddFunction('procedure Writeln(s: string);');
end;


procedure tPlugin_Commands.RegisterFunction(aExec: TPSExec);
begin
   aExec.RegisterFunctionName('WRITELN', InternalWriteln, nil, nil);
end;


procedure tPlugin_Commands.SetVariantToClass(aExec: TPSExec);
begin
end;


procedure tPlugin_Commands.RegisterImport;
begin
end;

function InternalWriteln(Caller: TPSExec; p: TIFExternalProcRec; Global, Stack: TPSStack): Boolean;
var
  PStart: Cardinal;
begin
  if Global = nil then begin result := false; exit; end;
  PStart := Stack.Count - 1;

  oRuntime.oMessagesLog.WriteLog(Stack.GetString(PStart));


  Result := True;
end;


Initialization
 begin
   tPluginsMapFactory.RegisterClass(tPlugin_Commands);
 end;

end.
