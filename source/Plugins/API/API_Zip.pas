unit API_Zip;

interface

uses Classes, SysUtils, APIBase, uPSRuntime, IOUtils, NovusFileUtils,
     AbZipper, AbArcTyp, AbZBrows, {AbMeter,} AbBrowse, AbBase, AbUnzper, AbZipKit,
     AbZipTyp, AbUtils, StrUtils ;

type
   TZIPEvent = procedure of object;

   TZIPOptions = class(TPersistent)
   private
   protected
     fExcludedFile: TStringList;
     fsPassword: String;
     fbOutput: Boolean;
   public
     constructor Create; virtual;
     destructor Destroy; virtual;

     property ExcludedFile: TStringlist
       read fExcludedFile write fExcludedFile;

     property Password: String
       read fsPassword write fsPassword;

     property Output: Boolean
       read fbOutput write fbOutput;

   end;

   TAPI_Zip = class(TAPIBase)
   private
   protected
     fBeforeZIPEvent: TZIPEvent;
     fAfterZIPEvent: TZIPEvent;
     procedure ConfirmProcessItem(Sender: TObject; Item: TAbArchiveItem;
         ProcessType: TAbProcessType; var Confirm: Boolean);
   public
     ///	<summary>
     ///	  Create a new .zip file with specified file(s). The fileMasks may
     ///	  contain wildcards and relative paths to include portion of the path
     ///	  in the zip itself.
     ///	</summary>
     ///	<param name="aZipFilename">
     ///	  Zip Filename
     ///	</param>
     ///	<param name="aPath">
     ///	  Path to Zip Filename
     ///	</param>
     function Compress(const aZipFilename: String;
                          const aPath: String;
                          const aFileMasks: String;
                          const aZIPOptions: TZIPOptions): Boolean;

     function BrowserList(const aZipFilename: String; var aZipStringList: TStringList; const aIncludePath: Boolean; const aZIPOptions: TZIPOptions): Boolean;
     function ExtractAll(const aZipFilename: String; const aPath: string; const aZIPOptions: TZIPOptions): Boolean;
     function ExtractFile(const aZipFilename: String;
                             const aFileName: string;
                             const aPath: string;
                             const aZIPOptions: TZIPOptions): Boolean;


     property OnBeforeZIPEvent: TZIPEvent
       read fBeforeZIPEvent write fBeforeZIPEvent;

      property OnAfterZIPEvent: TZIPEvent
       read fAfterZIPEvent write fAfterZIPEvent;
   end;

Const
   API_Zip_NotFileExists = 'ZipFilename cannot be found [%s]';
   API_Zip_FileInUse = 'Cannot add this file being used [%s]';


implementation

//TAPI_Zip

procedure TAPI_Zip.ConfirmProcessItem(Sender: TObject; Item: TAbArchiveItem; ProcessType: TAbProcessType; var Confirm: Boolean);
Var
  lsMessageLog: String;
begin
  case ProcessType of
    ptAdd: lsMessageLog := 'Add ..' + Item.DiskPath + Item.FileName;
    ptDelete:lsMessageLog := 'Delete ..' + Item.DiskPath + Item.FileName;
    ptExtract: lsMessageLog := 'Extract ..' + Item.DiskPath + Item.FileName;
    ptFreshen: lsMessageLog := 'Refresh ..' + Item.DiskPath + Item.FileName;
    ptMove: lsMessageLog := 'Move ..' + Item.DiskPath + Item.FileName;
    ptReplace: lsMessageLog := 'Replace ..' + Item.DiskPath + Item.FileName;
    ptFoundUnhandled: lsMessageLog := 'Found Unhandled ..' + Item.DiskPath + Item.FileName;
  end;

  oAPI_Output.Log(lsMessageLog);
end;


function TAPI_Zip.Compress(const aZipFilename: String;
                              const aPath: String;
                              const aFileMasks: String;
                              const aZIPOptions: TZIPOptions): Boolean;
var
  loZipFile: tAbZipper;
  LsPath: String;
  LsFile: string;
  LsZFile: string;
  lsFileMasks: String;
  Filter: TDirectory.TFilterPredicate;

begin
  Result := True;

  Filter := function(const Path: string; const SearchRec: TSearchRec): Boolean
  var
      I: Integer;
    begin
      Result := False;

      if Assigned(aZIPOptions) then
        begin
          for I := 0 to aZIPOptions.ExcludedFile.Count - 1 do
            begin
              Result := Not (TPath.MatchesPattern(SearchRec.Name, aZIPOptions.ExcludedFile.Strings[i], False));
              if (Result = false) then break;
            end;
        end
      else
        Result := True;
    end;


  Try
    Try
      loZipFile := tAbZipper.Create(NIL);
      loZipFile.AutoSave := false;
      loZipFile.DOSMode := False;
      loZipFile.CompressionMethodToUse := smBestMethod;
      loZipFile.DeflationOption := doNormal;

      if assigned(fBeforeZipEvent) then
         fBeforeZipEvent();

      if Assigned(aZIPOptions) then
        begin
          loZipFile.Password := aZIPOptions.Password;
          loZipFile.OnConfirmProcessItem := ConfirmProcessItem;
        end;

      if  FileExists(aZipFilename) then
         loZipFile.StoreOptions := [soStripDrive,  soFreshen, soReplace, soRemoveDots]
      else loZipFile.StoreOptions := [soStripDrive, soRemoveDots];

      loZipFile.FileName := aZipFilename;

      LsPath := IncludeTrailingPathDelimiter(aPath);

      lsFileMasks := aFileMasks;
      if aFileMasks = '' then lsFileMasks := '*';

      loZipFile.BaseDirectory := lsPath;

      for LsFile in TDirectory.GetFiles(lsPath, lsFileMasks, TSearchOption.soAllDirectories, Filter) do
        begin
          {$IFDEF MSWINDOWS}
          LsZFile := StringReplace(Copy(LsFile, Length(LsPath) + 1, Length(LsFile)), '\', '/', [rfReplaceAll]);
          {$ELSE}
          LsZFile := Copy(LFile, Length(LPath) + 1, Length(LFile));
          {$ENDIF MSWINDOWS}

          if Not TNovusFileUtils.IsFileInUse(LsFile) then
            begin
              LsZFile := StrUtils.ReplaceStr(LsFile, lsPath, '');

              loZipFile.AddFiles(LsZFile, faAnyFile  );

              Result := True;
            end
           else
             begin
               RuntimeErrorFmt(API_Zip_FileInUse, [LsFile]);

               result := False;

               Exit;
             end;
      end;
      oAPI_Output.Log('Saving ' + aZipFilename );

      loZipFile.Save;

      loZipFile.CloseArchive;


      if assigned(fAfterZipEvent) then
         fAfterZipEvent();
    Except
      oAPI_Output.InternalError;

      Result := False;
    End;
  Finally
    FreeandNil(loZipFile);
  End;

end;

function TAPI_Zip.ExtractAll(const aZipFilename: String;
                                const aPath: string;
                                const aZIPOptions: TZIPOptions): Boolean;
var
  loZipFile: TAbUnZipper;
begin
  Result := True;

  Try
    Try
      loZipFile := TAbUnZipper.Create(NIL);
      if Not FileExists(aZipFilename) then
        begin
          RuntimeErrorFmt(API_Zip_NotFileExists, [aZipFilename]);

          result := False;

          Exit;
        end;


      if Assigned(aZIPOptions) then
        begin
          loZipFile.Password := aZIPOptions.Password;
          loZipFile.OnConfirmProcessItem := ConfirmProcessItem;
        end;



      loZipFile.Filename := aZipFilename;

      loZipFile.BaseDirectory := IncludeTrailingPathDelimiter(apath);

      loZipFile.ExtractFiles('*');
    Except
      oAPI_Output.InternalError;

      Result := False;
    End;
  Finally
    FreeandNil(loZipFile);
  End;

end;

function TAPI_Zip.ExtractFile(const aZipFilename: String;
                             const aFileName: string;
                             const aPath: string;
                             const aZIPOptions: TZIPOptions): Boolean;
var
  loZipFile: TAbUnZipper;
begin
  Result := True;

  Try
    Try
      loZipFile := TAbUnZipper.Create(NIL);

      if not FileExists(aZipFilename) then
        begin
          RuntimeErrorFmt(API_Zip_NotFileExists, [aZipFilename]);

          result := False;

          Exit;
        end;


      if Assigned(aZIPOptions) then
        begin
          loZipFile.Password := aZIPOptions.Password;
          loZipFile.OnConfirmProcessItem := ConfirmProcessItem;
        end;



      loZipFile.Filename := aZipFilename;

      loZipFile.BaseDirectory := IncludeTrailingPathDelimiter(apath);

      loZipFile.ExtractFiles(aFileName);
    Except
      oAPI_Output.InternalError;

      Result := False;
    End;
  Finally
    FreeandNil(loZipFile);
  End;

end;



function TAPI_Zip.BrowserList(const aZipFilename: String;
                                 var aZipStringList: TStringList;
                                 const aIncludePath: Boolean;
                                 const aZIPOptions: TZIPOptions): Boolean;
var
  loZipFile: TAbZipKit;
  I: Integer;
  loZipItem: TAbZipItem;
  S: String;
begin
  Result := True;

  Try
    Try
      loZipFile:= TAbZipKit.Create(nil);

      if Not FileExists(aZipFilename) then
        begin
          RuntimeErrorFmt(API_Zip_NotFileExists, [aZipFilename]);

          Result := False;

          Exit;
        end;


      if Assigned(aZIPOptions) then
        begin
          loZipFile.Password := aZIPOptions.Password;
          loZipFile.OnConfirmProcessItem := ConfirmProcessItem;
        end;



      loZipFile.Filename := aZipFilename;

      if Not Assigned(aZipStringList) then
        aZipStringList := TStringList.Create;

      for I := 0 to loZipFile.Count - 1 do
        begin
          loZipItem := loZipFile.Items[i];

          s := '';
          if aIncludePath then
            s := loZipItem.DiskPath;

          s := s +  loZipItem.FileName;


          aZipStringList.Add(s);
        end;
    Except
      oAPI_Output.InternalError;

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

  fExcludedFile.Delimiter := ',';
end;

destructor TZIPOptions.destroy;
begin
  fExcludedFile.Free;
end;


end.
