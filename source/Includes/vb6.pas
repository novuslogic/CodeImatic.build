unit vb6;

interface

Uses cmd, msbuild, Windows;

const 
  cvb6win32bin = 'c:\progam files\microsoft visual studio\vb98\vb6.exe';
  cvb6win64bin = 'C:\Program Files (x86)\microsoft visual studio\vb98\vb6.exe';
     
//$vb6bin /m $project /out $logfile /outdir $outdir

function IsVB6Running: boolean;
function VB6(aProject: string): Integer;
function GetVB6BinDir: String;

implementation

function IsVB6Running: boolean;
begin
  result := IsProcess32Exists('VB6.exe');  
end;

function VB6(aProject: string): Integer;
var
  lsvb6bindir: string;
begin
  Result := -1;

  lsvb6bindir := GetVB6BinDir;
  
  if not File.Exists(lsvb6bindir) then 
    RaiseException(erCustomError, 'Cannot find vb6.exe');

end;

function GetVB6BinDir: String;
begin
  Result := '';

  If Result = '' then 
    begin
      if not IsWin64 then 
        Result := cvb6win32bin
      else
        Result := cvb6win64bin;
    end;       
end;


end.