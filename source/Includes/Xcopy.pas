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

  if liIsFileOrFolder = -1 then
    RaiseException(erCustomError, 'Source ['+ aSource+ '] is not a valid file or directory.'); 

  if Folder.Exists(aDestination) = false then 
    if not Folder.CreateFolder(aDestination) then
      RaiseException(erCustomError, 'Destination cannot create folder [' + aDestination +']');
  
  Output.log('Copying From [' +aSource + '] To [' + adestination + ']' );

  fbOverWrite := True;              
  if liIsFileOrFolder = 1 then 
    begin
      If File.Exists(aSource)  = false then 
        RaiseException(erCustomError, format('Mssing source file [%s] ', aSource));
        
      lsDestiantionFilename := File.IncludeTrailingPathDelimiter(aDestination) + File.Extractfilename(aSource);

      if not File.Copy(aSource, lsDestiantionFilename, fbOverWrite) then
        RaiseException(erCustomError, 'Failed copying file [' + aSource +'] ')
      else result := true;  
    end
  else
  if (liIsFileOrFolder = 2)  then
    begin
      Output.log('Copying folder: [' + aSource + ']');

      If Folder.Exists(aSource)  = false then 
        RaiseException(erCustomError, 'Mssing source folder [' + aSource +']');

       if not Folder.Copy(aSource, aDestination) then 
         RaiseException(erCustomError, 'Failed copying folder ['+  aSource + ']')

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