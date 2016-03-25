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
                                aError: string): boolean;

     function RunCommandSilent(const aFilename: String;
                        const aDirectory: string;
                        const aParameters: String): Boolean;

     function RunCommand(const aFilename: String;
                        const aDirectory: string;
                        const aParameters: String): Boolean;
   end;

implementation


function TAPI_Shell.RunCommandSilent(const aFilename: String;
                        const aDirectory: string;
                        const aParameters: String): Boolean;
Var
  loShell: TNovusShell;
begin
  Try
    Try
      loShell := TNovusShell.Create;

      if not loShell.RunCommandSilent(aFilename,
                        aDirectory,
                        aParameters) then
        begin
          Result := False;
        end
      else
        Result := True;
    Except
      oMessagesLog.InternalError;
     End;
  Finally

    loShell.Free;
  End;
end;

function TAPI_Shell.RunCommand(const aFilename: String;
                        const aDirectory: string;
                        const aParameters: String): Boolean;
Var
  loShell: TNovusShell;
begin
   Try
    Try
      loShell := TNovusShell.Create;

      if not loShell.RunCommand(aFilename,
                        aDirectory,
                        aParameters) then
        begin
          Result := False;
        end
      else
        Result := True;
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
                                aError: string): boolean;
Var
  loShell: TNovusShell;
begin
   Try
    Try
      loShell := TNovusShell.Create;

      if not loShell.RunRedirectCommand(aCommandLine,
                                aInput,
                                aOutput,
                                aError) then
        begin
          Result := False;
        end
      else
        Result := True;
    Except
      oMessagesLog.InternalError;
     End;
  Finally
    loShell.Free;
  End;





end;


end.
