{$I CodeImatic.build.inc}
unit Config;

interface

Uses SysUtils, NovusXMLBO, Registry, Windows, NovusStringUtils, NovusFileUtils,
  JvSimpleXml, NovusSimpleXML, NovusList, NovusCommandLine, CommandLine;

Const
  csOutputLogFileName = 'codeimatic.build.log';
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
    fCommandLineResult: INovusCommandLineResult;
    fConfigPluginsList: tNovusList;
    fsConfigfile: string;
    fsPluginPath: String;
    fsOutputFilename: string;
    fsProjectFileName: String;
    fsworkingdirectory: string;
    fsRootPath: String;
    fbCompileOnly: Boolean;
    fbConsoleoutputonly: Boolean;
  private
  public
    constructor Create; virtual; // override;
    destructor Destroy; override;

    function LoadConfig(aCommandLineResult
      : INovusCommandLineResult): Integer;

    procedure ParseCommandLine;

    property ProjectFileName: String read fsProjectFileName
       write fsProjectFileName;

    property OutputlogFilename: String read fsOutputFilename write fsOutputFilename;

    property RootPath: String read fsRootPath write fsRootPath;

    property Configfile: string read fsConfigfile write fsConfigfile;

    property PluginPath: String read fsPluginPath write fsPluginPath;

    property CompileOnly: Boolean read fbCompileOnly write fbCompileOnly;

    property oConfigPluginsList: tNovusList read fConfigPluginsList
      write fConfigPluginsList;

    property workingdirectory: String
       read fsworkingdirectory
       write fsworkingdirectory;

    property Consoleoutputonly: boolean
      read fbConsoleoutputonly
      write fbConsoleoutputonly;
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

function TConfig.LoadConfig(aCommandLineResult
      : INovusCommandLineResult): integer;
Var
  fConfigElem,
  fPluginElem,
  fPluginsElem: TJvSimpleXmlElem;
  I, Index: integer;
  lsPluginName, lsPluginFilename, lspluginfilenamepathname: String;
  loConfigPlugin: TConfigPlugin;
begin
  result := 0;

  fCommandLineResult := aCommandLineResult;

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

             end;
          end;

      end;
    end
     else
       begin
         aCommandLineResult.AddError(csConfigfile + ' is the wrong config file version [ '+ csConfigfileversion  + ']');
         aCommandLineResult.ExitCode := -1001;
         Result := aCommandLineResult.ExitCode;
       end;
  end
    else
      begin
        aCommandLineResult.AddError(csConfigfile + ' not a config file.', -1000);
        aCommandLineResult.ExitCode := -1000;
        Result := aCommandLineResult.ExitCode;
       end;


  if result = 0 then ParseCommandLine;

end;


procedure TConfig.ParseCommandLine;
var
  fNovusCommandLineResultCommands: INovusCommandLineResultCommands;
  fNovusCommandLineResultCommand: INovusCommandLineResultCommand;
  fNovusCommandLineResultOption: INovusCommandLineResultOption;
begin
  Consoleoutputonly := false;
  fNovusCommandLineResultCommand := fCommandLineResult.FindFirstCommand(clConsoleoutputonly);
  if Assigned(fNovusCommandLineResultCommand) then
    Consoleoutputonly := fNovusCommandLineResultCommand.IsCommandOnly;

  ProjectFileName := '';
  fNovusCommandLineResultOption := fCommandLineResult.FindFirstCommandwithOption(clproject);
  if Assigned(fNovusCommandLineResultOption) then
    ProjectFileName := fNovusCommandLineResultOption.Value.AsString;

  workingdirectory := '';
  fNovusCommandLineResultOption := fCommandLineResult.FindFirstCommandwithOption(clworkingdirectory);
  if Assigned(fNovusCommandLineResultOption) then
    workingdirectory := fNovusCommandLineResultOption.Value.AsString;

  outputlogfilename :=  csOutputLogFileName;
  fNovusCommandLineResultOption := fCommandLineResult.FindFirstCommandwithOption(clOutputlog);
  if Assigned(fNovusCommandLineResultOption) then
    outputlogfilename := fNovusCommandLineResultOption.Value.AsString;

  CompileOnly := false;
  fNovusCommandLineResultCommand := fCommandLineResult.FindFirstCommand(clCompileOnly);
  if Assigned(fNovusCommandLineResultCommand) then
    CompileOnly := fNovusCommandLineResultCommand.IsCommandOnly;


end;


Initialization

oConfig := TConfig.Create;

finalization

oConfig.Free;

end.
