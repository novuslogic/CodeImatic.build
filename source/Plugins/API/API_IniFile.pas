unit API_IniFile;

interface

uses APIBase, SysUtils, Registry, MessagesLog, Classes;

type
   TIniFile = class(TPersistent)
   private
   protected
     foMessagesLog: tMessagesLog;
     fsFilename: String;
     foRegIniFile: TRegIniFile;
   public
     constructor Create(aFilename: String; aMessagesLog: tMessagesLog);
     destructor Destroy; override;

     procedure WriteString(const aSection: string; const aKey: String; const aValue: String);
     function ReadString(const aSection: string; const aKey: String; const aDefault: string): String;
     function DeleteSection(const aSection: string) : Boolean;
     function DeleteKey(const aSection: string; const aKey: string): boolean;

   end;


   TAPI_IniFile = class(TAPIBase)
   private
   protected
   public
     constructor Create(aMessagesLog: tMessagesLog); override;
     destructor Destroy; override;

     function OpenIniFile(aFilename: String): TIniFile;
   end;

Const
   API_IniFile_cannot_find_filename = 'Cannot find filename [%s]';

implementation


constructor TAPI_IniFile.create(aMessagesLog: tMessagesLog);
begin
  Inherited create(aMessagesLog);
end;

destructor TAPI_IniFile.destroy;
begin
  Inherited

end;

function TAPI_IniFile.OpenIniFile(aFilename: String): TIniFile;
begin
  Result := NIL;

  if Not FileExists(aFilename) then
    begin
      RuntimeErrorFmt(API_IniFile_cannot_find_filename, [aFilename]);

      Exit;
    end;


  Try
    Result := TInifile.Create(aFilename, oMessagesLog);


  Except
    oMessagesLog.InternalError;
  End;


end;


//TIniFile

constructor TIniFile.create(aFilename: String; aMessagesLog: tMessagesLog);
begin
  foMessagesLog := aMessagesLog;
  fsFilename := aFilename;
end;

destructor TIniFile.destroy;
begin
  Inherited;

  foRegIniFile.Free;
end;

procedure TIniFile.WriteString(const aSection: string; const aKey: String; const aValue: String);
begin
  Try
    Try
      foRegIniFile:= TRegIniFile.Create(fsFilename);

      foRegIniFile.WriteString(aSection, aKey, aValue);
    Except
      foMessagesLog.InternalError;
    End;
  Finally
    foRegIniFile.Free;
  End;
end;

function TIniFile.ReadString(const aSection: string; const aKey: String; const aDefault: string): String;
begin
  Try
    Try
      foRegIniFile:= TRegIniFile.Create(fsFilename);

      Result := foRegIniFile.ReadString(aSection, aKey, aDefault)
    Except
      foMessagesLog.InternalError;
    End;
  Finally
    foRegIniFile.Free;
  End;
end;

function TIniFile.DeleteSection(const aSection: string) : Boolean;
begin
   Try
    Try
      foRegIniFile:= TRegIniFile.Create(fsFilename);

      foRegIniFile.EraseSection(aSection);

      Result := True;
    Except
      foMessagesLog.InternalError;

      result := False;
    End;
  Finally
    foRegIniFile.Free;
  End;
end;

function TIniFile.DeleteKey(const aSection: string; const aKey: string) : Boolean;
begin
   Try
    Try
      foRegIniFile:= TRegIniFile.Create(fsFilename);

      foRegIniFile.DeleteKey(aSection, aKey);

      Result := True;
    Except
      foMessagesLog.InternalError;

      result := False;
    End;
  Finally
    foRegIniFile.Free;
  End;
end;


end.
