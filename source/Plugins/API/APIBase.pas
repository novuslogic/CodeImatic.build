unit APIBase;

interface

uses Classes, System.Zip, SysUtils, MessagesLog, uPSCompiler, uPSRuntime, uPSUtils;

type
   TAPIBase = class(TPersistent)
   protected
   private
     foCompiler: TPSPascalCompiler;
     foMessagesLog: tMessagesLog;
     foExec: TPSExec;
   public
     constructor Create(aMessagesLog: tMessagesLog); virtual;
     destructor Destroy; virtual;

     procedure RuntimeErrorFmt(const aParam: tbtString; const aArgs: array of const);

     property oMessagesLog: tMessagesLog
       read foMessagesLog;

     property oCompiler: TPSPascalCompiler
        read foCompiler
        write foCompiler;

     property oExec: TPSExec
        read foExec
        write foExec;

   end;

implementation

constructor TAPIBase.create;
begin
  foMessagesLog:= aMessagesLog;

  foCompiler := NIL;
end;

destructor TAPIBase.destroy;
begin
  foMessagesLog := NIL;
  foCompiler := NIL;
  foExec := NIl;

end;

procedure TAPIBase.RuntimeErrorFmt(const aParam: tbtString; const aArgs: array of const);
Var
  fsParam: tbtString;
begin
  if Not Assigned(oExec) then Exit;

  FsParam := Format(aParam, aArgs);

  //oExec.CMD_Err2(ErNoError, FsParam);
  oExec.CMD_Err2(erException, FsParam);

end;


end.
