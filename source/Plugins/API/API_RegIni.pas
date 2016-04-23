unit API_RegIni;

interface

uses APIBase, SysUtils, Registry, MessagesLog, Classes;

type
   TAPI_RegIni = class(TAPIBase)
   private
     foRegistry: tRegistry;
   protected
   public
     constructor Create(aMessagesLog: tMessagesLog); overload;
     destructor Destroy;

     procedure CloseKey;
     function CreateKey(const Key: string): Boolean;
     function DeleteKey(const Key: string): Boolean;
     function DeleteValue(const Name: string): Boolean;
     function GetDataAsString(const ValueName: string; PrefixType: Boolean = false): string;
     function GetDataInfo(const ValueName: string; var Value: TRegDataInfo): Boolean;
     function GetDataSize(const ValueName: string): Integer;
     function GetDataType(const ValueName: string): TRegDataType;
     function GetKeyInfo(var Value: TRegKeyInfo): Boolean;
     procedure GetKeyNames(Strings: TStrings);
     procedure GetValueNames(Strings: TStrings);
     function HasSubKeys: Boolean;
     function KeyExists(const Key: string): Boolean;
     function LoadKey(const Key, FileName: string): Boolean;
     procedure MoveKey(const OldName, NewName: string; Delete: Boolean);
     function OpenKey(const Key: string; CanCreate: Boolean): Boolean;
     function OpenKeyReadOnly(const Key: String): Boolean;
     function ReadCurrency(const Name: string): Currency;
     function ReadBinaryData(const Name: string; var Buffer; BufSize: Integer): Integer;
     function ReadBool(const Name: string): Boolean;
     function ReadDate(const Name: string): TDateTime;
     function ReadDateTime(const Name: string): TDateTime;
     function ReadFloat(const Name: string): Double;
     function ReadInteger(const Name: string): Integer;
     function ReadString(const Name: string): string;
     function ReadTime(const Name: string): TDateTime;
     function RegistryConnect(const UNCName: string): Boolean;
     procedure RenameValue(const OldName, NewName: string);
     function ReplaceKey(const Key, FileName, BackUpFileName: string): Boolean;
     function RestoreKey(const Key, FileName: string): Boolean;
     function SaveKey(const Key, FileName: string): Boolean;
     function UnLoadKey(const Key: string): Boolean;
     function ValueExists(const Name: string): Boolean;
     procedure WriteCurrency(const Name: string; Value: Currency);
     procedure WriteBinaryData(const Name: string; var Buffer; BufSize: Integer);
     procedure WriteBool(const Name: string; Value: Boolean);
     procedure WriteDate(const Name: string; Value: TDateTime);
     procedure WriteDateTime(const Name: string; Value: TDateTime);
     procedure WriteFloat(const Name: string; Value: Double);
     procedure WriteInteger(const Name: string; Value: Integer);
     procedure WriteString(const Name, Value: string);
     procedure WriteExpandString(const Name, Value: string);
     procedure WriteTime(const Name: string; Value: TDateTime);

     (*
     property CurrentKey: HKEY read FCurrentKey;
     property CurrentPath: string read FCurrentPath;
     property LazyWrite: Boolean read FLazyWrite write FLazyWrite;
     property LastError: Longint read FLastError;
     property LastErrorMsg: string read GetLastErrorMsg;
     property RootKey: HKEY read FRootKey write SetRootKey;
     property RootKeyName: string read GetRootKeyName;
     property Access: LongWord read FAccess write FAccess;
     *)
   end;



implementation


constructor TAPI_RegIni.create(aMessagesLog: tMessagesLog);
begin
  Inherited create(aMessagesLog);

  foRegistry := tRegistry.Create;


end;

destructor TAPI_RegIni.destroy;
begin
  foRegistry.Free;

end;

procedure TAPI_RegIni.CloseKey;
begin
  foRegistry.CloseKey;
end;

function TAPI_RegIni.CreateKey(const Key: string): Boolean;
begin
  Result :=  foRegistry.CreateKey(Key);
end;

function TAPI_RegIni.DeleteKey(const Key: string): Boolean;
begin
  Result :=  foRegistry.DeleteKey(Key);
end;

function TAPI_RegIni.DeleteValue(const Name: string): Boolean;
begin
  Result :=  foRegistry.DeleteValue(Name);
end;

function TAPI_RegIni.GetDataAsString(const ValueName: string; PrefixType: Boolean = false): string;
begin
  Result :=  foRegistry.GetDataAsString(ValueName,PrefixType);
end;

function TAPI_RegIni.GetDataInfo(const ValueName: string; var Value: TRegDataInfo): Boolean;
begin
  Result := foRegistry.GetDataInfo(ValueName, Value);
end;

function TAPI_RegIni.GetDataSize(const ValueName: string): Integer;
begin
  Result := foRegistry.GetDataSize(ValueName);
end;

function TAPI_RegIni.GetDataType(const ValueName: string): TRegDataType;
begin
  Result := foRegistry.GetDataType(ValueName);
end;

function TAPI_RegIni.GetKeyInfo(var Value: TRegKeyInfo): Boolean;
begin
  Result := foRegistry.GetKeyInfo(Value);
end;

procedure TAPI_RegIni.GetKeyNames(Strings: TStrings);
begin
  foRegistry.GetKeyNames(Strings);
end;

procedure TAPI_RegIni.GetValueNames(Strings: TStrings);
begin
  foRegistry.GetValueNames(Strings);
end;

function TAPI_RegIni.HasSubKeys: Boolean;
begin
  Result := foRegistry.HasSubKeys;
end;

function TAPI_RegIni.KeyExists(const Key: string): Boolean;
begin
  Result := foRegistry.KeyExists(Key);
end;

function TAPI_RegIni.LoadKey(const Key, FileName: string): Boolean;
begin
  Result := foRegistry.LoadKey(Key, FileName);
end;

procedure TAPI_RegIni.MoveKey(const OldName, NewName: string; Delete: Boolean);
begin
  foRegistry.MoveKey(OldName, NewName, Delete);
end;

function TAPI_RegIni.OpenKey(const Key: string; CanCreate: Boolean): Boolean;
begin
  Result := foRegistry.OpenKey(Key,CanCreate);
end;

function TAPI_RegIni.OpenKeyReadOnly(const Key: String): Boolean;
begin
  Result := foRegistry.OpenKeyReadOnly(Key);
end;

function TAPI_RegIni.ReadCurrency(const Name: string): Currency;
begin
  Result := foRegistry.ReadCurrency(Name);
end;

function TAPI_RegIni.ReadBinaryData(const Name: string; var Buffer; BufSize: Integer): Integer;
begin
  Result := foRegistry.ReadBinaryData(Name,Buffer,BufSize);
end;

function TAPI_RegIni.ReadBool(const Name: string): Boolean;
begin
  Result := foRegistry.ReadBool(Name);
end;

function TAPI_RegIni.ReadDate(const Name: string): TDateTime;
begin
  Result := foRegistry.ReadDate(Name);
end;

function TAPI_RegIni.ReadDateTime(const Name: string): TDateTime;
begin
  Result := foRegistry.ReadDateTime(Name);
end;

function TAPI_RegIni.ReadFloat(const Name: string): Double;
begin
  Result := foRegistry.ReadFloat(Name);
end;

function TAPI_RegIni.ReadInteger(const Name: string): Integer;
begin
  Result := foRegistry.ReadInteger(Name);
end;

function TAPI_RegIni.ReadString(const Name: string): string;
begin
  Result := foRegistry.ReadString(Name);
end;

function TAPI_RegIni.ReadTime(const Name: string): TDateTime;
begin
  Result := foRegistry.ReadTime(Name);
end;

function TAPI_RegIni.RegistryConnect(const UNCName: string): Boolean;
begin
  Result := foRegistry.RegistryConnect(UNCName);
end;

procedure TAPI_RegIni.RenameValue(const OldName, NewName: string);
begin
  foRegistry.RenameValue(OldName, NewName);
end;

function TAPI_RegIni.ReplaceKey(const Key, FileName, BackUpFileName: string): Boolean;
begin
  Result := foRegistry.ReplaceKey(Key, FileName, BackUpFileName);
end;

function TAPI_RegIni.RestoreKey(const Key, FileName: string): Boolean;
begin
  Result := foRegistry.RestoreKey(Key, FileName);
end;

function TAPI_RegIni.SaveKey(const Key, FileName: string): Boolean;
begin
  Result := foRegistry.SaveKey(Key, FileName);
end;

function TAPI_RegIni.UnLoadKey(const Key: string): Boolean;
begin
  Result := foRegistry.UnLoadKey(Key);
end;

function TAPI_RegIni.ValueExists(const Name: string): Boolean;
begin
  Result := foRegistry.ValueExists(Name);
end;

procedure TAPI_RegIni.WriteCurrency(const Name: string; Value: Currency);
begin
  foRegistry.WriteCurrency(Name,Value);
end;

procedure TAPI_RegIni.WriteBinaryData(const Name: string; var Buffer; BufSize: Integer);
begin
  foRegistry.WriteBinaryData(Name,Buffer, BufSize);
end;

procedure TAPI_RegIni.WriteBool(const Name: string; Value: Boolean);
begin
end;

procedure TAPI_RegIni.WriteDate(const Name: string; Value: TDateTime);
begin
end;

procedure TAPI_RegIni.WriteDateTime(const Name: string; Value: TDateTime);
begin
end;

procedure TAPI_RegIni.WriteFloat(const Name: string; Value: Double);
begin
end;

procedure TAPI_RegIni.WriteInteger(const Name: string; Value: Integer);
begin
end;

procedure TAPI_RegIni.WriteString(const Name, Value: string);
begin
end;

procedure TAPI_RegIni.WriteExpandString(const Name, Value: string);
begin
end;

procedure TAPI_RegIni.WriteTime(const Name: string; Value: TDateTime);
begin
end;


end.
