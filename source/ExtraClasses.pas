unit ExtraClasses;

interface

uses SysUtils, NovusList, NovusVariants;

type
  TVariableCmdLine = class;

  TVariableCmdLineList = class
  protected
  private
    fNovusList: tNovusList;
    function GetItems(Index: Integer): TVariableCmdLine;
    function GetCount: Integer;
  public
    constructor Create;
    destructor Destroy;

    procedure Add(aItem: TVariableCmdLine);
    function ToVarCmdLines: String;

    property Items[Index: Integer]: TVariableCmdLine read GetItems;
    property Count: Integer read GetCount;
  end;

  TVariableCmdLine = class
  protected
  private
    fsVariableName: string;
    fsValue: string;
  public
    function ToVarCmdLine: String;

    property VariableName: string read fsVariableName write fsVariableName;
    property Value: string read fsValue write fsValue;
  end;

  TStringBuilderExtra = class(TStringBuilder)
  protected
  private
  public
    function AppendasString(const Value: string): TStringBuilder;
    function ToStringAll: String;
  end;

function InternalFormat(Const aFormat: string;
  Const Args: array of Variant): string;

implementation

function InternalFormat(Const aFormat: string;
  Const Args: array of Variant): string;
var
  lParams: Array of TVarRec;
  I: Integer;
begin
  Try
    SetLength(lParams, High(Args) + 1);

    for I := Low(Args) to High(Args) do
      lParams[I] := TNovusVariants.VarToVarRec(Args[I]);
  Finally
    Result := format(aFormat, lParams);
  End;
end;

// TStringBuilderExtra
function TStringBuilderExtra.AppendasString(const Value: string)
  : TStringBuilder;
begin
  Result := Self.Append(Value);
end;

function TStringBuilderExtra.ToStringAll: String;
begin
  Result := Self.ToString;
end;

// TVariableCmdLineList
constructor TVariableCmdLineList.Create;
begin
  fNovusList := tNovusList.Create(TVariableCmdLine);
end;

destructor TVariableCmdLineList.Destroy;
begin
  fNovusList.Free;
end;

procedure TVariableCmdLineList.Add(aItem: TVariableCmdLine);
begin
  fNovusList.Add(aItem);
end;

function TVariableCmdLineList.GetItems(Index: Integer): TVariableCmdLine;
begin
  Result := nil;
  if (fNovusList.Count - 1 < Index) or (Index >= fNovusList.Count) then
    Exit;

  Result := (fNovusList.Items[Index] as TVariableCmdLine);
end;

function TVariableCmdLineList.GetCount: Integer;
begin
  Result := fNovusList.Count;
end;

function TVariableCmdLineList.ToVarCmdLines: String;
Var
  I: Integer;
  fVariableCmdLine: TVariableCmdLine;
begin
  Result := '';

  for I := 0 to Count - 1 do
  begin
    fVariableCmdLine := fNovusList.Items[I] as TVariableCmdLine;
    if Assigned(fVariableCmdLine) then
      Result := Result + fVariableCmdLine.ToVarCmdLine + ' ';
  end;

  Result := Trim(Result);
end;

// TVariableCmdLine
function TVariableCmdLine.ToVarCmdLine: String;
begin
  Result := '-var ' + VariableName + '=' + Value;
end;

end.
