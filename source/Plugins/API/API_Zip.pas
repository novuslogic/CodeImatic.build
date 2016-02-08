unit API_Zip;

interface

uses Classes, SysUtils, Zip, APIBase, uPSRuntime;

type
   TAPI_Zip = class(TAPIBase)
   private
   protected
   public
     function ZipCompress: Boolean;
     function ZipExtractAll: Boolean;
     function ZipExtractFile(const aZipFilename: String;
                             const aFileName: string;
                             const aPath: string = '';
                             aCreateSubdirs: Boolean = True): Boolean;
   end;

Const
   API_Zip_NotFileExists = 'ZipFilename cannot be found [%s]';


implementation


function TAPI_Zip.ZipCompress;
begin
  Result := False;
end;

function TAPI_Zip.ZipExtractAll;
begin
  Result := False;
end;

function TAPI_Zip.ZipExtractFile(const aZipFilename: String;
                             const aFileName: string;
                             const aPath: string = '';
                             aCreateSubdirs: Boolean = True): Boolean;
var
  loZipFile: TZipFile;
begin

  Result := True;

  Try
    Try
      loZipFile := TZipFile.Create;
      if Not FileExists(aZipFilename) then
        begin
          RuntimeErrorFmt(API_Zip_NotFileExists, [aZipFilename]);

          result := False;

          Exit;
        end;




    Except
      oMessagesLog.InternalError;

      Result := False;
    End;
  Finally
    FreeandNil(loZipFile);
  End;
end;


end.
