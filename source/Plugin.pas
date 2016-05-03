unit Plugin;

interface

uses classes, uPSRuntime, uPSCompiler, MessagesLog;

type
   TPlugin = class(TPersistent)
   private
   protected
     foMessagesLog: tMessagesLog;
     fImp: TPSRuntimeClassImporter;
   public
     constructor Create(aMessagesLog: tMessagesLog; aImp: TPSRuntimeClassImporter); virtual;
//     destructor Destroy; virtual;

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

//destructor TPlugin.destroy;
//begin
//end;



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
