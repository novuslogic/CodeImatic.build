unit VariablesCmdLine;

interface

type
  tVariableCmdLine = class(tobject)
  private
  protected
    fsVariableName: string;
    fsValue: string;
  public
    property VariableName: string read fsVariableName write fsVariableName;
    property Value: string read fsValue write fsValue;
  end;



implementation

end.
