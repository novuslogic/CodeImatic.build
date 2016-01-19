unit Builder;

interface

uses
  uPSCompiler,
  uPSRuntime,
  uPSUtils;

Type
   TBuilder = class
   protected
     FCompiler: TPSPascalCompiler;
     FExec: TPSExec;
     FsData: AnsiString;
   private
   public
     function ExecuteScript(const aScript: AnsiString): Boolean;
   end;



implementation



function TBuilder.ExecuteScript(const aScript: Ansistring): boolean;
begin
  Result := false;

  FCompiler := TPSPascalCompiler.Create; // create an instance of the compiler.
  //FCompiler.OnUses := ScriptOnUses; // assign the OnUses event.

  //FCompiler.OnExportCheck := ScriptOnExportCheck; // Assign the onExportCheck event.

  FCompiler.AllowNoBegin := True;
  FCompiler.AllowNoEnd := True; // AllowNoBegin and AllowNoEnd allows it that begin and end are not required in a script.

  if not FCompiler.Compile(aScript) then  // Compile the Pascal script into bytecode.
  begin
    FCompiler.Free;

    Exit;
  end;

  FCompiler.GetOutput(fsData); // Save the output of the compiler in the string Data.
  FCompiler.Free; // After compiling the script, there is no need for the compiler anymore.

  FExec := TPSExec.Create;  // Create an instance of the executer.

  //FExec.RegisterDelphiFunction(@MyOwnFunction, 'MYOWNFUNCTION', cdRegister);

  if not FExec.LoadData(fsData) then
  begin
    FExec.Free;
     // You could raise an exception here.
    Exit;
  end;

  //TestFunc := TTestFunction(Exec.GetProcAsMethodN('Test'));
  //if @TestFunc <> nil then
  //  ShowMessage('Result from TestFunc(''test indata''): '+TestFunc('test indata'));

  Result := True;

  fExec.Free; // Free the executer.
end;

end.
