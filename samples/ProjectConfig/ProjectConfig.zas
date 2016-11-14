begin
  writeln(ProjectConfig.ProjectConfigFileName);

  writeln('SearchPath');
  writeln(ProjectConfig.SearchPath);
  writeln(ProjectConfig.Getproperty('searchpath'));

  if (not ProjectConfig.IsPropertyExists('test')) then
    begin
      writeln('create test');

      ProjectConfig.CreateProperty('test');

      ProjectConfig.SetProperty('test', 'foo');
    end
  else
    begin
      writeln('delete test');
      ProjectConfig.DeleteProperty('test');
    end;


end.
