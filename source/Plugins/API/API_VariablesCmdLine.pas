unit API_VariablesCmdLine;

interface

uses APIBase, SysUtils, API_Output, Classes, NovusFileUtils, VariablesCmdLine;

type
  TAPI_VariablesCmdLine = class(TAPIBase)
  private
  protected
  public
    constructor Create(aAPI_Output: tAPI_Output); override;
    destructor Destroy; override;

    function Exists(Const VariableName: String): Boolean;
  end;

implementation

constructor TAPI_VariablesCmdLine.Create(aAPI_Output: tAPI_Output);
begin
  Inherited Create(aAPI_Output);
end;

destructor TAPI_VariablesCmdLine.Destroy;
begin
end;

function TAPI_VariablesCmdLine.Exists(Const VariableName: String): boolean;
begin
  Result := False;
end;

end.
