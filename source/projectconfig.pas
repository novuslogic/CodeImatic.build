{$I Zautomatic.inc}
unit projectconfig;

interface

uses XMLList, NovusTemplate, SysUtils, NovusSimpleXML, JvSimpleXml, novuslist,
     NovusStringUtils, NovusEnvironment;

type
   tProjectConfig = Class(TXMLList)
   private
   protected
     fConnectionNameList: tNovuslist;
     fsSearchPath: String;
     fsworkingdirectory: String;
     fsProjectConfigFileName: String;
   public
      constructor Create; override;
      destructor Destroy; override;

      procedure LoadProjectConfigFile(aProjectConfigFilename: String; aWorkingdirectory: string);

      function IspropertyExists(aPropertyName: String): boolean;
      function Getproperty(aPropertyName: String): String;

      function GetSearchPath: String;
      function GetWorkingdirectory: String;
      function CreateProperty(aPropertyName: String): Boolean;

      function SetProperty(aPropertyName: String; aValue: String): Boolean;
      function DeleteProperty(aPropertyName: String): Boolean;

      property ProjectConfigFileName: String
        read fsProjectConfigFileName
        write fsProjectConfigFileName;

      property SearchPath: String
        read fsSearchPath
        write fsSearchPath;

      property Workingdirectory: string
        read fsworkingdirectory
        write fsworkingdirectory;

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

function  TProjectConfig.GetWorkingdirectory: String;
var
  lsworkingdirectory: string;
begin
  lsworkingdirectory := Trim(Getproperty('workingdirectory'));

  Result := '';
  if lsworkingdirectory  <> ''then
     Result := IncludeTrailingPathDelimiter(lsworkingdirectory);
end;


procedure TProjectConfig.LoadProjectConfigFile(aProjectConfigFilename: String; aWorkingdirectory: string);
begin
  XMLFileName := aProjectConfigFilename;
  Retrieve;

  ProjectConfigFileName := aProjectConfigFilename;

  fsSearchPath := GetSearchPath;
  fsworkingdirectory := GetWorkingdirectory;
  if Trim(fsworkingdirectory) = '' then fsworkingdirectory := aWorkingdirectory;

end;

function TProjectConfig.GetSearchPath: String;
begin
  Result := TNovusStringUtils.TrailingBackSlash(Getproperty('searchpath'));
end;

function TProjectConfig.Getproperty(aPropertyname: string): String;
begin
  result := '';
  if aPropertyName = '' then Exit;

  if not Assigned(oXMLDocument) then Exit;

  Result := tNovusEnvironment.ParseGetEnvironmentVar(GetFieldAsString(oXMLDocument.Root, Lowercase(aPropertyname)));
end;

function TProjectConfig.IspropertyExists(aPropertyName: String): boolean;
begin
  Result := False;

  if not Assigned(oXMLDocument) then Exit;

  Result := IsFieldExists(oXMLDocument.Root,Lowercase(aPropertyName));
end;

function TProjectConfig.CreateProperty(aPropertyName: String): Boolean;
begin
  oXMLDocument.Root.Items.Add(Lowercase(aPropertyName));

  Result := Post;
end;

function TProjectConfig.SetProperty(aPropertyName: String; aValue: String): Boolean;
begin
  SetFieldAsString(oXMLDocument.Root, aPropertyName, aValue);

  Result := Post;
end;

function TProjectConfig.DeleteProperty(aPropertyName: String): Boolean;
var
  fNodeList: TJvSimpleXmlElem;
  fIndex: Integer;
begin
  Result := False;

  fIndex := 0;

  fNodeList := FindNode(oXMLDocument.Root,aPropertyName,fIndex);
  if Assigned(fNodeList) then
    begin
      DeleteXML(fNodeList);

      Result := Post;
    end;
end;

end.
