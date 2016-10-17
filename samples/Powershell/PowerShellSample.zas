uses powershell;

begin
  output.log('Powershell Sample');

  if IsPowerShellInstalled then 
    begin
      output.log('Powershell Installed');

      output.log('PSExecCommand example');

      if PSExecCommand('write-host hello world') <> 0 then 
        RaiseException(erCustomError, 'Error execute Powershell command.');

      output.log('PSExecFilename example');

      if PSExecFilename(wd+ 'Helloworld.ps1') <> 0 then
         RaiseException(erCustomError, 'Error execute Powershell script filename.');

    end
  else
    RaiseException(erCustomError, 'Powershell not installed');  

end.
