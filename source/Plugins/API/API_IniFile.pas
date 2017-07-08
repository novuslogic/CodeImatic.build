unit API_IniFile;

interface

uses APIBase, SysUtils, API_Output, Classes, IniFiles;

type
  TAPI_IniFile = class(TAPIBase)
  private
  protected
  public
    constructor Create(aAPI_Output: tAPI_Output); override;
    destructor Destroy; override;

    procedure WriteString(const aFilename: string; const aSection: string;
      const aKey: String; const aValue: String);
    function ReadString(const aFilename: string; const aSection: string;
      const aKey: String): String;
    function DeleteSection(const aFilename: string;
      const aSection: string): Boolean;
    function DeleteKey(const aFilename: string; const aSection: string;
      const aKey: string): Boolean;

  end;

Const
  API_IniFile_cannot_find_filename = 'Cannot find filename [%s]';

implementation

constructor TAPI_IniFile.Create(aAPI_Output: tAPI_Output);
begin
  Inherited Create(aAPI_Output);
end;

destructor TAPI_IniFile.Destroy;
begin
  Inherited

end;

procedure TAPI_IniFile.WriteString(const aFilename: string;
  const aSection: string; const aKey: String; const aValue: String);
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
      foIniFile := TIniFile.Create(aFilename);

      foIniFile.WriteString(aSection, aKey, aValue);
    Except
      oAPI_Output.InternalError;
    End;
  Finally
    foIniFile.Free;
  End;
end;

function TAPI_IniFile.ReadString(const aFilename: string;
  const aSection: string; const aKey: String): String;
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
      foIniFile := TIniFile.Create(aFilename);

      Result := foIniFile.ReadString(aSection, aKey, '')
    Except
      oAPI_Output.InternalError;
    End;
  Finally
    foIniFile.Free;
  End;
end;

function TAPI_IniFile.DeleteSection(const aFilename: string;
  const aSection: string): Boolean;
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
      foIniFile := TIniFile.Create(aFilename);

      foIniFile.EraseSection(aSection);

      Result := True;
    Except
      oAPI_Output.InternalError;

      Result := False;
    End;
  Finally
    foIniFile.Free;
  End;
end;

function TAPI_IniFile.DeleteKey(const aFilename: string; const aSection: string;
  const aKey: string): Boolean;
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
      foIniFile := TIniFile.Create(aFilename);

      foIniFile.DeleteKey(aSection, aKey);

      Result := True;
    Except
      oAPI_Output.InternalError;

      Result := False;
    End;
  Finally
    foIniFile.Free;
  End;
end;

end.
