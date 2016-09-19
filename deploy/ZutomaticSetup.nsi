; Script generated with the Venis Install Wizard

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
	SetOutPath "$INSTDIR\"
	File "..\build\ZautoCore.bpl"
	File "..\build\Zautomatic.config"
	File "..\build\Zautomatic.exe"
	SetOutPath "$INSTDIR\plugins\"
	File "..\build\plugins\Task.dll"
	File "..\build\plugins\Zip.dll"
	
	SetOutPath "$INSTDIR\includes\"
	
	File "..\source\Includes\AWS.zas"
	File "..\source\Includes\cmd.zas"
	File "..\source\Includes\numutils.zas"
	File "..\source\Includes\ole32.zas"
	File "..\source\Includes\stringutils.zas"
	
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