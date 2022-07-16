unit msbuild;

interface

Uses cmd, Windows, DotNET;

const cVSCommunity2019 = 'C:\Program Files (x86)\Microsoft Visual Studio\2019\Community\MSBuild\Current\Bin\MSBuild.exe';
const cTlbExp48 = 'C:\Program Files (x86)\Microsoft SDKs\Windows\v10.0A\bin\NETFX 4.8 Tools\x64\TlbExp.exe';

type
  TMSBuildOptions = record
    Configuration: string;
    Platform: string;
    OutputPath: string;
    Target: string;
    OtherParameters: string;
  end;


function GetMSBuildFullname(aVersion: string): string;
function MSBuild(aVersion: string; aProjectSolutionFilename: string;aMSBuildOptions:TMSBuildOptions): integer;
function TlbExp(aOptions: string): integer;

   
implementation


(*

MSBuild Command-Line Reference
https://msdn.microsoft.com/en-us/library/ms164311.aspx
*)

function MSBuild(aVersion: string; aProjectSolutionFilename: string;aMSBuildOptions:TMSBuildOptions): integer;
var 
  SB: TStringBuilder;
  lsMSBuildFullname: string;
  lsProjectSolutionFilename: string;
begin
  result := -1;

  

  lsProjectSolutionFilename := aProjectSolutionFilename; 
  if not Files.Exists(aProjectSolutionFilename) then
   begin
       lsProjectSolutionFilename := WD + aProjectSolutionFilename;

      if not Files.Exists(lsProjectSolutionFilename) then
        RaiseException(erCustomError, 'Project/Soluation file cannot be found: '+lsProjectSolutionFilename);
   end;
  Output.logformat('MSBuild Project/Solution: %s', [lsProjectSolutionFilename]);   

  lsMSBuildFullname := GetMSBuildFullname(aVersion)
 

  Try
    SB:= TStringBuilder.Create;

    SB.Append( '"' + lsMSBuildFullname + '" ');

    SB.Append('/nologo ');

    SB.Append( lsProjectSolutionFilename + ' ');

    if Trim(aMSBuildOptions.Target) <> '' then
      SB.Append('"/target:' + aMSBuildOptions.Target + '" ');

    if Trim(aMSBuildOptions.Configuration) <> '' then
      SB.Append('"/property:configuration=' + aMSBuildOptions.Configuration + '" ');

    if Trim(aMSBuildOptions.platform) <> '' then   
      SB.Append('"/property:Platform='+aMSBuildOptions.platform+'" ');
    
    if Trim(aMSBuildOptions.OutputPath) <> '' then 
      sb.Append('"/property:OutputPath='+aMSBuildOptions.OutputPath+'" ');   

    if Trim(aMSBuildOptions.OtherParameters) <> '' then
     sb.Append(' ' +aMSBuildOptions.OtherParameters);  
  
    Output.logformat('MSBuild Running: %s', [sb.ToString]);

    result := ExecExA(SB.ToString);
  finally
    SB.Free;
  End;
end;

function GetMSBuildFullname(aVersion: string): string;
begin
  if (CompareText(lowercase(aVersion), '2') = 0) or
     (CompareText(lowercase(aVersion), '2.0') = 0) or
     (CompareText(lowercase(aVersion), '3.5') = 0) or
     (CompareText(lowercase(aVersion), '4') = 0) or
     (CompareText(lowercase(aVersion), '4.0') = 0) then
     result := GetDotNETFrameworkDirectory(aVersion) + 'MSBuild.exe'
   else   
   if (CompareText(lowercase(aVersion), 'VSCommunity2019') = 0) then 
     result := cVSCommunity2019  
   else 
     RaiseException(erCustomError, 'Unsupported version ("2.0", "3.5", "4.0", "VSCommunity2019") of msbuild');   
   
  if not Files.Exists(result) then RaiseException(erCustomError, 'msbuild.exe not found: '+result);
end;


// https://docs.microsoft.com/en-us/dotnet/framework/tools/tlbexp-exe-type-library-exporter

function TlbExp(aOptions: string): integer;
begin
  if not Files.Exists(cTlbExp48) then RaiseException(erCustomError, 'TlbExp.exe not found: '+cTlbExp48);

  result := Exec(cTlbExp48 + ' ' + aOptions);
end;



end.