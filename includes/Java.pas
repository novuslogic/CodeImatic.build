unit Java;

interface

uses Cmd;

function GetJAVA_HOME: string;
function GetJavaFolder: String;
function GetJavaVersion: String;

implementation

function GetJavaVersion: String;
begin
  result := '';
end;

function GetJavaFolder: String;
begin
  result := Files.IncludeTrailingPathDelimiter(GetJAVA_HOME);
end;


// Example: setx -m JAVA_HOME "C:\Program Files\AdoptOpenJDK\jdk-11.0.8.10-hotspot\bin"
function GetJAVA_HOME: string;
begin
  result := Environment.GetEnvironmentVar('JAVA_HOME');

  If Result = '' then
    RaiseException(erCustomError, 'Invalid "JAVA_HOME" environment variable not set.');

end;


function JavaOutput

function Java(const aFilename: string;const aOption: string): Integer;
var
  SB: TStringBuilder;
begin
   Result := -1;

   if not Files.Exists(GetJavaFolder + 'Java.exe') then
     RaiseException(erCustomError, 'Cannot find java.exe.');
    
   Try
     SB:= TStringBuilder.Create;
     SB.Append('"' + GetJavaFolder + 'Java.exe'  + '" ');

     if aFilename <> '' then SB.Append('"' + aFilename  + '"');
 
     if Trim(aOption) <> '' then SB.Append(aOption + ' ');
  
     Output.logformat('Running: %s', [SB.ToString]);

     result := Exec(sb.ToString);
  
  finally
    SB.Free;
  End;
 
end;


end.
