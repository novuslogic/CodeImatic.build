
Uses Windows;

begin
  Writeln('IsProcessExists: notepad.exe');

  if IsProcessExists('notepad.exe') then  Writeln('Running...');
  



end.
