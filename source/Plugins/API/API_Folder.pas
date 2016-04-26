unit API_Folder;

interface

uses APIBase, SysUtils, MessagesLog, Classes;

type
   TAPI_Folder = class(TAPIBase)
   private
   protected
   public
     constructor Create(aMessagesLog: tMessagesLog); override;
     destructor Destroy; override;

     function Exists(aFolder: String): Boolean;
   end;

implementation


constructor TAPI_Folder.create(aMessagesLog: tMessagesLog);
begin
  Inherited create(aMessagesLog);
end;

destructor TAPI_Folder.destroy;
begin
end;

function TAPI_Folder.Exists(aFolder: String): Boolean;
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

end.
