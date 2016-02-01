unit projectconfig;

interface

uses XMLList, NovusTemplate, SysUtils, NovusSimpleXML, JvSimpleXml, novuslist,
     NovusStringUtils;

type



   tProjectConfig = Class(TXMLList)
   private
   protected
     fConnectionNameList: tNovuslist;
     fsIncludesPath: String;
     fsProjectConfigFileName: String;
   public
      constructor Create; override;
      destructor Destroy; override;

      procedure LoadProjectConfigFile(aProjectConfigFilename: String);

      function Parseproperties(aInput: String): String;

      property ProjectConfigFileName: String
        read fsProjectConfigFileName
        write fsProjectConfigFileName;

      property SearchPath: String
        read fsIncludesPath
        write fsIncludesPath;


   End;


implementation

constructor tProjectConfig.Create;
begin
  inherited;
end;

destructor tProjectConfig.Destroy;
begin
  inherited;

  fConnectionNameList.Free;
end;

procedure TProjectConfig.LoadProjectConfigFile(aProjectConfigFilename: String);
begin
  XMLFileName := aProjectConfigFilename;
  Retrieve;

  ProjectConfigFileName := aProjectConfigFilename;

  fsIncludesPath := TNovusStringUtils.TrailingBackSlash(GetFieldAsString(oXMLDocument.Root, 'includespath'));
end;

function TProjectConfig.Parseproperties(aInput: String): String;
Var
  loTemplate: tNovusTemplate;
  I: INteger;
  FTemplateTag: TTemplateTag;
begin
  result := aInput;

  if aInput = '' then Exit;

  loTemplate := tNovusTemplate.Create;

  loTemplate.StartToken := '[';
  loTemplate.EndToken := ']';
  loTemplate.SecondToken := '%';

  loTemplate.TemplateDoc.Text := Trim(aInput);

  loTemplate.ParseTemplate;

  For I := 0 to loTemplate.TemplateTags.Count -1 do
    begin
      FTemplateTag := TTemplateTag(loTemplate.TemplateTags.items[i]);

      FTemplateTag.TagValue := GetFirstNodeName(FTemplateTag.TagName, 'properties');
    end;

  loTemplate.InsertAllTagValues;

  Result := Trim(loTemplate.OutputDoc.Text);

  loTemplate.Free;
end;



end.
