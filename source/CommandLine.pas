unit CommandLine;

interface

Uses
  NovusCommandLine, SysUtils;

const
  clworkingdirectory = 'workingdirectory';
  clproject = 'project';
  clconsoleoutputonly = 'consoleoutputonly';
  clOutputlog = 'outputlog';
  clCompileOnly = 'compileonly';


type
  tProjectCommand = class(tNovusCommandLineCommand)
  protected
  private
    fsProjectFileName: string;
  public
    constructor Create; override;

    function Execute: boolean; override;

    property ProjectFileName: string read fsProjectFileName
      write fsProjectFileName;
  end;

  tHelpCommand = class(tNovusCommandLineCommand )
  protected
  private
  public
    constructor Create; override;
    function Execute: boolean; override;
  end;

  tOutputlogCommand = class(tNovusCommandLineCommand)
  protected
  private
    fsOutputlogFilename: string;
  public
    constructor Create; override;
    function Execute: boolean; override;

    property OutputlogFilename: string
      read fsOutputlogFilename
      write fsOutputlogFilename;
  end;


  tConsoleoutputonlyCommand = class(tNovusCommandLineCommand)
  protected
  private
  public
  end;

  tCompileOnlyCommand = class(tNovusCommandLineCommand)
  protected
  private
  public
  end;

  tWorkingDirectoryCommand = class(tNovusCommandLineCommand)
  protected
  private
    fsWorkingDirectory: string;
  public
    constructor Create; override;
    function Execute: boolean; override;

    property WorkingDirectory: string
       read fsWorkingDirectory
       write fsWorkingDirectory;
  end;

  TCommandLine = class(tNovusCommandLine)
  protected
  private
  public
    class procedure RegisterCommands;
  end;


implementation

Uses Config;

// tPeojectCommand
constructor tprojectCommand.Create;
begin
  inherited;

  RegisterOption('filename', '', true, NIL);
end;

function tProjectCommand.Execute: boolean;
var
  fFilenameOption: INovusCommandLineOption;
begin
  result := false;

  fFilenameOption := FindOptionByName('filename');

  if Assigned(fFilenameOption) then
    begin
      result := True;

      ProjectFileName := fFilenameOption.Value;
    end;
end;

// tHelpCommand
constructor tHelpCommand.Create;
begin
  inherited;

  RegisterOption('command', '', false, NIL);
end;


function tHelpCommand.Execute: boolean;
var
  fCommandOption: INovusCommandLineOption;
  fCommand: INovusCommandLineCommand;
begin
  result := false;

  fCommandOption := FindOptionByName('command');
  if Assigned(fCommandOption) then
    begin
      fCommand := FindCommandName(fCommandOption.Value);
      if Assigned(fCommand) then
        begin
          result := True;

          Help := fCommand.Help;
        end;
    end;

end;

// tWorkingDirectoryCommand
constructor tWorkingDirectoryCommand.Create;
begin
  inherited;

  RegisterOption(clworkingdirectory, '', true, NIL);
end;

function tWorkingDirectoryCommand.Execute: boolean;
var
  fWorkingdirectoryOption: INovusCommandLineOption;
begin
  result := false;

  fWorkingdirectoryOption := FindOptionByName(clworkingdirectory);

  if Assigned(fWorkingdirectoryOption) then
    begin
      result := true;

      Workingdirectory := fWorkingdirectoryOption.Value;
    end;
end;

// tOutputlogCommand
constructor tOutputlogCommand.Create;
begin
  inherited;

  fsOutputlogFilename := csOutputLogFileName;

  RegisterOption(clOutputlog, '', false, NIL);
end;

function tOutputlogCommand.Execute: boolean;
var
  fOutputlogOption: INovusCommandLineOption;
begin
  result := false;

  fOutputlogOption := FindOptionByName(clOutputlog);

  if Assigned(fOutputlogOption) then
    begin
      result := true;

      OutputlogFilename := fOutputlogOption.Value;
    end;
end;


//TCommandLine
class procedure TCommandLine.RegisterCommands;
begin
  tCommandLine.RegisterCommand(clproject, 's',
    'Usage : codeimatic.build -project [filename]', true, tProjectCommand.Create);

  tCommandLine.RegisterCommand(clworkingdirectory, 'w',
    'Usage : codeimatic.build -workingdirectory [directory]', false, tWorkingDirectoryCommand.Create);

  tCommandLine.RegisterCommand(clconsoleoutputonly, '', 'Usage : codeimatic.build -consoleoutputonly', false,
    tConsoleoutputonlyCommand.Create);

  tCommandLine.RegisterHelpCommand('help', 'h', 'Usage : codeimatic.build -help [command]',
    tHelpCommand.Create);

  tCommandLine.RegisterCommand(clOutputlog, 'o', 'Usage : codeimatic.build -outputlog [outputlogfilename]', false,
    tOutputlogCommand.Create);

  tCommandLine.RegisterCommand(clCompileOnly, 'c', 'Usage : codeimatic.build -compileonly', false,
    tCompileOnlyCommand.Create);

end;


end.
