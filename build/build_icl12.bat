@ECHO OFF
rem ******************************************************************************
rem *
rem * Notepad2-mod
rem *
rem * build_icl12.bat
rem *   Batch file used to build Notepad2 with ICL12
rem *
rem * See License.txt for details about distribution and modification.
rem *
rem *                                       (c) XhmikosR 2010-2012
rem *                                       https://github.com/XhmikosR/notepad2-mod
rem *
rem ******************************************************************************

SETLOCAL ENABLEEXTENSIONS
CD /D %~dp0

rem Check the building environment
IF NOT DEFINED VS100COMNTOOLS    CALL :SUBMSG "ERROR" "Visual Studio 2010 wasn't found!"
IF NOT DEFINED ICPP_COMPOSER2011 CALL :SUBMSG "ERROR" "Intel C++ Compiler XE 2011 wasn't found!"


rem Check for the help switches
IF /I "%~1" == "help"   GOTO SHOWHELP
IF /I "%~1" == "/help"  GOTO SHOWHELP
IF /I "%~1" == "-help"  GOTO SHOWHELP
IF /I "%~1" == "--help" GOTO SHOWHELP
IF /I "%~1" == "/?"     GOTO SHOWHELP


rem Check for the first switch
IF "%~1" == "" (
  SET "BUILDTYPE=Build"
) ELSE (
  IF /I "%~1" == "Build"     SET "BUILDTYPE=Build"   & GOTO CHECKSECONDARG
  IF /I "%~1" == "/Build"    SET "BUILDTYPE=Build"   & GOTO CHECKSECONDARG
  IF /I "%~1" == "-Build"    SET "BUILDTYPE=Build"   & GOTO CHECKSECONDARG
  IF /I "%~1" == "--Build"   SET "BUILDTYPE=Build"   & GOTO CHECKSECONDARG
  IF /I "%~1" == "Clean"     SET "BUILDTYPE=Clean"   & GOTO CHECKSECONDARG
  IF /I "%~1" == "/Clean"    SET "BUILDTYPE=Clean"   & GOTO CHECKSECONDARG
  IF /I "%~1" == "-Clean"    SET "BUILDTYPE=Clean"   & GOTO CHECKSECONDARG
  IF /I "%~1" == "--Clean"   SET "BUILDTYPE=Clean"   & GOTO CHECKSECONDARG
  IF /I "%~1" == "Rebuild"   SET "BUILDTYPE=Rebuild" & GOTO CHECKSECONDARG
  IF /I "%~1" == "/Rebuild"  SET "BUILDTYPE=Rebuild" & GOTO CHECKSECONDARG
  IF /I "%~1" == "-Rebuild"  SET "BUILDTYPE=Rebuild" & GOTO CHECKSECONDARG
  IF /I "%~1" == "--Rebuild" SET "BUILDTYPE=Rebuild" & GOTO CHECKSECONDARG

  ECHO.
  ECHO Unsupported commandline switch!
  ECHO Run "%~nx0 help" for details about the commandline switches.
  CALL :SUBMSG "ERROR" "Compilation failed!"
)


:CHECKSECONDARG
rem Check for the second switch
IF "%~2" == "" (
  SET "ARCH=all"
) ELSE (
  IF /I "%~2" == "x86"   SET "ARCH=x86" & GOTO CHECKTHIRDARG
  IF /I "%~2" == "/x86"  SET "ARCH=x86" & GOTO CHECKTHIRDARG
  IF /I "%~2" == "-x86"  SET "ARCH=x86" & GOTO CHECKTHIRDARG
  IF /I "%~2" == "--x86" SET "ARCH=x86" & GOTO CHECKTHIRDARG
  IF /I "%~2" == "x64"   SET "ARCH=x64" & GOTO CHECKTHIRDARG
  IF /I "%~2" == "/x64"  SET "ARCH=x64" & GOTO CHECKTHIRDARG
  IF /I "%~2" == "-x64"  SET "ARCH=x64" & GOTO CHECKTHIRDARG
  IF /I "%~2" == "--x64" SET "ARCH=x64" & GOTO CHECKTHIRDARG
  IF /I "%~2" == "all"   SET "ARCH=all" & GOTO CHECKTHIRDARG
  IF /I "%~2" == "/all"  SET "ARCH=all" & GOTO CHECKTHIRDARG
  IF /I "%~2" == "-all"  SET "ARCH=all" & GOTO CHECKTHIRDARG
  IF /I "%~2" == "--all" SET "ARCH=all" & GOTO CHECKTHIRDARG

  ECHO.
  ECHO Unsupported commandline switch!
  ECHO Run "%~nx0 help" for details about the commandline switches.
  CALL :SUBMSG "ERROR" "Compilation failed!"
)


:CHECKTHIRDARG
rem Check for the third switch
IF "%~3" == "" (
  SET "CONFIG=Release"
) ELSE (
  IF /I "%~3" == "Debug"     SET "CONFIG=Debug"   & GOTO START
  IF /I "%~3" == "/Debug"    SET "CONFIG=Debug"   & GOTO START
  IF /I "%~3" == "-Debug"    SET "CONFIG=Debug"   & GOTO START
  IF /I "%~3" == "--Debug"   SET "CONFIG=Debug"   & GOTO START
  IF /I "%~3" == "Release"   SET "CONFIG=Release" & GOTO START
  IF /I "%~3" == "/Release"  SET "CONFIG=Release" & GOTO START
  IF /I "%~3" == "-Release"  SET "CONFIG=Release" & GOTO START
  IF /I "%~3" == "--Release" SET "CONFIG=Release" & GOTO START
  IF /I "%~3" == "all"       SET "CONFIG=all"     & GOTO START
  IF /I "%~3" == "/all"      SET "CONFIG=all"     & GOTO START
  IF /I "%~3" == "-all"      SET "CONFIG=all"     & GOTO START
  IF /I "%~3" == "--all"     SET "CONFIG=all"     & GOTO START

  ECHO.
  ECHO Unsupported commandline switch!
  ECHO Run "%~nx0 help" for details about the commandline switches.
  CALL :SUBMSG "ERROR" "Compilation failed!"
)


:START
IF "%ARCH%" == "x64" GOTO x64
IF "%ARCH%" == "x86" GOTO x86


:x86
CALL "%VS100COMNTOOLS%..\..\VC\vcvarsall.bat" x86

IF "%CONFIG%" == "all" (CALL :SUBMSVC %BUILDTYPE% Debug Win32 && CALL :SUBMSVC %BUILDTYPE% Release Win32) ELSE (CALL :SUBMSVC %BUILDTYPE% %CONFIG% Win32)

IF "%ARCH%" == "x86" GOTO END


:x64
IF DEFINED PROGRAMFILES(x86) (SET build_type=amd64) ELSE (SET build_type=x86_amd64)

CALL "%VS100COMNTOOLS%..\..\VC\vcvarsall.bat" %build_type%

IF "%CONFIG%" == "all" (CALL :SUBMSVC %BUILDTYPE% Debug x64 && CALL :SUBMSVC %BUILDTYPE% Release x64) ELSE (CALL :SUBMSVC %BUILDTYPE% %CONFIG% x64)


:END
TITLE Building Notepad2-mod with ICL12 - Finished!
ENDLOCAL
EXIT /B


:SUBMSVC
ECHO.
TITLE Building Notepad2-mod with ICL12 - %~1 "%~2|%~3"...
"%WINDIR%\Microsoft.NET\Framework\v4.0.30319\MSBuild.exe" /nologo Notepad2_icl12.sln^
 /t:%~1 /p:Configuration=%~2;Platform=%~3 /consoleloggerparameters:Verbosity=minimal^
 /maxcpucount /nodeReuse:true
IF %ERRORLEVEL% NEQ 0 CALL :SUBMSG "ERROR" "Compilation failed!"
EXIT /B


:SHOWHELP
TITLE %~nx0 %1
ECHO. & ECHO.
ECHO Usage: %~nx0 [Clean^|Build^|Rebuild] [x86^|x64^|all] [Debug^|Release^|all]
ECHO.
ECHO Notes: You can also prefix the commands with "-", "--" or "/".
ECHO        The arguments are not case sensitive.
ECHO. & ECHO.
ECHO Executing %~nx0 without any arguments is equivalent to "%~nx0 build all release"
ECHO.
ECHO If you skip the second argument the default one will be used.
ECHO The same goes for the third argument. Examples:
ECHO "%~nx0 rebuild" is the same as "%~nx0 rebuild all release"
ECHO "%~nx0 rebuild x86" is the same as "%~nx0 rebuild x86 release"
ECHO.
ECHO WARNING: "%~nx0 x86" or "%~nx0 debug" won't work.
ECHO.
ENDLOCAL
EXIT /B


:SUBMSG
ECHO. & ECHO ______________________________
ECHO [%~1] %~2
ECHO ______________________________ & ECHO.
IF /I "%~1" == "ERROR" (
  PAUSE
  EXIT
) ELSE (
  EXIT /B
)
