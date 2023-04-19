unit API_Files;

interface

uses APIBase, SysUtils, API_Output, Classes, NovusFileUtils, NovusStringUtils;

type
  TAPI_Files = class(TAPIBase)
  private
  protected
  public
    constructor Create(aAPI_Output: tAPI_Output); override;
    destructor Destroy; override;

    function ExtractFilePath(const aFilename: string): String;
    function AbsoluteFilePath(const aFilename: string): string;
    function Extractfilename(const aFilename: string): string;
    function IncludeTrailingPathDelimiter(const aPath: string): String;
    function Exists(const aFilename: String): Boolean;
    function Copy(const aSourceFilename: String; const aDestFilename: String;
      const aOverWrite: Boolean): Boolean;
    function Delete(const aFilename: String): Boolean;
    function Move(const aSourceFilename: String;
      const aDestFilename: String): Boolean;
    function IsFileInUse(const aFilename: String): Boolean;
    function IsFileReadonly(const aFilename: String): Boolean;
    function MakeTmpFileName(aExt: string; aUseGUID: Boolean): String;
    function RenameFile(const OldName: String; const NewName: String): boolean;
  end;

implementation

uses System.IOUtils;

constructor TAPI_Files.Create(aAPI_Output: tAPI_Output);
begin
  Inherited Create(aAPI_Output);
end;

destructor TAPI_Files.Destroy;
begin
end;

function TAPI_Files.Exists(const aFilename: String): Boolean;
begin
  Result := False;

  Try
    Try
      Result := FileExists(aFilename);
    Except
      oAPI_Output.InternalError;
    End;
  Finally

  End;
end;

function TAPI_Files.Copy(const aSourceFilename: String;
  const aDestFilename: String; const aOverWrite: Boolean): Boolean;
begin
  Try
    Try
      TFile.Copy(aSourceFilename, aDestFilename, aOverWrite);

      Result := True;

    Except
      Result := False;

      oAPI_Output.InternalError;
    End;
  Finally

  End;
end;

function TAPI_Files.IncludeTrailingPathDelimiter(const aPath: string): String;
begin
  Try
    Try
      Result := SysUtils.IncludeTrailingPathDelimiter(aPath);

    Except
      oAPI_Output.InternalError;
    End;
  Finally

  End;
end;

function TAPI_Files.ExtractFilePath(const aFilename: string): String;
begin
  Try
    Try
      Result := SysUtils.ExtractFilePath(aFilename);

    Except
      oAPI_Output.InternalError;
    End;
  Finally

  End;
end;

function TAPI_Files.Extractfilename(const aFilename: string): String;
begin
  Try
    Try
      Result := SysUtils.Extractfilename(aFilename);

    Except
      oAPI_Output.InternalError;
    End;
  Finally

  End;
end;

function TAPI_Files.Delete(const aFilename: String): Boolean;
begin
  Try
    Try
      TFile.Delete(aFilename);

      Result := True;
    Except
      Result := False;

      oAPI_Output.InternalError;
    End;
  Finally
  End;
end;

function TAPI_Files.RenameFile(const OldName: String; const NewName: String): boolean;
begin
  Try
    Try
      Result := RenameFile(Oldname, NewName);
    Except
      Result := False;

      oAPI_Output.InternalError;
    End;
  Finally
  End;
end;




function TAPI_Files.Move(const aSourceFilename: String;
  const aDestFilename: String): Boolean;
begin
  Try
    Try
      TFile.Move(aSourceFilename, aDestFilename);

      Result := True;
    Except
      Result := False;

      oAPI_Output.InternalError;
    End;
  Finally

  End;
end;

function TAPI_Files.AbsoluteFilePath(const aFilename: string): string;
begin
  Try
    Try
      Result := TNovusFileUtils.AbsoluteFilePath(aFilename);
    Except
      oAPI_Output.InternalError;
    End;
  Finally

  End;
end;

function TAPI_Files.IsFileInUse(const aFilename: string): Boolean;
begin
  Result := False;

  Try
    Try
      Result := TNovusFileUtils.IsFileInUse(aFilename);
    Except
      oAPI_Output.InternalError;
    End;
  Finally

  End;
end;

function TAPI_Files.IsFileReadonly(const aFilename: string): Boolean;
begin
  Try
    Try
      Result := TNovusFileUtils.IsFileReadonly(aFilename);
    Except
      oAPI_Output.InternalError;
    End;
  Finally

  End;
end;

function TAPI_Files.MakeTmpFileName(aExt: string; aUseGUID: Boolean): String;
begin
  Try
    Try
      Result := TNovusStringUtils.MakeTmpFileName(aExt, aUseGUID);
    Except
      oAPI_Output.InternalError;
    End;
  Finally

  End;
end;

end.
