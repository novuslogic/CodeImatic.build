unit API_RESTClient;


interface

uses APIBase, SysUtils, API_Output, Classes;

type
   TAPI_RESTClient = class(TAPIBase)
   private
     fiHTTPResponseCode: longint;
     fsHTTPResponse: string;
   protected
   public
     constructor Create(aAPI_Output: tAPI_Output);
     destructor Destroy;
   end;

implementation


constructor TAPI_RESTClient.create(aAPI_Output: tAPI_Output);
begin
  inherited Create(aAPI_Output);

end;

destructor TAPI_RESTClient.Destroy;
begin
end;

end.

