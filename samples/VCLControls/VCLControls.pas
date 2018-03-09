var
  Dlg: TForm;
  ButtonSelected : Integer;
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

  Try
    openDialog := TOpenDialog.Create(NIL);

    openDialog.InitialDir := Folder.GetCurrentFolder;
 
    openDialog.Options := [ofAllowMultiSelect];
    if not openDialog.Execute then ShowMessage('Open file was cancelled')
    else
      begin
       for i := 0 to openDialog.Files.Count-1 do
         ShowMessage(openDialog.Files[i]);
      end;

  finally
    openDialog.free;
  end;  



end.
