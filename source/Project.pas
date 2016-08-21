unit Project;

interface

Uses NovusXMLBO, Classes, SysUtils, NovusStringUtils, NovusBO, NovusList,
     JvSimpleXml, NovusSimpleXML, XMLlist, ProjectConfig, Dialogs, NovusFileUtils ;

Type
  TBuildStatus = (bsSucceeded, bsErrors, bsFailed);

  TCriteria = class(TNovusBO)
  protected
    firetry: integer;
    fbSkip: Boolean;
    fbAbort: Boolean;
  private
  public
    property Retry:integer
      read firetry
      write firetry;

    property skip: Boolean
      read fbSkip
      write fbSkip;

    property abort: Boolean
      read fbAbort
      write fbAbort;
  end;

  Tprojecttask = class(TNovusBO)
  protected
  private
    fdtStartBuild: tdatetime;
    fdtEndBuild: tDatetime;
    fsTaskName: String;
    fsProjectFilename: String;
    fBuildStatus: TBuildStatus;
    FdtDuration: TDateTime;
    FCriteria: TCriteria;
  Public
    constructor Create; override;
    destructor Destroy; override;

    property ProjectFilename: String
      read fsProjectFilename
      write fsProjectFilename;

    property TaskName: String
      read fsTaskName
      write fsTaskName;

    property StartBuild: tdatetime
      read fdtStartBuild
      write fdtStartBuild;

    property  EndBuild: tDatetime
       read fdtEndBuild
       write fdtEndBuild;

    property BuildStatus: TBuildStatus
      read  fBuildStatus
      write fBuildStatus;

    property Duration: TDateTime
      read FdtDuration
      write FdtDuration;

    property Criteria: TCriteria
       read FCriteria
       write FCriteria;
  end;


  TProject = class(TXMLlist)
  protected
  private
    fbOutputConsole: boolean;
    foProjectConfig: TProjectConfig;
    foprojecttaskList: TNovusList;
    fsOutputPath: String;
    fsProjectFilename: String;
  public
    constructor Create; override;
    destructor Destroy; override;

    function GetOutputPath: String;
    function GetOutputConsole: Boolean;
    function GetCreateoutputdir: Boolean;

    function GetWorkingdirectory: String;

    procedure LoadProjectFile(aProjectFilename: String; aProjectConfigFilename: String);
    function Loadprojecttask(aTaskName: String; aprojecttask: Tprojecttask): Boolean;

    property oprojecttaskList: TNovusList
      read foprojecttaskList
      write foprojecttaskList;

    property ProjectFileName: String
      read fsProjectFileName
      write fsProjectFileName;

    property OutputPath: string
      read fsOutputPath
      write fsOutputPath;

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

  foprojecttaskList:= TNovusList.Create(Tprojecttask);

end;

destructor TProject.Destroy;
begin
  foProjectConfig.Free;

  foprojecttaskList.Free;

  inherited;
end;

function TProject.Loadprojecttask(aTaskName: String; aprojecttask: Tprojecttask): Boolean;
Var
  fprojecttaskNode,
  fsucceededNode,
  ferrorsNode,
  ffailedNode,
  fAbortNode,
  fskipNode,
  fretryNode,
  fcriteriaNode: TJvSimpleXmlElem;
  Index: Integer;
begin
  Result := False;

  Try
    fprojecttaskNode  := TnovusSimpleXML.FindNodeByValue(oXMLDocument.Root, 'projecttask', 'name', aTaskName);

    If Assigned(fprojecttaskNode) then
      begin
        Index := 0;
        if assigned(TNovusSimpleXML.FindNode(fprojecttaskNode, 'projectfilename', Index)) then
          begin
            aprojecttask.Criteria.retry := 0;


            Index := 0;
            aprojecttask.projectfilename := TNovusSimpleXML.FindNode(fprojecttaskNode, 'projectfilename', Index).Value;

            fcriteriaNode := TNovusSimpleXML.FindNode(fprojecttaskNode, 'criteria', Index);

            aprojecttask.Criteria.retry := 0;
            aprojecttask.Criteria.skip := false;
            aprojecttask.Criteria.Abort := false;


            if Assigned(fcriteriaNode) then
              begin
                Index := 0;
                ffailedNode := TNovusSimpleXML.FindNode(fcriteriaNode, 'failed', Index);
                if Assigned(ffailedNode) then
                  begin
                    Index := 0;
                    fretryNode := TNovusSimpleXML.FindNode(ffailedNode, 'retry', Index);
                    if assigned(fretryNode) then
                      aprojecttask.Criteria.retry := TNovusStringUtils.Str2Int(fretryNode.Value);

                    Index := 0;
                    fskipNode := TNovusSimpleXML.FindNode(ffailedNode, 'skip', Index);
                    if assigned(fskipNode) then
                      aprojecttask.Criteria.skip := TNovusStringUtils.StrToBoolean(fskipNode.Value);

                    Index := 0;
                    fabortNode := TNovusSimpleXML.FindNode(ffailedNode, 'abort', Index);
                    if assigned(fabortNode) then
                      aprojecttask.Criteria.abort := TNovusStringUtils.StrToBoolean(fabortNode.Value);
                  end;


              end;
            


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

function TProject.GetOutputPath: String;
Var
  lsOutputpath: String;
begin
  lsOutputpath := Trim(GetFieldAsString(oXMLDocument.Root, 'Outputpath'));

  if lsOutputpath <> '' then
    Result := TNovusStringUtils.TrailingBackSlash(lsOutputpath);
end;




function TProject.GetOutputConsole: Boolean;
begin
  Result := GetFieldAsBoolean(oXMLDocument.Root, 'outputconsole');
end;

procedure TProject.LoadProjectFile(aProjectFilename: String; aProjectConfigFilename: String);
Var
  fprojecttaskNode: TJvSimpleXmlElem;
  Index: Integer;
  loprojecttask: Tprojecttask;
begin
  XMLFileName := aProjectFilename;
  Retrieve;

  fsOutputPath := GetOutputPath;
  fbOutputConsole := GetoutputConsole;

  ProjectFileName := aProjectFilename;

  if FileExists(aProjectConfigFilename) then
    foProjectConfig.LoadProjectConfigFile(aProjectConfigFilename);

  //Project task
  Index := 0;
  fprojecttaskNode  := TNovusSimpleXML.FindNode(oXMLDocument.Root, 'projecttask', Index);
  While(fprojecttaskNode <> NIL) do
    begin
      loprojecttask:= Tprojecttask.Create;

      loprojecttask.TaskName := fprojecttaskNode.Properties[0].Value;

      Loadprojecttask(loprojecttask.TaskName, loprojecttask);

      oprojecttaskList.Add(loprojecttask);

      fprojecttaskNode  := TNovusSimpleXML.FindNode(oXMLDocument.Root, 'projecttask', Index);
    end;

end;

function TProject.GetCreateoutputdir: Boolean;
begin
  Result := GetFieldAsBoolean(oXMLDocument.Root, 'Createoutputdir');
end;

constructor Tprojecttask.Create;
begin
  inherited Create;

  FCriteria:=  TCriteria.Create;


end;

destructor Tprojecttask.Destroy;
begin
  FCriteria.Free;

  inherited;
end;




end.
