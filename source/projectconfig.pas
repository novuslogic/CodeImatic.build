{$I Zautomatic.inc}
unit projectconfig;

interface

uses XMLList, NovusTemplate, SysUtils, NovusSimpleXML, JvSimpleXml, novuslist,
  NovusStringUtils, NovusEnvironment, NovusFileUtils;

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

    procedure LoadProjectConfigFile(aProjectConfigFilename: String;
      aWorkingdirectory: string);

    function IspropertyExists(aPropertyName: String): boolean;
    function Getproperties(aPropertyName: String): String;

    function GetSearchPath: String;
    function GetWorkingdirectory: String;
    function CreateProperty(aPropertyName: String): boolean;

    function SetProperty(aPropertyName: String; aValue: String): boolean;
    function DeleteProperty(aPropertyName: String): boolean;

    property ProjectConfigFileName: String read fsProjectConfigFileName
      write fsProjectConfigFileName;

    property SearchPath: String read fsSearchPath write fsSearchPath;

    property Workingdirectory: string read fsworkingdirectory
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

function tProjectConfig.GetWorkingdirectory: String;
var
  lsworkingdirectory: string;
begin
  lsworkingdirectory := Trim(Getproperties('workingdirectory'));

  Result := '';
  if lsworkingdirectory <> '' then
    Result := IncludeTrailingPathDelimiter(lsworkingdirectory);
end;

procedure tProjectConfig.LoadProjectConfigFile(aProjectConfigFilename: String;
  aWorkingdirectory: string);
begin
  XMLFileName := aProjectConfigFilename;
  Retrieve;

  ProjectConfigFileName := aProjectConfigFilename;

  fsSearchPath := GetSearchPath;
  fsworkingdirectory := GetWorkingdirectory;
  if Trim(fsworkingdirectory) = '' then
    fsworkingdirectory := aWorkingdirectory;

end;

function tProjectConfig.GetSearchPath: String;
begin
  Result := TNovusFileUtils.TrailingBackSlash(Getproperties('searchpath'));
end;

function tProjectConfig.Getproperties(aPropertyName: string): String;
begin
  Result := '';
  if aPropertyName = '' then
    Exit;

  if not Assigned(oXMLDocument) then
    Exit;

  Result := tNovusEnvironment.ParseGetEnvironmentVar
    (GetFieldAsString(oXMLDocument.Root, Lowercase(aPropertyName)));
end;

function tProjectConfig.IspropertyExists(aPropertyName: String): boolean;
begin
  Result := False;

  if not Assigned(oXMLDocument) then
    Exit;

  Result := IsFieldExists(oXMLDocument.Root, Lowercase(aPropertyName));
end;

function tProjectConfig.CreateProperty(aPropertyName: String): boolean;
begin
  oXMLDocument.Root.Items.Add(Lowercase(aPropertyName));

  Result := Post;
end;

function tProjectConfig.SetProperty(aPropertyName: String;
  aValue: String): boolean;
begin
  SetFieldAsString(oXMLDocument.Root, aPropertyName, aValue);

  Result := Post;
end;

function tProjectConfig.DeleteProperty(aPropertyName: String): boolean;
var
  fNodeList: TJvSimpleXmlElem;
  fIndex: Integer;
begin
  Result := False;

  fIndex := 0;

  fNodeList := FindNode(oXMLDocument.Root, aPropertyName, fIndex);
  if Assigned(fNodeList) then
  begin
    DeleteXML(fNodeList);

    Result := Post;
  end;
end;

end.
