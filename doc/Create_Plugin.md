1. Delphi  Dynamic-link Library
2. Set Target Win64
3. Set Paths for Compiler
     * Output directory ..\..\build\plugins\
     * Search Path ..\..\build\
     * Unit output Directory ..\..\units\$(Platform)\
4. FastMM4 must be the first unit in your library's USES clause AND your project's 
5. Add a Plugin_???Classes unit
6. Add a API_???
7. Use unit-importing from PascslScript cmdimp.exe. Note constructor and destructor cannot overload causing it to crash. 
8. Runtime Packages 
     1. Link with runtime packages set True
     2. Runtime Packages set to only CodeImatic.build.core





5. Add plugin to codeimatic.build.config

    