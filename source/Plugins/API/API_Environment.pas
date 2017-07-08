/// <summary>
/// API Environment
/// </summary>
unit API_Environment;

interface

uses APIBase, SysUtils, NovusWindows;

type
  TAPI_Environment = class(TAPIBase)
  private
  protected
  public
    /// <summary>
    /// Call Is64BitOperatingSystem to check for host operating system is a
    /// 64Bit version.
    /// </summary>
    /// <returns>
    /// boolean
    /// </returns>
    function Is64BitOperatingSystem: boolean;
    /// <summary>
    /// Call GetEnvironmentVar retrieve a value from a environment variable.
    /// </summary>
    /// <param name="aVariableName">
    /// Environment variable name <br />
    /// </param>
    /// <returns>
    /// string
    /// </returns>
    /// <seealso cref="SetEnvironmentVar">
    /// SetEnvironmentVar
    /// </seealso>
    function GetEnvironmentVar(const aVariableName: string): string;
    /// <summary>
    /// Call SetEnvironmentVar set a value to an environment variable.
    /// </summary>
    /// <param name="aVariableName">
    /// Environment variable name <br />
    /// </param>
    /// <param name="aValue">
    /// Value <br />
    /// </param>
    /// <param name="aIsSystemVariable">
    /// Is system variable <br />
    /// </param>
    /// <returns>
    /// Integer
    /// </returns>
    /// <seealso cref="SetEnvironmentVar">
    /// SetEnvironmentVar
    /// </seealso>
    function SetEnvironmentVar(const aVariableName: string;
      const aValue: string; aIsSystemVariable: boolean): integer;
  end;

Const
  API_Environment_cannot_set_variable = 'Cannot not set variable [%s]';

implementation

function TAPI_Environment.GetEnvironmentVar(const aVariableName
  : string): String;
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

function TAPI_Environment.SetEnvironmentVar(const aVariableName: string;
  const aValue: string; aIsSystemVariable: boolean): integer;
begin
  Try
    Try
      Result := TNovusWindows.SetEnvironmentVariableEx(aVariableName, aValue,
        aIsSystemVariable);

      if Result = -1 then
        RuntimeErrorFmt(API_Environment_cannot_set_variable, [aVariableName]);

    Except
      oAPI_Output.InternalError;
    End;
  Finally
  End;
end;

function TAPI_Environment.Is64BitOperatingSystem: boolean;
begin
  Result := TNovusWindows.IsWin64;
end;

end.
