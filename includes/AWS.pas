{********************************************************************}
{                                                                    }
{           AWS.pas                                                  }
{                                                                    }
{           Apache License                                           }
{           Version 2.0, January 2004                                }
{           License at http://www.apache.org/licenses/               }
{                                                                    }
{                                                                    }
{           Copyright (c) 2017 Novuslogic Software                   }
{           http://www.novuslogic.com                                }
{                                                                    }
{********************************************************************}

/// <summary>
///   Amazon Web Services
/// </summary>
unit AWS;

interface

Uses cmd, stringutils;

Const
  aws_credentials = 'credentials';
  aws_config = 'config';
  aws_S3Bucket = 'S3Bucket';
  aws_json = '": "';


/// <summary>
///   Execute an AWSCLI command
/// </summary>
function ExecAWSCliEx(const aCommandLine: String; var aOutput: String): Integer;

/// <summary>
///   Check if ASWCli has been installed
/// </summary>
function IsAWSCliConfigured: Boolean;

function GetAWSCliConfigPath: String;
function ExecAWSCli(const aCommandLine: String): Integer;
function GetAWSCliElasticbeanstalkLastS3Bucket(const aApplicationname: string;var aLastS3Bucket: String): Integer;
function ListAWSCliS3Bucket(const aS3Bucket: string; var aS3BucketList: string): Integer;
function CopyFileAWSCliS3Bucket(const aFilename: string; const aS3Bucket: string; var aoutput: string): Integer;
function AWSCliElasticbeanstalkCreateAppVerion(const aApplicationname: String; const aVersionlabel: string; const aS3ZipFilename: string; const aS3Bucket: String; var aOutput: string): integer;
function AWSCliiElasticbeanstalkUpdateEnv(const aEnvironmentname: string;const aVersionlabel: string; var aOutput: string): Integer;
function AWSCliAWSCliiElasticbeanstalkDeploy(const aApplicationname: string; const aS3ZipFullFilepath: string;const aVersionlabel: string;const aEnvironmentname: String): Integer;

implementation

function IsAWSCliConfigured: Boolean;
Var
  fsaws_access_key_id: String;
  fsaws_secret_access_key: String;
  fsaws_region: String;
begin
  Result := False;

  if not Folder.Exists(GetAWSCliConfigPath) then
    begin
      RaiseException(erCustomError, 'AWSCli Configured path [' + GetAWSCliConfigPath +'] cannot not be found.');

      Exit;
    end;

  if Not Files.Exists(GetAWSCliConfigPath + aws_credentials) then
    begin
      RaiseException(erCustomError, 'AWSCli Configured file cannot not be found.');

      Exit;
    end;

  fsaws_access_key_id := IniFile.ReadString(GetAWSCliConfigPath + aws_credentials,
                                'default', 'aws_access_key_id');
  fsaws_secret_access_key := IniFile.ReadString(GetAWSCliConfigPath + aws_credentials,
                                'default', 'aws_secret_access_key');


  // Config
  if Files.Exists(GetAWSCliConfigPath + aws_config) then
    begin
      fsaws_region := IniFile.ReadString(GetAWSCliConfigPath + aws_config,
                                'default', 'region');

    end;

  if (Trim(fsaws_access_key_id) <> '') or (Trim(fsaws_secret_access_key) <> '') then
    Result := true;

end;

function GetAWSCliConfigPath: String;
begin
  Result := Files.IncludeTrailingPathDelimiter(WinAPI.GetSpecialFolder(CSIDL_PROFILE) + '\.aws');
end;

function ExecAWSCli(const aCommandLine: String): Integer;
begin
  Result := -1;

  if Not IsAWSCliConfigured then Exit;

  Result := ExecCMD('aws ' + aCommandLine);
end;
  
function GetAWSCliElasticbeanstalkLastS3Bucket(const aApplicationname: string;var aLastS3Bucket: String): Integer;
var 
  lsLastS3Bucket,
  lsdescribe: String;
begin
  aLastS3Bucket := '';
  lsdescribe := '';

  Result :=ExecAWSCliEx('elasticbeanstalk describe-application-versions --application-name "' + aapplicationname + '"' ,lsdescribe );
  if result= 0 then
     begin
       lsLastS3Bucket := '';
       
       if RegEx.Match('"S3Bucket"[ :]+((?=\[)\[[^]]*\]|(?=\{)\{[^\}]*\}|\"[^"]*\")', lsdescribe, lsLastS3Bucket) then
         begin
           aLastS3Bucket :=ExtractTextPos(lsLastS3Bucket,pos(aws_json, lsLastS3Bucket)+ length(aws_json), '"');
         end;
     end;
end;

function ListAWSCliS3Bucket(const aS3Bucket: string; var aS3BucketList: string): Integer;
begin
  Result := ExecAWSCliEx('s3 ls "' + aS3Bucket + '"', aS3BucketList); 
end;

function AWSCliElasticbeanstalkCreateAppVerion(const aApplicationname: String; const aVersionlabel: string; const aS3ZipFilename: string; const aS3Bucket: String; var aOutput: string): integer; 
begin
  aOutput := '';
    
  result := ExecAWSCliEx('elasticbeanstalk create-application-version --application-name "' +aApplicationname + 
              '" --version-label "' + aVersionlabel +'" --source-bundle S3Bucket="' + aS3Bucket + '",S3Key="' + aS3ZipFilename + '"',
              aoutput);
end; 

function AWSCliiElasticbeanstalkUpdateEnv(const aEnvironmentname: string;const aVersionlabel: string; var aOutput: string): Integer;
begin             
   result := ExecAWSCliEx('elasticbeanstalk update-environment --environment-name "' + aEnvironmentname + '" --version-label "'+ aVersionlabel +'"',  aOutput); 
end;



function CopyFileAWSCliS3Bucket(const aFilename: string; const aS3Bucket: string; var aOutput: string): Integer;
begin

  Result := -1;
  aOutput := '';

  if Not Files.Exists(aFilename) then
    begin
      RaiseException(erCustomError, 'Filename cannot be found ['+ aFilename+'].');

      Exit;
    end;


  Result := ExecAWSCliEx('s3 cp ' + aFilename + ' s3://' + aS3Bucket +'/', aOutput); 
end;



function ExecAWSCliEx(const aCommandLine: String; var aOutput: String): Integer;
begin
  Result := -1;

  if Not IsAWSCliConfigured then Exit;

  Result := ExecCMDEx('aws ' + aCommandLine, aOutput);
end;


function AWSCliAWSCliiElasticbeanstalkDeploy(const aApplicationname: string; const aS3ZipFullFilepath: string;const aVersionlabel: string;const aEnvironmentname: String): Integer;
var
  fsLastS3Bucket: string;
  fsoutput: string;
  fsS3ZipFilename: string;
begin
  if IsAWSCliConfigured then 
    begin
      fsLastS3Bucket := '';
      fsoutput := '';

     Output.log('Get Elasticbeanstalk Last S3 Bucket.');
  
     if GetAWSCliElasticbeanstalkLastS3Bucket(aApplicationname, fsLastS3Bucket) <> 0 then 
       begin
         Exit;
       end; 

     Output.Log('Last S3 Bucket: '+ fsLastS3Bucket);

     Output.Log('Copy Deployment zip filename '+ aS3ZipFullFilepath + ' to '+ fsLastS3Bucket);

     Result := CopyFileAWSCliS3Bucket(aS3ZipFullFilepath, fsLastS3Bucket, fsoutput);
     if Result <> 0 then 
        begin
          if Trim(fsoutput) <> '' then  Output.Log(fsoutput);
          
          Exit; 
        end
     else
      if Trim(fsoutput) <> '' then  Output.Log(fsoutput);
 

     fsS3ZipFilename := ExtractFileName(aS3ZipFullFilepath);

     Output.Log('Create Appplication Verion with zip filename: '+ fsS3ZipFilename);
      
     Result := AWSCliElasticbeanstalkCreateAppVerion(aApplicationname, aVersionlabel, fsS3ZipFilename, fsLastS3Bucket, fsoutput);
     if Result <> 0 then
        begin
          if Trim(fsoutput) <> '' then  Output.Log(fsoutput);
          
          Exit;
        end 
      else
        if Trim(fsoutput) <> '' then  Output.Log(fsoutput);
        
     Result := AWSCliiElasticbeanstalkUpdateEnv( aEnvironmentname,aVersionlabel,fsOutput);
     if Result <> 0 then
        begin
          if Trim(fsoutput) <> '' then  Output.Log(fsoutput);
          
          Exit; 
        end 
      else
        if Trim(fsoutput) <> '' then  Output.Log(fsoutput);

    end
  else   
    Result := -1;   
end;    

end.
