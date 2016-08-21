unit Plugin_TaskRunner;

interface

Uses Classes, NovusList, SysUtils;

type
  TTaskRunner = class(TNovusList)
  protected
  private
  public
    function FindTask(aProcedureName: String): tObject;
  end;



implementation

Uses API_Task;

function TTaskRunner.FindTask(aProcedureName: String): tObject;
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
