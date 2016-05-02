unit API_Folder;

interface

uses APIBase, SysUtils, MessagesLog, Classes, NovusFileUtils;

type
   TAPI_Folder = class(TAPIBase)
   private
   protected
   public
     constructor Create(aMessagesLog: tMessagesLog); override;
     destructor Destroy; override;

     function Exists(const aFolder: String): Boolean;
     function RemoveFolder(const aFolder: String): Boolean;
     function Move(Const aSourceFolder: String; Const aDestFolder: String): Boolean;
     function Copy(Const aSourceFolder: String; Const aDestFolder: String): Boolean;
     function CreateFolder(Const aFolder: String): Boolean;
     function SetCurrentFolder(Const aFolder: String): Boolean;
     function GetCurrentFolder: String;
   end;

implementation


constructor TAPI_Folder.create(aMessagesLog: tMessagesLog);
begin
  Inherited create(aMessagesLog);
end;

destructor TAPI_Folder.destroy;
begin
end;

function TAPI_Folder.Exists(Const aFolder: String): Boolean;
begin
  Try
    Try
      Result := DirectoryExists(aFolder);
    Except
      oMessagesLog.InternalError;
    End;
  Finally
 
  End;
end;

function TAPI_Folder.RemoveFolder(Const aFolder: String): Boolean;
begin
Try
    Try
      Result := RemoveDir(aFolder);
    Except
      oMessagesLog.InternalError;
    End;
  Finally
 
  End;
end;


function TAPI_Folder.Move(Const aSourceFolder: String; Const aDestFolder: String): Boolean;
begin
  Try
    Try
      Result := TNovusFileUtils.MoveDir(aSourceFolder, aDestFolder);
    Except
      oMessagesLog.InternalError;
    End;
  Finally

  End;
end;

function TAPI_Folder.Copy(Const aSourceFolder: String; Const aDestFolder: String): Boolean;
begin
   Try
    Try
      Result := TNovusFileUtils.CopyDir(aSourceFolder, aDestFolder);
    Except
      oMessagesLog.InternalError;
    End;
  Finally

  End;
end;


function TAPI_Folder.CreateFolder(Const aFolder: String): Boolean;
begin
  Try
    Try
      Result := CreateDir(aFolder);
    Except
      oMessagesLog.InternalError;
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
      oMessagesLog.InternalError;
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
      oMessagesLog.InternalError;
    End;
  Finally

  End;
end;

end.
