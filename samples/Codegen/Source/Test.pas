unit Test;

uses Codeimatic;

Var
  FVariableCmdLineList: TVariableCmdLineList;
  FVariableCmdLine: tVariableCmdLine;
begin
  try
    FVariableCmdLineList:= TVariableCmdLineList.Create;


    FVariableCmdLine:= tVariableCmdLine.Create;
    FVariableCmdLine.VariableName := 'Var1';
    FVariableCmdLine.Value := 'Var1';

    FVariableCmdLineList.Add(FVariableCmdLine);

    FVariableCmdLine:= tVariableCmdLine.Create;
    FVariableCmdLine.VariableName := 'Var2';
    FVariableCmdLine.Value := 'Var2';

    FVariableCmdLineList.Add(FVariableCmdLine);
    
    if codegenex('test.ccproject',FVariableCmdLineList,  wd, '', false, '') <> 0 then ;
  finally
    FVariableCmdLineList.Free;
  end;
  
   
  
end.
