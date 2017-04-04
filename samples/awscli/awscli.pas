uses AWS;

begin
  output.log('AWSCLI Config Path: ' +  GetAWSCliConfigPath);

  output.Log('aws_access_key_id');
  ExecAWSCli('configure get aws_access_key_id');

  output.Log('aws_secret_access_key');
  ExecAWSCli('configure get aws_secret_access_key');

  output.Log('region');
  ExecAWSCli('configure get region');

  output.Log('AWSCli version');
  ExecAWSCli('--version');
end.
