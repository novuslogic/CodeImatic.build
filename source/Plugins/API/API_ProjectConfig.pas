unit API_ProjectConfig;

interface

uses APIBase, Runtime, SysUtils;

type
  TAPI_ProjectConfig = class(TAPIBase)
  private
  protected
    function GetProjectConfigFileName: String;
    function GetSearchPath: String;
    function Getworkingdirectory: String;
  public
    property ProjectConfigFileName: String read GetProjectConfigFileName;

    property SearchPath: String read GetSearchPath;

    property Workingdirectory: string read Getworkingdirectory;

    procedure Createproperty(aPropertyName: String);
    function IsPropertyExists(aPropertyName: String): Boolean;
    function SetProperty(aPropertyName: String; aValue: String): Boolean;
    function DeleteProperty(aPropertyName: String): Boolean;

    function Getproperty(aPropertyName: String): String;
  end;

Const
  API_ProjectConfig_NopropertyExists = 'propertyname cannot be found [%s].';
  API_ProjectConfig_Nopropertyblank = 'propertyname cannot be blank.';
  API_ProjectConfig_propertyExists = 'propertyname exists [%s].';

implementation

procedure TAPI_ProjectConfig.Createproperty(aPropertyName: String);
begin
  Try
    if Trim(aPropertyName) = '' then
    begin
      RuntimeErrorFmt(API_ProjectConfig_Nopropertyblank, []);

      Exit;
    end;

    if oRuntime.oProject.oProjectConfig.IsPropertyExists(aPropertyName) then
    begin
      RuntimeErrorFmt(API_ProjectConfig_propertyExists, [aPropertyName]);

      Exit;
    end;

    if not oRuntime.oProject.oProjectConfig.Createproperty(aPropertyName) then
      oAPI_Output.InternalError;
  Except
    oAPI_Output.InternalError;
  End;
end;

function TAPI_ProjectConfig.IsPropertyExists(aPropertyName: String): Boolean;
begin
  Result := False;

  Try
    if Trim(aPropertyName) = '' then
    begin
      RuntimeErrorFmt(API_ProjectConfig_Nopropertyblank, []);

      Exit;
    end;

    Result := oRuntime.oProject.oProjectConfig.IsPropertyExists(aPropertyName);
  Except
    oAPI_Output.InternalError;
  End;
end;

function TAPI_ProjectConfig.SetProperty(aPropertyName: String;
  aValue: String): Boolean;
begin
  Try
    if Trim(aPropertyName) = '' then
    begin
      RuntimeErrorFmt(API_ProjectConfig_Nopropertyblank, []);

      Exit;
    end;

    if Not oRuntime.oProject.oProjectConfig.IsPropertyExists(aPropertyName) then
    begin
      RuntimeErrorFmt(API_ProjectConfig_NopropertyExists, [aPropertyName]);

      Exit;
    end;

    if not oRuntime.oProject.oProjectConfig.SetProperty(aPropertyName, aValue)
    then
      oAPI_Output.InternalError;

  Except
    oAPI_Output.InternalError;
  End;
end;

function TAPI_ProjectConfig.DeleteProperty(aPropertyName: String): Boolean;
begin
  Try
    if Trim(aPropertyName) = '' then
    begin
      RuntimeErrorFmt(API_ProjectConfig_Nopropertyblank, []);

      Exit;
    end;

    if not oRuntime.oProject.oProjectConfig.IsPropertyExists(aPropertyName) then
    begin
      RuntimeErrorFmt(API_ProjectConfig_NopropertyExists, [aPropertyName]);

      Exit;
    end;

    if not oRuntime.oProject.oProjectConfig.DeleteProperty(aPropertyName) then
      oAPI_Output.InternalError;
  Except
    oAPI_Output.InternalError;
  End;

end;

function TAPI_ProjectConfig.GetProjectConfigFileName: String;
begin
  Result := oRuntime.oProject.oProjectConfig.ProjectConfigFileName;
end;

function TAPI_ProjectConfig.GetSearchPath: String;
begin
  Result := oRuntime.oProject.oProjectConfig.SearchPath;
end;

function TAPI_ProjectConfig.Getworkingdirectory: String;
begin
  Result := oRuntime.oProject.oProjectConfig.Workingdirectory;
end;

function TAPI_ProjectConfig.Getproperty(aPropertyName: String): String;
begin
  Result := '';

  Try
    if Trim(aPropertyName) = '' then
    begin
      RuntimeErrorFmt(API_ProjectConfig_Nopropertyblank, []);

      Exit;
    end;

    if not oRuntime.oProject.oProjectConfig.IsPropertyExists(aPropertyName) then
    begin
      RuntimeErrorFmt(API_ProjectConfig_NopropertyExists, [aPropertyName]);

      Exit;
    end;

    Result := oRuntime.oProject.oProjectConfig.Getproperties(aPropertyName);
  Except
    oAPI_Output.InternalError;
  End;
end;

end.
