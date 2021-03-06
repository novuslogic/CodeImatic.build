unit numutils;

interface

function inttohex(l:longword; digits:integer):string;
function expnumber(number, exponent: integer): integer;
function hextoint(hex: string): integer;

implementation


function inttohex(l:longword; digits:integer):string;
var hexchars:string;
begin
  hexchars:='0123456789ABCDEF';
  setlength(result,digits);
  while (digits>0) do begin
    result[digits]:=hexchars[l mod 16+1];
    l:=l div 16;
    digits:=digits-1;
 end;
end;


function expnumber(number, exponent: integer): integer;
var counter: integer;
begin
   result:=1;
   if exponent=0 then exit;
   for counter:=1 to exponent do
   begin
      result:=result*number;
   end;
end;

function hextoint(hex: string): integer;
var counter: integer;
    value: integer;
begin
   result:=0;
   for counter:=0 to length(hex)-1 do
   begin
      case hex[length(hex)-counter] of
      'A': value:=10;
      'B': value:=11;
      'C': value:=12;
      'D': value:=13;
      'E': value:=14;
      'F': value:=15;
      else value:=strtoint(hex[length(hex)-counter]);
      end;
      result:=result+value*expnumber(16, counter);
   end;
end;


end.