uses MSBuild;

var 
  FMSBuildOptions: TMSBUildOptions;
begin
  output.log('MSBuild TestApp Sample');

  FMSBuildOptions.Configuration := 'debug';
  FMSBuildOptions.Target := 'rebuild';
  
  if (MSBuild('4', 'TestApp.sln', FMSBuildOptions) <> 0) then 
    RaiseException(erCustomError, 'Exception:'+ SysErrorMessage);  

end.
