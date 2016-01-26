unit ScriptEngine;

interface

uses
  Forms,
  Runtime,
  MessagesLog,
  System.Classes,
  System.SysUtils,
  uPSCompiler,
  uPSRuntime,
  uPSUtils,
  uPSI_MessagesLog;

Type
   TScriptEngine = class
   protected
     fImp : TPSRuntimeClassImporter;
     foMessagesLog: tMessagesLog;
     FScript: TStringList;
     FsFilename: String;
     FParserStream: TMemoryStream;
     FCompiler: TPSPascalCompiler;
     FExec: TPSExec;
     FsData: AnsiString;
   private
     procedure CompilerOutputMessage;
   public
     constructor Create(aMessagesLog: tMessagesLog; aImp: TPSRuntimeClassImporter);
     destructor Destroy;

     procedure LoadScript(aFilename: String);

     function ExecuteScript: Boolean;

   end;

   function MyWriteln(Caller: TPSExec; p: TIFExternalProcRec; Global, Stack: TPSStack): Boolean;

implementation

function CustomOnUses(Sender: TPSPascalCompiler; const Name: AnsiString): Boolean;
begin
  if Name = 'SYSTEM' then
  begin
    TPSPascalCompiler(Sender).AddFunction('procedure Writeln(s: string);');

    SIRegister_MessagesLog(Sender);

    AddImportedClassVariable(Sender, 'MessagesLog', 'TMessagesLog');

    Result := True;
  end
  else
  begin
    TPSPascalCompiler(Sender).MakeError('', ecUnknownIdentifier, '');
    Result := False;
  end;
end;

constructor TScriptEngine.create;
begin
  foMessagesLog:= aMessagesLog;

  FParserStream := TMemoryStream.Create;
  FScript := TStringList.Create;

  fImp:= aImp;
end;

destructor TScriptEngine.destroy;
begin
  FScript.Free;
  FParserStream.Free;
end;

function TScriptEngine.ExecuteScript: boolean;
begin
  Result := false;

  FCompiler := TPSPascalCompiler.Create; // create an instance of the compiler.
  FCompiler.OnUses :=CustomOnUses; // assign the OnUses event.

  //FCompiler.OnExportCheck := ScriptOnExportCheck; // Assign the onExportCheck event.

  FCompiler.AllowNoBegin := True;
  FCompiler.AllowNoEnd := True; // AllowNoBegin and AllowNoEnd allows it that begin and end are not required in a script.

  foMessageslog.WriteLog('Compiling');

  if not FCompiler.Compile(FScript.Text) then  // Compile the Pascal script into bytecode.
  begin
    CompilerOutputMessage;

    foMessageslog.Failed := True;

    Exit;
  end;

  CompilerOutputMessage;

  foMessageslog.WriteLog('Executing');

  FCompiler.GetOutput(fsData); // Save the output of the compiler in the string Data.
  FCompiler.Free; // After compiling the script, there is no need for the compiler anymore.

  FExec := TPSExec.Create;  // Create an instance of the executer.

  FExec.RegisterFunctionName('WRITELN', MyWriteln, nil, nil);

  RegisterClassLibraryRuntime(FExec, FImp);

  if not FExec.LoadData(fsData) then
  begin
    foMessageslog.WriteLog('[Error] : Could not load data: '+TIFErrorToString(FExec.ExceptionCode, FExec.ExceptionString));

    FExec.Free;

    foMessageslog.Failed := True;

    Exit;
  end;

  SetVariantToClass(FExec.GetVarNo(FExec.GetVar('MESSAGESLOG')), foMessageslog);

  if not FExec.RunScript then
    begin
      foMessageslog.WriteLog('[Runtime Error] : ' + TIFErrorToString(FExec.ExceptionCode, FExec.ExceptionString) +
            ' in ' + IntToStr(FExec.ExceptionProcNo) + ' at ' + IntToSTr(FExec.ExceptionPos));


      FExec.Free;

      foMessageslog.Failed := True;

      Exit;
    end
  else foMessageslog.WriteLog('Successfully executed');

  Result := True;

  fExec.Free; // Free the executer.
end;


procedure TScriptEngine.LoadScript(aFilename: String);
begin
  FScript.LoadFromFile(aFilename, TEncoding.ASCII);
end;


procedure TScriptEngine.CompilerOutputMessage;
var
  I: Integer;
begin
  for i := 0 to FCompiler.MsgCount - 1 do
    begin
      foMessageslog.WriteLog(FCompiler.Msg[i].MessageToString)
    end;
end;


function MyWriteln(Caller: TPSExec; p: TIFExternalProcRec; Global, Stack: TPSStack): Boolean;
var
  PStart: Cardinal;
begin
  if Global = nil then begin result := false; exit; end;
  PStart := Stack.Count - 1;

  oRuntime.oMessagesLog.WriteLog(Stack.GetString(PStart));


  Result := True;
end;


end.
