var
  Dlg: TForm;
  ButtonSelected, I : Integer;
  openDialog : topendialog;
begin
  output.log('VCLControls Sample');

  ShowMessage('ShowMessage');

  Try
    Dlg := CreateMessageDialog('message ???', mtInformation, [mbOk]);
    Dlg.Caption := 'Hello World';

    with TLabel(Dlg.FindComponent('message')) do
    begin
      Font.Style := [fsUnderline];

      // extraordinary code goes here
    end;

    Dlg.ShowModal;

  finally
    Dlg.Free;
  end;


  buttonSelected := messagedlg('Custom dialog',mtCustom, 
                              [mbYes,mbAll,mbCancel], 0);
 

  output.log('buttonSelected: ' +  IntToStr(buttonSelected));
  
  if buttonSelected = mrYes    then ShowMessage('Yes pressed');
  if buttonSelected = mrAll    then ShowMessage('All pressed');
  if buttonSelected = mrCancel then ShowMessage('Cancel pressed');






end.
