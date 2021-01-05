unit Plugin_SystemExt;

interface

uses Classes, runtime, Plugin, uPSCompiler, uPSI_API_Output, PluginsMapFactory,
  uPSC_classes, uPSC_std, uPSRuntime, uPSR_std, uPSR_classes, SysUtils,
  uPSC_dateutils,
  uPSI_ExtraClasses, uPSR_ExtraClasses, uPSC_comobj, uPSR_comobj, uPSC_dll,
  uPSR_dll, NovusVariants,  ExtraClasses,
  uPSR_dateutils, variants;

type
  tPlugin_SystemExtBase = class(TInternalplugin)
  private
  protected
  public
    function CustomOnUses(var aCompiler: TPSPascalCompiler): Boolean; override;
    procedure RegisterFunction(var aExec: TPSExec); override;
    procedure SetVariantToClass(var aExec: TPSExec); override;
    procedure RegisterImport; override;
  end;

function CommandFormat(Caller: TPSExec; p: TIFExternalProcRec;
    Global, Stack: TPSStack): Boolean;
function CommandSleep(Caller: TPSExec; p: TIFExternalProcRec;
  Global, Stack: TPSStack): Boolean;
function CommandWriteln(Caller: TPSExec; p: TIFExternalProcRec;
  Global, Stack: TPSStack): Boolean;
function CommandWD(Caller: TPSExec; p: TIFExternalProcRec;
  Global, Stack: TPSStack): Boolean;
function CommandCRF(Caller: TPSExec; p: TIFExternalProcRec;
  Global, Stack: TPSStack): Boolean;
function CommandGetLastError(Caller: TPSExec; p: TIFExternalProcRec;
  Global, Stack: TPSStack): Boolean;
function CommandSysErrorMessage(Caller: TPSExec; p: TIFExternalProcRec;
  Global, Stack: TPSStack): Boolean;
function CommandExtractFileName(Caller: TPSExec; p: TIFExternalProcRec;
  Global, Stack: TPSStack): Boolean;
function CommandCompareText(Caller: TPSExec; p: TIFExternalProcRec;
  Global, Stack: TPSStack): Boolean;

implementation



function tPlugin_SystemExtBase.CustomOnUses(var aCompiler
  : TPSPascalCompiler): Boolean;
begin
  Result := True;

  SIRegister_Std(aCompiler);
  SIRegister_Classes(aCompiler, True);
  SIRegister_ComObj(aCompiler);
  SIRegister_ExtraClasses(aCompiler);
  RegisterDll_Compiletime(aCompiler);
  RegisterDateTimeLibrary_C(aCompiler);

  TPSPascalCompiler(aCompiler).AddTypeCopyN('RawByteString', 'AnsiString');
  TPSPascalCompiler(aCompiler).AddTypeCopyN('UTF8String', 'AnsiString');

  TPSPascalCompiler(aCompiler).AddDelphiFunction
    ('function format(const aFormat: string; const Args : array of variant ) : string;');

  TPSPascalCompiler(aCompiler).AddFunction('procedure Writeln(s: string);');
  TPSPascalCompiler(aCompiler).AddFunction('function wd():string;');
  TPSPascalCompiler(aCompiler).AddFunction('function crlf():string;');
  TPSPascalCompiler(aCompiler).AddFunction('function GetLastError():Integer;');
  TPSPascalCompiler(aCompiler).AddFunction
    ('function SysErrorMessage():String;');
  TPSPascalCompiler(aCompiler).AddFunction
    ('function ExtractFileName(aFilename: string): String;');
  TPSPascalCompiler(aCompiler).AddFunction
    ('function CompareText(const S1, S2: string): Integer;');
  TPSPascalCompiler(aCompiler).AddFunction
    ('procedure Sleep(milliseconds: Cardinal);');

end;



procedure tPlugin_SystemExtBase.RegisterFunction(var aExec: TPSExec);
begin
  RegisterClassLibraryRuntime(aExec, FImp);
  RegisterDLLRuntime(aExec);
  RIRegister_ComObj(aExec);
  RegisterDateTimeLibrary_R(aExec);

  //aExec.RegisterDelphiFunction(@InternalFormat, 'FORMAT', cdRegister);

  aExec.RegisterFunctionName('FORMAT', CommandFormat, nil, nil);

  aExec.RegisterFunctionName('WRITELN', CommandWriteln, nil, nil);
  aExec.RegisterFunctionName('WD', CommandWD, nil, nil);
  aExec.RegisterFunctionName('CRLF', CommandCRF, nil, nil);
  aExec.RegisterFunctionName('GETLASTERROR', CommandGetLastError, nil, nil);
  aExec.RegisterFunctionName('SYSERRORMESSAGE', CommandSysErrorMessage,
    nil, nil);
  aExec.RegisterFunctionName('EXTRACTFILENAME', CommandExtractFileName,
    nil, nil);
  aExec.RegisterFunctionName('COMPARETEXT', CommandCompareText, nil, nil);
  aExec.RegisterFunctionName('SLEEP', CommandSleep, nil, nil);

end;

procedure tPlugin_SystemExtBase.SetVariantToClass(var aExec: TPSExec);
begin
end;

procedure tPlugin_SystemExtBase.RegisterImport;
begin
  RIRegister_Std(FImp);
  RIRegister_Classes(FImp, True);

  RIRegister_ExtraClasses(FImp);
end;

function CommandWriteln(Caller: TPSExec; p: TIFExternalProcRec;
  Global, Stack: TPSStack): Boolean;
var
  PStart: Cardinal;
begin
  if Global = nil then
  begin
    Result := false;
    exit;
  end;
  PStart := Stack.Count - 1;

  oRuntime.oAPI_Output.WriteLog(Stack.GetString(PStart));

  Result := True;
end;


function CommandFormat(Caller: TPSExec; p: TIFExternalProcRec;
  Global, Stack: TPSStack): Boolean;
var
  PStart: Cardinal;
  lsFormat: String;
  lPIFVariant: PIFVariant;
  lRefArgs: Variant;
  lArgs: array of variant;
begin
  Result := false;
  if Global = nil then Exit;

  PStart := Stack.Count - 1;

  lsFormat := Stack.GetString(PStart-1);
  lPIFVariant := Stack.Items[PStart-2];

  If PIFVariantToVariant(lPIFVariant, lRefArgs) then
    begin
      lArgs := VarArrayRef(lRefArgs);
      Stack.SetString(PStart, InternalFormat(lsFormat,lArgs));
      Result := True;
    end;
end;


function CommandSleep(Caller: TPSExec; p: TIFExternalProcRec;
  Global, Stack: TPSStack): Boolean;
var
  PStart: Cardinal;
begin
  if Global = nil then
  begin
    Result := false;
    exit;
  end;
  PStart := Stack.Count - 1;

  Sleep(Cardinal(Stack.GetUInt(PStart)));

  Result := True;
end;

function CommandWD(Caller: TPSExec; p: TIFExternalProcRec;
  Global, Stack: TPSStack): Boolean;
var
  PStart: Cardinal;
  lsWorkingdirectory: String;
begin
  if Global = nil then
  begin
    Result := false;
    exit;
  end;
  PStart := Stack.Count - 1;

  lsWorkingdirectory := oRuntime.oProject.GetWorkingdirectory;

  Stack.SetString(PStart, lsWorkingdirectory);

  Result := True;
end;

function CommandGetLastError(Caller: TPSExec; p: TIFExternalProcRec;
  Global, Stack: TPSStack): Boolean;
var
  PStart: Cardinal;
begin
  if Global = nil then
  begin
    Result := false;
    exit;
  end;
  PStart := Stack.Count - 1;

  Stack.SetInt(PStart, GetLastError);

  Result := True;
end;

function CommandSysErrorMessage(Caller: TPSExec; p: TIFExternalProcRec;
  Global, Stack: TPSStack): Boolean;
var
  PStart: Cardinal;
begin
  if Global = nil then
  begin
    Result := false;
    exit;
  end;
  PStart := Stack.Count - 1;

  Stack.SetString(PStart, SysErrorMessage(GetLastError));

  Result := True;
end;

function CommandExtractFileName(Caller: TPSExec; p: TIFExternalProcRec;
  Global, Stack: TPSStack): Boolean;
var
  PStart: Cardinal;
  fsFullFilename: String;
  fsFilename: String;
begin
  if Global = nil then
  begin
    Result := false;
    exit;
  end;
  PStart := Stack.Count - 2;

  fsFullFilename := Stack.GetString(PStart);

  fsFilename := ExtractFileName(fsFullFilename);

  Stack.SetString(PStart + 1, fsFilename);

  Result := True;
end;

function CommandCRF(Caller: TPSExec; p: TIFExternalProcRec;
  Global, Stack: TPSStack): Boolean;
var
  PStart: Cardinal;
const
  cCR = #13#10;
begin
  if Global = nil then
  begin
    Result := false;
    exit;
  end;
  PStart := Stack.Count - 1;

  Stack.SetString(PStart, cCR);

  Result := True;

end;

function CommandCompareText(Caller: TPSExec; p: TIFExternalProcRec;
  Global, Stack: TPSStack): Boolean;
var
  PStart: Cardinal;
  S1, S2: string;
begin
  if Global = nil then
  begin
    Result := false;
    exit;
  end;
  PStart := Stack.Count - 3;

  S1 := Stack.GetString(PStart);
  S2 := Stack.GetString(PStart + 1);

  Stack.SetInt(PStart + 2, CompareText(S1, S2));

  Result := True;
end;

Initialization

begin
  tPluginsMapFactory.RegisterClass(tPlugin_SystemExtBase);
end;

end.
