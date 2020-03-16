{$I CodeImatic.build.inc}
unit Project;

interface

Uses NovusXMLBO, Classes, SysUtils, NovusStringUtils, NovusBO, NovusList,
  JvSimpleXml, NovusSimpleXML, XMLlist, ProjectConfigLoader, NovusFileUtils,
  API_output, ProjectTask, NovusUtilities, ProjectLog;


Type


  TProject = class(TXMLlist)
  protected
  private
    foProjectLog: TProjectLog;
    fsOutputPath: string;
    fbOutputConsole: Boolean;
    foProjectConfigLoader: TProjectConfigLoader;
    foprojecttaskList: TNovusList;
    fsBasePath: String;
    fsProjectFilename: String;
  public
    constructor Create; override;
    destructor Destroy; override;

    function GetOutputPath: String;
    function GetOutputConsole: Boolean;
    function GetCreateoutputdir: Boolean;

    function GetWorkingdirectory: String;

    function LoadProjectFile(aProjectFilename: String; aWorkingdirectory: string): Boolean;
    function Loadprojecttask(aTaskName: String;
      aprojecttask: Tprojecttask): Boolean;

    property oprojecttaskList: TNovusList read foprojecttaskList
      write foprojecttaskList;

    property ProjectFilename: String read fsProjectFilename
      write fsProjectFilename;

    property OutputPath: string read fsOutputPath write fsOutputPath;

    property OutputConsole: Boolean read fbOutputConsole write fbOutputConsole;

    property oProjectConfigLoader: TProjectConfigLoader read foProjectConfigLoader
      write foProjectConfigLoader;

  end;

const
  cTimeformat = 'hh:mm:ss.zzz';

implementation

uses ProjectParser;

constructor TProject.Create;
begin
  inherited Create;

  foProjectConfigLoader := TProjectConfigLoader.Create(self, foProjectLog);

  foprojecttaskList := TNovusList.Create(Tprojecttask);

  foProjectLog := TProjectLog.Create;
end;

destructor TProject.Destroy;
begin
  foProjectLog.Free;

  foProjectConfigLoader.Free;

  foprojecttaskList.Free;

  inherited;
end;

function TProject.Loadprojecttask(aTaskName: String;
  aprojecttask: Tprojecttask): Boolean;
Var
  fprojecttaskNode, fsucceededNode, ferrorsNode, ffailedNode, fAbortNode,
    fskipNode, fretryNode, fcriteriaNode: TJvSimpleXmlElem;
  Index: integer;
begin
  Result := False;

  Try
    fprojecttaskNode := TnovusSimpleXML.FindNodeByValue(oXMLDocument.Root,
      'projecttask', 'name', aTaskName);

    If Assigned(fprojecttaskNode) then
    begin
      Index := 0;
      if Assigned(TnovusSimpleXML.FindNode(fprojecttaskNode, 'projectfilename',
        Index)) then
      begin
        aprojecttask.Criteria.Failed.Retry := 0;

        Index := 0;

        aprojecttask.ProjectFilename := tProjectParser.ParseProject(TnovusSimpleXML.FindNode
          (fprojecttaskNode, 'projectfilename', Index).Value, Self,
           foProjectLog);


        fcriteriaNode := TnovusSimpleXML.FindNode(fprojecttaskNode,
          'criteria', Index);

        aprojecttask.Criteria.Failed.Retry := 0;
        aprojecttask.Criteria.Failed.skip := False;
        aprojecttask.Criteria.Failed.abort := False;

        if Assigned(fcriteriaNode) then
        begin
          Index := 0;
          ffailedNode := TnovusSimpleXML.FindNode(fcriteriaNode,
            'failed', Index);
          if Assigned(ffailedNode) then
          begin
            Index := 0;
            fretryNode := TnovusSimpleXML.FindNode(ffailedNode, 'retry', Index);
            if Assigned(fretryNode) then
              aprojecttask.Criteria.Failed.Retry :=
                TNovusStringUtils.Str2Int(fretryNode.Value);

            Index := 0;
            fskipNode := TnovusSimpleXML.FindNode(ffailedNode, 'skip', Index);
            if Assigned(fskipNode) then
              aprojecttask.Criteria.Failed.skip :=
                TNovusStringUtils.StrToBoolean(fskipNode.Value);

            Index := 0;
            fAbortNode := TnovusSimpleXML.FindNode(ffailedNode, 'abort', Index);
            if Assigned(fAbortNode) then
              aprojecttask.Criteria.Failed.abort :=
                TNovusStringUtils.StrToBoolean(fAbortNode.Value);
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

  lsWorkingdirectory := Trim(foProjectConfigLoader.workingdirectory);

  if lsWorkingdirectory <> '' then
    lsWorkingdirectory := IncludeTrailingPathDelimiter
      (foProjectConfigLoader.workingdirectory);

  if (Not DirectoryExists(lsWorkingdirectory)) or (Trim(lsWorkingdirectory) = '')
  then
    lsWorkingdirectory := IncludeTrailingPathDelimiter
      (TNovusFileUtils.AbsoluteFilePath(ProjectFilename));

  Result := lsWorkingdirectory;
end;

function TProject.GetOutputPath: String;
Var
  lsOutputpath: String;
begin
  lsOutputpath := Trim(GetFieldAsString(oXMLDocument.Root, 'Outputpath'));

  if lsOutputpath <> '' then
    Result := TNovusFileUtils.TrailingBackSlash(lsOutputpath);
end;

function TProject.GetOutputConsole: Boolean;
begin
  Result := GetFieldAsBoolean(oXMLDocument.Root, 'outputconsole');
end;

function TProject.LoadProjectFile(aProjectFilename: String;
  aWorkingdirectory: string): Boolean;
Var
  fprojecttaskNode: TJvSimpleXmlElem;
  Index: integer;
  loprojecttask: Tprojecttask;
begin
  XMLFileName := aProjectFilename;
  Result := Retrieve;
  if not Result then
    exit;

  fsOutputPath := GetOutputPath;
  fbOutputConsole := GetOutputConsole;

  ProjectFilename := aProjectFilename;

  // Project Config

  foProjectConfigLoader.LoadProjectConfig(aWorkingdirectory);

  // Project task
  Index := 0;
  fprojecttaskNode := TnovusSimpleXML.FindNode(oXMLDocument.Root,
    'projecttask', Index);
  While (fprojecttaskNode <> NIL) do
  begin
    loprojecttask := Tprojecttask.Create;

    loprojecttask.TaskName := fprojecttaskNode.Properties[0].Value;

    Loadprojecttask(loprojecttask.TaskName, loprojecttask);

    oprojecttaskList.Add(loprojecttask);

    fprojecttaskNode := TnovusSimpleXML.FindNode(oXMLDocument.Root,
      'projecttask', Index);
  end;

end;

function TProject.GetCreateoutputdir: Boolean;
begin
  Result := GetFieldAsBoolean(oXMLDocument.Root, 'Createoutputdir');
end;




end.
