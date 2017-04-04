unit Xcopy;

interface

function IsFileorFolder(aPath: string): integer;
function Xcopy(const aSource, aDestination: string): boolean;

implementation

function Xcopy(const aSource, aDestination: string): boolean;
var
  liIsFileOrFolder: integer;
  fbOverWrite: boolean;
  lsDestiantionFilename: string;
begin 
  result := false;
  
  liIsFileOrFolder := IsFileOrFolder(aSource);
  if liIsFileOrFolder = -2 then
    RaiseException(erCustomError, format('Source [%s] is not a valid file or directory.', aSource)); 
  if Folder.Exists(aDestination) = false then 
    if not Folder.CreateFolder(aDestination) then
      RaiseException(erCustomError, format('Destination [%s] cannot create folder.', aDestination));
  
  Output.log('Copying From [' +aSource + '] To [' + adestination + ']' );

  if liIsFileOrFolder = 1 then 
    begin
      fbOverWrite := True;
      
      lsDestiantionFilename := File.IncludeTrailingPathDelimiter(aDestination) + File.Extractfilename(aSource);

      if not File.Copy(aSource, lsDestiantionFilename, fbOverWrite) then
        RaiseException(erCustomError, format('Failed copying file [%s] ', aSource))
      else result := true;  
    end
  else
  if liIsFileOrFolder = 2 then
    begin
      if not Folder.Copy(aSource, aDestination) then 
        RaiseException(erCustomError, format('Failed copying folder [%s] ', aSource))
      else result := true;  
    end; 
end;

function IsFileOrFolder(aPath: string):integer;
begin
  result := -1;
  if(File.Exists(apath) = true) then result := 1
  else 
  if(folder.Exists(apath) = true) then result := 2;
end;

end.