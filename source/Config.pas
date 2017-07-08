{$I Zautomatic.inc}
unit Config;

interface

Uses SysUtils, NovusXMLBO, Registry, Windows, NovusStringUtils, NovusFileUtils,
  JvSimpleXml, NovusSimpleXML, NovusList;

Const
  csOutputFile = 'zaoutput.log';
  csConfigfile = 'zautomatic.config';

Type
  TConfigPlugins = class(Tobject)
  private
    fsPluginName: String;
    fsPluginFilename: string;
    fsPluginFilenamePathname: String;
  protected
  public
    property PluginName: String read fsPluginName write fsPluginName;

    property Pluginfilename: string read fsPluginFilename
      write fsPluginFilename;

    property PluginFilenamePathname: String read fsPluginFilenamePathname
      write fsPluginFilenamePathname;
  end;

  TConfig = Class(TNovusXMLBO)
  protected
    fConfigPluginsList: tNovusList;
    fsSolutionFilename: String;
    fsConfigfile: string;
    fsPluginPath: String;
    fsOutputFile: string;
    fsProjectConfigFileName: String;
    fsProjectFileName: String;
    fsRootPath: String;
    fbCompileOnly: Boolean;
  private
  public
    constructor Create; virtual; // override;
    destructor Destroy; override;

    procedure LoadConfig;

    function ParseParams: Boolean;

    property SolutionFilename: String read fsSolutionFilename
      write fsSolutionFilename;

    property ProjectFileName: String read fsProjectFileName
      write fsProjectFileName;

    property ProjectConfigFileName: String read fsProjectConfigFileName
      write fsProjectConfigFileName;

    property OutputFile: String read fsOutputFile write fsOutputFile;

    property RootPath: String read fsRootPath write fsRootPath;

    property Configfile: string read fsConfigfile write fsConfigfile;

    property PluginPath: String read fsPluginPath write fsPluginPath;

    property CompileOnly: Boolean read fbCompileOnly write fbCompileOnly;

    property oConfigPluginsList: tNovusList read fConfigPluginsList
      write fConfigPluginsList;
  End;

Var
  oConfig: TConfig;

implementation

constructor TConfig.Create;
begin
  inherited Create;

  fConfigPluginsList := tNovusList.Create(TConfigPlugins);

  fbCompileOnly := False;
end;

destructor TConfig.Destroy;
begin
  fConfigPluginsList.Free;

  inherited Destroy;
end;

function TConfig.ParseParams: Boolean;
Var
  I: integer;
  fbOK: Boolean;
  lsParamStr: String;
begin
  Result := False;

  fbOK := False;
  I := 1;
  While Not fbOK do
  begin
    lsParamStr := Lowercase(ParamStr(I));

    if lsParamStr = '-solution' then
    begin
      Inc(I);
      fsSolutionFilename := Trim(ParamStr(I));

      if Trim(TNovusStringUtils.JustFilename(fsSolutionFilename))
        = Trim(fsSolutionFilename) then
        fsSolutionFilename := IncludeTrailingPathDelimiter
          (TNovusFileUtils.AbsoluteFilePath(ParamStr(I))) + Trim(ParamStr(I));

      if Not FileExists(fsSolutionFilename) then
      begin
        writeln('-solution ' + TNovusStringUtils.JustFilename
          (fsSolutionFilename) + ' project filename cannot be found.');

        Exit;
      end;

      Result := True;
    end
    else if lsParamStr = '-project' then
    begin
      Inc(I);
      fsProjectFileName := Trim(ParamStr(I));

      if Trim(TNovusStringUtils.JustFilename(fsProjectFileName))
        = Trim(fsProjectFileName) then
        fsProjectFileName := IncludeTrailingPathDelimiter
          (TNovusFileUtils.AbsoluteFilePath(ParamStr(I))) + Trim(ParamStr(I));

      if Not FileExists(fsProjectFileName) then
      begin
        writeln('-project ' + TNovusStringUtils.JustFilename(fsProjectFileName)
          + ' project filename cannot be found.');

        Exit;
      end;

      Result := True;
    end
    else if lsParamStr = '-projectconfig' then
    begin
      Inc(I);
      fsProjectConfigFileName := Trim(ParamStr(I));

      if Trim(TNovusStringUtils.JustFilename(fsProjectConfigFileName))
        = Trim(fsProjectConfigFileName) then
        fsProjectConfigFileName := IncludeTrailingPathDelimiter
          (TNovusFileUtils.AbsoluteFilePath(ParamStr(I))) + Trim(ParamStr(I));

      if Not FileExists(fsProjectConfigFileName) then
      begin
        writeln('-projectconfig ' + TNovusStringUtils.JustFilename
          (fsProjectConfigFileName) +
          ' projectconfig filename cannot be found.');

        Exit;
      end;

      Result := True;
    end
    else if lsParamStr = '-compileonly' then
      fbCompileOnly := True;

    Inc(I);

    if I > ParamCount then
      fbOK := True;
  end;

  if Trim(fsSolutionFilename) = '' then
  begin
    if Trim(fsProjectFileName) = '' then
    begin
      writeln('-project filename cannot be found.');

      Result := False;
    end;

    if Trim(fsProjectConfigFileName) = '' then
    begin
      writeln('-projectconfig filename cannot be found.');

      Result := False;
    end;
  end;

  if Result = False then
  begin
    writeln('-error ');

    //
  end;

  fsOutputFile := csOutputFile;
end;

procedure TConfig.LoadConfig;
Var
  fPluginElem, fPluginsElem: TJvSimpleXmlElem;
  I, Index: integer;
  fsPluginName, fsPluginFilename: String;
  loConfigPlugins: TConfigPlugins;
begin
  if fsRootPath = '' then
    fsRootPath := TNovusFileUtils.TrailingBackSlash
      (TNovusStringUtils.RootDirectory);

  fsConfigfile := fsRootPath + csConfigfile;

  if FileExists(fsConfigfile) then
  begin
    XMLFileName := fsRootPath + csConfigfile;
    Retrieve;

    Index := 0;
    fPluginsElem := TNovusSimpleXML.FindNode(oXMLDocument.Root,
      'plugins', Index);
    if Assigned(fPluginsElem) then
    begin
      For I := 0 to fPluginsElem.Items.count - 1 do
      begin
        loConfigPlugins := TConfigPlugins.Create;

        fsPluginName := fPluginsElem.Items[I].Name;

        Index := 0;
        fsPluginFilename := '';
        fPluginElem := TNovusSimpleXML.FindNode(fPluginsElem.Items[I],
          'filename', Index);
        if Assigned(fPluginElem) then
          fsPluginFilename := fPluginElem.Value;

        loConfigPlugins.PluginName := fsPluginName;
        loConfigPlugins.Pluginfilename := fsPluginFilename;
        loConfigPlugins.PluginFilenamePathname := RootPath + 'plugins\' +
          fsPluginFilename;

        fConfigPluginsList.Add(loConfigPlugins);
      end;
    end;

  end;

end;

Initialization

oConfig := TConfig.Create;

finalization

oConfig.Free;

end.
