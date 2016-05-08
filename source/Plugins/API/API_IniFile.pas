unit API_IniFile;

interface

uses APIBase, SysUtils, MessagesLog, Classes, IniFiles;

type
   TAPI_IniFile = class(TAPIBase)
   private
   protected
   public
     constructor Create(aMessagesLog: tMessagesLog); override;
     destructor Destroy; override;

     procedure WriteString(const aFilename: string;const aSection: string; const aKey: String; const aValue: String);
     function ReadString(const aFilename: string;const aSection: string; const aKey: String): String;
     function DeleteSection(const aFilename: string;const aSection: string) : Boolean;
     function DeleteKey(const aFilename: string;const aSection: string; const aKey: string): boolean;


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

procedure TAPI_IniFile.WriteString(const aFilename: string;const aSection: string; const aKey: String; const aValue: String);
var
  foIniFile: TIniFile;
begin
  if Not FileExists(aFilename) then
    begin
      RuntimeErrorFmt(API_IniFile_cannot_find_filename, [aFilename]);

      Exit;
    end;


  Try
    Try
      foIniFile:= TIniFile.Create(aFilename);

      foIniFile.WriteString(aSection, aKey, aValue);
    Except
      oMessagesLog.InternalError;
    End;
  Finally
    foIniFile.Free;
  End;
end;

function TAPI_IniFile.ReadString(const aFilename: string;const aSection: string; const aKey: String): String;
var
  foIniFile: TIniFile;
begin
  if Not FileExists(aFilename) then
    begin
      RuntimeErrorFmt(API_IniFile_cannot_find_filename, [aFilename]);

      Exit;
    end;

  Try
    Try
      foIniFile:= TIniFile.Create(aFilename);

      Result := foIniFile.ReadString(aSection, aKey, '')
    Except
      oMessagesLog.InternalError;
    End;
  Finally
    foIniFile.Free;
  End;
end;

function TAPI_IniFile.DeleteSection(const aFilename: string;const aSection: string) : Boolean;
var
  foIniFile: TIniFile;
begin
   if Not FileExists(aFilename) then
    begin
      RuntimeErrorFmt(API_IniFile_cannot_find_filename, [aFilename]);

      Exit;
    end;


   Try
    Try
      foIniFile:= TIniFile.Create(aFilename);

      foIniFile.EraseSection(aSection);

      Result := True;
    Except
      oMessagesLog.InternalError;

      result := False;
    End;
  Finally
    foIniFile.Free;
  End;
end;

function TAPI_IniFile.DeleteKey(const aFilename: string;const aSection: string; const aKey: string) : Boolean;
var
  foIniFile: TIniFile;
begin
  if Not FileExists(aFilename) then
    begin
      RuntimeErrorFmt(API_IniFile_cannot_find_filename, [aFilename]);

      Exit;
    end;

  Try
    Try
      foIniFile:= TIniFile.Create(aFilename);

      foIniFile.DeleteKey(aSection, aKey);

      Result := True;
    Except
      oMessagesLog.InternalError;

      result := False;
    End;
  Finally
    foIniFile.Free;
  End;
end;


end.
