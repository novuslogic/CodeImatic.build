unit JSONParser;

interface

Uses Classes, uPSRuntime, uPSUtils,DBXJson, dialogs, SysUtils;

type
  TJSON = class(TPersistent)
  private
  protected
    FJSONPair: TJSONPair;

  public
    constructor Create;
    destructor Destroy; override;

    function IsJSONArray: Boolean;

    property oJSONPair: TJSONPair
      read FJSONPair
      write FJSONPair;
  end;


  TJSONParser = class(TPersistent)
  private
    FJSONObject: TJSONObject;
  protected
  public
    constructor Create;
    destructor Destroy; override;

    procedure ParseJSONString(aJSONString: String);

    function ToString: String;
    function GetValue(aParName: string): TJSON;

    property oJSONObject :TJSONObject
     read FJSONObject
     write FJSONObject;
  end;

implementation

constructor TJSONParser.Create;
begin
  FJSONObject := TJSONObject.Create;
end;

destructor TJSONParser.Destroy;
begin
  if Assigned(FJSONObject) then
    FJSONObject.Free;
end;

function TJSONParser.GetValue(aParName: String): TJSON;
Var
  lJSONPair: TJSONPair;
begin
  Result := NIL;

  lJSONPair := FJSONObject.Get(aParName);

  if Assigned(lJSONPair) then
    begin
      Result := TJSON.Create;
      Result.oJSONPair := lJSONPair;
    end;
end;

function TJSONParser.ToString: String;
begin
  Result := FJSONObject.ToString;
end;

procedure TJSONParser.ParseJSONString(aJSONString: String);
begin
  if Assigned(FJSONObject) then FJSONObject.Free;
  Try
    FJSONObject := TJSONObject.ParseJSONValue(TEncoding.ASCII.GetBytes(aJSONString), 0) as TJSONObject;
  Except
    //RuntimeErrorFmt(API_Zip_NotFileExists, [aZipFilename]);
  End;
end;

constructor TJSON.Create;
begin
//
end;

destructor TJSON.Destroy;
begin
//
end;

function TJSON.IsJSONArray: Boolean;
begin
  result := False;
  if not Assigned(FJSONPair) then Exit;

  result := (FJSONPair.JsonValue is TJSONArray);
end;


initialization
 begin
   RegisterClass(TJSON);
   RegisterClass(TJSONParser);
 end;


end.



