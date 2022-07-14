{$include simple.inc}

unit Sample;

begin
  {$ifdef xyz=1}
  Output.LogFormat('%s World 1', ['Hello']);
  {$else}
  writeln(Format('%s World 2', ['Hello']));
  {$endif}


  writeln('Working Direftory:' + WD());

end.
