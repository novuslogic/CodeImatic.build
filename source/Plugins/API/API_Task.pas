unit API_Task;

interface

uses APIBase, SysUtils, NovusWindows;

type
   TAPI_Task = class(TAPIBase)
   private
   protected
   public
     procedure AddTask(const aProcedureName: String);

   end;

implementation

procedure TAPI_Task.AddTask(const aProcedureName: String);
Var
  FProc: Cardinal;
begin
  Try
    FProc := Self.oExec.GetProc(aProcedureName);

    Self.oExec.RunProcP([], FProc);
  Except

  End;


end;

end.
