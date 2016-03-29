unit projectconfig;

interface

uses XMLList, NovusTemplate, SysUtils, NovusSimpleXML, JvSimpleXml, novuslist,
     NovusStringUtils;

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

      procedure LoadProjectConfigFile(aProjectConfigFilename: String);

      function IspropertyExists(aPropertyName: String): boolean;
      function Getproperty(aPropertyName: String): String;

      function GetSearchPath: String;
      function GetWorkingdirectory: String;

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
begin
  Result := TNovusStringUtils.TrailingBackSlash(Getproperty('workingdirectory'));
end;


procedure TProjectConfig.LoadProjectConfigFile(aProjectConfigFilename: String);
begin
  XMLFileName := aProjectConfigFilename;
  Retrieve;

  ProjectConfigFileName := aProjectConfigFilename;

  fsSearchPath := GetSearchPath;
  fsworkingdirectory := GetWorkingdirectory;
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

  Result := GetFieldAsString(oXMLDocument.Root, aPropertyname);
end;

function TProjectConfig.IspropertyExists(aPropertyName: String): boolean;
begin
  Result := False;


  if not Assigned(oXMLDocument) then Exit;


  Result := IsFieldExists(oXMLDocument.Root,aPropertyName);
end;

end.
