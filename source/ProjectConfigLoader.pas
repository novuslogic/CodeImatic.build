{$I CodeImatic.build.inc}
unit ProjectConfigLoader;

interface

uses XMLList, NovusTemplate, SysUtils, NovusSimpleXML, JvSimpleXml, novuslist,
  NovusStringUtils, NovusEnvironment, NovusFileUtils, Loader, ProjectLog,
  NovusBO;

type
  tProjectConfigLoader = Class(TLoader)
  private
  protected
    foProjectLog: TProjectLog;
    FoRootNodeLoader: tNodeLoader;
    foProject: tXMLlist;
    fConnectionNameList: tNovuslist;
    fsSearchPath: String;
    fsworkingdirectory: String;
    fsProjectConfigFileName: String;
  public
    constructor Create(aProject: tXMLlist; aProjectLog: TProjectLog);
    destructor Destroy; override;

    function Load: boolean; override;

    procedure LoadProjectConfig(aWorkingdirectory: string);

    function IspropertyExists(aPropertyName: String): boolean;
    function Getproperties(aPropertyName: String): String;

    function GetSearchPath: String;
    function GetWorkingdirectory: String;
    function CreateProperty(aPropertyName: String): boolean;

    function SetProperty(aPropertyName: String; aValue: String): boolean;
    function DeleteProperty(aPropertyName: String): boolean;

    property SearchPath: String read fsSearchPath write fsSearchPath;

    property Workingdirectory: string read fsworkingdirectory
      write fsworkingdirectory;

  End;

implementation

Uses ProjectParser, Project, API_Output;

constructor tProjectConfigLoader.Create(aProject: tXMLlist; aProjectLog: TProjectLog);
begin
  foProject := aProject;

  foProjectLog := aProjectLog;
end;

destructor tProjectConfigLoader.Destroy;
begin
  inherited;

  fConnectionNameList.Free;
end;

function tProjectConfigLoader.GetWorkingdirectory: String;
var
  lsworkingdirectory: string;
begin
  lsworkingdirectory := Trim(Getproperties('workingdirectory'));

  Result := '';
  if lsworkingdirectory <> '' then
    Result := IncludeTrailingPathDelimiter(lsworkingdirectory);
end;

procedure tProjectConfigLoader.LoadProjectConfig(aWorkingdirectory: string);
begin
  Load;

  fsSearchPath := GetSearchPath;
  fsworkingdirectory := GetWorkingdirectory;
  if Trim(fsworkingdirectory) = '' then
    fsworkingdirectory := aWorkingdirectory;

end;

function tProjectConfigLoader.GetSearchPath: String;
begin
  Result := TNovusFileUtils.TrailingBackSlash(Getproperties('searchpath'));
end;

function tProjectConfigLoader.Getproperties(aPropertyName: string): String;
Var
  FNodeLoader: tNodeLoader;
  lsItemName: string;
begin
  Result := '';
  if Trim(aPropertyName) = '' then
    Exit;

  FNodeLoader := GetNode(FoRootNodeLoader, aPropertyName);
  if FNodeLoader.IsExists then
    lsItemName := GetValue(FNodeLoader.Value);
  //else
  //   lsItemName := aPropertyName;


  Result := tProjectParser.ParseProject(lsItemName, tProject(foProject),
        foProjectLog)
end;

function tProjectConfigLoader.IspropertyExists(aPropertyName: String): boolean;
Var
  FNodeLoader: tNodeLoader;
begin
  Result := False;

  if Trim(aPropertyName) = '' then
    Exit;

  FNodeLoader := GetNode(FoRootNodeLoader, aPropertyName);
  Result := FNodeLoader.IsExists;
end;

function tProjectConfigLoader.CreateProperty(aPropertyName: String): boolean;
Var
  FNodeLoader: tNodeLoader;
begin
  Result := False;

  FNodeLoader := GetNode(FoRootNodeLoader, aPropertyName);
  if not FNodeLoader.IsExists then
  begin
    FoRootNodeLoader.Node.Items.Add(Lowercase(aPropertyName));

    Result := foProject.Post;
  end;
end;

function tProjectConfigLoader.SetProperty(aPropertyName: String;
  aValue: String): boolean;
Var
  FNodeLoader: tNodeLoader;
begin
  Result := False;

  FNodeLoader := GetNode(FoRootNodeLoader, aPropertyName);
  if FNodeLoader.IsExists then
  begin
    FNodeLoader.Value := aValue;

    Result := foProject.Post;
  end;
end;

function tProjectConfigLoader.DeleteProperty(aPropertyName: String): boolean;
Var
  FNodeLoader: tNodeLoader;
begin
  Result := False;

  FNodeLoader := GetNode(FoRootNodeLoader, aPropertyName);
  if FNodeLoader.IsExists then
  begin
    FoRootNodeLoader.Node.Items.Delete(FNodeLoader.Node.Name);

    Result := foProject.Post;
  end;
end;

function tProjectConfigLoader.Load: boolean;
begin
  Result := False;
  RootNode := foProject.GetNode('projectconfig');
  if RootNode = Nil then
    Exit;

  FoRootNodeLoader := GetRootNode;

  Result := True;
end;

end.
