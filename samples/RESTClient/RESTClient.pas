Var
  FRESTClient: tRESTClient;
  fResponseContent: UTF8String;
  fSource: UTF8String;
begin
  Writeln('RESTClient Test');


   // https://www.guru99.com/postman-tutorial.html


  Writeln('GET: https://jsonplaceholder.typicode.com/users');

  try
    FRESTClient := tRESTClient.Create; 

    FRESTClient.Get('https://jsonplaceholder.typicode.com/users',  fResponseContent ) ;
    
    Writeln(fResponseContent) ;
    
  finally
    FRESTClient.Free;
  end;
  

  Writeln('POST:  https://jsonplaceholder.typicode.com/users')
  
  try
    FRESTClient := tRESTClient.Create; 


   fSource := '[';
   fSource := fSource + ' { ';
   fSource := fSource + '     "id": 11,';
   fSource := fSource + '    "name": "Krishna Rungta",';
   fSource := fSource + '     "username": "Bret",';
   fSource := fSource + '     "email": "Sincere@april.biz",';
   fSource := fSource + '      "address": {';
   fSource := fSource + '         "street": "Kulas Light",';
   fSource := fSource + '         "suite": "Apt. 556",';
   fSource := fSource + '         "city": "Gwenborough",';
   fSource := fSource + '         "zipcode": "92998-3874",';
   fSource := fSource + '        "geo": {';
   fSource := fSource + '             "lat": "-37.3159",';
   fSource := fSource + '             "lng": "81.1496"';
   fSource := fSource + '         }';
   fSource := fSource + '     },';
   fSource := fSource + '    "phone": "1-770-736-8031 x56442",';
   fSource := fSource + '     "website": "hildegard.org",';
   fSource := fSource + '     "company": {';
   fSource := fSource + '         "name": "Romaguera-Crona",';
   fSource := fSource + '         "catchPhrase": "Multi-layered client-server neural-net",';
   fSource := fSource + '         "bs": "harness real-time e-markets"';
   fSource := fSource + '     }';
   fSource := fSource + '  }';
   fSource := fSource + ']';




    FRESTClient.Post('https://jsonplaceholder.typicode.com/users', fSource, fResponseContent ) ;
    
    Writeln(fResponseContent) ;
    
  finally
    FRESTClient.Free;
  end;



end.
