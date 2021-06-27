unit API_Web;

interface

uses APIBase, SysUtils, API_Output, Classes, NovusIndyUtils, NovusWebUtils,
     NovusUtilities;

type
   TWebDownloadResponse = class(TPersistent)
   private
   protected
    fbResult: Boolean;
    fiErrorCode: Integer;
    fsErrorMessage: String;
   public
     constructor Create; virtual;
     destructor Destroy; virtual;

     property Result: Boolean read fbResult write fbResult;
     property ErrorCode: Integer read fiErrorCode write fiErrorCode;
     property ErrorMessage: String read fsErrorMessage write fsErrorMessage;
   end;



   TAPI_Web = class(TAPIBase)
   private
   protected
   public
     constructor Create(aAPI_Output: tAPI_Output);

     function URLDownloadToFile(aURL: UnicodeString; aDownloadPath: String): TWebDownloadResponse;
     function OpenDefaultWebBrowser(const aURL: string): Integer;

     function UrlEncode(const aDecodedStr: String; aPluses: Boolean): String;

     function UrlDecode(const aEncodedStr: String): String;
     function GetMIMEType(aURL: String): string;
   end;

implementation


constructor TAPI_Web.create(aAPI_Output: tAPI_Output);
begin
  inherited Create(aAPI_Output);
end;

function TAPI_Web.URLDownloadToFile(aURL: UnicodeString; aDownloadPath: String): TWebDownloadResponse;
Var
  loDownloadResponse: tDownloadResponse;
begin
  Result := TWebDownloadResponse.Create;

  Try
    loDownloadResponse := tNovusIndyUtils.URLDownloadToFile(aURL, aDownloadPath);

    Result.Result := loDownloadResponse.Result;
    Result.ErrorCode := loDownloadResponse.ErrorCode;
    Result.ErrorMessage := loDownloadResponse.ErrorMessage;
  Except
    Result.Result := False;

    oAPI_Output.InternalError;
  End;
end;

function TAPI_Web.OpenDefaultWebBrowser(const aURL: string): Integer;
begin
  Try
    Result := TNovusWebUtils.OpenDefaultWebBrowser(aURL);
  Except
    oAPI_Output.InternalError;
  End;
end;


function TAPI_Web.UrlEncode(const aDecodedStr: String; aPluses: Boolean): String;
begin
  Try
    Result := TNovusWebUtils.UrlEncode(aDecodedStr, aPluses);
  Except
    oAPI_Output.InternalError;
  End;
end;

function TAPI_Web.UrlDecode(const aEncodedStr: String): String;
begin
  Try
    Result := TNovusWebUtils.UrlDecode(aEncodedStr);
  Except
    oAPI_Output.InternalError;
  End;
end;

function TAPI_Web.GetMIMEType(aURL: String): string;
begin
  Try
    Result := TNovusWebUtils.GetMIMEType(aURL);
  Except
    oAPI_Output.InternalError;
  End;
end;

// TWebDownloadResponse
constructor TWebDownloadResponse.Create;
begin
end;

destructor TWebDownloadResponse.Destroy;
begin
end;



end.

