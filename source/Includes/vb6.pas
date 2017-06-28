unit vb6;

interface

Uses cmd, msbuild, Windows;

type
  TVB6Options = record
    Outdir: string;

  end;


const 
  cvb6 = 'vb6.exe'; 
  
  cvb6win32bin = 'c:\progam files\microsoft visual studio\vb98\' +  cvb6;
  cvb6win64bin = 'C:\Program Files (x86)\microsoft visual studio\vb98\' +  cvb6;
     
//$vb6bin /m $project /out $logfile /outdir $outdir

function IsVB6Running: boolean;
function VB6(aProject: string; aVB6Options: TVB6Options): Integer;
function GetVB6BinDir: String;

implementation

function IsVB6Running: boolean;
begin
  result := IsProcess32Exists(cvb6);  
end;

function VB6(aProject: string; aVB6Options: TVB6Options): Integer;
var
  lsvb6bindir: string;
  SB: TStringBuilder;
begin
  Result := -1;

  lsvb6bindir := GetVB6BinDir;
  
  if not File.Exists(lsvb6bindir) then 
    RaiseException(erCustomError, 'Cannot find vb6.exe');

 Try
   SB:= TStringBuilder.Create;

   SB.Append('"' + lsvb6bindir  + '"');
  
   SB.Append(' /make '+ '"'+ aProject + '"');

   if (aVB6Options.Outdir <> '') then
      SB.Append(' /outdir '+ '"' + aVB6Options.Outdir + '"');

   Output.logformat('Running: %s', [SB.ToString]);

   result := Exec(sb.ToString);

   //sleep(1000);


 finally
   SB.Free;
 End;
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