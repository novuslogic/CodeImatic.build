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
     property ProjectConfigFileName: String
        read GetProjectConfigFileName;

      property SearchPath: String
        read GetSearchPath;

      property Workingdirectory: string
        read Getworkingdirectory;

      function Getproperty(aPropertyName: String): String;
   end;

Const 
   API_ProjectConfig_NopropertyExists = 'propertyname cannot be found [%s].';
   API_ProjectConfig_Nopropertyblank = 'propertyname cannot be blank.';

implementation

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
 
    if not oRuntime.oProject.oProjectConfig.IspropertyExists(aPropertyName) then
      begin
        RuntimeErrorFmt(API_ProjectConfig_NopropertyExists, [aPropertyName]);
        
        Exit;
      end;

    Result := oRuntime.oProject.oProjectConfig.Getproperty(aPropertyName);
  Except
    oMessagesLog.InternalError;
  End;
end;

end.
