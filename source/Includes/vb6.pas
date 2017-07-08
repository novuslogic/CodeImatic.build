unit vb6;

interface

Uses cmd, msbuild, Windows, stringutils;

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
  lipos: Integer;
  lLogFileSL: tStringList;
  lsTmplogfile,
  lslogfile,
  lsvb6bindir: string;
  SB: TStringBuilder;
begin
  Result := -1;

  lsvb6bindir := GetVB6BinDir;
  
  if not File.Exists(lsvb6bindir) then 
    RaiseException(erCustomError, 'Cannot find vb6.exe');

 Try
   lslogfile := File.MakeTmpFileName('log', true);
   lsTmpLogFile :=  lslogfile;
        
   SB:= TStringBuilder.Create;

   SB.Append('"' + lsvb6bindir  + '"');
  
   SB.Append(' /make '+ '"'+ aProject + '"');

   if (aVB6Options.Outdir <> '') then
      begin
        SB.Append(' /outdir '+ '"' + aVB6Options.Outdir + '"');

        lsTmpLogFile := File.IncludeTrailingPathDelimiter(aVB6Options.Outdir) + lslogfile;
      end;  

   SB.Append(' /out '+ '"'+ lsTmplogfile + '"');
   
   Output.logformat('Running: %s', [SB.ToString]);

   result := Exec(sb.ToString);

   lipos := 0;
   if File.Exists(lsTmpLogFile) then
     begin
       Try
         lLogFileSL := tStringList.Create;

         lLogFileSL.LoadFromFile(lsTmpLogFile);
       finally
         lipos := Pos('succeeded', trim(lLogFileSL.Text)) ;
         Output.Log(trim(lLogFileSL.Text))

         lLogFileSL.Free;

         File.Delete(lsTmpLogFile);
       end;  
     end;
   
 finally
   SB.Free;

  if lipos = 0 then 
   begin 
     result := -1;
     RaiseException(erCustomError, 'build failed.');
   end;  

 End;
end;

function GetVB6BinDir: String;
begin
  Result := '';

  if ProjectConfig.IsPropertyExists('vb6bindir') then
    result := File.IncludeTrailingPathDelimiter(ProjectConfig.Getproperty('vb6bindir'));

  If Result = '' then 
    begin
      if not IsWin64 then 
        Result := cvb6win32bin
      else
        Result := cvb6win64bin;
    end;       
end;


end.