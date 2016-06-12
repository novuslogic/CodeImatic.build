unit JSON;

interface

Uses Classes, uPSRuntime, uPSUtils;

type
  TJSON = class(TPersistent)
  private
  protected
  public
    constructor Create;

  end;

implementation

constructor TJSON.Create;
begin
end;

initialization
   RegisterClass(TJSON);


end.



