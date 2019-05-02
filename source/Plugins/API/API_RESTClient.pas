unit API_RESTClient;


interface

uses APIBase, SysUtils, API_Output, Classes,
   IdSSLOpenSSL, IdHttp, IdStack, IdGlobal, IdURI, System.Generics.Collections ;


type
   THTTPMethods = (httpGET, httpPOST, httpPUT, httpDELETE, httpPATHCH);

   TRESTClient = class(TPersistent)
   private
     fIdHttp: TIDHttp;
     fIdIOHandler: TIdSSLIOHandlerSocketOpenSSL;
     fsAccept: string;
     fsAcceptCharset: string;
     fsContent_type: string;
     fiErrorCode: Integer;
     fsErrorMessage: String;
     fsUserAgent: string;
     fQueryStrings: TDictionary<String, String>;

     function GetAcceptCharset: string;
     procedure SetAcceptCharset(value: string);
     function GetResponseCode: Integer;
     function GetResponseText: String;
     function GetContent_type: string;
     function GetErrorCode: Integer;
     procedure SetContent_type(value: string);
     function GetErrorMessage: String;
     function GetUserAgent: string;
     procedure SetUserAgent(value:string);
     function GetAccept: string;
     procedure SetAccept(value: string);

     function DoExecute(aHTTPMethods: THTTPMethods; aUrl: string; aSource : TStringStream; aResponseContent: TStringStream): TIdHTTPResponse;
     function AddQueryStringsToURL(aURL: String): String;
   protected
   public
     constructor Create; virtual;
     destructor Destroy; virtual;

     procedure AddHeader(aName, aValue: UTF8String);
     procedure AddQueryString(aName, aValue: UTF8String);

     property Content_type: String read GetContent_type write SetContent_type;

     property ResponseCode: Integer read GetResponseCode;
     property ResponseText: string read GetResponseText;

     property ErrorCode: Integer read GetErrorCode;
     property ErrorMessage: String read GetErrorMessage;

     property UserAgent: string read GetUserAgent write SetUserAgent;

     property AcceptCharset: string read GetAcceptCharset write SetAcceptCharset;
     property Accept: string read GetAccept write SetAccept;

     function Post(aUrl: string; aSource: UTF8String; var aResponseContent: UTF8String): boolean;
     function Get(aUrl: string; var aResponseContent: UTF8String): boolean;
     function Delete(aUrl: string; var aResponseContent: UTF8String): boolean;
     function Put(aUrl: string; aSource: UTF8String): boolean;
   end;


   TAPI_RESTClient = class(TAPIBase)
   private
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

// TRESTClient
constructor TRESTClient.create;
begin
  fIdHttp := tIDHttp.Create(NIL);
  fIdIOHandler := TIdSSLIOHandlerSocketOpenSSL.Create(nil);
  fIdIOHandler.ReadTimeout := IdTimeoutInfinite;
  fIdIOHandler.ConnectTimeout := IdTimeoutInfinite;

  fQueryStrings:= TDictionary<String, String>.Create;
end;

destructor TRESTClient.destroy;
begin
  FreeandNil(fQueryStrings);
  FreeandNil(FIdIOHandler);
  FreeandNil(FIdHttp);
end;

procedure tRESTClient.AddHeader(aName, aValue: UTF8String);
begin
  fIdHttp.Request.CustomHeaders.AddValue(aName, aValue);
end;

function tRESTClient.GetResponseCode: Integer;
begin
  Result := FIdHttp.ResponseCode;
end;

function tRESTClient.GetResponseText: String;
begin
  Result := FIdHttp.ResponseText;
end;

function tRESTClient.GetContent_type: string;
begin
  if fsContent_type =''  then fsContent_type := 'application/json';

  Result := fsContent_type;
end;

function tRESTClient.GetErrorCode: Integer;
begin
  Result := fiErrorCode;
end;

procedure tRESTClient.SetContent_type(value: string);
begin
  fsContent_type := value;
end;

function tRESTClient.GetErrorMessage: String;
begin
  Result := fsErrorMessage;
end;

function tRESTClient.GetUserAgent: string;
begin
  if Trim(fsUserAgent) = '' then
    if Assigned(fIdHttp.Request) then
      fsUserAgent := FIdHttp.Request.UserAgent;

  Result := fsUserAgent;
end;

procedure tRESTClient.SetUserAgent(value:string);
begin
  fsUserAgent := value;
end;

function tRESTClient.GetAcceptCharset: string;
begin
  if Trim(fsAcceptCharset) = '' then
    if Assigned(FIdHttp.Request) then
       fsAcceptCharset := FIdHttp.Request.AcceptCharSet;

  Result := fsAcceptCharset;
end;

procedure tRESTClient.SetAcceptCharset(value:string);
begin
  fsAcceptCharset := value;
end;

function tRESTClient.GetAccept: string;
begin
   if Trim(fsAcceptCharset) = '' then
      if Assigned(FIdHttp.Request) then
          fsAccept := FIdHttp.Request.Accept;

  Result := fsAccept;
end;

procedure tRESTClient.SetAccept(value:string);
begin
  fsAccept := value;
end;

function tRESTClient.DoExecute(aHTTPMethods: THTTPMethods; aUrl: string; aSource : TStringStream; aResponseContent: TStringStream): TIdHTTPresponse;
begin
  Result := NIL;

  if Not Assigned(aSource) then Exit;
  if Not Assigned(aResponseContent) then Exit;

  try
   fIdHTTP.ReadTimeout := IdTimeoutInfinite;
   fIdHTTP.Request.Connection := 'Keep-Alive';

   aSource.Position := 0;

   aResponseContent.Position := 0;

   if Content_type =''  then Content_type := 'application/json';

   FIdHttp.Request.ContentType := Content_type;

    aURL := AddQueryStringsToURL(aUrl);

    fIdHttp.Request.UserAgent := UserAgent;

    fIdHttp.Request.Accept := Accept;
    fIdHttp.Request.AcceptCharset := AcceptCharset;

    case aHTTPMethods of
      httpGET:  fIdHttp.Get(aURL, aResponseContent);
      httpPOST: fIdHttp.Post(aUrl, aSource, aResponseContent);
      httpPUT:  fIdHttp.Put(aURL, aSource);
      httpDELETE: fIdHttp.Delete(aURL, aResponseContent);
      httpPATHCH: fIdHttp.Patch(aUrl, aSource, aResponseContent);
    end;

    Result := FIdHttp.Response;
  except
    on E: EIdHTTPProtocolException do
    begin
      fiErrorCode := E.ErrorCode;
      fsErrorMessage := E.ErrorMessage;

      FIdHttp.Disconnect;
    end;

  end;
end;


function tRESTClient.AddQueryStringsToURL(aURL: String): String;
Var
  lsQueryStrings: String;
  lQueryString: TPair<string, string>;
begin
  Result := aURL;

  if fQueryStrings.Count = 0 then Exit;


  lsQueryStrings := '';
  for lQueryString in fQueryStrings do
  begin
    if lsQueryStrings <> '' then
    begin
      lsQueryStrings := lsQueryStrings + '&';
    end
    else
    begin
      lsQueryStrings := '?';
    end;
    lsQueryStrings := lsQueryStrings + lQueryString.Key + '=' + lQueryString.Value;
  end;

  Result := Result + lsQueryStrings;
end;

procedure tRESTClient.AddQueryString(aName, aValue: UTF8String);
begin
  fQueryStrings.Add(aName, aValue);
end;


function tRESTClient.Post(aUrl: string; aSource: UTF8String; var aResponseContent: UTF8String): boolean;
Var
  FSource: TStringStream;
  FResponseContent: TStringStream;
  FPresponse: TIdHTTPresponse;
begin
  result := False;

  Try
    FSource := TStringStream.Create(aSource, TEncoding.ANSI);
    FResponseContent := TStringStream.Create('');

    FPresponse := DoExecute(httpPOST,aUrl, FSource, FResponseContent);

    aResponseContent := FResponseContent.DataString;

    Result := (FPresponse.ResponseCode = 200);
  Finally
    FResponseContent.Free;
    FSource.Free;
  End;
end;

function tRESTClient.Get(aUrl: string; var aResponseContent: UTF8String): boolean;
Var
  FSource: TStringStream;
  FResponseContent: TStringStream;
  FPresponse: TIdHTTPresponse;
begin
  result := False;

  Try
    FSource := TStringStream.Create('');
    FResponseContent := TStringStream.Create('');

    FPresponse := DoExecute(httpGet,aUrl, FSource, FResponseContent);

    aResponseContent := FResponseContent.DataString;

    Result := (FPresponse.ResponseCode = 200);
  Finally
    FResponseContent.Free;
    FSource.Free;
  End;
end;


function tRESTClient.Delete(aUrl: string; var aResponseContent: UTF8String): boolean;
Var
  FSource: TStringStream;
  FResponseContent: TStringStream;
  FPresponse: TIdHTTPresponse;
begin
  result := False;

  Try
    FSource := TStringStream.Create('');
    FResponseContent := TStringStream.Create('');

    FPresponse := DoExecute(httpDelete,aUrl, FSource, FResponseContent);

    aResponseContent := FResponseContent.DataString;

    Result := (FPresponse.ResponseCode = 200);
  Finally
    FResponseContent.Free;
    FSource.Free;
  End;
end;

function tRESTClient.Put(aUrl: string; aSource: UTF8String): boolean;
Var
  FSource: TStringStream;
  FResponseContent: TStringStream;
  FPresponse: TIdHTTPresponse;
begin
  result := False;

  Try
    FSource := TStringStream.Create(aSource, TEncoding.ANSI);
    FResponseContent := TStringStream.Create('');

    FPresponse := DoExecute(httpPut,aUrl, FSource, FResponseContent);

    Result := (FPresponse.ResponseCode = 200);
  Finally
    FResponseContent.Free;
    FSource.Free;
  End;
end;


end.

