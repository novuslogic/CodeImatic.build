
var
  SB: TStringBuilder;
begin
  writeln('Hello World'+ Format('String           = %s', ['Hello']));

 

  Try
     SB:= TStringBuilder.Create;
  
     SB.Append('test');


     Output.logformat('Running: %s', [SB.ToString]);

  

   
  finally
    SB.Free;
  End;

end.
