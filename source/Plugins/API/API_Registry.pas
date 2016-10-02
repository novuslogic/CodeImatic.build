unit API_Registry;

interface

uses APIBase, SysUtils, API_Output, Classes, Registry, Windows;

const
  HKEY_CLASSES_ROOT     = Int64($80000000);
  HKEY_CURRENT_USER     = Int64($80000001);
  HKEY_LOCAL_MACHINE    = Int64($80000002);
  HKEY_USERS            = Int64($80000003);
  HKEY_PERFORMANCE_DATA = Int64($80000004);
  HKEY_CURRENT_CONFIG   = Int64($80000005);
  HKEY_DYN_DATA         = Int64($80000006);

  API_Registry_MissingRegKey = 'Missing Registery Key [%s]';

type
   TAPI_Registry = class(TAPIBase)
   private
   protected
   public
     constructor Create(aAPI_Output: tAPI_Output); override;
     destructor Destroy; override;

     function KeyExists(const aHKEY: Int64; const aKey: String): boolean;
     function ReadString(const aHKEY: Int64; const aKey: String; const aName: string): String;
   end;



implementation


constructor TAPI_Registry.create(aAPI_Output: tAPI_Output);
begin
  Inherited create(aAPI_Output);
end;

destructor TAPI_Registry.destroy;
begin
  Inherited
end;


function TAPI_Registry.ReadString(const aHKEY: Int64; const aKey: String; const aName: string): String;
var
  foRegistry: TRegistry;
begin
  Try
    Try
      foRegistry:= TRegistry.Create(KEY_READ);

      foRegistry.RootKey := HKEY(aHKEY);

      if not foRegistry.OpenKey(aKey, False) then
         RuntimeErrorFmt(API_Registry_MissingRegKey, [aKey]);

      Result := foRegistry.ReadString(aName);
    Except
      oAPI_Output.InternalError;
    End;
  Finally
    foRegistry.Free;
  End;
end;

function TAPI_Registry.KeyExists(const aHKEY: Int64; const aKey: String): boolean;
var
  foRegistry: TRegistry;
begin
  Try
    Try
      foRegistry:= TRegistry.Create(KEY_READ);

      foRegistry.RootKey := HKEY(aHKEY);

      Result := foRegistry.KeyExists(aKey);

    Except
      oAPI_Output.InternalError;
    End;
  Finally
    foRegistry.Free;
  End;
end;


end.
