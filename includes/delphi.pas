unit delphi;

interface

Uses cmd, msbuild;

type 
  TDelphiVersion = (DELPHI7, DELPHI2005, DELPHI2006, DELPHI2007, DELPHI2009, DELPHI2010, DELPHIXE,  DELPHIXE2,
                   DELPHIXE3, DELPHIXE4, DELPHIXE5, DELPHIXE6, DELPHIXE7, DELPHIXE8, DELPHI10, 
                   DELPHI10_1,  DELPHI10_2, DELPHI10_3, DELPHI10_4, DELPHI11);

  TDelphiOptions = record
    Platform: string;
    SearchPath: string;
    QuietCompile: boolean;
    UnitAliases: string;
    ConditionalDefines: string;
    Namespaces: string;
    UnitOutputDirectory: string;
    OutputDirectory: string;
    IncludeDirectories: string;
    UnitDirectories: string;
    OtherParameters: string;
    Configuration: string;
    Target: string;
  end;

function DelphiVersionMax: Integer;
function GetDelphiPackageVersion(aDelphiVersion:  TDelphiVersion): string;
function GetDelphiCompilerVersion(aDelphiVersion:  TDelphiVersion): string;
function GetBDSDIR(aDelphiVersion:  TDelphiVersion): string;
function GetBDSINCLUDE(aDelphiVersion:  TDelphiVersion): string;
function GetBDSCOMMONDIR(aDelphiVersion:  TDelphiVersion): string;
function GetBDSBPLDIR(aDelphiVersion:  TDelphiVersion): string;
function GetBDSRegKey(Key: string; Name: string): string;
function GetBDSRegistery(aDelphiVersion:  TDelphiVersion; Name: string): string;
function brcc32(aDelphiVersion: TDelphiVersion; aOptions: string; aFilename: string): integer;
/// <remarks>
///   http://docwiki.embarcadero.com/RADStudio/Sydney/en/Compiler_Versions
/// </remarks>
function Delphi(aDelphiVersion: TDelphiVersion;aProject: string; aDelphiOptions:TDelphiOptions): Integer;
   
implementation

function GetBDSRegistery(aDelphiVersion:  TDelphiVersion; Name: string): string;
var 
  lsKey: string;
begin
  Result := '';
    
  case aDelphiVersion of
    DELPHI7    : lsKey := 'Borland\Delphi\7';
    DELPHI2005 : lsKey := 'Borland\BDS\3';
    DELPHI2006 : lsKey := 'Borland\BDS\4';
    DELPHI2007 : lsKey := 'Borland\BDS\5';
    DELPHI2009 : lsKey := 'CodeGear\BDS\6';
    DELPHI2010 : lsKey := 'CodeGear\BDS\7';
    DELPHIXE   : lsKey := 'Embarcadero\BDS\8';
    DELPHIXE2  : lsKey := 'Embarcadero\BDS\9';
    DELPHIXE3  : lsKey := 'Embarcadero\BDS\10';
    DELPHIXE4  : lsKey := 'Embarcadero\BDS\11';
    DELPHIXE5  : lsKey := 'Embarcadero\BDS\12';
    DELPHIXE6..DELPHI11  : lsKey := 'Embarcadero\BDS\'+ IntToStr(Integer(aDelphiVersion) + 3);
  
  else
    RaiseException(erCustomError, 'Invalid "delphi" constant; Supported compiler versions DELPHI7..DELPHI10_3');
  end;

  Result := GetBDSRegKey(lsKey, Name);
end;


function GetBDSRegKey(Key: string; Name: string): string;
begin
  if Registry.KeyExists(HKEY_CURRENT_USER, 'SOFTWARE\' + Key + '.0') then
    Result := Registry.ReadString( HKEY_CURRENT_USER, 'SOFTWARE\' + Key + '.0', Name)
  else  
  if Registry.KeyExists(HKEY_LOCAL_MACHINE, 'SOFTWARE\' + Key + '.0') then
    Result := Registry.ReadString( HKEY_LOCAL_MACHINE, 'SOFTWARE\' + Key + '.0', Name)
  else  
  if Registry.KeyExists(HKEY_LOCAL_MACHINE, 'SOFTWARE\Wow6432Node\' + Key + '.0') then
    Result := Registry.ReadString( HKEY_LOCAL_MACHINE, 'SOFTWARE\Wow6432Node\' + Key + '.0', Name);
end;

function GetBDSCOMMONDIR(aDelphiVersion:  TDelphiVersion): string;
var
  lines,
  lrsvars: tStringlist; 
  lsmatch,
  lsRootDir: string;
begin
  result := Environment.GetEnvironmentVar('BDSCOMMONDIR');
  if trim(result) = '' then 
    begin
       Try
         lsRootDir:=GetBDSDIR(aDelphiVersion) + '\bin\rsvars.bat';
         if Files.Exists(lsRootDir) = false then
           RaiseException(erCustomError, 'Cannot find Delphi rsbar.bat file: '+ lsRootDir);
         lrsvars:= tStringlist.Create;

         lrsvars.LoadFromFile(lsRootDir); 

         RegEx.Match('(BDSCOMMONDIR=)([^\0]+)', lrsvars.text, lsmatch);

         Lines := TStringList.Create;
         try
           Lines.Text := lsmatch;
           Result := Lines.Values['BDSCOMMONDIR'];
         finally
           Lines.Free;
         end;
       finally
         lrsvars.Free; 
       End;
    end;

  Result := Files.IncludeTrailingPathDelimiter(result);
end;

function GetBDSDIR(aDelphiVersion:  TDelphiVersion): string;
begin
  result := GetBDSRegistery(aDelphiVersion, 'rootdir');
end;

function GetBDSINCLUDE(aDelphiVersion:  TDelphiVersion): string;
begin
  result := Environment.GetEnvironmentVar('BDSINCLUDE');
  if trim(result) = '' then 
    begin
      result := Files.IncludeTrailingPathDelimiter(GetBDSDIR(aDelphiVersion) + '\include');
    end;

end;

function GetBDSBPLDir(aDelphiVersion:  TDelphiVersion): string;
begin
  result := Files.IncludeTrailingPathDelimiter(GetBDSDIR(aDelphiVersion) + '\bpl');
end;


function brcc32(aDelphiVersion: TDelphiVersion; aOptions: string; aFilename: string): integer;
var 
  lsrootdir: string;
  SB: TStringBuilder;
begin
  lsrootdir :=  GetBDSDIR(aDelphiVersion);
  if lsrootdir = '' then 
    RaiseException(erCustomError, 'Cannot find Delphi registry key for '+ GetDelphiCompilerVersion(aDelphiVersion));
   
  Try
    SB:= TStringBuilder.Create;

    SB.Append('"' + lsrootdir  +  '\bin\brcc32.exe"');

    if trim(aOptions) <> '' then 
       SB.Append(' ' + aOptions);
    
    if trim(aFilename) <> '' then 
       SB.Append(' ' + aFilename);       
  
    Output.logformat('Running: %s', [SB.ToString]);

    result := Exec(sb.ToString);
  finally
    SB.Free;
  End; 
end;

function Delphi(aDelphiVersion:  TDelphiVersion;aProject: string; aDelphiOptions:TDelphiOptions): Integer;
var
  lsrootdir: string;
  SB: TStringBuilder;
  FMSBuildOptions: TMSBUildOptions;
begin
  result := -1;

  lsrootdir :=  GetBDSDIR(aDelphiVersion);

  if lsrootdir = '' then 
    RaiseException(erCustomError, 'Cannot find Delphi registry key for '+ GetDelphiCompilerVersion(aDelphiVersion));

  if (aDelphiVersion in [DELPHI7, DELPHI2005, DELPHI2006]) and (lowercase(aDelphiOptions.platform) = 'msbuild') then 
    RaiseException(erCustomError, 'Compiler Version 7,9,10 does not support platform = msbuild')
  else
  if (lowercase(aDelphiOptions.platform) = 'msbuild') then
    begin
      Environment.SetEnvironmentVar('BDS', GetBDSDIR(aDelphiVersion), false);

      Environment.SetEnvironmentVar('BDSINCLUDE', GetBDSINCLUDE(  aDelphiVersion), false);
  
      Environment.SetEnvironmentVar('BDSCOMMONDIR',  GetBDSCOMMONDIR(  aDelphiVersion ), false);
    
      if (aDelphiVersion in [DELPHI10_3]) then
        begin
          Environment.SetEnvironmentVar('FrameworkDir', GetDotNETFrameworkDirectory('4.0'), false);
          Environment.SetEnvironmentVar('FrameworkVersion', 'v4.0', false);
        end
      else 
        begin
          Environment.SetEnvironmentVar('FrameworkDir', GetDotNETFrameworkDirectory('3.5'), false);
          Environment.SetEnvironmentVar('FrameworkVersion', 'v3.5', false);
        end;    

      FMSBuildOptions.Configuration := aDelphiOptions.Configuration;
      if FMSBuildOptions.Configuration = '' then FMSBuildOptions.Configuration := 'debug';

      FMSBuildOptions.Target := aDelphiOptions.target;
      if FMSBuildOptions.Target= '' then FMSBuildOptions.Target := 'rebuild';
      FMSBuildOptions.OtherParameters := aDelphiOptions.OtherParameters;
      FMSBuildOptions.OutputPath := aDelphiOptions.OutputDirectory;

      Output.log('Delphi MSBuild.');

      if (aDelphiVersion in [DELPHI10_3, DELPHI11]) then
        result := MSBuild('4.0', aProject, FMSBuildOptions)
      else
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

  if not Files.Exists(lsRootDir) then RaiseException(erCustomError, 'Delphi dcc not found: '+lsRootDir+' '+aDelphiOptions.platform);


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
        if aDelphiVersion = DELPHI7 then       
          sb.AppendFormat(' -N"%s"', [aDelphiOptions.UnitOutputDirectory])
        else
          sb.AppendFormat(' -NO"%s" -N0"%s"', [aDelphiOptions.UnitOutputDirectory, aDelphiOptions.UnitOutputDirectory]);  
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

     Output.logformat('Delphi Running: %s', [sb.ToString]);

     result := Exec(sb.ToString);
   
  finally
    SB.Free;
  End;
end;

function GetDelphiPackageVersion(aDelphiVersion:  TDelphiVersion): string;
begin
  case aDelphiVersion of
    DELPHI7 : Result := '70';
    DELPHI2005 : Result := '90';
    DELPHI2006 : Result := '100';
    DELPHI2007 : Result := '110';
    DELPHI2009 : Result := '120';
    DELPHI2010 : Result := '140';
    DELPHIXE   : Result := '150';
    DELPHIXE2  : Result := '160';
    DELPHIXE3  : Result := '170';
    DELPHIXE4  : Result := '180';
    DELPHIXE5  : Result := '190';
    DELPHIXE6  : Result := '200';
    DELPHIXE7  : Result := '210';
    DELPHIXE8  : Result := '220';
    DELPHI10   : Result := '230';
    DELPHI10_1 : Result := '240';
    DELPHI10_2 : Result := '250';
    DELPHI10_3 : Result := '260';
    DELPHI10_4 : Result := '270';
    DELPHI11 : Result := '280';
  else
    RaiseException(erCustomError, 'Invalid supported delphi versions');
  end;
end;

function GetDelphiCompilerVersion(aDelphiVersion:  TDelphiVersion): string;
begin
  case aDelphiVersion of
    DELPHI7 : Result := 'DELPHI7';
    DELPHI2005 : Result := 'DELPHI2005';
    DELPHI2006 : Result := 'DELPHI2006';
    DELPHI2007 : Result := 'DELPHI2007';
    DELPHI2009 : Result := 'DELPHI2009';
    DELPHI2010 : Result := 'DELPHI2010';
    DELPHIXE   : Result := 'DELPHIXE';
    DELPHIXE2  : Result := 'DELPHIXE2';
    DELPHIXE3  : Result := 'DELPHIXE3';
    DELPHIXE4  : Result := 'DELPHIXE4';
    DELPHIXE5  : Result := 'DELPHIXE5';
    DELPHIXE6  : Result := 'DELPHIXE6';
    DELPHIXE7  : Result := 'DELPHIXE7';
    DELPHIXE8  : Result := 'DELPHIXE8';
    DELPHI10   : Result := 'DELPHI10';
    DELPHI10_1 : Result := 'DELPHI10_1';
    DELPHI10_2 : Result := 'DELPHI10_2';
    DELPHI10_3 : Result := 'DELPHI10_3';
    DELPHI10_4 : Result := 'DELPHI10_4';
    DELPHI11 : Result := 'DELPHI11';
  else
    RaiseException(erCustomError, 'Invalid supported delphi versions');
  end;
end;

function DelphiVersionMax: Integer;
begin
  Result := 16;
end;
 

end.
