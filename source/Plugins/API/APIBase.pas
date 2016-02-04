unit APIBase;

interface

uses Classes, System.Zip, SysUtils, MessagesLog;

type
   TAPIBase = class(TPersistent)
   protected
   private
     foMessagesLog: tMessagesLog;
   public
     constructor Create(aMessagesLog: tMessagesLog); virtual;
     destructor Destroy; virtual;

     property oMessagesLog: tMessagesLog
       read foMessagesLog;
   end;

implementation

constructor TAPIBase.create;
begin
  foMessagesLog:= aMessagesLog;
end;

destructor TAPIBase.destroy;
begin
end;

end.
