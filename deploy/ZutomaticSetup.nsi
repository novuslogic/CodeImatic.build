
; Define your application name
!define APPNAME "Zautomatic"
!define APPNAMEANDVERSION "Zautomatic 1.0.0 Alpha 1"

; Main Install settings
Name "${APPNAMEANDVERSION}"
InstallDir "$PROGRAMFILES\Zautomatic"
InstallDirRegKey HKLM "Software\${APPNAME}" ""
OutFile "ZautomaticSetup.exe"

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
    File "..\deploy\bin\NovusCodeLibrary_plugin220.bpl"
    File "..\deploy\bin\NovusCodeLibrary_XML220.bpl"
    File "..\deploy\bin\PascalScript_Core_D22.bpl"
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
	Delete "$INSTDIR\ZautoCore.bpl"
	Delete "$INSTDIR\Zautomatic.config"
	Delete "$INSTDIR\Zautomatic.exe"
	Delete "$INSTDIR\plugins\Task.dll"
	Delete "$INSTDIR\plugins\Zip.dll"

	; Remove remaining directories
	RMDir "$SMPROGRAMS\Zautomatic"
	RMDir "$INSTDIR\plugins\"
	RMDir "$INSTDIR\"

SectionEnd

; eof