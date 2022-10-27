unit APIBase;

interface

uses Classes, System.Zip, SysUtils, API_Output, uPSCompiler, uPSRuntime,
  uPSUtils;

type
 // TAPIBase = class(TPersistent)
  TAPIBase = class(Tobject)
  protected
  private
    foCompiler: TPSPascalCompiler;
    foAPI_Output: tAPI_Output;
    foExec: TPSExec;
  public
    constructor Create(aAPI_Output: tAPI_Output); virtual;
    destructor Destroy; override;

    procedure RuntimeErrorFmt(const aParam: tbtString;
      const aArgs: array of const);

    property oAPI_Output: tAPI_Output read foAPI_Output;

    property oCompiler: TPSPascalCompiler read foCompiler write foCompiler;

    property oExec: TPSExec read foExec write foExec;

  end;

implementation

constructor TAPIBase.Create;
begin
  foAPI_Output := aAPI_Output;

  foCompiler := NIL;
end;

destructor TAPIBase.Destroy;
begin
  Inherited;

  foAPI_Output := NIL;
  foCompiler := NIL;
  foExec := NIl;

end;

procedure TAPIBase.RuntimeErrorFmt(const aParam: tbtString;
  const aArgs: array of const);
Var
  fsParam: tbtString;
begin
  if Not Assigned(oExec) then
    Exit;

  fsParam := Format(aParam, aArgs);

  oExec.CMD_Err2(erException, fsParam);
end;

end.
