@echo off
title niL MC Launcher - Legacy Fabric 1.8.9
color 0A

:: 1. پیدا کردن پوشه‌ی mcdata (از محل اجرای فایل بت شروع می‌کنه و به سمت بالا می‌گرده)
set "SEARCH_DIR=%~dp0"
:SEARCH_LOOP
if exist "%SEARCH_DIR%\mcdata" (
    set "MC_DIR=%SEARCH_DIR%\mcdata"
    goto :FOUND
)
:: رفتن به پوشه‌ی والد
for %%a in ("%SEARCH_DIR%.") do set "PARENT=%%~dpa"
if "%SEARCH_DIR%"=="%PARENT%" goto :NOTFOUND
set "SEARCH_DIR=%PARENT%"
goto :SEARCH_LOOP

:NOTFOUND
echo.
echo ERROR: Could not find 'mcdata' folder.
echo Make sure this launcher is placed somewhere in the portable directory.
pause
exit /b

:FOUND
:: حالا MC_DIR دقیقاً همون پوشه‌ی mcdata پیدا‌شده است.
set "GAME_DIR=%MC_DIR%"
set "ASSETS_DIR=%MC_DIR%\assets"
set "ASSETS_INDEX=1.8"
set "NATIVES_DIR=%MC_DIR%\natives\1.8.9"
set "JAVA_EXE=%MC_DIR%\java\bin\javaw.exe"

:: بررسی وجود فایل‌های ضروری
if not exist "%JAVA_EXE%" (
    echo.
    echo ERROR: Java not found at: "%JAVA_EXE%"
    pause
    exit /b
)

if not exist "%MC_DIR%\versions\1.8.9\1.8.9.jar" (
    echo.
    echo ERROR: Minecraft 1.8.9.jar not found!
    pause
    exit /b
)

:MENU
cls
echo.
echo ============================================================
echo.
echo                    n    n  iiii  L
echo                    nn   n   ii   L
echo                    n n  n   ii   L
echo                    n  n n   ii   L
echo                    n   nn   ii   L
echo                    n    n  iiii  LLLLL
echo.
echo                   niL MC by ATA nazari
echo.
echo      A perfect performance launcher for Minecraft
echo                    1.8.9 BedWars
echo.
echo ============================================================
echo.
echo.
echo   [1] Launch Game
echo   [2] Credits
echo   [3] Exit
echo.
echo ============================================================
set /p "CHOICE=Select option (1-3): "

if "%CHOICE%"=="1" goto LAUNCH
if "%CHOICE%"=="2" goto CREDITS
if "%CHOICE%"=="3" exit
goto MENU

:LAUNCH
cls
echo.
echo ============================================================
echo                     LAUNCH SETUP
echo ============================================================
echo.
set /p "PLAYER_NAME=Enter Username: "
echo.
echo Select RAM Allocation:
echo   [1] 1 GB (1024 MB)
echo   [2] 2 GB (2048 MB) - Default
echo   [3] 3 GB (3072 MB)
echo   [4] 4 GB (4096 MB)
echo   [5] Custom (Enter MB)
echo.
set /p "RAM_OPTION=Select RAM (1-5): "

if "%RAM_OPTION%"=="1" set "RAM_MB=1024" & set "RAM_G=1G"
if "%RAM_OPTION%"=="2" set "RAM_MB=2048" & set "RAM_G=2G"
if "%RAM_OPTION%"=="3" set "RAM_MB=3072" & set "RAM_G=3G"
if "%RAM_OPTION%"=="4" set "RAM_MB=4096" & set "RAM_G=4G"
if "%RAM_OPTION%"=="5" (
    set /p "CUSTOM_RAM=Enter RAM in MB (e.g., 2560): "
    set /a "RAM_MB=%CUSTOM_RAM%" 2>nul
    if not defined RAM_MB (
        echo Invalid input. Using default 2G.
        set "RAM_MB=2048"
        set "RAM_G=2G"
    ) else (
        set "RAM_G=%RAM_MB%M"
    )
)

if not defined RAM_G (
    echo No RAM selected. Using default 2G.
    set "RAM_MB=2048"
    set "RAM_G=2G"
)

echo.
echo ============================================================
echo Launching with %RAM_MB% MB RAM allocated...
echo Username: %PLAYER_NAME%
echo ============================================================
echo.

:: ساخت کلاس‌پس کتابخونه‌ها (همه نسبت به MC_DIR)
set "CP="
set "CP=%CP%;%MC_DIR%\libraries\net\fabricmc\fabric-loader\0.19.3\fabric-loader-0.19.3.jar"
set "CP=%CP%;%MC_DIR%\libraries\net\fabricmc\sponge-mixin\0.17.3+mixin.0.8.7\sponge-mixin-0.17.3+mixin.0.8.7.jar"
set "CP=%CP%;%MC_DIR%\libraries\net\legacyfabric\intermediary\1.8.9\intermediary-1.8.9.jar"
set "CP=%CP%;%MC_DIR%\libraries\org\ow2\asm\asm\9.10.1\asm-9.10.1.jar"
set "CP=%CP%;%MC_DIR%\libraries\org\ow2\asm\asm-analysis\9.10.1\asm-analysis-9.10.1.jar"
set "CP=%CP%;%MC_DIR%\libraries\org\ow2\asm\asm-commons\9.10.1\asm-commons-9.10.1.jar"
set "CP=%CP%;%MC_DIR%\libraries\org\ow2\asm\asm-tree\9.10.1\asm-tree-9.10.1.jar"
set "CP=%CP%;%MC_DIR%\libraries\org\ow2\asm\asm-util\9.10.1\asm-util-9.10.1.jar"
set "CP=%CP%;%MC_DIR%\libraries\org\lwjgl\lwjgl\lwjgl\2.9.4+legacyfabric.17\lwjgl-2.9.4+legacyfabric.17.jar"
set "CP=%CP%;%MC_DIR%\libraries\org\lwjgl\lwjgl\lwjgl_util\2.9.4+legacyfabric.17\lwjgl_util-2.9.4+legacyfabric.17.jar"
set "CP=%CP%;%MC_DIR%\libraries\com\mojang\authlib\1.5.21\authlib-1.5.21.jar"
set "CP=%CP%;%MC_DIR%\libraries\com\mojang\realms\1.7.59\realms-1.7.59.jar"
set "CP=%CP%;%MC_DIR%\libraries\com\google\code\gson\gson\2.2.4\gson-2.2.4.jar"
set "CP=%CP%;%MC_DIR%\libraries\com\google\guava\guava\17.0\guava-17.0.jar"
set "CP=%CP%;%MC_DIR%\libraries\org\apache\logging\log4j\log4j-core\2.0-beta9\log4j-core-2.0-beta9.jar"
set "CP=%CP%;%MC_DIR%\libraries\org\apache\logging\log4j\log4j-api\2.0-beta9\log4j-api-2.0-beta9.jar"
set "CP=%CP%;%MC_DIR%\libraries\net\sf\jopt-simple\jopt-simple\4.6\jopt-simple-4.6.jar"
set "CP=%CP%;%MC_DIR%\libraries\org\apache\commons\commons-lang3\3.3.2\commons-lang3-3.3.2.jar"
set "CP=%CP%;%MC_DIR%\libraries\io\netty\netty-all\4.0.23.Final\netty-all-4.0.23.Final.jar"
set "CP=%CP%;%MC_DIR%\libraries\commons-io\commons-io\2.4\commons-io-2.4.jar"
set "CP=%CP%;%MC_DIR%\libraries\commons-codec\commons-codec\1.9\commons-codec-1.9.jar"
set "CP=%CP%;%MC_DIR%\libraries\com\paulscode\soundsystem\20120107\soundsystem-20120107.jar"
set "CP=%CP%;%MC_DIR%\libraries\com\paulscode\librarylwjglopenal\20100824\librarylwjglopenal-20100824.jar"
set "CP=%CP%;%MC_DIR%\libraries\com\paulscode\codecjorbis\20101023\codecjorbis-20101023.jar"
set "CP=%CP%;%MC_DIR%\libraries\com\paulscode\codecwav\20101023\codecwav-20101023.jar"
set "CP=%CP%;%MC_DIR%\libraries\com\ibm\icu\icu4j-core-mojang\51.2\icu4j-core-mojang-51.2.jar"
set "CP=%CP%;%MC_DIR%\versions\1.8.9\1.8.9.jar"

:: حذف ; اضافی اول کلاس‌پس
set "CP=%CP:~1%"

start "" "%JAVA_EXE%" -Xmx%RAM_G% -XX:+UseG1GC -Dsun.rmi.dgc.server.gcInterval=2147483646 -XX:+UnlockExperimentalVMOptions -XX:G1NewSizePercent=20 -XX:G1ReservePercent=20 -XX:MaxGCPauseMillis=50 -XX:G1HeapRegionSize=32M -Djava.library.path="%NATIVES_DIR%" -cp "%CP%" net.fabricmc.loader.impl.launch.knot.KnotClient --username %PLAYER_NAME% --version 1.8.9 --gameDir "%GAME_DIR%" --assetsDir "%ASSETS_DIR%" --assetIndex %ASSETS_INDEX% --width 930 --height 540

echo.
echo ============================================================
echo Game launched in separate window.
echo Press any key to return to menu...
echo ============================================================
pause >nul
goto MENU

:CREDITS
cls
echo.
echo ============================================================
echo                       CREDITS
echo ============================================================
echo.
echo.
echo            ====================================
echo                     Created by ATA nazari
echo                           (niL)
echo.
echo                          6/5/2026
echo.
echo            A perfect performance launcher for
echo                  Minecraft 1.8.9 BedWars
echo.
echo            Special thanks to:
echo            - Legacy Fabric Team
echo            - Radium Developers
echo            - All mod creators
echo            ====================================
echo.
echo.
echo ============================================================
echo Press any key to return to main menu...
echo ============================================================
pause >nul
goto MENU