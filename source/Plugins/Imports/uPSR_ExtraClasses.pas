unit uPSR_ExtraClasses;

{$I PascalScript.inc}
interface
uses
  uPSRuntime, uPSUtils, JSON;



procedure RIRegisterTJSON(Cl: TPSRuntimeClassImporter);

procedure RIRegister_ExtraClasses(Cl: TPSRuntimeClassImporter);

implementation
uses
  Classes;

procedure RIRegisterTJSON(Cl: TPSRuntimeClassImporter);
begin
  with Cl.Add(TJSON) do
  begin
    RegisterConstructor(@TJSON.CREATE, 'CREATE');
    RegisterMethod(@TJSON.ToString, 'TOSTRING');
    RegisterMethod(@TJSON.ParseJSONString, 'PARSEJSONSTRING');
    (*
    RegisterMethod(@TPARSER.CHECKTOKEN, 'CHECKTOKEN');
    RegisterMethod(@TPARSER.CHECKTOKENSYMBOL, 'CHECKTOKENSYMBOL');
    RegisterMethod(@TPARSER.ERROR, 'ERROR');
    RegisterMethod(@TPARSER.ERRORSTR, 'ERRORSTR');
    RegisterMethod(@TPARSER.HEXTOBINARY, 'HEXTOBINARY');
    RegisterMethod(@TPARSER.NEXTTOKEN, 'NEXTTOKEN');
    RegisterMethod(@TPARSER.SOURCEPOS, 'SOURCEPOS');
    RegisterMethod(@TPARSER.TOKENCOMPONENTIDENT, 'TOKENCOMPONENTIDENT');
    RegisterMethod(@TPARSER.TOKENFLOAT, 'TOKENFLOAT');
    RegisterMethod(@TPARSER.TOKENINT, 'TOKENINT');
    RegisterMethod(@TPARSER.TOKENSTRING, 'TOKENSTRING');
    RegisterMethod(@TPARSER.TOKENSYMBOLIS, 'TOKENSYMBOLIS');
    RegisterPropertyHelper(@TPARSERSOURCELINE_R, nil, 'SOURCELINE');
    RegisterPropertyHelper(@TPARSERTOKEN_R, nil, 'TOKEN');
    *)
  end;
end;

procedure RIRegister_ExtraClasses(Cl: TPSRuntimeClassImporter);
begin
  RIRegisterTJSON(Cl);
end;

end.
