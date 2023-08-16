unit uPSI_API_Folders;

{
  This file has been generated by UnitParser v0.7, written by M. Knight
  and updated by NP. v/d Spek and George Birbilis.
  Source Code from Carlo Kok has been used to implement various sections of
  UnitParser. Components of ROPS are used in the construction of UnitParser,
  code implementing the class wrapper is taken from Carlo Kok's conv utility

}
interface

uses
  SysUtils, Classes, uPSComponent, uPSRuntime, uPSCompiler;

type
  (* ---------------------------------------------------------------------------- *)
  TPSImport_API_Folders = class(TPSPlugin)
  public
    procedure CompileImport1(CompExec: TPSScript); override;
    procedure ExecImport1(CompExec: TPSScript;
      const ri: TPSRuntimeClassImporter); override;
  end;

  { compile-time registration functions }
procedure SIRegister_TAPI_Folders(CL: TPSPascalCompiler);
procedure SIRegister_API_Folders(CL: TPSPascalCompiler);

{ run-time registration functions }
procedure RIRegister_TAPI_Folders(CL: TPSRuntimeClassImporter);
procedure RIRegister_API_Folders(CL: TPSRuntimeClassImporter);

procedure Register;

implementation

uses
  APIBase, API_Output, NovusFileUtils, API_Folders;

procedure Register;
begin
  RegisterComponents('Pascal Script', [TPSImport_API_Folders]);
end;

(* === compile-time registration functions === *)
(* ---------------------------------------------------------------------------- *)
procedure SIRegister_TAPI_Folders(CL: TPSPascalCompiler);
begin
  // with RegClassS(CL,'TAPIBase', 'TAPI_Folder') do
  with CL.AddClassN(CL.FindClass('TAPIBase'), 'TAPI_Folders') do
  begin
    RegisterMethod('Function Exists( const aFolder : String) : Boolean');
    RegisterMethod('Function RemoveFolder( const aFolder : String) : Boolean');
    RegisterMethod
      ('Function Move( const aSourceFolder : String; const aDestFolder : String) : Boolean');
    RegisterMethod
      ('Function Copy( const aSourceFolder : String; const aDestFolder : String) : Boolean');
    RegisterMethod('Function CreateFolder( const aFolder : String) : Boolean');
    RegisterMethod
      ('Function SetCurrentFolder( const aFolder : String) : Boolean');
    RegisterMethod('Function GetCurrentFolder : String');
  end;
end;

(* ---------------------------------------------------------------------------- *)
procedure SIRegister_API_Folders(CL: TPSPascalCompiler);
begin
  SIRegister_TAPI_Folders(CL);
end;

(* === run-time registration functions === *)
(* ---------------------------------------------------------------------------- *)
procedure RIRegister_TAPI_Folders(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TAPI_Folders) do
  begin
    RegisterMethod(@TAPI_Folders.Exists, 'Exists');
    RegisterMethod(@TAPI_Folders.RemoveFolder, 'RemoveFolder');
    RegisterMethod(@TAPI_Folders.Move, 'Move');
    RegisterMethod(@TAPI_Folders.Copy, 'Copy');
    RegisterMethod(@TAPI_Folders.CreateFolder, 'CreateFolder');
    RegisterMethod(@TAPI_Folders.SetCurrentFolder, 'SetCurrentFolder');
    RegisterMethod(@TAPI_Folders.GetCurrentFolder, 'GetCurrentFolder');
  end;
end;

(* ---------------------------------------------------------------------------- *)
procedure RIRegister_API_Folders(CL: TPSRuntimeClassImporter);
begin
  RIRegister_TAPI_Folders(CL);
end;

{ TPSImport_API_Folder }
(* ---------------------------------------------------------------------------- *)
procedure TPSImport_API_Folders.CompileImport1(CompExec: TPSScript);
begin
  SIRegister_API_Folders(CompExec.Comp);
end;

(* ---------------------------------------------------------------------------- *)
procedure TPSImport_API_Folders.ExecImport1(CompExec: TPSScript;
  const ri: TPSRuntimeClassImporter);
begin
  RIRegister_API_Folders(ri);
end;
(* ---------------------------------------------------------------------------- *)

end.