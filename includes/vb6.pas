unit vb6;

interface

Uses cmd, msbuild, Windows, stringutils;

const 
  cvb6 = 'vb6.exe'; 
  
  cvb6win32bin = 'c:\progam files\microsoft visual studio\vb98\' +  cvb6;
  cvb6win64bin = 'C:\Program Files (x86)\microsoft visual studio\vb98\' +  cvb6;
     
//$vb6bin /m $project /out $logfile /outdir $outdir

function IsVB6Running: boolean;
function VB6(aProject: string;  aOutdir: string): Integer;
function GetVB6BinFolder: String;
function LinkVB6Console(aFilename: string): Integer;


implementation

function IsVB6Running: boolean;
begin
  result := IsProcess32Exists(cvb6);  
end;

function VB6(aProject: string; aOutdir: string): Integer;
var
  lipos: Integer;
  lLogFileSL: tStringList;
  lsTmplogfile,
  lslogfile,
  lsvb6bindir: string;
  SB: TStringBuilder;
begin
  Result := -1;

  if IsVB6Running then 
    RaiseException(erCustomError, 'vb6.exe is running');


  lsvb6bindir := GetVB6BinFolder;
  
  if not File.Exists(lsvb6bindir) then 
    RaiseException(erCustomError, 'Cannot find vb6.exe ['+ lsvb6bindir +']');

 Try
   lslogfile := File.MakeTmpFileName('log', true);
   lsTmpLogFile :=  lslogfile;
        
   SB:= TStringBuilder.Create;

   SB.Append('"' + lsvb6bindir  + '"');
  
   SB.Append(' /make '+ '"'+ aProject + '"');

   if (aOutdir <> '') then
      begin
        SB.Append(' /outdir '+ '"' + aOutdir + '"');

        lsTmpLogFile := File.IncludeTrailingPathDelimiter(aOutdir) + lslogfile;
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

function GetVB6BinFolder: String;
begin
  Result := '';

  if ProjectConfig.IsPropertyExists('vb6binfolder') then
    result := File.IncludeTrailingPathDelimiter(ProjectConfig.Getproperty('vb6binfolder'));

  If Result = '' then 
    begin
      if not IsWin64 then 
        Result := cvb6win32bin
      else
        Result := cvb6win64bin;
    end;       
end;

function LinkVB6Console(aFilename: string): Integer;
Var
  lsvb6bindir: string;
  lsExec: string;
begin
   lsvb6bindir := GetVB6BinFolder + cvb6link;
   
   if not File.Exists(lsvb6bindir) then 
     RaiseException(erCustomError, 'Cannot find link.exe ['+ lsvb6bindir +']');

   if not File.Exists(aFilename) then 
     RaiseException(erCustomError, 'Cannot find ['+ aFilename +']');  

   lsExec := lsvb6bindir + ' /EDIT /SUBSYSTEM:CONSOLE ' + aFilename;
   
   Output.logformat('Running: %s', [lsExec]);

   result := Exec(lsExec);  
end;



end.