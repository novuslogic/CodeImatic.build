unit Plugin_Messageslog;

interface

uses Classes,Plugin,  uPSRuntime,  uPSCompiler, uPSI_MessagesLog, PluginsMapFactory;

type
  tPlugin_Messageslog = class(Tplugin)
  private
  protected
  public
    function CustomOnUses(aCompiler: TPSPascalCompiler): Boolean; override;
    procedure RegisterFunction(aExec: TPSExec); override;
    procedure SetVariantToClass(aExec: TPSExec); override;
    procedure RegisterImport; override;
  end;

implementation

function tPlugin_Messageslog.CustomOnUses(aCompiler: TPSPascalCompiler): Boolean;
begin
  Result := True;

  SIRegister_MessagesLog(aCompiler);
  AddImportedClassVariable(aCompiler, 'MessagesLog', 'TMessagesLog');

end;

procedure tPlugin_Messageslog.RegisterFunction(aExec: TPSExec);
begin
end;

procedure tPlugin_Messageslog.SetVariantToClass(aExec: TPSExec);
begin
  uPSRuntime.SetVariantToClass(aExec.GetVarNo(aExec.GetVar('MESSAGESLOG')), foMessageslog);
end;

procedure tPlugin_Messageslog.RegisterImport;
begin
  RIRegister_MessagesLog(FImp);
end;

Initialization
 begin
   tPluginsMapFactory.RegisterClass(tPlugin_Messageslog);
 end;

end.
