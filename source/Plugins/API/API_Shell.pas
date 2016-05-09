unit API_Shell;

interface

uses APIBase, NovusShell;

type
   TAPI_Shell = class(TAPIBase)
   private
   protected
   public
     function RunRedirectCommand(const aCommandLine: string;
                                const aInput: string;
                                var aOutput,
                                aError: string): Integer;

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

function TAPI_Shell.RunRedirectCommand(const aCommandLine: string;
                                const aInput: string;
                                var aOutput,
                                aError: string): Integer;
Var
  loShell: TNovusShell;
begin
   Try
    Try
      loShell := TNovusShell.Create;

      result := loShell.RunRedirectCommand(aCommandLine,
                                aInput,
                                aOutput,
                                aError);

    Except
      oMessagesLog.InternalError;
     End;
  Finally
    loShell.Free;
  End;





end;


end.
