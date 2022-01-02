
Uses Windows, stringutils;

Var
  FGUID: tGUID;

begin
  Writeln('IsProcessExists: notepad.exe');

  if IsProcess32Exists('notepad.exe') then  Writeln('Running...');
  
  CoCreateGuid(fGuid);

  Writeln(GUIDToString(fGuid));


  Writeln('ProgramData Folder:' + ProgramDataFolder);


end.
