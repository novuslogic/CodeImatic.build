unit uPSR_ExtraClasses;

interface

uses
  uPSRuntime, uPSUtils, SysUtils, ExtraClasses;

procedure RIRegisterTStringBuilder(Cl: TPSRuntimeClassImporter);
procedure RIRegisterTVariableCmdLine(Cl: TPSRuntimeClassImporter);
procedure RIRegisterTVariableCmdLineList(Cl: TPSRuntimeClassImporter);
procedure RIRegister_ExtraClasses(Cl: TPSRuntimeClassImporter);


implementation

uses
  Classes;


procedure TTVariableCmdLineValue_W(Self: TVariableCmdLine; const T: String);
begin
  Self.Value := T;
end;

procedure TTVariableCmdLineListItems_R(Self: TVariableCmdLineList; var T: TVariableCmdLine; I: Longint);
begin
  T := Self.Items[i]
end;

(*----------------------------------------------------------------------------*)
procedure TTVariableCmdLineValue_R(Self: TVariableCmdLine; var T: String);
begin
  T := Self.Value;
end;

procedure TTVariableCmdLineVariableName_W(Self: TVariableCmdLine; const T: String);
begin
  Self.VariableName := T;
end;

(*----------------------------------------------------------------------------*)
procedure TTVariableCmdLineVariableName_R(Self: TVariableCmdLine; var T: String);
begin
  T := Self.VariableName;
end;



procedure RIRegisterTStringBuilder(Cl: TPSRuntimeClassImporter);
begin
  with Cl.Add2(TStringBuilderExtra, 'TStringBuilder') do
  begin
    RegisterConstructor(@TStringBuilderExtra.CREATE, 'CREATE');
    RegisterMethod(@TStringBuilderExtra.FREE, 'FREE');
    RegisterMethod(@TStringBuilderExtra.ToStringAll, 'ToString');
    RegisterMethod(@TStringBuilderExtra.AppendasString, 'Append');
    RegisterMethod(@TStringBuilderExtra.AppendFormat, 'AppendFormat');
  end;
end;


procedure RIRegisterTVariableCmdLine(Cl: TPSRuntimeClassImporter);
begin
  with Cl.Add(TVariableCmdLine) do
  begin
    RegisterConstructor(@TVariableCmdLine.CREATE, 'CREATE');
    RegisterMethod(@TVariableCmdLine.FREE, 'FREE');
    RegisterMethod(@TVariableCmdLine.ToVarCmdLine, 'ToVarCmdLine');
    RegisterPropertyHelper(@TTVariableCmdLineValue_R,@TTVariableCmdLineValue_W,'Value');
    RegisterPropertyHelper(@TTVariableCmdLineVariableName_R,@TTVariableCmdLineVariableName_W,'VariableName');
  end;
end;


procedure RIRegisterTVariableCmdLineList(Cl: TPSRuntimeClassImporter);
begin
  with Cl.Add(TVariableCmdLineList) do
  begin
    RegisterConstructor(@TVariableCmdLineList.CREATE, 'CREATE');
    RegisterMethod(@TVariableCmdLineList.FREE, 'FREE');
    RegisterMethod(@TVariableCmdLineList.Add, 'Add');
    RegisterMethod(@TVariableCmdLineList.ToVarCmdLines, 'ToVarCmdLines');
    RegisterPropertyHelper(@TTVariableCmdLineListItems_R,NIL,'Items');
  end;
end;

procedure RIRegister_ExtraClasses(Cl: TPSRuntimeClassImporter);
begin
  RIRegisterTStringBuilder(Cl);
  RIRegisterTVariableCmdLine(Cl);
  RIRegisterTVariableCmdLineList(Cl);
end;

end.
