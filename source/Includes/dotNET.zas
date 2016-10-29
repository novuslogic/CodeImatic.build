unit dotNET;

interface


function GetDotNETFrameworkDirectory(aVersion: string): string;
   
implementation

function GetDotNETFrameworkDirectory(aVersion: string): string;
begin
   if (CompareText(lowercase(aVersion), '2') = 0) or
      (CompareText(lowercase(aVersion), '2.0') = 0) then
     begin
      if Registry.KeyExists(HKEY_LOCAL_MACHINE, 'SOFTWARE\Microsoft\ASP.NET\2.0.50727.0') then
        Result := Registry.ReadString( HKEY_LOCAL_MACHINE, 'SOFTWARE\Microsoft\ASP.NET\2.0.50727.0', 'Path');
     end
  else 
  if (CompareText(lowercase(aVersion), '3.5') = 0) then
    begin
      if Registry.KeyExists(HKEY_LOCAL_MACHINE, 'SOFTWARE\Microsoft\NET Framework Setup\NDP\v3.5') then
         Result := Registry.ReadString( HKEY_LOCAL_MACHINE, 'SOFTWARE\Microsoft\NET Framework Setup\NDP\v3.5', 'InstallPath');
    end
  else
  if (CompareText(lowercase(aVersion), '4') = 0) or
     (CompareText(lowercase(aVersion), '4.0') = 0) or
     (CompareText(lowercase(aVersion), '4.5') = 0) then
     begin
       if Registry.KeyExists(HKEY_LOCAL_MACHINE, 'SOFTWARE\Microsoft\NET Framework Setup\NDP\v4\Full') then
         Result := Registry.ReadString( HKEY_LOCAL_MACHINE, 'SOFTWARE\Microsoft\NET Framework Setup\NDP\v4\Full', 'InstallPath');
     end
  else 
    RaiseException(erCustomError, 'Unsupported version ("2.0", "3.0", "3.5", "4.0", "4.5")');   
   

  result := File.IncludeTrailingPathDelimiter(result);

  if not Folder.Exists(result) then RaiseException(erCustomError, '.NET Framework not installed: '+result);
end;

end.