unit Solution;

interface

uses NovusXMLBO, SysUtils, NovusStringUtils, NovusFileUtils;

type
   TSolution = class(TNovusXMLBO)
   protected
   private
     fsworkingdirectory: string;
     fsSolutionFilename: string;
     fsProjectFileName: string;
     fsProjectConfigFilename: string;
   public
     property ProjectFileName: string
       read fsProjectFileName;

     property ProjectConfigFilename: string
       read fsProjectConfigFilename;

     property SolutionFilename: string
       read fsSolutionFilename;

     property Workingdirectory: string
       read fsworkingdirectory;

     function LoadSolutionFile(aSolutionFilename: string): Boolean;
   end;

implementation

function TSolution.LoadSolutionFile(aSolutionFilename: string): Boolean;
begin
  Try
    fsSolutionFilename := aSolutionFilename;

    fsworkingdirectory := TNovusFileUtils.TrailingBackSlash(ExtractFilePath(fsSolutionFilename));
    if Trim(fsworkingdirectory) = '' then
      fsworkingdirectory := TNovusFileUtils.TrailingBackSlash(TNovusFileUtils.AbsoluteFilePath(fsSolutionFilename));

    XMLFileName := aSolutionFilename;
    Retrieve;

    fsProjectFileName := Trim(GetFieldAsString(oXMLDocument.Root, 'Project'));
    fsProjectConfigFilename := Trim(GetFieldAsString(oXMLDocument.Root, 'ProjectConfig'));

    if Trim(TNovusStringUtils.JustFilename(fsProjectFilename)) = trim(fsProjectFilename) then
      fsProjectFilename := fsworkingdirectory + fsProjectFilename;

    if Trim(TNovusStringUtils.JustFilename(fsProjectConfigFilename)) = trim(fsProjectConfigFilename) then
      fsProjectConfigFilename := fsworkingdirectory + fsProjectConfigFilename;

    Result := true;
  Except
    Result := false;
  End;
end;

end.
