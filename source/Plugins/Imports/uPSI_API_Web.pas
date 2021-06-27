unit uPSI_API_Web;
{
This file has been generated by UnitParser v0.7, written by M. Knight
and updated by NP. v/d Spek and George Birbilis. 
Source Code from Carlo Kok has been used to implement various sections of
UnitParser. Components of ROPS are used in the construction of UnitParser,
code implementing the class wrapper is taken from Carlo Kok's conv utility

}
interface
 

 
uses
   SysUtils
  ,Classes
  ,uPSComponent
  ,uPSRuntime
  ,uPSCompiler
  ;
 
type 
(*----------------------------------------------------------------------------*)
  TPSImport_API_Web = class(TPSPlugin)
  public
    procedure CompileImport1(CompExec: TPSScript); override;
    procedure ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter); override;
  end;
 
 
{ compile-time registration functions }
procedure SIRegister_TAPI_Web(CL: TPSPascalCompiler);
procedure SIRegister_TWebDownloadResponse(CL: TPSPascalCompiler);
procedure SIRegister_API_Web(CL: TPSPascalCompiler);

{ run-time registration functions }
procedure RIRegister_TAPI_Web(CL: TPSRuntimeClassImporter);
procedure RIRegister_TWebDownloadResponse(CL: TPSRuntimeClassImporter);
procedure RIRegister_API_Web(CL: TPSRuntimeClassImporter);

procedure Register;

implementation


uses
   APIBase
  ,API_Output
  ,NovusIndyUtils
  ,NovusWebUtils
  ,NovusUtilities
  ,API_Web
  ;
 
 
procedure Register;
begin
  RegisterComponents('Pascal Script', [TPSImport_API_Web]);
end;

(* === compile-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure SIRegister_TAPI_Web(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TAPIBase', 'TAPI_Web') do
  with CL.AddClassN(CL.FindClass('TAPIBase'),'TAPI_Web') do
  begin
//    RegisterMethod('Constructor Create( aAPI_Output : tAPI_Output)');
    RegisterMethod('Function URLDownloadToFile( aURL : UnicodeString; aDownloadPath : String) : TWebDownloadResponse');
    RegisterMethod('Function OpenDefaultWebBrowser( const aURL : string) : Integer');
    RegisterMethod('Function UrlEncode( const aDecodedStr : String; aPluses : Boolean) : String');
    RegisterMethod('Function UrlDecode( const aEncodedStr : String) : String');
    RegisterMethod('Function GetMIMEType( aURL : String) : string');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TWebDownloadResponse(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TPersistent', 'TWebDownloadResponse') do
  with CL.AddClassN(CL.FindClass('TPersistent'),'TWebDownloadResponse') do
  begin
    RegisterMethod('Constructor Create');
    RegisterProperty('Result', 'Boolean', iptrw);
    RegisterProperty('ErrorCode', 'Integer', iptrw);
    RegisterProperty('ErrorMessage', 'String', iptrw);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_API_Web(CL: TPSPascalCompiler);
begin
  SIRegister_TWebDownloadResponse(CL);
  SIRegister_TAPI_Web(CL);
end;

(* === run-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure TWebDownloadResponseErrorMessage_W(Self: TWebDownloadResponse; const T: String);
begin Self.ErrorMessage := T; end;

(*----------------------------------------------------------------------------*)
procedure TWebDownloadResponseErrorMessage_R(Self: TWebDownloadResponse; var T: String);
begin T := Self.ErrorMessage; end;

(*----------------------------------------------------------------------------*)
procedure TWebDownloadResponseErrorCode_W(Self: TWebDownloadResponse; const T: Integer);
begin Self.ErrorCode := T; end;

(*----------------------------------------------------------------------------*)
procedure TWebDownloadResponseErrorCode_R(Self: TWebDownloadResponse; var T: Integer);
begin T := Self.ErrorCode; end;

(*----------------------------------------------------------------------------*)
procedure TWebDownloadResponseResult_W(Self: TWebDownloadResponse; const T: Boolean);
begin Self.Result := T; end;

(*----------------------------------------------------------------------------*)
procedure TWebDownloadResponseResult_R(Self: TWebDownloadResponse; var T: Boolean);
begin T := Self.Result; end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TAPI_Web(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TAPI_Web) do
  begin
    RegisterConstructor(@TAPI_Web.Create, 'Create');
    RegisterMethod(@TAPI_Web.URLDownloadToFile, 'URLDownloadToFile');
    RegisterMethod(@TAPI_Web.OpenDefaultWebBrowser, 'OpenDefaultWebBrowser');
    RegisterMethod(@TAPI_Web.UrlEncode, 'UrlEncode');
    RegisterMethod(@TAPI_Web.UrlDecode, 'UrlDecode');
    RegisterMethod(@TAPI_Web.GetMIMEType, 'GetMIMEType');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TWebDownloadResponse(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TWebDownloadResponse) do
  begin
    RegisterVirtualConstructor(@TWebDownloadResponse.Create, 'Create');
    RegisterPropertyHelper(@TWebDownloadResponseResult_R,@TWebDownloadResponseResult_W,'Result');
    RegisterPropertyHelper(@TWebDownloadResponseErrorCode_R,@TWebDownloadResponseErrorCode_W,'ErrorCode');
    RegisterPropertyHelper(@TWebDownloadResponseErrorMessage_R,@TWebDownloadResponseErrorMessage_W,'ErrorMessage');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_API_Web(CL: TPSRuntimeClassImporter);
begin
  RIRegister_TWebDownloadResponse(CL);
  RIRegister_TAPI_Web(CL);
end;

 
 
{ TPSImport_API_Web }
(*----------------------------------------------------------------------------*)
procedure TPSImport_API_Web.CompileImport1(CompExec: TPSScript);
begin
  SIRegister_API_Web(CompExec.Comp);
end;
(*----------------------------------------------------------------------------*)
procedure TPSImport_API_Web.ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter);
begin
  RIRegister_API_Web(ri);
end;
(*----------------------------------------------------------------------------*)
 
 
end.
