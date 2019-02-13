unit API_cURL;

interface

uses APIBase, SysUtils, API_Output, Classes, NovuscURLUtils;

type
   TAPI_cURL = class(TAPIBase)
   private
     fiHTTPResponseCode: longint;
     fsHTTPResponse: string;
   protected
  public
     constructor Create(aAPI_Output: tAPI_Output); 
     destructor Destroy; 
     function DownloadFile(aURL: UnicodeString; aDownloadPath: String): boolean;

     property HTTPResponseCode: longint
      read fiHTTPResponseCode;

     property HTTPResponse: string
       read fsHTTPResponse;
   end;

implementation


constructor TAPI_cURL.create(aAPI_Output: tAPI_Output);
begin
  inherited Create(aAPI_Output);

end;

destructor TAPI_cURL.Destroy;
begin
end;


function TAPI_cURL.DownloadFile(aURL: UnicodeString; aDownloadPath: String): boolean;
var
  loNovuscURLUtils: tNovuscURLUtils;
begin
  Try
    Try
      loNovuscURLUtils:= tNovuscURLUtils.Create;

      Result := loNovuscURLUtils.DownloadFile(aURL, aDownloadPath);

      fiHTTPResponseCode := loNovuscURLUtils.HTTPResponseCode;
      fsHTTPResponse := loNovuscURLUtils.HTTPResponse;
    Except
      oAPI_Output.InternalError;
    End;
  Finally
    loNovuscURLUtils.Free;
  End;
end;


end.

