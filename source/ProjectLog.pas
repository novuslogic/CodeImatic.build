unit ProjectLog;

interface

Uses NovusUtilities;

type
  TProjectLog = class
  protected
  private
    fiExitCode: Integer;
    fsLastErrorMessage: String;
  public
    property ExitCode: Integer read fiExitCode write fiExitCode;
    property LastErrorMessage: String read fsLastErrorMessage write fsLastErrorMessage;

    procedure InternalError;
  end;

implementation

procedure TProjectLog.InternalError;
begin
  LastErrorMessage := TNovusUtilities.GetExceptMess
end;

end.
