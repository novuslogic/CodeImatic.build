unit API_File;

interface

uses APIBase, SysUtils, API_Output, Classes, NovusFileUtils, NovusStringUtils;

type
  TAPI_File = class(TAPIBase)
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
  end;

implementation

uses System.IOUtils;

constructor TAPI_File.Create(aAPI_Output: tAPI_Output);
begin
  Inherited Create(aAPI_Output);
end;

destructor TAPI_File.Destroy;
begin
end;

function TAPI_File.Exists(const aFilename: String): Boolean;
begin
  Try
    Try
      Result := FileExists(aFilename);
    Except
      oAPI_Output.InternalError;
    End;
  Finally

  End;
end;

function TAPI_File.Copy(const aSourceFilename: String;
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

function TAPI_File.IncludeTrailingPathDelimiter(const aPath: string): String;
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

function TAPI_File.ExtractFilePath(const aFilename: string): String;
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

function TAPI_File.Extractfilename(const aFilename: string): String;
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

function TAPI_File.Delete(const aFilename: String): Boolean;
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

function TAPI_File.Move(const aSourceFilename: String;
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

function TAPI_File.AbsoluteFilePath(const aFilename: string): string;
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

function TAPI_File.IsFileInUse(const aFilename: string): Boolean;
begin
  Try
    Try
      Result := TNovusFileUtils.IsFileInUse(aFilename);
    Except
      oAPI_Output.InternalError;
    End;
  Finally

  End;
end;

function TAPI_File.IsFileReadonly(const aFilename: string): Boolean;
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

function TAPI_File.MakeTmpFileName(aExt: string; aUseGUID: Boolean): String;
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
