var 
  lsURL: string;
  liResponse: TWebDownloadResponse;
begin

  lsURL := 'https://www.google.com/intl/de/images/home_title.gif';

  writeln('Downloading...' +lsURL );
 
  liResponse := Web.URLDownloadToFile(lsURL, Folder.GetCurrentFolder);

  if liResponse.result = true then 
      writeln('Downloaded.')
 else  RaiseException(erCustomError, 'Failed download Response Code: '+  IntToStr(liResponse.Errorcode)); 

end.
