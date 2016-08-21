unit API_Environment;

interface

uses APIBase, SysUtils, NovusWindows;

type
   TAPI_Environment = class(TAPIBase)
   private
   protected
   public
     function GetEnvironmentVar(const aVariableName: string): string;
     function SetEnvironmentVar(const aVariableName: string; const aValue: string;aIsSystemVariable: Boolean): integer;
   end;

Const
   API_Environment_cannot_set_variable = 'Cannot not set variable [%s]';

implementation

function TAPI_Environment.GetEnvironmentVar(const aVariableName: string): String;
begin
  Try
    Try
      Result := GetEnvironmentVariable(aVariableName);
    Except
      oAPI_Output.InternalError;
    End;
  Finally
  End;
end;

function TAPI_Environment.SetEnvironmentVar(const aVariableName: string; const aValue: string; aIsSystemVariable: Boolean): integer;
begin
  Try
    Try
      Result := TNovusWindows.SetEnvironmentVariableEx(aVariableName,  aValue, aIsSystemVariable);

      if Result = -1 then RuntimeErrorFmt(API_Environment_cannot_set_variable, [aVariableName]);

    Except
      oAPI_Output.InternalError;
    End;
  Finally
  End;
end;


end.
