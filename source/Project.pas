unit Project;

interface

Uses NovusXMLBO, Classes, SysUtils, NovusStringUtils, NovusBO, NovusList,
     JvSimpleXml, NovusSimpleXML, XMLlist, ProjectConfig, Dialogs, NovusFileUtils ;

Type
  TBuildStatus = (bsFailed, bsErrors, bsSucceeded, bsNone);

  TProjectItem = class(TNovusBO)
  protected
  private
    fdtStartBuild: tdatetime;
    fdtEndBuild: tDatetime;
    fsItemName: String;
    fsProjectFilename: String;
    fBuildStatus: TBuildStatus;
  Public
    property ProjectFilename: String
      read fsProjectFilename
      write fsProjectFilename;
    property ItemName: String
      read fsItemName
      write fsItemName;

    property StartBuild: tdatetime
      read fdtStartBuild
      write fdtStartBuild;

    property  EndBuild: tDatetime
       read fdtEndBuild
       write fdtEndBuild;

    property BuildStatus: TBuildStatus
      read  fBuildStatus
      write fBuildStatus;
   end;


  TProject = class(TXMLlist)
  protected
  private
    fbOutputConsole: boolean;
    foProjectConfig: TProjectConfig;
    foProjectItemList: TNovusList;
    fsMessageslogPath: String;
    fsProjectFilename: String;
  public
    constructor Create; override;
    destructor Destroy; override;


    function GetMessageslogPath: String;
    function GetOutputConsole: Boolean;
    function GetCreateoutputdir: Boolean;

    function GetWorkingdirectory: String;

    procedure LoadProjectFile(aProjectFilename: String; aProjectConfigFilename: String);
    function LoadProjectItem(aItemName: String; aProjectItem: TProjectItem): Boolean;

    property oProjectItemList: TNovusList
      read foProjectItemList
      write foProjectItemList;

    property ProjectFileName: String
      read fsProjectFileName
      write fsProjectFileName;

    property MessageslogPath: string
      read fsMessageslogPath
      write fsMessageslogPath;

    property  OutputConsole: Boolean
      read  fbOutputConsole
      write fbOutputConsole;

    property oProjectConfig: TProjectConfig
      read foProjectConfig
      write foProjectConfig;

  end;

implementation


constructor TProject.Create;
begin
  inherited Create;

  foProjectConfig := TProjectConfig.Create;

  foProjectItemList:= TNovusList.Create(TProjectItem);

end;

destructor TProject.Destroy;
begin
  foProjectConfig.Free;

  foProjectItemList.Free;

  inherited;
end;

function TProject.LoadProjectItem(aItemName: String; aProjectItem: TProjectItem): Boolean;
Var
  fJvSimpleXmlElem: TJvSimpleXmlElem;
  Index: Integer;
  FNode: TJvSimpleXmlElem;
begin
  Result := False;

  Try
    fJvSimpleXmlElem  := TnovusSimpleXML.FindNodeByValue(oXMLDocument.Root, 'projectitem', 'name', aItemName);

    If Assigned(fJvSimpleXmlElem) then
      begin
        Index := 0;
        if assigned(TNovusSimpleXML.FindNode(fJvSimpleXmlElem, 'projectfilename', Index)) then
          begin
            Index := 0;
            aProjectItem.projectfilename := TNovusSimpleXML.FindNode(fJvSimpleXmlElem, 'projectfilename', Index).Value;
          end;
      end;
  Finally
    Result := True;
  end;
end;

function TProject.GetWorkingdirectory: String;
var
  lsWorkingdirectory: String;
begin
  Result := '';

  lsWorkingdirectory := Trim(foProjectConfig.workingdirectory);

  if lsWorkingdirectory <> '' then
    lsWorkingdirectory :=  IncludeTrailingPathDelimiter(foProjectConfig.workingdirectory);

  if (Not DirectoryExists(lsWorkingdirectory))  or (Trim(lsWorkingdirectory) = '') then
    lsWorkingdirectory := IncludeTrailingPathDelimiter(TNovusFileUtils.AbsoluteFilePath(ProjectFileName));

  result := lsWorkingdirectory;
end;

function TProject.GetMessageslogPath: String;
Var
  lsmessageslogpath: String;
begin
  lsmessageslogpath := Trim(GetFieldAsString(oXMLDocument.Root, 'messageslogpath'));

  if lsmessageslogpath <> '' then
    Result := TNovusStringUtils.TrailingBackSlash(lsmessageslogpath);
end;




function TProject.GetOutputConsole: Boolean;
begin
  Result := GetFieldAsBoolean(oXMLDocument.Root, 'outputconsole');
end;

procedure TProject.LoadProjectFile(aProjectFilename: String; aProjectConfigFilename: String);
Var
  fJvSimpleXmlElem: TJvSimpleXmlElem;
  Index: Integer;
  loProjectItem: TProjectItem;
begin
  XMLFileName := aProjectFilename;
  Retrieve;

  fsMessageslogPath := GetMessageslogPath;
  fbOutputConsole := GetoutputConsole;

  ProjectFileName := aProjectFilename;

  if FileExists(aProjectConfigFilename) then
    foProjectConfig.LoadProjectConfigFile(aProjectConfigFilename);

  //Project Items
  Index := 0;
  fJvSimpleXmlElem  := TNovusSimpleXML.FindNode(oXMLDocument.Root, 'projectitem', Index);
  While(fJvSimpleXmlElem <> NIL) do
    begin
      loProjectItem:= TProjectItem.Create;

      loProjectItem.ItemName := fJvSimpleXmlElem.Properties[0].Value;

      LoadProjectItem(loProjectItem.ItemName, loProjectItem);

      oProjectItemList.Add(loProjectItem);

      fJvSimpleXmlElem  := TNovusSimpleXML.FindNode(oXMLDocument.Root, 'projectitem', Index);
    end;

end;

function TProject.GetCreateoutputdir: Boolean;
begin
  Result := GetFieldAsBoolean(oXMLDocument.Root, 'Createoutputdir');
end;



end.
