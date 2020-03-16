unit TagParser;

interface

Uses TagType, SysUtils, API_output, Classes, TokenProcessor, NovusStringUtils,
     ProjectLog;

Type
  TTagParser = class(Tobject)
  protected
  private
    function InternalParseTag(aToken: string; aProjectLog: tProjectLog): TTagType;
  public
    constructor Create; overload;
    destructor Destroy; override;

    class function ParseTagType(aToken: string; aProjectLog: tProjectLog): TTagType; overload;



  end;

implementation

Uses Runtime;

constructor TTagParser.Create;
begin
  inherited;
end;

destructor TTagParser.Destroy;
begin
  inherited;
end;

class function TTagParser.ParseTagType(aToken: string; aProjectLog: tProjectLog) : TTagType;
var
  lTagParser: TTagParser;
begin
  result := TTagType.ttUnknown;

  Try
    Try
      lTagParser := TTagParser.Create;

      result := lTagParser.InternalParseTag(aToken,aProjectLog);
    Finally
      lTagParser.Free;
    End;
  except
    aProjectLog.InternalError;
  End;
end;

function TTagParser.InternalParseTag(aToken: string; aProjectLog: tProjectlog): TTagType;
Var
  lsToken1: String;
begin
   if Trim(aToken) = '' then
    begin
      result := ttUnknown;

      exit;
    end;

  lsToken1 := Uppercase(aToken);

  Try
    if Uppercase(lsToken1) = 'WORKINGDIRECTORY' then
      result := ttWorkingDirectory
    else
      result := ttProperties;
  Finally

  End;
end;



end.
