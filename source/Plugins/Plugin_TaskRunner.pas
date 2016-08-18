unit Plugin_TaskRunner;

interface

Uses Classes, NovusList, SysUtils;

type
  TTask = class(TObject)
  protected
    fsProcedureName: String;
  private
  public
    property ProcedureName: String
      read fsProcedureName
      write fsProcedureName;
  end;


  TTaskRunner = class(TNovusList)
  protected
  private
  public
    function FindTask(aProcedureName: String): tTask;
  end;



implementation

function TTaskRunner.FindTask(aProcedureName: String): tTask;
Var
  I: integer;
  FTask: tTask;
begin
  Result := NIL;

  for I := 0 to Count -1  do
    begin
      FTask := tTask(Items[i]);
      if Uppercase(fTask.ProcedureName) = Uppercase(aProcedureName) then
        begin
          Result := FTask;

          Break;
        end;
    end;
end;

end.
