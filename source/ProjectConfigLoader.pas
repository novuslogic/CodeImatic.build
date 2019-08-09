{$I CodeImatic.build.inc}
unit ProjectConfigLoader;

interface

uses XMLList, NovusTemplate, SysUtils, NovusSimpleXML, JvSimpleXml, novuslist,
  NovusStringUtils, NovusEnvironment, NovusFileUtils, Loader;

type
  tProjectConfigLoader = Class(TLoader)
  private
  protected
    FoRootNodeLoader: tNodeLoader;
    foProject: tXMLlist;
    fConnectionNameList: tNovuslist;
    fsSearchPath: String;
    fsworkingdirectory: String;
    fsProjectConfigFileName: String;
  public
    constructor Create(aProject: TXMLlist);
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

constructor tProjectConfigLoader.Create(aProject: TXMLlist);
begin
  foProject := aProject;
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

(*
procedure tProjectConfigLoader.LoadProjectConfigFile(aProjectConfigFilename: String;
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
*)

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
  FNodeLoader: TNodeLoader;
begin
  Result := '';
  if Trim(aPropertyName) = '' then
    Exit;

  FNodeLoader := GetNode(FoRootNodeLoader, aPropertyName);
  if FNodeLoader.IsExists then
    Result := GetValue(FNodeLoader.Value)



  (*
  Result := '';
  if aPropertyName = '' then
    Exit;

  if not Assigned(oXMLDocument) then
    Exit;

  Result := tNovusEnvironment.ParseGetEnvironmentVar
    (GetFieldAsString(oXMLDocument.Root, Lowercase(aPropertyName)), ETTToken2);

  Result :=  tNovusEnvironment.ParseGetEnvironmentVar(result, ETTToken1);
  *)
end;

function tProjectConfigLoader.IspropertyExists(aPropertyName: String): boolean;
Var
  FNodeLoader: TNodeLoader;                                                                                   '
begin
  Result := False;

  if Trim(aPropertyName) = '' then
    Exit;

  FNodeLoader := GetNode(FoRootNodeLoader, aPropertyName);
  Result := FNodeLoader.IsExists;

  (*
  if not Assigned(oXMLDocument) then
    Exit;

  Result := IsFieldExists(oXMLDocument.Root, Lowercase(aPropertyName));
  *)
end;

function tProjectConfigLoader.CreateProperty(aPropertyName: String): boolean;
begin
  (*
  oXMLDocument.Root.Items.Add(Lowercase(aPropertyName));

  Result := Post;
  *)
end;

function tProjectConfigLoader.SetProperty(aPropertyName: String;
  aValue: String): boolean;
begin
  (*
  SetFieldAsString(oXMLDocument.Root, aPropertyName, aValue);

  Result := Post;
  *)
end;

function tProjectConfigLoader.DeleteProperty(aPropertyName: String): boolean;
var
  fNodeList: TJvSimpleXmlElem;
  fIndex: Integer;
begin
  (*
  Result := False;

  fIndex := 0;

  fNodeList := FindNode(oXMLDocument.Root, aPropertyName, fIndex);
  if Assigned(fNodeList) then
  begin
    DeleteXML(fNodeList);

    Result := Post;
  end;
  *)
end;

function tProjectConfigLoader.Load: boolean;
begin
  Result := false;
  RootNode := foProject.GetNode('projectconfig');
  if RootNode = Nil then Exit;

  FoRootNodeLoader := GetRootNode;

  Result := True;

  (*

  if FRootNodeLoader.PropertyName = 'FOLDER' then
  begin
    foProjectItem.ItemFolder := GetValue(FrootNodeLoader.PropertyValue);
    foProjectItem.ProjectItemType := pitFolder;
  end
  else if FRootNodeLoader.PropertyName = 'NAME' then
  begin
    foProjectItem.ItemName := GetValue(FRootNodeLoader.PropertyValueA);
    foProjectItem.ProjectItemType := pitItem;
  end
  else
  begin
    foOutput.LogError('projectitem.folder or projectitem.name required.');
    Result := False;

    exit;
  end;

  FNodeLoader := GetNode(FRootNodeLoader, 'properties');
  if FNodeLoader.IsExists then
    foProjectItem.propertiesFile := GetValue(FNodeLoader.Value);

  foProjectItem.overrideoutput := false;
  FNodeLoader := GetNode(FRootNodeLoader, 'overrideoutput');
  if FNodeLoader.IsExists then
    foProjectItem.overrideoutput := TNovusStringUtils.IsBoolean(GetValue(FNodeLoader.Value));

  foProjectItem.deleteoutput := false;
  FNodeLoader := GetNode(FRootNodeLoader, 'deleteoutput');
  if FNodeLoader.IsExists then
    foProjectItem.deleteoutput := TNovusStringUtils.StrToBoolean(GetValue(FNodeLoader.Value));

  foProjectItem.IgnoreItem := false;
  FNodeLoader := GetNode(FRootNodeLoader, 'ignoreitem');
  if FNodeLoader.IsExists then
    foProjectItem.ignoreitem := TNovusStringUtils.StrToBoolean(GetValue(FNodeLoader.Value));

  FNodeLoader := GetNode(FRootNodeLoader, 'output');
  if FNodeLoader.IsExists then
    foProjectItem.OutputFile := GetValue(FNodeLoader.Value)
  else
   begin
    foOutput.LogError(foProjectItem.Name + ': projectitem.output required.');
    Result := False;
  end;

  if FRootNodeLoader.PropertyName = 'NAME' then
    begin
      FNodeLoader := GetNode(FRootNodeLoader, 'template');
      if FNodeLoader.IsExists then
       foProjectItem.TemplateFile := GetValue(FNodeLoader.Value);

      FNodeLoader := GetNode(FRootNodeLoader, 'sourcefile');
      if FNodeLoader.IsExists then
       foProjectItem.TemplateFile := GetValue(FNodeLoader.Value);


      FNodeLoader := GetNode(FRootNodeLoader, 'source');
      if FNodeLoader.IsExists then
       foProjectItem.TemplateFile := GetValue(FNodeLoader.Value);
      if Trim(foProjectItem.TemplateFile) = '' then
         begin
           foOutput.LogError(foProjectItem.Name + ': projectitem.source or projectitem.template required.');
           Result := False;
         end;

      FprocessorNodeLoader := GetNode(FRootNodeLoader, 'processor');
      if FprocessorNodeLoader.IsExists then
        begin
          if (FprocessorNodeLoader.PropertyName = 'NAME') then
            foProjectItem.processorPlugin := FNodeLoader.PropertyValue
           else
             foProjectItem.processorPlugin := GetValue(FprocessorNodeLoader.Value);
        end;
    end
  else
  if FRootNodeLoader.PropertyName = 'FOLDER' then
    begin
      FSrcFileNodeLoader := GetNode(FRootNodeLoader, 'sourcefiles');
      if FSrcFileNodeLoader.IsExists then
        begin
          if FSrcFileNodeLoader.PropertyName = 'FOLDER' then
            begin
              foProjectItem.oSourceFiles.Folder := TNovusFileUtils.TrailingBackSlash(GetValue(FSrcFileNodeLoader.PropertyValue));
            end
          else
            begin
              foOutput.LogError(foProjectItem.Name + ': projectitem.sourcefiles.folder required.');
              Result := False;
            end;

          // templates
          FSrcTmpNodeLoader := GetNode(FSrcFileNodeLoader, 'templates');
          if FSrcTmpNodeLoader.IsExists then
            begin
              FTmpFilesNodeLoader := GetNode(FSrcTmpNodeLoader, 'file');
              while(FTmpFilesNodeLoader.IsExists <> false)  do
                begin
                  if (FTmpFilesNodeLoader.PropertyName = 'NAME') then
                     begin
                       lsFullPathname :=
                         GetValue(FTmpFilesNodeLoader.PropertyValue);

                       FprocessorNodeLoader := GetNode(FTmpFilesNodeLoader,
                         'processor');

                       if FprocessorNodeLoader.IsExists then
                         begin
                           if (FprocessorNodeLoader.PropertyName = 'NAME') then
                             lsprocessor := FprocessorNodeLoader.PropertyValue
                           else
                             lsprocessor := GetValue(FprocessorNodeLoader.Value);
                         end;

                       foProjectItem.oSourceFiles.oTemplates.AddFile
                         (foProjectItem.oSourceFiles.Folder + lsFullPathname,
                         lsFullPathname,
                         lsprocessor,
                         FprocessorNodeLoader);
                     end
                     else
                     begin
                       foOutput.LogError(foProjectItem.Name + ': projectitem.sourcefiles.templates.file.name required.');
                       Result := False;
                       break;
                     end;

                  FTmpFilesNodeLoader := GetNode(FSrcTmpNodeLoader, 'file', FTmpFilesNodeLoader.IndexPos);
                end;
             end;


          // filters
          FSrcFltNodeLoader := GetNode(FSrcFileNodeLoader, 'filters');
          if FSrcFltNodeLoader.IsExists then
            begin
              FFltFilesNodeLoader := GetNode(FSrcFltNodeLoader, 'file');
              while(FFltFilesNodeLoader.IsExists <> false)  do
                begin
                  if (FFltFilesNodeLoader.PropertyName = 'NAME') then
                     begin
                       lsFullPathname :=
                         GetValue(FFltFilesNodeLoader.PropertyValue);

                       foProjectItem.oSourceFiles.oFilters.AddFile
                         (foProjectItem.oSourceFiles.Folder + lsFullPathname,
                         lsFullPathname);
                     end
                   else
                     begin
                       foOutput.LogError(foProjectItem.Name + ': projectitem.sourcefiles.filters.file.name required.');
                       Result := False;
                       break;
                     end;

                  FFltFilesNodeLoader := GetNode(FSrcFltNodeLoader, 'file', FFltFilesNodeLoader.IndexPos);
                end;
            end;
        end;

    end;
    *)
end;

end.
