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
  TPascalScript = class(tObject)
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

function GetIncludeFullFilename(aIncludeFilename: String): string;
Var
  lsUnitNameFilename: String;
begin
  Result := aIncludeFilename;

  if FileExists(aIncludeFilename) then Exit;

  if TNovusFileUtils.IsJustFilenameOnly(aIncludeFilename) then
    begin
      if FileExists(TNovusFileUtils.TrailingBackSlash(oruntime.oProject.oProjectConfigLoader.Workingdirectory) +aIncludeFilename) then
        Result := TNovusFileUtils.TrailingBackSlash(oruntime.oProject.oProjectConfigLoader.Workingdirectory) +aIncludeFilename
      else
      if FileExists(TNovusFileUtils.TrailingBackSlash(oruntime.oProject.oProjectConfigLoader.SearchPath)+ aIncludeFilename) then
        Result := TNovusFileUtils.TrailingBackSlash(oruntime.oProject.oProjectConfigLoader.SearchPath)+ aIncludeFilename
    end;

end;

function CENeedFile(Sender: TPSPreProcessor; const callingfilename: tbtstring; var FileName, Output: tbtstring): Boolean;
var
  lsIncludeFile: string;
  f: TFileStream;
begin
  lsIncludeFile := GetIncludeFullFilename(FileName);
  try
    f := TFileStream.Create(lsIncludeFile, fmOpenRead or fmShareDenyWrite);
  except
    Result := False;

    Exit;
  end;

  try
    SetLength(Output, f.Size);
    f.Read(Output[1], Length(Output));
  finally
    f.Free;
  end;
  Result := true;
end;

function PreProcessor(aObject: tObject; aName: tbtstring; var aScript: TStringList): TPSPreProcessor;
Var
  fFPP: TPSPreProcessor;
  lsScript: tbtstring;
begin
  Try
    lsScript := aScript.text;

    fFPP := TPSPreProcessor.Create;
    fFPP.Clear;
    fFPP.Id := aObject;

    fFPP.OnNeedFile := CENeedFile;

    fFPP.Defines.Text := aScript.text;
    fFpp.MainFile := aScript.text;
    fFpp.MainFileName := aName;
    fFpp.PreProcess(aName, lsScript);
  Finally
    aScript.text := lsScript;

    result := fFpp;
  End;
end;


procedure OnPascalScriptException(Sender: TPSExec; ExError: TPSError;
  const ExParam: tbtstring; ExObject: TObject; ProcNo, Position: Cardinal);
var
  lsExParam: String;
begin
  oruntime.oAPI_Output.LastExError := ExError;

  lsExParam := ExParam;
  if ExParam = '' then
    lsExParam := 'Unknown error.';

  oruntime.oAPI_Output.LastExParam := lsExParam;

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
  fUseScript: TStringList;
  fTPSCompileTimeClass: TPSCompileTimeClass;
  fFpp: TPSPreProcessor;
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

          fUseScript := TStringList.Create;
          fUseScript.LoadFromFile(GetUnitFilename(name));

          fFpp := PreProcessor(NIL, Name, fUseScript);

          if Sender.Compile(fUseScript.Text) then
          begin
            Result := true;

          end
          else
          begin
            Result := False;

//            Sender.MakeError(Sender.UnitName, ecUnknownIdentifier, Name);
          end;
        Finally
          fFpp.AdjustMessages(Sender);

          fUseScript.Free;

          fFpp := NIL;
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
  fFpp: TPSPreProcessor;
begin
  Result := False;

  FCompiler := TPSPascalCompiler.Create; // create an instance of the compiler.

  FCompiler.OnUses := CustomOnUses; // assign the OnUses event.

  FCompiler.AllowNoBegin := true;
  FCompiler.AllowNoEnd := true;

  fFpp := PreProcessor(Self, aprojecttask.TaskName, FScript);

  foAPI_Output.WriteLog('Compiling ... ');

  if not FCompiler.Compile(FScript.Text) then
    begin
      fFpp.AdjustMessages(FCompiler);

      CompilerOutputMessage;

      foAPI_Output.projecttask.BuildStatus := TBuildStatus.bsFailed;

      FCompiler.Free;

      fFpp := NIL;

      Exit;
    end;

  fFpp.AdjustMessages(FCompiler);

  CompilerOutputMessage;

  fFpp := NIL;

  FCompiler.GetOutput(FsData);

  FCompiler.Free;

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

      FExec.OnException := OnPascalScriptException;

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

