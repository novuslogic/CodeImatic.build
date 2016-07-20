unit Plugin;

interface

uses classes, uPSRuntime, uPSCompiler, MessagesLog, NovusPlugin;

type
    IExternalPlugin = interface(INovusPlugin)
     ['{838468EA-1750-4CB5-B6B3-E7078F59A46A}']
     function CustomOnUses(aCompiler: TPSPascalCompiler): Boolean; safecall;
     procedure RegisterFunction(aExec: TPSExec); safecall;
     procedure SetVariantToClass(aExec: TPSExec); safecall;
     procedure RegisterImport;  safecall;

     procedure InitializeEx(aMessagesLog: tMessagesLog; aImp: TPSRuntimeClassImporter); safecall;
   end;

   TPlugin = class(TPersistent)
   private
   protected
     foMessagesLog: tMessagesLog;
     fImp: TPSRuntimeClassImporter;
   public
     constructor Create(aMessagesLog: tMessagesLog; aImp: TPSRuntimeClassImporter); virtual;

     function CustomOnUses(aCompiler: TPSPascalCompiler): Boolean; virtual;
     procedure RegisterFunction(aExec: TPSExec); virtual;
     procedure SetVariantToClass(aExec: TPSExec); virtual;
     procedure RegisterImport; virtual;

     property oMessagesLog: tMessagesLog
       read foMessagesLog
       write foMessagesLog;

     property _Imp: TPSRuntimeClassImporter
       read fImp
       write fImp;
   end;

   TPluginClass = class of TPlugin;

implementation

constructor TPlugin.create;
begin
  foMessagesLog:= aMessagesLog;

  fImp:= aImp;
end;


function TPlugin.CustomOnUses(aCompiler: TPSPascalCompiler): Boolean;
begin
  Result := False;
end;

procedure TPlugin.RegisterFunction(aExec: TPSExec);
begin

end;
procedure TPlugin.SetVariantToClass(aExec: TPSExec);
begin

end;
procedure TPlugin.RegisterImport;
begin

end;

end.
