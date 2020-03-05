unit test;

interface

procedure StringBuilderTest;
procedure RaiseExceptionTest;


implementation

procedure StringBuilderTest;
var
  SB: TStringBuilder;
begin
  Try
     SB:= TStringBuilder.Create;
  
     SB.Append('test');

     Output.logformat('Running: %s', [SB.ToString]);
  finally
    SB.Free;
  End;
end;


procedure RaiseExceptionTest;
begin
  RaiseException(erCustomError, 'TEST');
end;



end.
