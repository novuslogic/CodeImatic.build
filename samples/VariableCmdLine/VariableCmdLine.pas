unit VariableCmdLine;

var
  FVariableCmdLine1, FVariableCmdLine2, FVariableCmdLine3, FVariableCmdLine4: TVariableCmdLine;
  FVariableCmdLineList: TVariableCmdLineList;
  

procedure Test(aVariableCmdLineList: TVariableCmdLineList);
begin
  WriteLn(aVariableCmdLineList.ToVarCmdLines);

end;

begin
  writeln('VariableCmdLine Sample');


  try
    FVariableCmdLineList:= TVariableCmdLineList.Create;


    FVariableCmdLine1:= TVariableCmdLine.Create;

    FVariableCmdLine1.VariableName := 'foo';
    FVariableCmdLine1.Value := 'boo';

    FVariableCmdLineList.Add(FVariableCmdLine1);

    FVariableCmdLine3:= TVariableCmdLine.Create;
    FVariableCmdLine3.VariableName := 'foo2';
    FVariableCmdLine3.Value := 'boo2';

    FVariableCmdLineList.Add(FVariableCmdLine3);

    WriteLn(FVariableCmdLineList.ToVarCmdLines);

    FVariableCmdLine4 := FVariableCmdLineList.Items[0];

    WriteLn('foo: ' + FVariableCmdLine4.VariableName);

    Test(FVariableCmdLineList);

  finally

    FVariableCmdLineList.Free;

  end;
  


end.
