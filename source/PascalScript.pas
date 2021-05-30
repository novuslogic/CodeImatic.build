{$I CodeImatic.build.inc}
unit PascalScript;

interface

uses
  Runtime,
  API_Output,
  System.Classes,
  System.SysUtils,
  uPSCompiler,
  uPSRuntime,
  uPSUtils,
  Plugins,
  project,
  VCL.dialogs,
  NovusFileUtils,
  uPSPreProcessor,
  uPSI_API_Output,
  ProjectTask;

Type
  TPascalScript = class
  protected
    foPlugins: TPlugins;
    fImp: TPSRuntimeClassImporter;
    foAPI_Output: tAPI_Output;
    FScript: TStringList;
    FsFilename: String;
    FParserStream: TMemoryStream;
    FCompiler: TPSPascalCompiler;
    FExec: TPSExec;
    FsData: AnsiString;
  private
    procedure CompilerOutputMessage;
  public
    constructor Create(aAPI_Output: tAPI_Output; aImp: TPSRuntimeClassImporter;
      aPlugins: TPlugins);
    destructor Destroy;

    procedure LoadScript(aFilename: String);

    function ExecuteScript(aprojecttask: TProjectTask;
      aCompileOnly: Boolean): Boolean;

  end;

implementation

procedure OnException(Sender: TPSExec; ExError: TPSError;
  const ExParam: tbtstring; ExObject: TObject; ProcNo, Position: Cardinal);
var
  lsExParam: String;
begin
  oruntime.oAPI_Output.LastExError := ExError;

  lsExParam := ExParam;
  if ExParam = '' then
    lsExParam := 'Unknown error.';

  oruntime.oAPI_Output.LastExParam := lsExParam;
  // oruntime.oAPI_Output.Errors := True;
  oruntime.oAPI_Output.projecttask.BuildStatus := TBuildStatus.bsErrors;
end;

function GetUnitFilename(aUnitName: String): string;
Var
  lsUnitNameFilename: String;
begin
  lsUnitNameFilename := aUnitName + '.pas';

  if FileExists(TNovusFileUtils.TrailingBackSlash(oruntime.oProject.oProjectConfigLoader.Workingdirectory) +lsUnitNameFilename) then
    Result := TNovusFileUtils.TrailingBackSlash(oruntime.oProject.oProjectConfigLoader.Workingdirectory) +lsUnitNameFilename
  else
  if FileExists(TNovusFileUtils.TrailingBackSlash(oruntime.oProject.oProjectConfigLoader.SearchPath)+ lsUnitNameFilename) then
    Result := TNovusFileUtils.TrailingBackSlash(oruntime.oProject.oProjectConfigLoader.SearchPath)+ lsUnitNameFilename
  else
    result := lsUnitNameFilename;
end;

function CustomOnUses(Sender: TPSPascalCompiler;
  const Name: AnsiString): Boolean;
Var
  lList: TStringList;
  FTPSCompileTimeClass: TPSCompileTimeClass;
begin
  if Name = 'SYSTEM' then
  begin
    Result := oruntime.oPlugins.CustomOnUses(Sender);
  end
  else
  begin
    if FileExists(GetUnitFilename(name)) then
    begin
      Try
        Try
          oruntime.oAPI_Output.Log('Compiling unit ... ' + GetUnitFilename(name));

          lList := TStringList.Create;
          lList.LoadFromFile(GetUnitFilename(name));

          if Sender.Compile(lList.Text) then
          begin
            Result := true;
          end
          else
          begin
            Result := False;
          end;
        Finally
          lList.Free;
        End;
      Except

      End;
    end
    else
    begin
      TPSPascalCompiler(Sender).MakeError('',
        ecUnitNotFoundOrContainsErrors, Name);

      Result := False;
    end;
  end;
end;

constructor TPascalScript.Create;
begin
  foAPI_Output := aAPI_Output;

  FParserStream := TMemoryStream.Create;
  FScript := TStringList.Create;

  foPlugins := aPlugins;

  fImp := aImp;
end;

destructor TPascalScript.Destroy;
begin
  FScript.Free;
  FParserStream.Free;
end;

function TPascalScript.ExecuteScript(aprojecttask: TProjectTask;
  aCompileOnly: Boolean): Boolean;
var
  liRetry, I: Integer;
  fbOK: Boolean;
  fbRetry: Boolean;
  fInternalProcRec: TPSInternalProcRec;
begin
  Result := False;

  FCompiler := TPSPascalCompiler.Create; // create an instance of the compiler.
  FCompiler.OnUses := CustomOnUses; // assign the OnUses event.

  FCompiler.AllowNoBegin := true;
  FCompiler.AllowNoEnd := true;
  // AllowNoBegin and AllowNoEnd allows it that begin and end are not required in a script.

  foAPI_Output.WriteLog('Compiling ... ');

  if not FCompiler.Compile(FScript.Text) then
    begin
      CompilerOutputMessage;

      foAPI_Output.projecttask.BuildStatus := TBuildStatus.bsFailed;

      FCompiler.Free;

      Exit;
    end;

  CompilerOutputMessage;

  FCompiler.GetOutput(FsData);
  // Save the output of the compiler in the string Data.
  FCompiler.Free;
  // After compiling the script, there is no need for the compiler anymore.

  if aCompileOnly then
  begin
    Result := true;

    Exit;
  end;

  foAPI_Output.WriteLog('Executing ... ');

  fbRetry := False;
  liRetry := aprojecttask.Criteria.Failed.Retry;
  if liRetry > 0 then
    fbRetry := true;

  if liRetry = 0 then
    liRetry := 1;

  for I := 1 to liRetry do
  begin
    Try
      FExec := TPSExec.Create; // Create an instance of the executer.

      FExec.OnException := OnException;

      foPlugins.RegisterFunctions(FExec);

      if not FExec.LoadData(FsData) then
      begin
        foAPI_Output.WriteLog('[Error] : Could not load data: ' +
          TIFErrorToString(FExec.ExceptionCode, FExec.ExceptionString));

        aprojecttask.BuildStatus := TBuildStatus.bsFailed;

        break;
      end;

      foPlugins.SetVariantToClasses(FExec);

      Try
        fbOK := FExec.RunScript;
      Except
        fbOK := False;

        foAPI_Output.LogError;
      End;

      if not fbOK then
      begin
        //FExec.ExceptionProcNo;



        ///fInternalProcRec := (FExec.GetProcNo(FExec.ExceptionProcNo) as TPSInternalProcRec);

        foAPI_Output.WriteLog('[Runtime Error] : ' + PSErrorToString(FExec.ExceptionCode,FExec.ExceptionString));

       // foAPI_Output.WriteLog('[Runtime Error] : ' +
       //   TIFErrorToString(FExec.ExceptionCode, FExec.ExceptionString) + ' in '
       //   + IntToStr(FExec.ExceptionProcNo) + ' at ' +
       //   IntToStr(FExec.ExceptionPos));

        if fbRetry then
          foAPI_Output.WriteLog('Retrying executing ... ' + IntToStr(I) + ' of '
            + IntToStr(liRetry));

        aprojecttask.BuildStatus := TBuildStatus.bsFailed;
      end
      else
        break;

    Finally
      FExec.Free;
    End;
  end;

  if aprojecttask.BuildStatus = TBuildStatus.bsSucceeded then
    Result := true;
end;

procedure TPascalScript.LoadScript(aFilename: String);
begin
  FScript.LoadFromFile(aFilename, TEncoding.ASCII);
end;

procedure TPascalScript.CompilerOutputMessage;
var
  I: Integer;
begin
  for I := 0 to FCompiler.MsgCount - 1 do
  begin
    foAPI_Output.WriteLog(FCompiler.Msg[I].MessageToString)
  end;
end;

end.
