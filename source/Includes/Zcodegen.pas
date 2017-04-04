unit Zcodegen;

interface

Uses cmd;

function Zcodegen(aProject: string; aProjectconfig: string; aVariables: string; aOptions: string): Integer;
   
implementation


function Zcodegen(aProject: string; aProjectconfig: string; aVariables: string; aOptions: string): Integer;
var
  SB: TStringBuilder;
begin
 
  try
    SB:= TStringBuilder.Create;

    SB.Append('zcodegen ');

    SB.Append('-project ' + aProject + ' ');
    SB.Append('-projectconfig ' + aProjectconfig + ' ');
    SB.Append('-outputlog zcoutput.log ');

    if aVariables <> '' then 
       SB.Append('-var ' + aVariables + ' ');

    Output.logformat('Running: %s', [SB.ToString]);

    result := Exec(sb.ToString);
  finally
    SB.Free;
  end;
    





  (* 
  
  http://docwiki.embarcadero.com/RADStudio/Berlin/en/Paths_and_Directories_(C%2B%2B)
  
  

  lsrootdir :=  GetBDSDIR(aCompilerVersion);

  if lsrootdir = '' then 
    RaiseException(erCustomError, 'Cannot find Delphi registry key for '+ IntToStr(aCompilerVersion));

  if (aCompilerVersion in [DELPHI7, DELPHI2005, DELPHI2006]) and (lowercase(aDelphiOptions.platform) = 'msbuild') then 
    RaiseException(erCustomError, 'Compiler Version 7,9,10 does not support platform = msbuild')
  else
  if (lowercase(aDelphiOptions.platform) = 'msbuild') then
    begin
      Environment.SetEnvironmentVar('BDS', GetBDSDIR(aCompilerVersion), false);

      Environment.SetEnvironmentVar('BDSINCLUDE', GetBDSINCLUDE(  aCompilerVersion), false);
  
      Environment.SetEnvironmentVar('BDSCOMMONDIR',  GetBDSCOMMONDIR(  aCompilerVersion ), false);
    
      Environment.SetEnvironmentVar('FrameworkDir', GetDotNETFrameworkDirectory('3.5'), false);
      Environment.SetEnvironmentVar('FrameworkVersion', 'v3.5', false);

      FMSBuildOptions.Configuration := aDelphiOptions.Configuration;
      if FMSBuildOptions.Configuration = '' then FMSBuildOptions.Configuration := 'debug';

      FMSBuildOptions.Target := aDelphiOptions.target;
      if FMSBuildOptions.Target= '' then FMSBuildOptions.Target := 'rebuild';
      FMSBuildOptions.OtherParameters := aDelphiOptions.OtherParameters;
      FMSBuildOptions.OutputPath := aDelphiOptions.OutputDirectory;

      result := MSBuild('3.5', aProject, FMSBuildOptions);

      exit;
    end
  else  
  if (CompareText(lowercase(aDelphiOptions.platform), 'ios32') = 0) or
     (CompareText(lowercase(aDelphiOptions.platform), 'iossimulator') = 0) then
    lsRootDir := Path.Combine(Path.Combine(lsRootDir, 'Bin'), 'dccios32.exe')
  else
  if (CompareText(lowercase(aDelphiOptions.platform), 'ios32') = 0) or
     (CompareText(lowercase(aDelphiOptions.platform), 'iossimulator') = 0) then
    lsRootDir := Path.Combine(Path.Combine(lsRootDir, 'Bin'), 'dccios32.exe')
  else
  if (CompareText(lowercase(aDelphiOptions.platform), 'android') = 0) then
    lsRootDir := Path.Combine(Path.Combine(lsRootDir, 'Bin'), 'dccaarm.EXE')
  else
  if (CompareText(lowercase(aDelphiOptions.platform), 'macosx') = 0) or
     (CompareText(lowercase(aDelphiOptions.platform), 'osx') = 0) or
     (CompareText(lowercase(aDelphiOptions.platform), 'osx32') = 0) then 
     lsRootDir := Path.Combine(Path.Combine(lsRootDir, 'Bin'), 'dccosx.exe')
  else
  if (CompareText(lowercase(aDelphiOptions.platform), '64') = 0) or
     (CompareText(lowercase(aDelphiOptions.platform), 'x64') = 0) or
     (CompareText(lowercase(aDelphiOptions.platform), 'win64') = 0) then    
     lsRootDir := Path.Combine(Path.Combine(lsRootDir, 'Bin'), 'dcc64.exe')
  else   
   if (CompareText(lowercase(aDelphiOptions.platform), '32') = 0) or
     (CompareText(lowercase(aDelphiOptions.platform), 'x86') = 0) or
     (CompareText(lowercase(aDelphiOptions.platform), 'win32') = 0) then 
    lsRootDir := Path.Combine(Path.Combine(lsRootDir, 'Bin'), 'dcc32.exe')
  else 
    RaiseException(erCustomError, 'Unsupported platform ("win32", "win64", "osx32", "iossimulator","iosdevice")');

  if not File.Exists(lsRootDir) then RaiseException(erCustomError, 'Delphi dcc not found: '+lsRootDir+' '+aDelphiOptions.platform);
    
  Try
    SB:= TStringBuilder.Create;

    SB.Append('""' + lsrootdir  + '""');

    if aDelphiOptions.QuietCompile then 
      SB.Append(' -Q');

    SB.Append(' -B '+ aProject);


    if Trim(aDelphiOptions.SearchPath) = '' then
      aDelphiOptions.SearchPath := Path.GetDirectoryName(aProject)
    else
      aDelphiOptions.SearchPath := aDelphiOptions.SearchPath +';'+Path.GetDirectoryName(aProject);

    if Trim(aDelphiOptions.UnitAliases) <> '' then
       sb.AppendFormat(' -A"%s"', [aDelphiOptions.UnitAliases]);

    if Trim(aDelphiOptions.ConditionalDefines) <> '' then
        sb.AppendFormat(' -D"%s"', [aDelphiOptions.ConditionalDefines]);
   
    if Trim(aDelphiOptions.namespaces) <> '' then
        sb.AppendFormat(' -NS"%s"', [aDelphiOptions.namespaces]);

    if Trim(aDelphiOptions.UnitOutputDirectory) <> '' then
      begin
        if aCompilerVersion > DELPHI7 then
          sb.AppendFormat(' -NO"%s" -N0"%s"', [aDelphiOptions.UnitOutputDirectory, aDelphiOptions.UnitOutputDirectory])
        else
         sb.AppendFormat(' -N"%s"', [aDelphiOptions.UnitOutputDirectory]);
      end;      

    if Trim(aDelphiOptions.OutputDirectory) <> '' then
       sb.AppendFormat(' -LE"%s" -LN"%s" -E"%s"',[aDelphiOptions.OutputDirectory, aDelphiOptions.OutputDirectory, aDelphiOptions.OutputDirectory]); 
     
    if Trim(aDelphiOptions.IncludeDirectories)  <> '' then
      sb.AppendFormat(' -I"%s"', [aDelphiOptions.IncludeDirectories])
    else
      sb.AppendFormat(' -I"%s"', [aDelphiOptions.SearchPath]);

    if Trim(aDelphiOptions.UnitDirectories)  <> '' then
      sb.AppendFormat(' -U"%s"', [aDelphiOptions.UnitDirectories])
    else
      sb.AppendFormat(' -U"%s"', [aDelphiOptions.SearchPath]);

    if Trim(aDelphiOptions.otherParameters) <> '' then
      sb.Append(' '+aDelphiOptions.otherParameters);
   
    Output.logformat('Running: %s', [SB.ToString]);

    result := Exec(sb.ToString);
   
  finally
    SB.Free;
  End;
  *)
end;
  

end.
