unit Sample;

Uses test;

begin
  writeln('Hello World'+ Format('String           = %s', ['Hello']));

  StringBuilderTest;
  RaiseExceptionTest;

end.
