unit API_WinAPI;

interface

uses APIBase, ShlObj, SysUtils, Windows, NovusWindows;

type
   TAPI_WinAPI = class(TAPIBase)
   private
   protected
   public
     function GetSpecialFolder(const CSIDL: integer) : string;
     function IsProcess32Exists(const aFilename: String): boolean;
   end;


Const
   CSIDL_ADMINTOOLS =	48; (*	The file system directory that is used to store administrative tools for an individual user. *)
   CSIDL_ALTSTARTUP	= 29; (* The file system directory that corresponds to the user's nonlocalized Startup program group. *)
   CSIDL_APPDATA = 26; (*	The file system directory that serves as a common repository for application-specific data. *)
   CSIDL_BITBUCKET = 10; (* The virtual folder containing the objects in the user's Recycle Bin. *)
   CSIDL_CDBURN_AREA = 59; (*	The file system directory acting as a staging area for files waiting to be written to CD. *)
   CSIDL_COMMON_ADMINTOOLS = 47; (*	The file system directory containing administrative tools for all users of the computer. *)
   CSIDL_COMMON_ALTSTARTUP = 30; (*	NT-based only	The file system directory that corresponds to the nonlocalized Startup program group for all users. *)
   CSIDL_COMMON_APPDATA	= 35; (* The file system directory containing application data for all users. *)
   CSIDL_COMMON_DESKTOPDIRECTORY = 25; (* NT-based only	The file system directory that contains files and folders that appear on the desktop for all users. *)
   CSIDL_COMMON_DOCUMENTS =	46;	(* The file system directory that contains documents that are common to all users. *)
   CSIDL_COMMON_FAVORITES =	31; (* NT-based only	The file system directory that serves as a common repository for favorite items common to all users. *)
   CSIDL_COMMON_MUSIC =	53; (*	The file system directory that serves as a repository for music files common to all users. *)
   CSIDL_COMMON_PICTURES = 54; (*	The file system directory that serves as a repository for image files common to all users. *)
   CSIDL_COMMON_PROGRAMS	= 23; (* NT-based only	The file system directory that contains the directories for the common program groups that appear on the Start menu for all users. *)
   CSIDL_COMMON_STARTMENU =	22; (* NT-based only	The file system directory that contains the programs and folders that appear on the Start menu for all users. *)
   CSIDL_COMMON_STARTUP =	24; (* NT-based only	The file system directory that contains the programs that appear in the Startup folder for all users. *)
   CSIDL_COMMON_TEMPLATES =	45; (* NT-based only	The file system directory that contains the templates that are available to all users. *)
   CSIDL_COMMON_VIDEO =	55; (* The file system directory that serves as a repository for video files common to all users. *)
   CSIDL_COMPUTERSNEARME = 61; (*	The folder representing other machines in your workgroup. *)
   CSIDL_CONNECTIONS = 49; (*	The virtual folder representing Network Connections, containing network and dial-up connections. *)
   CSIDL_CONTROLS =	3; (*	The virtual folder containing icons for the Control Panel applications. *)
   CSIDL_COOKIES	= 33; (* 	The file system directory that serves as a common repository for Internet cookies. *)
   CSIDL_DESKTOP	= 0; (*	The virtual folder representing the Windows desktop, the root of the shell namespace. *)
   CSIDL_DESKTOPDIRECTORY =	16; (*	The file system directory used to physically store file objects on the desktop. *)
   CSIDL_DRIVES =	17; (*	The virtual folder representing My Computer, containing everything on the local computer: storage devices, printers, and Control Panel. The folder may also contain mapped network drives. *)
   CSIDL_FAVORITES = 6; (*	The file system directory that serves as a common repository for the user's favorite items. *)
   CSIDL_FONTS = 20; (*	A virtual folder containing fonts. *)
   CSIDL_HISTORY = 34; (*	The file system directory that serves as a common repository for Internet history items. *)
   CSIDL_INTERNET	= 1; (*	A viritual folder for Internet Explorer. *)
   CSIDL_INTERNET_CACHE	= 32; (* The file system directory that serves as a common repository for temporary Internet files. *)
   CSIDL_LOCAL_APPDATA = 28; (*	The file system directory that serves as a data repository for local (nonroaming) applications. *)
   CSIDL_MYDOCUMENTS = 5; (* The virtual folder representing the My Documents desktop item. *)
   CSIDL_MYMUSIC = 13; (*	The file system directory that serves as a common repository for music files. *)
   CSIDL_MYPICTURES	=39; (*	The file system directory that serves as a common repository for image files. *)
   CSIDL_MYVIDEO = 14; (*	The file system directory that serves as a common repository for video files. *)
   CSIDL_NETHOOD = 19; (*	A file system directory containing the link objects that may exist in the My Network Places virtual folder. *)
   CSIDL_NETWORK = 18; (*	A virtual folder representing Network Neighborhood, the root of the network namespace hierarchy. *)
   CSIDL_PERSONAL	= 5; (*	The file system directory used to physically store a user's common repository of documents. (From shell version 6.0 onwards, CSIDL_PERSONAL is equivalent to CSIDL_MYDOCUMENTS, which is a virtual folder.) *)
   CSIDL_PHOTOALBUMS = 69; (*	Vista	The virtual folder used to store photo albums. *)
   CSIDL_PLAYLISTS = 63; (*	Vista	The virtual folder used to store play albums. *)
   CSIDL_PRINTERS	=4; (*	The virtual folder containing installed printers.  *)
   CSIDL_PRINTHOOD = 27; (*	The file system directory that contains the link objects that can exist in the Printers virtual folder. *)
   CSIDL_PROFILE =	40;	(* The user's profile folder. *)
   CSIDL_PROGRAM_FILES	= 38; (* The Program Files folder. *)
   CSIDL_PROGRAM_FILESX86 =	42; (* The Program Files folder for 32-bit programs on 64-bit systems. *)
   CSIDL_PROGRAM_FILES_COMMON	= 43; (* A folder for components that are shared across applications. *)
   CSIDL_PROGRAM_FILES_COMMONX86 = 44; (*	A folder for 32-bit components that are shared across applications on 64-bit systems. *)
   CSIDL_PROGRAMS	= 2; (*	The file system directory that contains the user's program groups (which are themselves file system directories). *)
   CSIDL_RECENT	= 8; (*	The file system directory that contains shortcuts to the user's most recently used documents. *)
   CSIDL_RESOURCES =	56; (* The file system directory that contains resource data. *)
   CSIDL_RESOURCES_LOCALIZED = 57; (* The file system directory that contains localized resource data. *)
   CSIDL_SAMPLE_MUSIC	= 64; (* Vista	The file system directory that contains sample music. *)
   CSIDL_SAMPLE_PLAYLISTS	= 65; (* Vista	The file system directory that contains sample playlists. *)
   CSIDL_SAMPLE_PICTURES =	66; (* Vista	The file system directory that contains sample pictures. *)
   CSIDL_SAMPLE_VIDEOS = 67; (* Vista	The file system directory that contains sample videos. *)
   CSIDL_SENDTO =	9; (*	The file system directory that contains Send To menu items. *)
   CSIDL_STARTMENU = 11; (*	The file system directory containing Start menu items. *)
   CSIDL_STARTUP = 7; (* The file system directory that corresponds to the user's Startup program group. *)
   CSIDL_SYSTEM	= 37; (* The Windows System folder. *)
   CSIDL_SYSTEMX86 = 41; (*	The Windows 32-bit System folder on 64-bit systems. *)
   CSIDL_TEMPLATES = 21; (*	The file system directory that serves as a common repository for document templates. *)
   CSIDL_WINDOWS = 36; (* The Windows directory or SYSROOT. *)

implementation


function TAPI_WinAPI.GetSpecialFolder(const CSIDL: integer) : string;
var
  RecPath : PWideChar;
begin
  RecPath := StrAlloc(MAX_PATH);
    try
    FillChar(RecPath^, MAX_PATH, 0);
    if SHGetSpecialFolderPath(0, RecPath, CSIDL, false)
      then result := RecPath
      else result := '';
    finally
      StrDispose(RecPath);
    end;
end;

function TAPI_WinAPI.IsProcess32Exists(const aFilename: String): boolean;
begin
  Result := TNovusWindows.IsProcess32Exists(aFileName);
end;


end.
