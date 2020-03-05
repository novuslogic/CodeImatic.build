unit Sample;

Uses test;

begin
  Output.LogFormat('%s World 1', ['Hello']);
  writeln(Format('%s World 2', ['Hello']));

  StringBuilderTest;

  RaiseExceptionTest;

end.
