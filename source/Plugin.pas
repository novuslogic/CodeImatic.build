unit Plugin;

interface

uses classes, uPSRuntime, uPSCompiler, MessagesLog, NovusPlugin;

type
   TPlugin = class(TPersistent)
   private
   protected
     foMessagesLog: tMessagesLog;
     fImp: TPSRuntimeClassImporter;
   public
     constructor Create(aMessagesLog: tMessagesLog; var aImp: TPSRuntimeClassImporter); virtual;

     function CustomOnUses(var aCompiler: TPSPascalCompiler): Boolean; virtual;
     procedure RegisterFunction(var aExec: TPSExec); virtual;
     procedure SetVariantToClass(var aExec: TPSExec); virtual;
     procedure RegisterImport; virtual;

     property oMessagesLog: tMessagesLog
       read foMessagesLog
       write foMessagesLog;

     property _Imp: TPSRuntimeClassImporter
       read fImp
       write fImp;
   end;

    IExternalPlugin = interface(INovusPlugin)
     ['{838468EA-1750-4CB5-B6B3-E7078F59A46A}']
     (*
     function CustomOnUses(var aCompiler: TPSPascalCompiler): Boolean; safecall;
     procedure RegisterFunction(var aExec: TPSExec); safecall;
     procedure SetVariantToClass(var aExec: TPSExec); safecall;
     procedure RegisterImport;  safecall;
     *)
     function  CreatePlugin(aMessagesLog: tMessagesLog; aImp: TPSRuntimeClassImporter):TPlugin safecall;
   end;


   TPluginClass = class of TPlugin;

implementation

constructor TPlugin.create;
begin
  foMessagesLog:= aMessagesLog;

  fImp:= aImp;
end;


function TPlugin.CustomOnUses(var aCompiler: TPSPascalCompiler): Boolean;
begin
  Result := False;
end;

procedure TPlugin.RegisterFunction(var aExec: TPSExec);
begin

end;
procedure TPlugin.SetVariantToClass(var aExec: TPSExec);
begin

end;
procedure TPlugin.RegisterImport;
begin

end;

end.
