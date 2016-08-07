unit uPSI_API_File;
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
  TPSImport_API_File = class(TPSPlugin)
  public
    procedure CompileImport1(CompExec: TPSScript); override;
    procedure ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter); override;
  end;
 
 
{ compile-time registration functions }
procedure SIRegister_TAPI_File(CL: TPSPascalCompiler);
procedure SIRegister_API_File(CL: TPSPascalCompiler);

{ run-time registration functions }
procedure RIRegister_TAPI_File(CL: TPSRuntimeClassImporter);
procedure RIRegister_API_File(CL: TPSRuntimeClassImporter);

procedure Register;

implementation


uses
   APIBase
  ,MessagesLog
  ,NovusFileUtils
  ,API_File
  ;
 
 
procedure Register;
begin
  RegisterComponents('Pascal Script', [TPSImport_API_File]);
end;

(* === compile-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure SIRegister_TAPI_File(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TAPIBase', 'TAPI_File') do
  with CL.AddClassN(CL.FindClass('TAPIBase'),'TAPI_File') do
  begin
    RegisterMethod('Function IncludeTrailingPathDelimiter( const s : string) : String');
    RegisterMethod('Function Exists( const aFilename : String) : Boolean');
    RegisterMethod('Function Copy( const aSourceFilename : String; const aDestFilename : String; const aOverWrite : Boolean) : Boolean');
    RegisterMethod('Function Delete( const aFilename : String) : Boolean');
    RegisterMethod('Function Move( const aSourceFilename : String; const aDestFilename : String) : Boolean');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_API_File(CL: TPSPascalCompiler);
begin
  SIRegister_TAPI_File(CL);
end;

(* === run-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure RIRegister_TAPI_File(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TAPI_File) do
  begin
    RegisterMethod(@TAPI_File.IncludeTrailingPathDelimiter, 'IncludeTrailingPathDelimiter');
    RegisterMethod(@TAPI_File.Exists, 'Exists');
    RegisterMethod(@TAPI_File.Copy, 'Copy');
    RegisterMethod(@TAPI_File.Delete, 'Delete');
    RegisterMethod(@TAPI_File.Move, 'Move');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_API_File(CL: TPSRuntimeClassImporter);
begin
  RIRegister_TAPI_File(CL);
end;

 
 
{ TPSImport_API_File }
(*----------------------------------------------------------------------------*)
procedure TPSImport_API_File.CompileImport1(CompExec: TPSScript);
begin
  SIRegister_API_File(CompExec.Comp);
end;
(*----------------------------------------------------------------------------*)
procedure TPSImport_API_File.ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter);
begin
  RIRegister_API_File(ri);
end;
(*----------------------------------------------------------------------------*)
 
 
end.