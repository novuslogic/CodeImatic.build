{$I CodeImatic.build.inc}
unit Config;

interface

Uses SysUtils, NovusXMLBO, Registry, Windows, NovusStringUtils, NovusFileUtils,
  JvSimpleXml, NovusSimpleXML, NovusList;

Const
  csOutputFile = 'codeimatic.build.log';
  csConfigfile = 'codeimatic.build.config';
  csConfigfileversion = 'codeimatic.build1.0';

Type
  TConfigPlugin = class(Tobject)
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

    function LoadConfig: Integer;

    function ParseParams: Boolean;

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

  fConfigPluginsList := tNovusList.Create(TConfigPlugin);

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

    if lsParamStr = '-project' then
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
    (*
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
    *)
    else if lsParamStr = '-compileonly' then
      fbCompileOnly := True;

    Inc(I);

    if I > ParamCount then
      fbOK := True;
  end;


  if Trim(fsProjectFileName) = '' then
  begin
    writeln('-project filename cannot be found.');

    Result := False;
  end;

  (*
  if Trim(fsProjectConfigFileName) = '' then
  begin
    writeln('-projectconfig filename cannot be found.');

    Result := False;
  end;
  *)

  if Result = False then
  begin
    writeln('-error ');

    //
  end;

  fsOutputFile := csOutputFile;
end;

function TConfig.LoadConfig: integer;
Var
  fConfigElem,
  fPluginElem,
  fPluginsElem: TJvSimpleXmlElem;
  I, Index: integer;
  lsPluginName, lsPluginFilename, lspluginfilenamepathname: String;
  loConfigPlugin: TConfigPlugin;
begin
  result := 0;

  if fsRootPath = '' then
    fsRootPath := TNovusFileUtils.TrailingBackSlash
      (TNovusStringUtils.RootDirectory);

  fsConfigfile := fsRootPath + csConfigfile;

  if FileExists(fsConfigfile) then
  begin
    XMLFileName := fsConfigfile;
    Retrieve;

    fsPluginPath := fsrootpath + 'plugins\';

    Index := 0;
    fConfigElem := TNovusSimpleXML.FindNode(oXMLDocument.Root, 'config', Index);
    if assigned(fConfigElem) then
    begin
      if TNovusSimpleXML.HasProperties(fConfigElem, 'version')  =  csConfigfileversion then
        begin
          Index := 0;
          fPluginsElem := TNovusSimpleXML.FindNode(oXMLDocument.Root,
            'plugins', Index);
          if assigned(fPluginsElem) then
          begin
            For I := 0 to fPluginsElem.Items.count - 1 do
            begin
              loConfigPlugin := TConfigPlugin.Create;

              lsPluginName := fPluginsElem.Items[I].Name;

              Index := 0;
              lsPluginFilename := '';
              fPluginElem := TNovusSimpleXML.FindNode(fPluginsElem.Items[I],
                'filename', Index);
              if assigned(fPluginElem) then
                lsPluginFilename := fPluginElem.Value;

              lspluginfilenamepathname := fsPluginPath + lspluginfilename;

              if FileExists( lspluginfilenamepathname) then
                begin
                  loconfigplugin.pluginname := lspluginname;
                  loconfigplugin.pluginfilename := lspluginfilename;
                  loconfigplugin.pluginfilenamepathname := lspluginfilenamepathname;

                  fconfigpluginslist.add(loconfigplugin);
                end;
                (*
              else
                begin
                  Result := -1002;

                  break;
                end;
                *)
             end;
          end;

      end;
    end
     else Result := -1001;
  end
    else Result := -1000;

end;

Initialization

oConfig := TConfig.Create;

finalization

oConfig.Free;

end.
