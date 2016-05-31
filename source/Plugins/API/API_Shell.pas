unit API_Shell;

interface

uses APIBase, NovusShell;

type
   TAPI_Shell = class(TAPIBase)
   private
   protected
   public
     function RunCaptureCommand(const aCommandLine: string;
                                var aOutput: string): Integer;

     function RunCommandSilent(const aFilename: String;
                        const aDirectory: string;
                        const aParameters: String): Integer;

     function RunCommand(const aFilename: String;
                        const aDirectory: string;
                        const aParameters: String): Integer;
   end;

implementation


function TAPI_Shell.RunCommandSilent(const aFilename: String;
                        const aDirectory: string;
                        const aParameters: String): Integer;
Var
  loShell: TNovusShell;
begin
  Try
    Try
      loShell := TNovusShell.Create;

      Result := loShell.RunCommandSilent(aFilename,
                        aDirectory,
                        aParameters) ;
    Except
      oMessagesLog.InternalError;
     End;
  Finally

    loShell.Free;
  End;
end;

function TAPI_Shell.RunCommand(const aFilename: String;
                        const aDirectory: string;
                        const aParameters: String): Integer;
Var
  loShell: TNovusShell;
begin
   Try
    Try
      loShell := TNovusShell.Create;

      Result := loShell.RunCommand(aFilename,
                        aDirectory,
                        aParameters);
    Except
      oMessagesLog.InternalError;
     End;
  Finally

    loShell.Free;
  End;
end;

function TAPI_Shell.RunCaptureCommand(const aCommandLine: string;
                                var aOutput: String): Integer;
Var
  loShell: TNovusShell;
begin
   Try
    Try
      loShell := TNovusShell.Create;

      result := loShell.RunCaptureCommand(aCommandLine,
                                aOutput);

    Except
      oMessagesLog.InternalError;
     End;
  Finally
    loShell.Free;
  End;





end;


end.
