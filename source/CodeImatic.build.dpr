{$I CodeImatic.build.inc}
program CodeImatic.build;

{$APPTYPE CONSOLE}
{$R *.res}

uses
  System.SysUtils,
  Config,
  Runtime,
  CommandLine,
  NovusCommandLine;

var
  FComandLineResult :  TNovusCommandLineResult;

begin
    FComandLineResult := NIL;

    Try
      TCommandLine.RegisterCommands;

      FComandLineResult := tCommandLine.Execute;
      if (FComandLineResult.IsHelpCommand) and (FComandLineResult.Errors = false) then
        begin
          Writeln(oRuntime.GetVersionCopyright);
          Writeln('');

          if Trim(FComandLineResult.Help) = '' then
                 Writeln('Usage : codeimatic.build [command] [options]')
           else Writeln(FComandLineResult.Help);

           ExitCode := FComandLineResult.ExitCode;
        end
      else
      if (FComandLineResult.Errors) and (FComandLineResult.IsCommandEmpty = false) then
      begin
        Writeln(oRuntime.GetVersionCopyright);
        Writeln('');
        Writeln('Invalid options:');

        Writeln(FComandLineResult.ErrorMessages.Text);

        Writeln('');
        if Trim(FComandLineResult.Help) = '' then
               Writeln('Usage : codeimatic.build [command] [options]')
         else Writeln(FComandLineResult.Help);

         ExitCode := FComandLineResult.ExitCode;

      end
    else
    if FComandLineResult.IsCommandEmpty then
      begin
        Writeln(oRuntime.GetVersionCopyright);
        Writeln('');
        Writeln('Usage : codeimatic.build [command] [options]');

        ExitCode := FComandLineResult.ExitCode;

       end
     else
        begin
          ExitCode := oConfig.LoadConfig(FComandLineResult);
          if ExitCode = 0 then
            begin
              ExitCode := oruntime.Execute(FComandLineResult);

              if (FComandLineResult.Errors) then
                begin
                  Writeln(oRuntime.GetVersionCopyright);
                  Writeln('');
                  Writeln('Error:');
                  Writeln(FComandLineResult.ErrorMessages.Text);
                end;
            end
          else
             begin
               Writeln(oRuntime.GetVersionCopyright);
               Writeln('');
               Writeln('Config Error:');

               Writeln(FComandLineResult.ErrorMessages.Text);
             end;

        end;
    Finally
      if Assigned(FComandLineResult) then
        FComandLineResult.Free;
    End;

end.

