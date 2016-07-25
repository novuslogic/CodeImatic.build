unit Plugin_Messageslog;

interface

uses Classes,Plugin,  uPSRuntime,  uPSCompiler, uPSI_MessagesLog, PluginsMapFactory;

type
  tPlugin_Messageslog = class(Tplugin)
  private
  protected
  public
    function CustomOnUses(var aCompiler: TPSPascalCompiler): Boolean; override;
    procedure RegisterFunction(var aExec: TPSExec); override;
    procedure SetVariantToClass(var aExec: TPSExec); override;
    procedure RegisterImport; override;
  end;

implementation

function tPlugin_Messageslog.CustomOnUses(var aCompiler: TPSPascalCompiler): Boolean;
begin
  Result := True;

  SIRegister_MessagesLog(aCompiler);
  AddImportedClassVariable(aCompiler, 'MessagesLog', 'TMessagesLog');

end;

procedure tPlugin_Messageslog.RegisterFunction(var aExec: TPSExec);
begin
end;

procedure tPlugin_Messageslog.SetVariantToClass(var aExec: TPSExec);
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
