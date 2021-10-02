@shift /0
@ECHO OFF
title LG Advanced Toolkit (release_1)
set currentpath=%~dp0
:MENU
echo  [91m================================================================================[0m
echo  [91m LG Advanced Toolkit (judyln/judypn). Created by Log1cs (github.com/log1cs)[0m
echo  [91m================================================================================[0m
echo Available options:
echo 1 - Unlock your bootloader
echo 2 - Lock your bootloader
echo 3 - Nuke your LAF
echo 4 - Recover your LAF (need to reflash KDZ after recover LAF process done)
echo 5 - Flash Recovery Image
echo 6 - Flash GSI Image
echo 7 - Flash your phone KDZ through LGUP
echo 8 - Unbrick your device in EDL mode
echo 9 - Extract KDZ
echo 10 - Install Custom ROM (locked bootloader)
echo 11 - Install Custom ROM (unlocked bootloader)
echo 12 - Install Prerequisites
echo 13 - How to install Fastboot Drivers
echo 14 - Changelog
set /p choice=Choose an option: 
if not "%choice%"=="" set choice=%choice:~0,1%
if /i "%choice%"=="1" goto UNLOCK
if /i "%choice%"=="2" goto LOCK
if /i "%choice%"=="3" goto NLAF
if /i "%choice%"=="4" goto RLAF
if /i "%choice%"=="5" goto REC
if /i "%choice%"=="6" goto GSI
if /i "%choice%"=="7" goto KDZ
if /i "%choice%"=="8" goto QFILFLASH
if /i "%choice%"=="9" goto UNKDZ
if /i "%choice%"=="10" goto CRIL
if /i "%choice%"=="11" goto CRIU
if /i "%choice%"=="12" goto PREQ
if /i "%choice%"=="13" goto FBD
if /i "%choice%"=="14" goto CL
ECHO.
ECHO.
ECHO. Invalid option. Please check again. Going back to Main Unlock Screen...
timeout /t 2 /nobreak >NUL
ECHO.
cls
goto :MENU

:CLM
cls
goto MENU

:UNKDZ
cls
echo Move your KDZ in here and press Y to confirm extraction. Press N to cancel.
explorer.exe %currentpath%files\kdztools
choice /c:YN /n
if %errorlevel%==2 goto no
if %errorlevel%==1 goto yes

:no
exit

:yes
for /f %%i in ('dir /b *.kdz') do (
echo Processing KDZ file: %%i
%currentpath%files\kdztools\unkdz.exe -f %%i -x -d .

del /f /s /q .\*.params
del /f /s /q .\*.bin
del /f /s /q .\*UP*.*
echo Processed KDZ file: %%i
)
echo All KDZ files are processed, PLEASE CHECK!

for /f %%i in ('dir /b *.dz') do (
echo Processing DZ file: %%i Using model: S
%currentpath%files\kdztools\undz.exe -f %%i -s -d .\%%~ni_img

del /f /s /q .\%%~ni_img\*.params
del /f /s /q .\%%~ni_img\userdata.image

ren .\%%~ni_img\*.image *.img
echo Processed DZ file: %%i
)
echo Finished!
pause

:UNLOCK
cls
echo These are 2 phones are currently supported. G8X under development.
echo 1 - LG V40(judypn)
echo 2 - LG G7(judyln)
echo 3 - Exit
set /p choice1=Choose an option: 
if not "%choice1%"=="" set choice=%choice:~0,1%
if /i "%choice1%"=="1" goto V40
if /i "%choice1%"=="2" goto G7
if /i "%choice1%"=="3" goto CLM
ECHO.
ECHO.
ECHO. Invalid option. Please check again. Going back to Main Unlock Screen...
timeout /t 2 /nobreak >NUL
ECHO.
cls
goto :UNLOCK