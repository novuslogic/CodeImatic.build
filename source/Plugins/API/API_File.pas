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

     function IncludeTrailingPathDelimiter(const s: string): String;
     function Exists(const aFilename: String): Boolean;
     function Copy(const aSourceFilename: String; const aDestFilename: String; const aOverWrite : Boolean ): Boolean;
     function Delete(const aFilename: String): Boolean;
     function Move(const aSourceFilename: String; const aDestFilename: String): Boolean;
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


function TAPI_File.Exists(const aFilename: String): Boolean;
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

function TAPI_File.Copy(const aSourceFilename: String; const aDestFilename: String; const aOverWrite : Boolean ): Boolean;
begin
  Try
    Try
      TFile.Copy(aSourceFilename, aDestFilename, aOverWrite);

      Result := True;

    Except
      Result := False;

      oMessagesLog.InternalError;
    End;
  Finally

  End;
end;

function TAPI_File.IncludeTrailingPathDelimiter(const s: string): String;
begin
  Try
    Try
      Result := SysUtils.IncludeTrailingPathDelimiter(s);

    Except
      oMessagesLog.InternalError;
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

      oMessagesLog.InternalError;
    End;
  Finally

  End;
end;


function TAPI_File.Move(const aSourceFilename: String; const aDestFilename: String): Boolean;
begin
  Try
    Try
      TFile.Move(aSourceFilename,aDestFilename);

      Result := true;
    Except
      Result := False;

      oMessagesLog.InternalError;
    End;
  Finally

  End;



end;

end.
