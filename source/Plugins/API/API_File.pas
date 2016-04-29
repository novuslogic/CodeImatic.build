unit API_File;

interface

uses APIBase, SysUtils, MessagesLog, Classes, NovusFileUtils;

type
   TAPI_File = class(TAPIBase)
   private
   protected
   public
     constructor Create(aMessagesLog: tMessagesLog); override;
     destructor Destroy; override;

     function Exists(aFilename: String): Boolean;
     function Copy(aSourceFilename: String; aDestFilename: String; aOverWrite : Boolean ): Boolean;
     function Delete(aFilename: String): Boolean;
     function Move(aSourceFilename: String; aDestFilename: String): Boolean;
   end;

implementation

uses System.IOUtils;

constructor TAPI_File.create(aMessagesLog: tMessagesLog);
begin
  Inherited create(aMessagesLog);
end;

destructor TAPI_File.destroy;
begin
end;


function TAPI_File.Exists(aFilename: String): Boolean;
begin
  Try
    Try
      Result := FileExists(aFilename);
    Except
      oMessagesLog.InternalError;
    End;
  Finally

  End;
end;

function TAPI_File.Copy(aSourceFilename: String; aDestFilename: String; aOverWrite : Boolean ): Boolean;
begin
  Try
    Try
      TFile.Copy(aSourceFilename, aDestFilename, aOverWrite);

    Except
      oMessagesLog.InternalError;
    End;
  Finally

  End;
end;

function TAPI_File.Delete(aFilename: String): Boolean;
begin
   Try
    Try
      TFile.Delete(aFilename);
    Except
      oMessagesLog.InternalError;
    End;
  Finally

  End;
end;


function TAPI_File.Move(aSourceFilename: String; aDestFilename: String): Boolean;
begin
  Try
    Try
      TFile.Move(aSourceFilename,aDestFilename);
    Except
      oMessagesLog.InternalError;
    End;
  Finally

  End;



end;

end.
