
var 
  lsURL: string;
begin

  lsURL := 'https://github.com/oneclick/rubyinstaller2/releases/download/RubyInstaller-2.6.1-1/rubyinstaller-devkit-2.6.1-1-x64.exe';

  writeln('Downloading...' +lsURL );

  if cURl.DownloadFile(lsURL, Folder.GetCurrentFolder) then
    writeln('Downloaded.')
 else  RaiseException(erCustomError, 'Response Code: '+  cURL.HTTPResponse); 

end.
