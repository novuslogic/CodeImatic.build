unit API_Zip;

interface

uses Classes, SysUtils, Zip, APIBase, uPSRuntime, IOUtils, NovusFileUtils;

type
   TZIPOptions = class(TPersistent)
   private
   protected
     fExcludedFile: TStringList;
   public
     constructor Create; virtual;
     destructor Destroy; virtual;

     property ExcludedFile: TStringlist
       read fExcludedFile write fExcludedFile;


   end;



   TAPI_Zip = class(TAPIBase)
   private
   protected
   public
     function ZipCompress(const aZipFilename: String;
                          const aPath: String;
                          const aFileMasks: String;
                          const aZIPOptions: TZIPOptions): Boolean;

     function ZipGetFileNameList(const aZipFilename: String; var aZipStringList: TStringList): Boolean;
     function ZipExtractAll(const aZipFilename: String; const aPath: string): Boolean;
     function ZipExtractFile(const aZipFilename: String;
                             const aFileName: string;
                             const aPath: string): Boolean;
   end;

Const
   API_Zip_NotFileExists = 'ZipFilename cannot be found [%s]';
   API_Zip_FileInUse = 'Cannot add this file being used [%s]';


implementation

//TAPI_Zip

function TAPI_Zip.ZipCompress(const aZipFilename: String;
                              const aPath: String;
                              const aFileMasks: String;
                              const aZIPOptions: TZIPOptions): Boolean;
var
  loZipFile: TZipFile;
  LsPath: String;
  LsFile: string;
  LsZFile: string;
  lsFileMasks: String;
begin
  Result := True;

  Try
    Try
      loZipFile := TZipFile.Create;
      if  FileExists(aZipFilename) then
        loZipFile.Open(aZipFilename, zmReadWrite)
      else loZipFile.Open(aZipFilename, zmWrite);

      LsPath := IncludeTrailingPathDelimiter(aPath);

      lsFileMasks := aFileMasks;
      if aFileMasks = '' then lsFileMasks := '*';

      for LsFile in TDirectory.GetFiles(aPath, lsFileMasks, TSearchOption.soAllDirectories) do
    begin
{$IFDEF MSWINDOWS}
      LsZFile := StringReplace(Copy(LsFile, Length(LsPath) + 1, Length(LsFile)), '\', '/', [rfReplaceAll]);
{$ELSE}
      LsZFile := Copy(LFile, Length(LPath) + 1, Length(LFile));
{$ENDIF MSWINDOWS}

      if Not TNovusFileUtils.IsFileInUse(LsFile) then
        loZipFile.Add(LsFile, LsZFile, zcDeflate)
      else
         begin
           RuntimeErrorFmt(API_Zip_FileInUse, [LsFile]);

           loZipFile.Close;

           result := False;

           Exit;
         end;

    end;

      loZipFile.Close;
    Except
      oMessagesLog.InternalError;

      Result := False;
    End;
  Finally
    FreeandNil(loZipFile);
  End;
end;

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



function TAPI_Zip.ZipGetFileNameList(const aZipFilename: String; var aZipStringList: TStringList): Boolean;
var
  loZipFile: TZipFile;
  lFilenames: TArray<string>;
  S: String;
begin
  Result := True;

  Try
    Try
      loZipFile := TZipFile.Create;
      if Not FileExists(aZipFilename) then
        begin
          RuntimeErrorFmt(API_Zip_NotFileExists, [aZipFilename]);

          Result := False;

          Exit;
        end;

      loZipFile.Open(aZipFilename, zmRead);

      if Not Assigned(aZipStringList) then
        aZipStringList := TStringList.Create;

      lFilenames := loZipFile.FileNames;
      if Assigned(lFilenames) then
        begin
          for s in lFilenames do
             aZipStringList.Add(s);
        end;

      loZipFile.Close;
    Except
      oMessagesLog.InternalError;

      Result := False;
    End;
  Finally
    FreeandNil(loZipFile);
  End;
end;


// TZIPOptions

constructor TZIPOptions.create;
begin
  fExcludedFile := TStringlist.Create;
end;

destructor TZIPOptions.destroy;
begin
  fExcludedFile.Free;
end;


end.
