unit API_Environment;

interface

uses APIBase, SysUtils, NovusWindows;

type
   TAPI_Environment = class(TAPIBase)
   private
   protected
   public
     function GetEnvironmentVar(const aVariableName: string): string;
     procedure SetEnvironmentVar(const aVariableName: string; const aValue: string);
   end;

implementation

function TAPI_Environment.GetEnvironmentVar(const aVariableName: string): String;
begin
  Try
    Try
      Result := GetEnvironmentVariable(aVariableName);
    Except
      oMessagesLog.InternalError;
    End;
  Finally
  End;
end;

procedure TAPI_Environment.SetEnvironmentVar(const aVariableName: string; const aValue: string);
begin
  Try
    Try
      TNovusWindows.SetEnvironmentVariable(aVariableName,  aValue);
    Except
      oMessagesLog.InternalError;
    End;
  Finally
  End;
end;


end.
