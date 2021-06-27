var 
  lsURL: string;
  liResponse: integer;
begin

  lsURL := 'https://www.google.com/';

  writeln('Openning...' +lsURL );
 
  liResponse := Web.OpenDefaultWebBrowser(lsURL);
  
end.
