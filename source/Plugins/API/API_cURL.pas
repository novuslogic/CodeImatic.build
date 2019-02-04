unit API_cURL;

interface

uses APIBase, SysUtils, API_Output, Classes;

type
   TAPI_cURL = class(TAPIBase)
   private
   protected
   public
     constructor Create(aAPI_Output: tAPI_Output); 
     destructor Destroy; 
     function test: string;
   end;

implementation


constructor TAPI_cURL.create(aAPI_Output: tAPI_Output);
begin
  inherited Create(aAPI_Output);

end;

destructor TAPI_cURL.Destroy;
begin
end;


function TAPI_cURL.test: string;
begin
  //
end;


end.

