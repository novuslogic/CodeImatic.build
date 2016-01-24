unit ScriptEngine;

interface

uses
  Runtime,
  MessagesLog,
  System.Classes,
  System.SysUtils,
  uPSCompiler,
  uPSRuntime,
  uPSUtils;

Type
   TScriptEngine = class
   protected
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
     constructor Create(aMessagesLog: tMessagesLog);
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

    Result := True;
  end
  else
  begin
    TPSPascalCompiler(Sender).MakeError('', ecUnknownIdentifier, '');
    Result := False;
  end;
end;

constructor TScriptEngine.create(aMessagesLog: tMessagesLog);
begin
  foMessagesLog:= aMessagesLog;

  FParserStream := TMemoryStream.Create;
  FScript := TStringList.Create;
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

  foMessageslog.WriteLog('Compiling script...');

  if not FCompiler.Compile(FScript.Text) then  // Compile the Pascal script into bytecode.
  begin
    CompilerOutputMessage;

    foMessageslog.Failed := True;

    Exit;
  end;

  CompilerOutputMessage;

  foMessageslog.WriteLog('Executing script...');

  FCompiler.GetOutput(fsData); // Save the output of the compiler in the string Data.
  FCompiler.Free; // After compiling the script, there is no need for the compiler anymore.

  FExec := TPSExec.Create;  // Create an instance of the executer.

  FExec.RegisterFunctionName('WRITELN', MyWriteln, nil, nil);

  if not FExec.LoadData(fsData) then
  begin
    FExec.Free;

    foMessageslog.Failed := True;

    Exit;
  end;

  if not FExec.RunScript then
    begin
      FExec.Free;

      foMessageslog.Failed := True;

      Exit;
    end;

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
