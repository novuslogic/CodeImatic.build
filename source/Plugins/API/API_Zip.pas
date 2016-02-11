unit API_Zip;

interface

uses Classes, SysUtils, Zip, APIBase, uPSRuntime;

type
   TAPI_Zip = class(TAPIBase)
   private
   protected
   public
     function ZipGetFileNames(const aZipFilename: String): TStringList;
     function ZipExtractAll(const aZipFilename: String; const aPath: string): Boolean;
     function ZipExtractFile(const aZipFilename: String;
                             const aFileName: string;
                             const aPath: string): Boolean;
   end;

Const
   API_Zip_NotFileExists = 'ZipFilename cannot be found [%s]';


implementation

function TAPI_Zip.ZipExtractAll(const aZipFilename: String; const aPath: string): Boolean;
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

      loZipFile.Open(aZipFilename, zmRead);

      loZipFile.ExtractAll(apath);

      loZipFile.Close;
    Except
      oMessagesLog.InternalError;

      Result := False;
    End;
  Finally
    FreeandNil(loZipFile);
  End;
end;

function TAPI_Zip.ZipExtractFile(const aZipFilename: String;
                             const aFileName: string;
                             const aPath: string): Boolean;
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

      loZipFile.Open(aZipFilename, zmRead);

      loZipFile.Extract(aFileName,
                        aPath);


      loZipFile.Close;
    Except
      oMessagesLog.InternalError;

      Result := False;
    End;
  Finally
    FreeandNil(loZipFile);
  End;
end;

function TAPI_Zip.ZipGetFileNames(const aZipFilename: String): TStringList;
var
  loZipFile: TZipFile;
  lFilenames: TArray<string>;
  S: String;
begin
  Result := NIL;

  Try
    Try
      loZipFile := TZipFile.Create;
      if Not FileExists(aZipFilename) then
        begin
          RuntimeErrorFmt(API_Zip_NotFileExists, [aZipFilename]);

          Exit;
        end;

      loZipFile.Open(aZipFilename, zmRead);

      lFilenames := loZipFile.FileNames;
      if Assigned(lFilenames) then
        begin
          Result := TStringList.Create;

          for s in lFilenames do
            Result.Add(s);
        end;




      loZipFile.Close;
    Except
      oMessagesLog.InternalError;

      if Assigned(result) then
        begin
          Freeandnil(Result);

        end;

    End;
  Finally
    FreeandNil(loZipFile);
  End;
end;


end.
