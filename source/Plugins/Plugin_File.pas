unit Plugin_File;

interface

uses Classes,Plugin,  uPSRuntime,  uPSCompiler, PluginsMapFactory, API_File,
    API_Output, SysUtils, uPSI_API_File ;


type
  tPlugin_File = class(Tplugin)
  private
  protected
     foAPI_File: TAPI_File;
  public
    constructor Create(aAPI_Output: tAPI_Output; var aImp: TPSRuntimeClassImporter); override;
    destructor Destroy; override;

    function CustomOnUses(var aCompiler: TPSPascalCompiler): Boolean; override;
    procedure RegisterFunction(var aExec: TPSExec); override;
    procedure SetVariantToClass(var aExec: TPSExec); override;
    procedure RegisterImport; override;
  end;



implementation


constructor tPlugin_File.Create(aAPI_Output: tAPI_Output; var aImp: TPSRuntimeClassImporter);
begin
  Inherited;

  foAPI_File := TAPI_File.Create(foAPI_Output);

end;


destructor  tPlugin_File.Destroy;
begin
  Inherited;

  FreeandNIl(foAPI_File);
end;



function tPlugin_File.CustomOnUses(var aCompiler: TPSPascalCompiler): Boolean;
begin
  Result := True;

  foAPI_File.oCompiler := aCompiler;

  SIRegister_API_File(aCompiler);

  AddImportedClassVariable(aCompiler, 'File', 'TAPI_File');


end;

procedure tPlugin_File.RegisterFunction(var aExec: TPSExec);
begin
end;

procedure tPlugin_File.SetVariantToClass(var aExec: TPSExec);
begin
  foAPI_File.oExec := aExec;

  uPSRuntime.SetVariantToClass(aExec.GetVarNo(aExec.GetVar('File')), foAPI_File);
end;

procedure tPlugin_File.RegisterImport;
begin
  RIRegister_API_File(FImp);
  RIRegister_API_File(FImp);
end;

Initialization
 begin
   tPluginsMapFactory.RegisterClass(tPlugin_File);
 end;




end.

