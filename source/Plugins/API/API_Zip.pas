unit API_Zip;

interface

uses Classes, SysUtils, Zip, APIBase;

type
   TAPI_Zip = class(TAPIBase)
   private
   protected
   public
     function ZipCompress: Boolean;
     function ZipExtractAll: Boolean;
     function ZipExtractFile(const aArchiveFilename: String;
                             const aFileName: string;
                             const aPath: string = '';
                             aCreateSubdirs: Boolean = True): Boolean;
   end;


implementation


function TAPI_Zip.ZipCompress;
begin
  Result := False;
end;

function TAPI_Zip.ZipExtractAll;
begin
  Result := False;
end;

function TAPI_Zip.ZipExtractFile(const aArchiveFilename: String;
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
      if Not FileExists(aArchiveFilename) then
        begin
         // TPSPascalCompiler(Sender).MakeError('', ecUnknownIdentifier, Name);

          result := False;
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
