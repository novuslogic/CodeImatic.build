14/07/2022

* Moved tPlugin_SystemExt to CodeImatic.build.Pascal.SystemExt.dll
* Moved tPlugin_Output to CodeImatic.build.Pascal.Output.dll
* Moved tPlugin_WinAPI to CodeImatic.build.Pascal.WinAPI.dll

10/07/2022

* Upgraded tp Pre multi Plantform NovuscodeLibrary Delphi 11

09/07/2022

* Refactored for upgraded Novusplugin unit in NovuscodeLibrary

24/01/2022

*  Updated Codeimatic.build for Delphi 11
*  Delphi.pas now supports Delphi 11

3/1/2022

* Add new functoin function ProgramDataFolder: String in windows unit
* Add new function function IsChocolateyInstalled: boolean to powershell unit


28/12/2021

* Removed FastMM5 unit
* Defines now supported {$ifdef}, {$else}, {$endif}, {$include}

18/12/2021

* Fixed a small bug in vb6.pas include - where vb6 was not found 

12/09/2021

* Updated Codeimatic.build for Delphi 10.4 and updated Delphi TestApp Sample updated for Delphi 10.4

1/09/2021

* New function TlbExp(aOptions: string): integer; in include MSBuild.pas

27/08/2021 

* New function LinkVB6Console(aFilename: string): Integer; in include vb6.pas


27/06/2021

* New Web Plugin
  * Add Function GetMIMEType( aURL : String) : string
  * Add function UrlDecode( const aEncodedStr : String) : String
  * add function UrlEncode( const aDecodedStr : String; aPluses : Boolean) : String
  * Add function OpenDefaultWebBrowser( const aURL : string) : Integer
  * Add function URLDownloadToFile(aURL: UnicodeString; aDownloadPath: String): TWebDownloadResponse; 
* Removed cURL Plugin replaces with Web Plugin
* New samples for Web plugin

16/06/2021

* Rename class TExternalPlugin to TPascalScriptPlugin
* Rename class TinternalPlugin to TPascalScriptInternalPlugin

30/05/2021

* Fixed memory leak in tPascalScript class
* Rename tScriptEngine to tPascalScript class
 

26/02/2021

* New MSBuild include now supports Visual Studio Community 2019 with verion option VSCommunity2019
* New function in ExecExA in cmd include

08/01/2021

* Log unload external plugins
  
5/1/2021

* Delphi.pas now supports Delphi 10.4
* Reworked Unloading Plugins procedure TPlugins.UnloadPlugins
* Removed External VCLControls Plugin
* Add PluginName to TPlugin Class
* New TExternalPlugin class defined for External Plugins
* New TInternalPlugin class defined for Internal Plugins

06/05/2020

* Upgraded FastMM4 to FastMM5 

21/03/2020

* Upgrade to NovuscodeLibrary new NovusObject Package

16/03/2020

* New Project tag [%workingdirectory%] Current working directory
  
5/03/2020

* Fixed crashing functions "Format" and Log.LogFormat in Delphi 10.3.3

14/02/2020

* Memory leak fixed in runtime class
  
16/01/2020

* Include CodeImatic.pas - Function Codegen Paramater ProjectCofing removed 
* Rename RunCaptureCommand to RunCommandCapture with in Shell API and Includes 

11/01/2020

* Start of the Changelog
* Now supports Delphi 10.3 using MSBuild 4.0 in includes unit Delphi.pas
* RunCaptureCommand now runs in a Task allowing for future Parallel run of a command and capture output.
 