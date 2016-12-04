
; Define your application name
!define APPNAME "Zautomatic"
!define APPNAMEANDVERSION "Zautomatic 1.0.0 Alpha 1"

; Main Install settings
Name "${APPNAMEANDVERSION}"
InstallDir "$PROGRAMFILES\Zautomatic"
InstallDirRegKey HKLM "Software\${APPNAME}" ""
OutFile "ZautomaticSetup.exe"

!include "winmessages.nsh"

; Modern interface settings
!include "MUI.nsh"

!define MUI_ABORTWARNING

!insertmacro MUI_PAGE_WELCOME
!insertmacro MUI_PAGE_LICENSE "..\LICENSE"
!insertmacro MUI_PAGE_COMPONENTS
!insertmacro MUI_PAGE_DIRECTORY
!insertmacro MUI_PAGE_INSTFILES
!insertmacro MUI_PAGE_FINISH

!insertmacro MUI_UNPAGE_CONFIRM
!insertmacro MUI_UNPAGE_INSTFILES

; Set languages (first is default language)
!insertmacro MUI_LANGUAGE "English"
!insertmacro MUI_RESERVEFILE_LANGDLL

Section "Zautomatic" Section1

	; Set Section properties
	SetOverwrite on

	; Set Section Files and Shortcuts
	SetOutPath "$INSTDIR\bin"
	File "..\deploy\bin\dbrtl220.bpl"
    File "..\deploy\bin\dbrtl220.bpl"
    File "..\deploy\bin\DBXCommonDriver220.bpl"
    File "..\deploy\bin\inet220.bpl"
    File "..\deploy\bin\jcl220.bpl"
    File "..\deploy\bin\jclvcl220.bpl"
    File "..\deploy\bin\jvCore220.bpl"
    File "..\deploy\bin\jvSystem220.bpl"
    File "..\deploy\bin\NovusCodeLibrary_Core220.bpl"
    File "..\deploy\bin\NovusCodeLibrary_log220.bpl"
	File "..\deploy\bin\NovusCodeLibrary_parser220.bpl"
    File "..\deploy\bin\NovusCodeLibrary_plugin220.bpl"
    File "..\deploy\bin\NovusCodeLibrary_XML220.bpl"
	File "..\deploy\bin\NovusCodeLibrary_Env220.bpl"
    File "..\deploy\bin\PascalScript_Core_D22.bpl"
	File "..\deploy\bin\borlndmm.dll"
    File "..\deploy\bin\rtl220.bpl"
    File "..\deploy\bin\soaprtl220.bpl"
    File "..\deploy\bin\vcl220.bpl"
    File "..\deploy\bin\vclimg220.bpl"
    File "..\deploy\bin\vclx220.bpl"
    File "..\deploy\bin\xmlrtl220.bpl"
    File "..\deploy\bin\ZAutoCore.bpl"
    File "..\deploy\bin\Zautomatic.exe"
	


	SetOutPath "$INSTDIR\bin\plugins\"

    File "..\deploy\bin\plugins\task.dll"
    File "..\deploy\bin\plugins\zip.dll"
	
	SetOutPath "$INSTDIR\includes\"
	
	File "..\deploy\includes\AWS.zas"
	File "..\deploy\includes\cmd.zas"
	File "..\deploy\includes\delphi.zas"
	File "..\deploy\includes\dotNET.zas"
	File "..\deploy\includes\msbuild.zas"
	File "..\deploy\includes\numutils.zas"
	File "..\deploy\includes\powershell.zas"
	File "..\deploy\includes\stringutils.zas"
	File "..\deploy\includes\Windows.zas"
	File "..\deploy\includes\Xcopy.zas"


	CreateDirectory "$SMPROGRAMS\Zautomatic"
	CreateShortCut "$SMPROGRAMS\Zautomatic\Uninstall.lnk" "$INSTDIR\uninstall.exe"

SectionEnd

Section -FinishSection

	WriteRegStr HKLM "Software\${APPNAME}" "" "$INSTDIR"
	WriteRegStr HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\${APPNAME}" "DisplayName" "${APPNAME}"
	WriteRegStr HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\${APPNAME}" "UninstallString" "$INSTDIR\uninstall.exe"
	WriteUninstaller "$INSTDIR\uninstall.exe"

   ; HKLM (all users) vs HKCU (current user) defines
   !define env_hklm 'HKLM "SYSTEM\CurrentControlSet\Control\Session Manager\Environment"'
   !define env_hkcu 'HKCU "Environment"'
   ; set variable for local machine
   WriteRegExpandStr ${env_hklm} "ZAUTO" "$INSTDIR\bin\"
   ; and current user
   WriteRegExpandStr ${env_hkcu} "ZAUTO" "$INSTDIR\bin\"

   ; set variable for local machine
   WriteRegExpandStr ${env_hklm} "ZAUTO_INCLUDES" "$INSTDIR\includes\"
   ; and current user
   WriteRegExpandStr ${env_hkcu} "ZAUTO_INCLUDES" "$INSTDIR\includes\"

   ; make sure windows knows about the change
   SendMessage ${HWND_BROADCAST} ${WM_WININICHANGE} 0 "STR:Environment" /TIMEOUT=5000


SectionEnd

; Modern install component descriptions
!insertmacro MUI_FUNCTION_DESCRIPTION_BEGIN
	!insertmacro MUI_DESCRIPTION_TEXT ${Section1} ""
!insertmacro MUI_FUNCTION_DESCRIPTION_END

;Uninstall section
Section Uninstall

	;Remove from registry...
	DeleteRegKey HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\${APPNAME}"
	DeleteRegKey HKLM "SOFTWARE\${APPNAME}"

	; Delete self
	Delete "$INSTDIR\uninstall.exe"

	; Delete Shortcuts
	Delete "$SMPROGRAMS\Zautomatic\Uninstall.lnk"

	; Clean up Zautomatic
    Delete "$INSTDIR\bin\dbrtl220.bpl"
    Delete "$INSTDIR\bin\dbrtl220.bpl"
    Delete "$INSTDIR\bin\DBXCommonDriver220.bpl"
    Delete "$INSTDIR\bin\inet220.bpl"
    Delete "$INSTDIR\bin\jcl220.bpl"
    Delete "$INSTDIR\bin\jclvcl220.bpl"
    Delete "$INSTDIR\bin\jvCore220.bpl"
    Delete "$INSTDIR\bin\jvSystem220.bpl"
    Delete "$INSTDIR\bin\NovusCodeLibrary_Core220.bpl"
	Delete "$INSTDIR\bin\NovusCodeLibrary_Parser220.bpl"
    Delete "$INSTDIR\bin\NovusCodeLibrary_log220.bpl"
    Delete "$INSTDIR\bin\NovusCodeLibrary_plugin220.bpl"
    Delete "$INSTDIR\bin\NovusCodeLibrary_XML220.bpl"
    Delete "$INSTDIR\bin\PascalScript_Core_D22.bpl"
	Delete "$INSTDIR\bin\NovusCodeLibrary_Env220.bpl"
    Delete "$INSTDIR\bin\borlndmm.dll"
    Delete "$INSTDIR\bin\rtl220.bpl"
    Delete "$INSTDIR\bin\soaprtl220.bpl"
    Delete "$INSTDIR\bin\vcl220.bpl"
    Delete "$INSTDIR\bin\vclimg220.bpl"
    Delete "$INSTDIR\bin\vclx220.bpl"
    Delete "$INSTDIR\bin\xmlrtl220.bpl"
    Delete "$INSTDIR\bin\ZAutoCore.bpl"
    Delete "$INSTDIR\bin\Zautomatic.exe"

    Delete "$INSTDIR\bin\plugins\task.dll"
    Delete "$INSTDIR\bin\plugins\zip.dll"
	
	Delete "$INSTDIR\includes\AWS.zas"
	Delete "$INSTDIR\includes\cmd.zas"
	Delete "$INSTDIR\includes\delphi.zas"
	Delete "$INSTDIR\includes\dotNET.zas"
	Delete "$INSTDIR\includes\msbuild.zas"
	Delete "$INSTDIR\includes\numutils.zas"
	Delete "$INSTDIR\includes\powershell.zas"
	Delete "$INSTDIR\includes\stringutils.zas"
	Delete "$INSTDIR\includes\Windows.zas"
	Delete "$INSTDIR\includes\Xcopy.zas"


	; Remove remaining directories
	RMDir "$SMPROGRAMS\Zautomatic"
	RMDir "$INSTDIR\bin\"
	RMDir "$INSTDIR\bin\plugins\"
	RMDir "$INSTDIR\"

SectionEnd

; eof