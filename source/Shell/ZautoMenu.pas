unit ZautoMenu;

interface

uses
  Windows, ActiveX, ComObj, ShlObj, ShellApi, NovusShell, NovusEnvironment, NovusFileUtils,
  Vcl.Dialogs, NovusDialogs;

const
  cZautomatic = 'codeimatic.build.exe';
  cZauto_env = '{%ZAUTO%}';


type
  TZautoMenu = class(TComObject, IUnknown,
    IContextMenu, IShellExtInit)
  private
    fsFileName: string;

    function GetZauto_Env: string;
    function GetZautomatic: string;
    function RunZutomatic(aMenuItem: integer): Integer;
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
  ComServ, Messages, SysUtils, Registry;

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
        SetLength (fsFileName, 1000);
        DragQueryFile (medium.hGlobal, 0, PChar (fsFileName), 1000);
        // realign string
        fsFileName := PChar (fsFileName);
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
  if Trim(lowercase(ExtractFileExt(fsFileName))) = '.zasolution' then
    begin
      InsertMenu (Menu, indexMenu,
          {MF_STRING or MF_BYPOSITION}MF_BYPOSITION, idCmdFirst,
          'Compile and Execute CodeImatic.build Solution');

          InsertMenu (Menu, indexMenu + 1,
          {MF_STRING or MF_BYPOSITION}MF_BYPOSITION, idCmdFirst + 1,
          'Compile CodeImatic.build Solution');

      Result := 2;
    end
   else
     Result := 0;

end;

function TZautoMenu.InvokeCommand(var lpici: TCMInvokeCommandInfo): HResult;
var
  hwnd: THandle;
  MenuItem: integer;
  //loShell: TNovusShell;
begin
  // Make sure we are not being called by an application
  if HiWord(Integer(lpici.lpVerb)) <> 0 then
  begin
    Result := E_FAIL;
    Exit;
  end;


  MenuItem := LoWord(Integer(lpici.lpVerb));

  case MenuItem of
  0: RunZutomatic(MenuItem);
  1: RunZutomatic(MenuItem);
  end;
end;

function TZautoMenu.GetCommandString(idCmd: UINT_PTR; uFlags: UINT; pwReserved: PUINT;
      pszName: LPSTR; cchMax: UINT): HResult; stdcall;
begin
  //
end;

function TZautoMenu.GetZauto_Env;
begin
  result := tNovusEnvironment.ParseGetEnvironmentVar(cZauto_env);
end;

function TZautoMenu.GetZautomatic: string;
begin
  Result :=TNovusFileUtils.TrailingBackSlash(GetZauto_Env) + cZautomatic;
end;

function TZautoMenu.RunZutomatic(aMenuItem: integer): Integer;
var
  loShell: TNovusShell;
begin
  if Trim(GetZauto_Env) = '' then
    begin
      TNovusVCLUtils.MessageDlgEx('ZautoShell', 'Environment variable "ZAUTO" is blank.', [mbOK], 0);

      Exit;
    end;

  if not FileExists(GetZautomatic) then
    begin
      TNovusVCLUtils.MessageDlgEx('ZautoShell', '"' + GetZautomatic + '" cannot be found.', [mbOK], 0);

      Exit;
    end;


  Try
    loShell := TNovusShell.Create;

    case (aMenuItem) of
    0: Result := loShell.RunCommand(GetZautomatic,
                        ExtractFilePath(fsFileName),
                        '-solution ' + fsFileName);

    1: Result := loShell.RunCommand(GetZautomatic,
                        ExtractFilePath(fsFileName),
                        '-solution ' + fsFileName + ' -compileonly' );

    end;


  Finally
    loShell.Free;
  End;
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
