unit API_IniFile;

interface

uses APIBase, SysUtils, Registry, MessagesLog, Classes;

type
   TIniFile = class(TPersistent)
   private
   protected
     foRegIniFile: TRegIniFile;
   public
     constructor Create;
     destructor Destroy; override;
   end;


   TAPI_IniFile = class(TAPIBase)
   private
   protected
   public
     constructor Create(aMessagesLog: tMessagesLog); override;
     destructor Destroy; override;

     function OpenIniFile(aFilename: String): TIniFile;

    // function NewOpenKey(const aKey: string; Const aCanCreate: Boolean): TRegIni;
   end;



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
  Try
    Result := TInifile.Create;

   // Result.OPenKey(aKey,aCanCreate);
  Except
    oMessagesLog.InternalError;
  End;


end;


//TIniFile

constructor TIniFile.create;
begin
  Inherited;

  foRegIniFile:= TRegIniFile.Create;
end;

destructor TIniFile.destroy;
begin
  Inherited;

  foRegIniFile.Free;
end;

end.
