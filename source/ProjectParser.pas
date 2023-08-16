unit ProjectParser;

interface

uses system.Classes,  SysUtils, Project, API_Output, ProjectLog,
      TokenProcessor, NovusEnvironment, TagType, TagParser;


type
   tProjectParser = class
   protected
   private
   public
     class function ParseProject(aItemName: String; aProject: tProject; aProjectLog: tProjectLog): String;
   end;


implementation

uses VariablesCmdLine, NovusTemplate, Config;

class function tProjectParser.ParseProject(aItemName: String; aProject: tProject; aProjectLog: tProjectLog): String;
var
  loTemplate: tNovusTemplate;
  I: Integer;
  FTemplateTag: TTemplateTag;
  FTagType: TTagType;
begin
  Result := '';

  if aItemName= '' then Exit;

  loTemplate := NIL;


  Try
    loTemplate := tNovusTemplate.Create;

    loTemplate.StartToken := '[';
    loTemplate.EndToken := ']';
    loTemplate.SecondToken := '%';

//    loTemplate.TemplateDoc.Text := Trim(aItemName);
    loTemplate.LoadFromString(Trim(aItemName));

    loTemplate.ParseTemplate;

    For I := 0 to loTemplate.TemplateTags.Count -1 do
       begin

         FTemplateTag := TTemplateTag(loTemplate.TemplateTags.items[i]);

         FTagType := TTagParser.ParseTagType(FTemplateTag.TagName, aProjectLog);

         case FtagType of
           ttworkingdirectory:
             begin
               FTemplateTag.TagValue := aProject.GetWorkingDirectory;
             end
           else
             FTemplateTag.TagValue := aProject.oProjectConfigLoader.Getproperties(FTemplateTag.TagName);
         end;
       end;

    loTemplate.InsertAllTagValues;

    Result := Trim(loTemplate.OutputDoc.Text);
  Finally
    if Assigned(loTemplate) then loTemplate.Free;
  End;

  Result :=  tNovusEnvironment.ParseGetEnvironmentVar(Result,ETTToken2 );
end;



end.
