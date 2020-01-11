unit API_Shell;

interface

uses APIBase, NovusShell, SysUtils, System.Threading, System.Classes,  System.SyncObjs;

type
  TAPI_Shell = class(TAPIBase)
  private
  protected
  public
    function RunCaptureCommand(const aCommandLine: string;
      var aOutput: string): Integer;

    function RunCommandSilent(const aFilename: String; const aDirectory: string;
      const aParameters: String): Integer;

    function RunCommand(const aFilename: String; const aDirectory: string;
      const aParameters: String): Integer;
  end;

implementation

function TAPI_Shell.RunCommandSilent(const aFilename: String;
  const aDirectory: string; const aParameters: String): Integer;
Var
  loShell: TNovusShell;
begin
  Try
    Try
      loShell := TNovusShell.Create;

      Result := loShell.RunCommandSilent(aFilename, aDirectory, aParameters);
    Except
      oAPI_Output.InternalError;
    End;
  Finally

    loShell.Free;
  End;
end;

function TAPI_Shell.RunCommand(const aFilename: String;
  const aDirectory: string; const aParameters: String): Integer;
Var
  loShell: TNovusShell;
begin
  Try
    Try
      loShell := TNovusShell.Create;

      Result := loShell.RunCommand(aFilename, aDirectory, aParameters);
    Except
      oAPI_Output.InternalError;
    End;
  Finally

    loShell.Free;
  End;
end;

function TAPI_Shell.RunCaptureCommand(const aCommandLine: string;
  var aOutput: String): Integer;
Var
  loShell: TNovusShell;
  FTask: ITask;
  fiTmpResult: Integer;
  fsTmpOutput: String;
begin
  fiTmpResult := -1;
  fsTmpOutput := '';
  FTask := TTask.Create(
    procedure
    Var
      liResult: Integer;
      lsoutput: String;
    begin

      try
        try
          loShell := TNovusShell.Create;

          liResult := loShell.RunCaptureCommand(aCommandLine, lsoutput);

          fiTmpResult := liResult;
          fsTmpOutput := lsoutput;
          (*
            TThread.Synchronize(nil,
            procedure
            begin
            fiTmpResult := liResult;
            fsTmpOutput := lsoutput;
            end
            );
          *)

        except
          oAPI_Output.InternalError;
        end;
      finally
        loShell.Free;
      end;

    end);

  FTask.Start;

  TTask.WaitForAll(FTask);

  Result := fiTmpResult;
  aOutput := fsTmpOutput;
end;

end.
