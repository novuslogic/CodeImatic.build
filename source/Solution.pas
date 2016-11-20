unit Solution;

interface

uses NovusXMLBO, SysUtils, NovusStringUtils, NovusFileUtils;

type
   TSolution = class(TNovusXMLBO)
   protected
   private
     fsProjectFileName: string;
     fsProjectConfigFilename: string;
   public
     property ProjectFileName: string
       read fsProjectFileName;

     property ProjectConfigFilename: string
       read fsProjectConfigFilename;


     function LoadSolutionFile(aSolutionFilename: string): Boolean;
   end;

implementation

function TSolution.LoadSolutionFile(aSolutionFilename: string): Boolean;
begin
  Try
    XMLFileName := aSolutionFilename;
    Retrieve;

    fsProjectFileName := Trim(GetFieldAsString(oXMLDocument.Root, 'Project'));
    fsProjectConfigFilename := Trim(GetFieldAsString(oXMLDocument.Root, 'ProjectConfig'));

    if Trim(TNovusStringUtils.JustFilename(fsProjectFilename)) = trim(fsProjectFilename) then
      fsProjectFilename := IncludeTrailingPathDelimiter(TNovusFileUtils.AbsoluteFilePath(fsProjectFilename)) + Trim(fsProjectFilename);

    if Trim(TNovusStringUtils.JustFilename(fsProjectConfigFilename)) = trim(fsProjectConfigFilename) then
      fsProjectConfigFilename := IncludeTrailingPathDelimiter(TNovusFileUtils.AbsoluteFilePath(fsProjectConfigFilename)) + Trim(fsProjectConfigFilename);



    Result := true;
  Except
    Result := false;
  End;
end;

end.
