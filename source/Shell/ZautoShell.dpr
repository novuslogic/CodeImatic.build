library ZautoShell;

uses
  ComServ,
  ZautoShell_TLB in 'ZautoShell_TLB.pas',
  ZautoMenu in 'ZautoMenu.pas',
  NovusShell in '..\..\..\NovuscodeLibrary\Source\Core\Utilities\NovusShell.pas',
  NovusUtilities in '..\..\..\NovuscodeLibrary\Source\Core\Utilities\NovusUtilities.pas',
  NovusWindows in '..\..\..\NovuscodeLibrary\Source\Core\Utilities\NovusWindows.pas';

exports
  DllGetClassObject,
  DllCanUnloadNow,
  DllRegisterServer,
  DllUnregisterServer;

{$R *.RES}

begin
end.
