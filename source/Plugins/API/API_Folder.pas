unit API_Folder;

interface

uses APIBase, SysUtils, API_Output, Classes, NovusFileUtils, System.IOUtils;

type
  TAPI_Folder = class(TAPIBase)
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

constructor TAPI_Folder.Create(aAPI_Output: tAPI_Output);
begin
  Inherited Create(aAPI_Output);
end;

destructor TAPI_Folder.Destroy;
begin
end;

function TAPI_Folder.Exists(Const aFolder: String): Boolean;
begin
  Try
    Try
      Result := DirectoryExists(aFolder);
    Except
      oAPI_Output.InternalError;
    End;
  Finally

  End;
end;

function TAPI_Folder.RemoveFolder(Const aFolder: String): Boolean;
begin
  Try
    Try
      TDirectory.Delete(aFolder, true);
    Except
      oAPI_Output.InternalError;
    End;
  Finally

  End;
end;

function TAPI_Folder.Move(Const aSourceFolder: String;
  Const aDestFolder: String): Boolean;
begin
  Try
    Try
      Result := TNovusFileUtils.MoveDir(aSourceFolder, aDestFolder);
    Except
      oAPI_Output.InternalError;
    End;
  Finally

  End;
end;

function TAPI_Folder.Copy(Const aSourceFolder: String;
  Const aDestFolder: String): Boolean;
begin
  Try
    Try
      Result := TNovusFileUtils.CopyDir(aSourceFolder, aDestFolder);
    Except
      oAPI_Output.InternalError;
    End;
  Finally

  End;
end;

function TAPI_Folder.CreateFolder(Const aFolder: String): Boolean;
begin
  Try
    Try
      TDirectory.CreateDirectory(aFolder);
    Except
      oAPI_Output.InternalError;
    End;
  Finally

  End;
end;

function TAPI_Folder.SetCurrentFolder(Const aFolder: String): Boolean;
begin
  Try
    Try
      Result := SetCurrentDir(aFolder);
    Except
      oAPI_Output.InternalError;
    End;
  Finally

  End;
end;

function TAPI_Folder.GetCurrentFolder: String;
begin
  Try
    Try
      Result := GetCurrentDir;
    Except
      oAPI_Output.InternalError;
    End;
  Finally

  End;
end;

end.
