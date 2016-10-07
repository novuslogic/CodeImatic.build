unit ExtraClasses;

interface

uses SysUtils;

type
  TStringBuilderHelper = class helper for TStringBuilder
    function AppendasString(const Value: string): TStringBuilder;
  end;


implementation

function TStringBuilderHelper.AppendasString(const Value: string): TStringBuilder;
begin
  Self.Append(Value);
end;


end.
