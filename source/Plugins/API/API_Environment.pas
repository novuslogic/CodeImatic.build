unit API_Environment;

interface

uses APIBase, SysUtils, NovusWindows;

type
   TAPI_Environment = class(TAPIBase)
   private
   protected
   public
     function GetEnvironmentVar(const aVariableName: string): string;
     function SetEnvironmentVar(const aVariableName: string; const aValue: string): integer;
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

function TAPI_Environment.SetEnvironmentVar(const aVariableName: string; const aValue: string): integer;
begin
  Try
    Try
      Result := TNovusWindows.SetEnvironmentVariable(aVariableName,  aValue);
    Except
      oMessagesLog.InternalError;
    End;
  Finally
  End;
end;


end.
