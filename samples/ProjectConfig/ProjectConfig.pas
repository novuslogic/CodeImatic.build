begin
  writeln('ProjectConfig.SearchPath property with TrailingBackSlash');
  writeln(ProjectConfig.SearchPath);

  writeln('ProjectConfig.SearchPath property directly from Getproperty function without TrailingBackSlash');
  writeln(ProjectConfig.Getproperty('searchpath'));

  writeln('ProjectConfig.IsPropertyExists check for property test');
  if (ProjectConfig.IsPropertyExists('test')) then
    begin
      writeln('Test property found: ' + ProjectConfig.Getproperty('test'));


      writeln('Test property Delete');
      ProjectConfig.DeleteProperty('test');

       //ProjectConfig.SetProperty('test', 'foo2');
    end
   else 
     begin
        writeln('create test');

        ProjectConfig.CreateProperty('test');

        ProjectConfig.SetProperty('test', 'foo');
      end;

end.
