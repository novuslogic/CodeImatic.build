unit Plugin_Commands;

interface

uses Classes,runtime, Plugin,  uPSCompiler, uPSI_MessagesLog, PluginsMapFactory,
     uPSC_classes,  uPSC_std, uPSRuntime, uPSR_std, uPSR_classes, SysUtils;

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

  function CommandWriteln(Caller: TPSExec; p: TIFExternalProcRec; Global, Stack: TPSStack): Boolean;
  function CommandWD(Caller: TPSExec; p: TIFExternalProcRec; Global, Stack: TPSStack): Boolean;
  function CommandCR(Caller: TPSExec; p: TIFExternalProcRec; Global, Stack: TPSStack): Boolean;


implementation

function tPlugin_Commands.CustomOnUses(aCompiler: TPSPascalCompiler): Boolean;
begin
  Result := True;

  SIRegister_Std(aCompiler);
  SIRegister_Classes(aCompiler, True);

  TPSPascalCompiler(aCompiler).AddFunction('procedure Writeln(s: string);');
  TPSPascalCompiler(aCompiler).AddFunction('function wd():string;');
  TPSPascalCompiler(aCompiler).AddFunction('function cr():string;');
end;


procedure tPlugin_Commands.RegisterFunction(aExec: TPSExec);
begin
  RegisterClassLibraryRuntime(aExec, FImp);
  aExec.RegisterFunctionName('WRITELN', CommandWriteln, nil, nil);
  aExec.RegisterFunctionName('WD', CommandWD, nil, nil);
  aExec.RegisterFunctionName('CR', CommandCR, nil, nil);
end;



procedure tPlugin_Commands.SetVariantToClass(aExec: TPSExec);
begin
end;


procedure tPlugin_Commands.RegisterImport;
begin
  RIRegister_Std(FImp);
  RIRegister_Classes(FImp, True);
end;

function CommandWriteln(Caller: TPSExec; p: TIFExternalProcRec; Global, Stack: TPSStack): Boolean;
var
  PStart: Cardinal;
begin
  if Global = nil then begin result := false; exit; end;
  PStart := Stack.Count - 1;

  oRuntime.oMessagesLog.WriteLog(Stack.GetString(PStart));

  Result := True;
end;


function CommandWD(Caller: TPSExec; p: TIFExternalProcRec; Global, Stack: TPSStack): Boolean;
var
  PStart: Cardinal;
  lsWorkingdirectory: String;
begin
  if Global = nil then begin result := false; exit; end;
  PStart := Stack.Count - 1;

  lsWorkingdirectory :=  IncludeTrailingPathDelimiter(oRuntime.oProject.oProjectConfig.workingdirectory);
  if (Not DirectoryExists(lsWorkingdirectory))  or (Trim(lsWorkingdirectory) = '') then
    lsWorkingdirectory := IncludeTrailingPathDelimiter(ExtractFilePath(oRuntime.oProject.ProjectFileName));

  Stack.SetString(PStart,lsWorkingdirectory);

  Result := True;

end;

function CommandCR(Caller: TPSExec; p: TIFExternalProcRec; Global, Stack: TPSStack): Boolean;
var
  PStart: Cardinal;
const
  cCR = #13#10;
begin
  if Global = nil then begin result := false; exit; end;
  PStart := Stack.Count - 1;


  Stack.SetString(PStart,cCR);

  Result := True;

end;

Initialization
 begin
   tPluginsMapFactory.RegisterClass(tPlugin_Commands);
 end;

end.
