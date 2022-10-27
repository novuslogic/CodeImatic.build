unit API_Folders;

interface

uses APIBase, SysUtils, API_Output, Classes, NovusFileUtils, System.IOUtils;

type
  TAPI_Folders = class(TAPIBase)
  private
  protected
  public
    constructor Create(aAPI_Output: tAPI_Output); override;
    destructor Destroy; override;

    function Exists(const aFolder: String): Boolean;
    function RemoveFolder(const aFolder: String): Boolean;
    function Move(Const aSourceFolder: String;
      Const aDestFolder: String): Boolean;
    function Copy(Const aSourceFolder: String;
      Const aDestFolder: String): Boolean;
    function CreateFolder(Const aFolder: String): Boolean;
    function SetCurrentFolder(Const aFolder: String): Boolean;
    function GetCurrentFolder: String;
  end;

implementation

constructor TAPI_Folders.Create(aAPI_Output: tAPI_Output);
begin
  Inherited Create(aAPI_Output);
end;

destructor TAPI_Folders.Destroy;
begin
end;

function TAPI_Folders.Exists(Const aFolder: String): Boolean;
begin
  Try
    Try
      Result := DirectoryExists(aFolder);
    Except
      oAPI_Output.InternalError;

      Result := False;
    End;
  Finally

  End;
end;

function TAPI_Folders.RemoveFolder(Const aFolder: String): Boolean;
begin
  Try
    Try
      Result := True;

      TDirectory.Delete(aFolder, true);
    Except
      oAPI_Output.InternalError;

      Result := False;
    End;
  Finally

  End;
end;

function TAPI_Folders.Move(Const aSourceFolder: String;
  Const aDestFolder: String): Boolean;
begin
  Try
    Try
      Result := TNovusFileUtils.MoveDir(aSourceFolder, aDestFolder);
    Except


      Result := False;
    End;
  Finally

  End;
end;

function TAPI_Folders.Copy(Const aSourceFolder: String;
  Const aDestFolder: String): Boolean;
begin
  Try
    Try
//      Result := TNovusFileUtils.CopyDir(aSourceFolder, aDestFolder);
      Result := true;

      TDirectory.Copy(aSourceFolder, aDestFolder);
    Except
      oAPI_Output.InternalError;

      Result := False;
    End;
  Finally

  End;
end;

function TAPI_Folders.CreateFolder(Const aFolder: String): Boolean;
begin
  Try
    Try
      Result := True;

      TDirectory.CreateDirectory(aFolder);
    Except
      oAPI_Output.InternalError;

      Result := False;
    End;
  Finally

  End;
end;

function TAPI_Folders.SetCurrentFolder(Const aFolder: String): Boolean;
begin
  Try
    Try
      Result := SetCurrentDir(aFolder);
    Except
      oAPI_Output.InternalError;

      Result := False;
    End;
  Finally

  End;
end;

function TAPI_Folders.GetCurrentFolder: String;
begin
  Try
    Try
      Result := GetCurrentDir;
    Except
      oAPI_Output.InternalError;

      Result := '';
    End;
  Finally

  End;
end;

end.
