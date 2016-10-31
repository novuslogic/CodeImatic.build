unit stringutils;

interface

uses NumUtils;


function ExtractText(const aStr: string; const aDelim1, aDelim2: char): string;
function ExtractTextPos(const aStr: string; const aPos: Integer; aDelim: char): string;
function GUIDToString(const Guid: TGUID): string;
function GUIDToStringEx(const GUID: TGUID; const Separator: string ): string;

implementation

function ExtractText(const aStr: string; const aDelim1, aDelim2: char): string;
var
  pos1, pos2: integer;
begin
  result := '';
  pos1 := Pos(aDelim1, aStr);
  pos2 := Pos(aDelim2, aStr);
  if (pos1 > 0) and (pos2 > pos1) then
    result := Copy(aStr, pos1 + 1, pos2 - pos1 - 1);
end;

function ExtractTextPos(const aStr: string; const aPos: Integer; aDelim: char): string;
var
  pos1, pos2: integer;
  lsDelim: String;
begin
  result := '';
  
  pos1 := apos;
  
  lsDelim := Copy(aStr, Pos1, Length(aStr));
  
  Pos2 := Pos(aDelim, lsDelim);
  if (pos2 > 0) then 
     Result := Copy(lsDelim, 1, Pos2 - 1);
end;


function GUIDToString(const GUID: TGUID): string;
begin
  result:='{'+GUIDToStringEx(GUID, '-')+'}';
end;

function GUIDToStringEx(const GUID: TGUID; const Separator: string ): string;
begin
  result:=IntToHex(Guid.D1,8)+Separator+
           IntToHex(Guid.D2,4)+Separator+
           IntToHex(Guid.D3,4)+Separator+
           IntToHex(Guid.D4[0],2)+IntToHex(Guid.D4[1],2)+Separator+
           IntToHex(Guid.D4[2],2)+IntToHex(Guid.D4[3],2)+
           IntToHex(Guid.D4[4],2)+IntToHex(Guid.D4[5],2)+
           IntToHex(Guid.D4[6],2)+IntToHex(Guid.D4[7],2);
end;



end.
