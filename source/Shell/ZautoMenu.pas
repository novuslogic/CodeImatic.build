unit ZautoMenu;

interface

uses
  Windows, ActiveX, ComObj, ShlObj, ShellApi;

type
  TZautoMenu = class(TComObject, IUnknown,
    IContextMenu, IShellExtInit)
  private
    fFileName: string;
    fCommand_id: Integer;
    fpszName: string;
  protected
    {Declare IContextMenu methods here}
    function QueryContextMenu(Menu: HMENU; indexMenu, idCmdFirst, idCmdLast,
      uFlags: UINT): HResult; stdcall;
    function InvokeCommand(var lpici: TCMInvokeCommandInfo): HResult; stdcall;
    function GetCommandString(idCmd: UINT_PTR; uFlags: UINT; pwReserved: PUINT;
      pszName: LPSTR; cchMax: UINT): HResult; stdcall;
    {Declare IShellExtInit methods here}
    function IShellExtInit.Initialize = InitShellExt;
    function InitShellExt (pidlFolder: PItemIDList; lpdobj: IDataObject;
      hKeyProgID: HKEY): HResult; stdcall;
  end;

  TZautoMenuFactory = class (TComObjectFactory)
  public
    procedure UpdateRegistry (Register: Boolean); override;
  end;

const
  Class_ZautoMenuMenu: TGUID = '{C1A9DC84-0E17-4BC2-A382-DE9D94608125}';

implementation

uses
  ComServ, Messages, SysUtils, Registry, dialogs;

// IShellExtInit method
function TZautoMenu.InitShellExt(pidlFolder: PItemIDList;
  lpdobj: IDataObject; hKeyProgID: HKEY): HResult; stdcall;
var
  medium: TStgMedium;
  fe: TFormatEtc;
begin
  Result := E_FAIL;
  // check if the lpdobj pointer is nil
  if Assigned (lpdobj) then
  begin
    with fe do
    begin
      cfFormat := CF_HDROP;
      ptd := nil;
      dwAspect := DVASPECT_CONTENT;
      lindex := -1;
      tymed := TYMED_HGLOBAL;
    end;
    // transform the lpdobj data to a storage medium structure
    Result := lpdobj.GetData(fe, medium);
    if not Failed (Result) then
    begin
      // check if only one file is selected
      if DragQueryFile (medium.hGlobal, $FFFFFFFF, nil, 0) = 1 then
      begin
        SetLength (fFileName, 1000);
        DragQueryFile (medium.hGlobal, 0, PChar (fFileName), 1000);
        // realign string
        fFileName := PChar (fFileName);
        Result := NOERROR;
      end
      else
        Result := E_FAIL;
    end;
    ReleaseStgMedium(medium);
  end;
end;

// context menu methods

function TZautoMenu.QueryContextMenu(Menu: HMENU;
  indexMenu, idCmdFirst, idCmdLast, uFlags: UINT): HResult;
begin
  if Trim(lowercase(ExtractFileExt(fFileName))) = '.zamanifest' then
    begin
      InsertMenu (Menu, indexMenu,
          {MF_STRING or MF_BYPOSITION}MF_BYPOSITION, idCmdFirst,
          'Compile and Execute Zautomatic');

          InsertMenu (Menu, indexMenu + 1,
          {MF_STRING or MF_BYPOSITION}MF_BYPOSITION, idCmdFirst + 1,
          'Compile Zautomatic');

      Result := 2;
    end
   else
     Result := 0;

end;

function TZautoMenu.InvokeCommand(var lpici: TCMInvokeCommandInfo): HResult;
var
  hwnd: THandle;
  Item: integer;
begin
  // Make sure we are not being called by an application
  if HiWord(Integer(lpici.lpVerb)) <> 0 then
  begin
    Result := E_FAIL;
    Exit;
  end;


  Item := LoWord(Integer(lpici.lpVerb));
  showmessage(inttoStr(Item));


end;

function TZautoMenu.GetCommandString(idCmd: UINT_PTR; uFlags: UINT; pwReserved: PUINT;
      pszName: LPSTR; cchMax: UINT): HResult; stdcall;
begin
  //
end;

{ TZautoMenuFactory methods }

procedure TZautoMenuFactory.UpdateRegistry(Register: Boolean);
var
  Reg: TRegistry;
begin
  inherited UpdateRegistry (Register);

  Reg := TRegistry.Create;
  Reg.RootKey := HKEY_CLASSES_ROOT;
  try
    if Register then
      if Reg.OpenKey('\*\ShellEx\ContextMenuHandlers\Zautomatic', True) then
        Reg.WriteString('', GUIDToString(Class_ZautoMenuMenu))
    else
      if Reg.OpenKey('\*\ShellEx\ContextMenuHandlers\Zautomatic', False) then
        Reg.DeleteKey ('\*\ShellEx\ContextMenuHandlers\Zautomatic');
  finally
    Reg.CloseKey;
    Reg.Free;
  end;
end;

initialization
  TZautoMenuFactory.Create (
    ComServer, TZautoMenu, Class_ZautoMenuMenu,
    'ZautoMenu', 'Zautomatic Shell Extension',
    ciMultiInstance, tmApartment);
end.
