unit vb6;

interface

Uses cmd, msbuild, Windows;

function IsVB6Running: boolean;

implementation

function IsVB6Running: boolean;
begin
  result := IsProcess32Exists('VB6.exe');  
end;

end.