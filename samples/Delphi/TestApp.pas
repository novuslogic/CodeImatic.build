uses Delphi;

var 
  FDelphiOptions: TDelphiOptions;
begin
  output.log('Delphi TestApp Sample');

  FDelphiOptions.platform := 'msbuild';
  FDelphiOptions.Configuration := 'debug';
  FDelphiOptions.Target := 'rebuild';

  if  Delphi(DELPHI10_4,'TestApp.dproj', FDelphiOptions) <> 0 then 
    RaiseException(erCustomError, 'Delphi Exception:'+ SysErrorMessage);  
end.
