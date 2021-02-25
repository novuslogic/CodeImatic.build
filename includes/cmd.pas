unit cmd;

interface

function ExecCMD(aCommandLine: String): Integer;
function ExecCMDEx(aCommandLine: String; var aOutput: String): Integer;
function Exec(aCommandLine: String): Integer;
function ExecEx(aCommandLine: String; var aOutput: String): Integer;


implementation


function Exec(aCommandLine: String): Integer;
var
  fsOutput: string;
begin
  try
    Result := ExecEx(aCommandLine,fsOutput);
  Finally
    Output.log(fsOutput);
  end;
end;

function ExecCMDEx(aCommandLine: String; var aOutput: String): Integer;
begin
  Result := ExecEx('cmd.exe /C ' + aCommandLine, aOutput);
end;


function ExecCMD(aCommandLine: String): Integer;
var
  fsOutput: string;
begin
  Result := 0;

  try
    Result := ExecCMDEx(aCommandLine, fsOutput);
  Finally
    Output.log(fsOutput);
  end;

  
end;

function ExecExA(aCommandLine: String): Integer;
var
  fsOutput: string;
begin
  Result := 0;

  try
    Result := ExecEx(aCommandLine, fsOutput);
  Finally
    Output.log(fsOutput);
  end;

  
end;



function ExecEx(aCommandLine: String; var aOutput: String): Integer;
begin
  Result := 0;

  try
    Result := Shell.RunCommandCapture(aCommandLine, aOutput);
  except
    Output.LogError;
  end;
end;


end.
