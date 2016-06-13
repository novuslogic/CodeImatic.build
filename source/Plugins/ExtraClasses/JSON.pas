unit JSON;

interface

Uses Classes, uPSRuntime, uPSUtils,DBXJson, dialogs, SysUtils;

type
  TJSON = class(TPersistent)
  private
    FJSONObject: TJSONObject;
  protected
  public
    constructor Create;
    destructor Destroy; override;

    procedure ParseJSONString(aJSONString: String);

    function ToString: String;

  end;

implementation

constructor TJSON.Create;
begin
  FJSONObject := TJSONObject.Create;
end;

destructor TJSON.Destroy;
begin
  FJSONObject.Free;
end;

function TJSON.ToString: String;
begin
  Result := FJSONObject.ToString;
end;

procedure TJSON.ParseJSONString(aJSONString: String);
begin
  if Assigned(FJSONObject) then FJSONObject.Free;
  Try
    FJSONObject := TJSONObject.ParseJSONValue(TEncoding.ASCII.GetBytes(aJSONString), 0) as TJSONObject;
  Except
    //RuntimeErrorFmt(API_Zip_NotFileExists, [aZipFilename]);
  End;
end;


initialization
   RegisterClass(TJSON);


end.



