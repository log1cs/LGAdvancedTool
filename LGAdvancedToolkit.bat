@shift /0
@ECHO OFF
title LG Advanced Toolkit (release_1)
set currentpath=%~dp0
:MENU
echo  [91m================================================================================[0m
echo  [91m LG Advanced Toolkit (judyln/judypn). Created by Log1cs (github.com/log1cs)[0m
echo  [91m================================================================================[0m
echo  [91mWindows 7 version under development. Stay tuned(tm)[0m
echo  Working path: C:\LGAT\
echo  If you are new: Read function 13 and function 14. It's mandatory before doing anything.
echo Available options:
echo 1 - Unlock your bootloader
echo 2 - Lock your bootloader
echo 3 - Nuke your LAF
echo 4 - Recover your LAF (need to reflash KDZ after recover LAF process done)
echo 5 - Boot Recovery Image
echo 6 - Flash GSI Image
echo 7 - Flash your phone KDZ through LGUP
echo 8 - Unbrick your device in EDL mode
echo 9 - Extract KDZ
echo 10 - Install Custom ROM (locked bootloader)
echo 11 - Install Custom ROM (unlocked bootloader)
echo 12 - Install Prerequisites
echo 13 - How to install Fastboot Drivers
echo 14 - FAQ
echo 15 - Changelog
echo 16 - Exit
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
if /i "%choice%"=="14" goto FAQ
if /i "%choice%"=="15" goto CL
if /i "%choice%"=="16" goto EXIT
if /i %choice%=="risk" goto BRICKMYPHONE
ECHO.
ECHO.
ECHO. Invalid option. Please check again. Going back to Main Unlock Screen...
timeout /t 2 /nobreak >NUL
ECHO.
cls
goto :MENU

:CLM							:: If user want to go back.
cls
goto :MENU 
cls 

:UNLOCK							:: This is where function 1 defined.
cls
echo These are 2 phones are currently supported.
echo 1 - LG V40 (judypn)
echo 2 - LG G7 (judyln)
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

:G7								:: If LG G7 is chosen (function 1)
cls
echo Now plug your device in EDL mode, and press Enter.
pause
powershell -Command "$temp=Get-WmiObject -Class Win32_PnPEntity | where { $_.Description -eq 'Qualcomm HS-USB QDLoader 9008' } | Select-Object Name | out-string;  $temp=[Regex]::Matches($temp, '(?<=\()(.*?)(?=\))') | Select -ExpandProperty Value; $temp.SubString(3, $temp.length-3)" > comport
set /p COM=<comport
del comport
C:\LGAT\files\QFIL\QFIL.exe -Mode=3 -COM=%COM% -RawProgram=C:\LGAT\files\v35abl\rawprogram4-G7.xml -Sahara=true -SEARCHPATH=C:\LGAT\files\v35abl -RESETAFTERDOWNLOAD=true -AckRawDataEveryNumPackets=TRUE;100 -FLATBUILDPATH=C:\LGAT\files\v35abl -PROGRAMMER=true;"C:\LGAT\files\Firehose\prog_ufs_firehose_Sdm845_lge.elf" -DEVICETYPE=ufs -DOWNLOADFLAT -RESETTIMEOUT=”10”
echo If you see the Red triangle then just ignore it, because you flashed the V35 engineering abl and the system just detected you modify the abl. No need to worry, just ignore it
echo If it stuck in the <waiting for devices>, then follow the step:
echo Step 1: Go to Device Manager, you should see Android with a yellow sign. If not, extend "Other devices", now you should see it
echo Step 2: Right click on it, select "Update Driver" or "Update Driver Software", then click "Browse my computer for drivers"
echo Step 3: Click on "Let me pick from a list of available on my computer"
echo Step 4: Click on "Show All Devices", then click "Have Disk", and click Browse. After that go to C:\LGAT\Fastboot Driver(manually install it)
echo Step 5: Double-click on "android_winusb.inf" then select OK. Select Android Bootloader Interface and click Next. A warning should appear, just ignore it and press OK. Now you got Fastboot driver installed.
C:\LGAT\files\platform-tools\fastboot flash frp C:\LGAT\files\v35abl\frp.img
C:\LGAT\files\platform-tools\fastboot reboot bootloader
timeout 3
echo Unlocking your Bootloader...
C:\LGAT\files\platform-tools\fastboot oem unlock
echo Rebooting to Bootloader one last time:
C:\LGAT\files\platform-tools\fastboot reboot bootloader
timeout 3
echo Checking your unlocked state:
C:\LGAT\files\platform-tools\fastboot getvar unlocked
timeout 10
echo Flashing necessary partition...
C:\LGAT\files\platform-tools\fastboot erase laf_a
C:\LGAT\files\platform-tools\fastboot erase abl_a
C:\LGAT\files\platform-tools\fastboot erase abl_b
C:\LGAT\files\platform-tools\fastboot erase laf_b
C:\LGAT\files\platform-tools\fastboot erase dtbo_a
C:\LGAT\files\platform-tools\fastboot erase dtbo_b
C:\LGAT\files\platform-tools\fastboot flash boot_a C:\LGAT\files\platform-tools\boot_g7.bin
C:\LGAT\files\platform-tools\fastboot flash boot_b C:\LGAT\files\platform-tools\boot_g7.bin
C:\LGAT\files\platform-tools\fastboot flash laf_a C:\LGAT\files\platform-tools\laf_g7.bin
C:\LGAT\files\platform-tools\fastboot flash laf_b C:\LGAT\files\platform-tools\laf_g7.bin
C:\LGAT\files\platform-tools\fastboot flash abl_a C:\LGAT\files\platform-tools\abl_g7.bin
C:\LGAT\files\platform-tools\fastboot flash abl_b C:\LGAT\files\platform-tools\abl_g7.bin
C:\LGAT\files\platform-tools\fastboot flash dtbo_a C:\LGAT\files\platform-tools\dtbo_g7.bin
C:\LGAT\files\platform-tools\fastboot flash dtbo_b C:\LGAT\files\platform-tools\dtbo_g7.bin
echo Device will REBOOT in 5 seconds!
echo NOW IMMIDIATELY HOLD YOUR VOLUME+ KEY TO GO TO THE DOWNLOAD MODE. IF YOU SEE THE RED CASE JUST IGNORE IT, THE PHONE WILL AUTOMATICALLY GO TO DOWNLOAD MODE.
timeout 5
C:\LGAT\files\platform-tools\fastboot reboot
echo If your phone connected in Download Mode, then press Enter.
pause
echo Starting LGUP_DEV 1.15.0.6...
echo Make sure to select correct KDZ of your model.
echo Crossflashing can cause lost VoLTE/VoWiFi function. Proceed at risk!
timeout 5
powershell -Command "$temp=Get-WmiObject -Class Win32_PnPEntity | where { $_.Description -eq 'LGE AndroidNet USB Serial Port' } | Select-Object Name | out-string;  $temp=[Regex]::Matches($temp, '(?<=\()(.*?)(?=\))') | Select -ExpandProperty Value; $temp.SubString(3, $temp.length-3)" > comport
set /p COMB=<comport
del comport
set /p var3="Drag and drop your KDZ in the tool (Example: D:\G710N30g.kdz):  "
echo Flashing operation will start in 10 seconds.
echo DO NOT DISCONNECT THE CABLE WHILE FLASHING DEVICE!
timeout 10
echo FLASHING OPERATION STARTED!
C:\LGAT\files\LGUP\LGUP_Cmd.exe com%COMB% "C:\LGAT\files\LGUP\LGUP_Common.dll" "%var3%" 
echo FLASHING OPERATION DONE!
echo Now wait for your phone to reboot. If you see the orange triangle with the text like "Your device can't be checked for corruption" then that is the sign of bootloader unlocked. Congrats!
timeout 20
echo. Press Enter to go back to the Main Menu.
pause
cls
goto :MENU

:V40								:: If LG V40 is chosen (function 1)
cls
echo Now plug your device in EDL mode, and press Enter.
pause
powershell -Command "$temp=Get-WmiObject -Class Win32_PnPEntity | where { $_.Description -eq 'Qualcomm HS-USB QDLoader 9008' } | Select-Object Name | out-string;  $temp=[Regex]::Matches($temp, '(?<=\()(.*?)(?=\))') | Select -ExpandProperty Value; $temp.SubString(3, $temp.length-3)" > comport
set /p COM=<comport
del comport
C:\LGAT\files\QFIL\QFIL.exe -Mode=3 -COM=%COM% -RawProgram=C:\LGAT\files\v35abl\rawprogram4-V40.xml -Sahara=true -SEARCHPATH=C:\LGAT\files\v35abl -RESETAFTERDOWNLOAD=true -AckRawDataEveryNumPackets=TRUE;100 -FLATBUILDPATH=C:\LGAT\files\v35abl -PROGRAMMER=true;"C:\LGAT\files\Firehose\prog_ufs_firehose_Sdm845_lge.elf" -DEVICETYPE=ufs -DOWNLOADFLAT -RESETTIMEOUT=”10”
echo If you see the Red triangle then just ignore it, because you flashed the V35 engineering abl and the system just detected you modify the abl. No need to worry, just ignore it
echo If it stuck in the <waiting for devices>, then follow the step:
echo Step 1: Go to Device Manager, you should see Android with a yellow sign. If not, extend "Other devices", now you should see it
echo Step 2: Right click on it, select "Update Driver" or "Update Driver Software", then click "Browse my computer for drivers"
echo Step 3: Click on "Let me pick from a list of available on my computer"
echo Step 4: Click on "Show All Devices", then click "Have Disk", and click Browse. After that go to C:\LGAT\Fastboot Driver(manually install it)
echo Step 5: Double-click on "android_winusb.inf" then select OK. Select Android Bootloader Interface and click Next. A warning should appear, just ignore it and press OK. Now you got Fastboot driver installed.
C:\LGAT\files\platform-tools\fastboot flash frp C:\LGAT\files\v35abl\frp.img
C:\LGAT\files\platform-tools\fastboot reboot bootloader
timeout 3
echo Unlocking your Bootloader...
C:\LGAT\files\platform-tools\fastboot oem unlock
echo Rebooting to Bootloader one last time:
C:\LGAT\files\platform-tools\fastboot reboot bootloader
timeout 3
echo Checking your unlocked state:
C:\LGAT\files\platform-tools\fastboot getvar unlocked
timeout 10
echo Flashing necessary partition...
C:\LGAT\files\platform-tools\fastboot erase laf_a
C:\LGAT\files\platform-tools\fastboot erase abl_a
C:\LGAT\files\platform-tools\fastboot erase abl_b
C:\LGAT\files\platform-tools\fastboot erase laf_b
C:\LGAT\files\platform-tools\fastboot erase dtbo_a
C:\LGAT\files\platform-tools\fastboot erase dtbo_b
C:\LGAT\files\platform-tools\fastboot flash boot_a C:\LGAT\files\platform-tools\boot_v40.bin
C:\LGAT\files\platform-tools\fastboot flash boot_b C:\LGAT\files\platform-tools\boot_v40.bin
C:\LGAT\files\platform-tools\fastboot flash laf_a C:\LGAT\files\platform-tools\laf_v40.bin
C:\LGAT\files\platform-tools\fastboot flash laf_b C:\LGAT\files\platform-tools\laf_v40.bin
C:\LGAT\files\platform-tools\fastboot flash abl_a C:\LGAT\files\platform-tools\abl_v40.bin
C:\LGAT\files\platform-tools\fastboot flash abl_b C:\LGAT\files\platform-tools\abl_v40.bin
C:\LGAT\files\platform-tools\fastboot flash dtbo_a C:\LGAT\files\platform-tools\dtbo_v40.bin
C:\LGAT\files\platform-tools\fastboot flash dtbo_b C:\LGAT\files\platform-tools\dtbo_v40.bin
echo Device will REBOOT in 5 seconds!
echo NOW IMMIDIATELY HOLD YOUR VOLUME+ KEY TO GO TO THE DOWNLOAD MODE. IF YOU SEE THE RED CASE JUST IGNORE IT, THE PHONE WILL AUTOMATICALLY GO TO DOWNLOAD MODE.
timeout 5
C:\LGAT\files\platform-tools\fastboot reboot
echo If your phone connected in Download Mode, then press Enter.
pause
echo Starting LGUP_DEV 1.15.0.6...
echo Make sure to select correct KDZ of your model.
echo Crossflashing can cause lost VoLTE/VoWiFi function. Proceed at risk!
timeout 5
powershell -Command "$temp=Get-WmiObject -Class Win32_PnPEntity | where { $_.Description -eq 'LGE AndroidNet USB Serial Port' } | Select-Object Name | out-string;  $temp=[Regex]::Matches($temp, '(?<=\()(.*?)(?=\))') | Select -ExpandProperty Value; $temp.SubString(3, $temp.length-3)" > comport
set /p COMB=<comport
del comport
set /p var3="Drag and drop your KDZ in the tool (Example: D:\G710N30g.kdz):  "
echo Flashing operation will start in 10 seconds.
echo DO NOT DISCONNECT THE CABLE WHILE FLASHING DEVICE!
timeout 10
echo FLASHING OPERATION STARTED!
C:\LGAT\files\LGUP\LGUP_Cmd.exe com%COMB% "C:\LGAT\files\LGUP\LGUP_Common.dll" "%var3%" 
echo FLASHING OPERATION DONE!
echo Now wait for your phone to reboot. If you see the orange triangle with the text like "Your device can't be checked for corruption" then that is the sign of bootloader unlocked. Congrats!
echo. Press Enter to go back to the Main Menu.
pause
cls
goto :MENU


:LOCK							:: This is where function 2 defined.
cls
echo These are 2 phones are currently supported.
echo 1 - LG V40 (judypn)
echo 2 - LG G7 (judyln)
echo 3 - Exit
set /p choice1=Choose an option: 
if not "%choice1%"=="" set choice=%choice:~0,1%
if /i "%choice1%"=="1" goto V40L
if /i "%choice1%"=="2" goto G7L
if /i "%choice1%"=="3" goto CLM
ECHO.
ECHO.
ECHO. Invalid option. Please check again. Going back to Lock menu...
timeout /t 2 /nobreak >NUL
ECHO.
cls
goto :LOCK

:G7L							:: If LG G7 is chosen (function 2)
cls
echo Now plug your device in EDL mode, and press Enter.
pause
powershell -Command "$temp=Get-WmiObject -Class Win32_PnPEntity | where { $_.Description -eq 'Qualcomm HS-USB QDLoader 9008' } | Select-Object Name | out-string;  $temp=[Regex]::Matches($temp, '(?<=\()(.*?)(?=\))') | Select -ExpandProperty Value; $temp.SubString(3, $temp.length-3)" > comport
set /p COM=<comport
del comport
C:\LGAT\file\QFIL\QFIL.exe -Mode=3 -COM=%COM% -RawProgram=C:\LGAT\files\v35abl\rawprogram4-G7.xml -Sahara=true -SEARCHPATH=C:\LGAT\files\v35abl -RESETAFTERDOWNLOAD=true -AckRawDataEveryNumPackets=TRUE;100 -FLATBUILDPATH=C:\LGAT\files\v35abl -PROGRAMMER=true;"C:\LGAT\files\Firehose\prog_ufs_firehose_Sdm845_lge.elf" -DEVICETYPE=ufs -DOWNLOADFLAT -RESETTIMEOUT=”10”
echo If you see the Red triangle then just ignore it, because you flashed the V35 engineering abl and the system just detected you modify the abl. No need to worry, just ignore it
echo If it stuck in the <waiting for devices>, then follow the step:
echo Step 1: Go to Device Manager, you should see Android with a yellow sign. If not, extend "Other devices", now you should see it
echo Step 2: Right click on it, select "Update Driver" or "Update Driver Software", then click "Browse my computer for drivers"
echo Step 3: Click on "Let me pick from a list of available on my computer"
echo Step 4: Click on "Show All Devices", then click "Have Disk", and click Browse. After that go to C:\LGAT\Fastboot Driver(manually install it)
echo Step 5: Double-click on "android_winusb.inf" then select OK. Select Android Bootloader Interface and click Next. A warning should appear, just ignore it and press OK. Now you got Fastboot driver installed.
C:\LGAT\files\platform-tools\fastboot flash frp C:\LGAT\v35abl\frp.img
C:\LGAT\files\platform-tools\fastboot reboot bootloader
timeout 3
echo Unlocking your Bootloader...
C:\LGAT\files\platform-tools\fastboot oem unlock
echo Rebooting to Bootloader one last time:
C:\LGAT\files\platform-tools\fastboot reboot bootloader
timeout 3
echo Checking your unlocked state:
C:\LGAT\files\platform-tools\fastboot getvar unlocked
timeout 10
echo Flashing necessary partition...
C:\LGAT\files\platform-tools\fastboot erase laf_a
C:\LGAT\files\platform-tools\fastboot erase abl_a
C:\LGAT\files\platform-tools\fastboot erase abl_b
C:\LGAT\files\platform-tools\fastboot erase laf_b
C:\LGAT\files\platform-tools\fastboot erase dtbo_a
C:\LGAT\files\platform-tools\fastboot erase dtbo_b
C:\LGAT\files\platform-tools\fastboot flash boot_a C:\LGAT\files\platform-tools\boot_g7.bin
C:\LGAT\files\platform-tools\fastboot flash boot_b C:\LGAT\files\platform-tools\boot_g7.bin
C:\LGAT\files\platform-tools\fastboot flash laf_a C:\LGAT\files\platform-tools\laf_g7.bin
C:\LGAT\files\platform-tools\fastboot flash laf_b C:\LGAT\files\platform-tools\laf_g7.bin
C:\LGAT\files\platform-tools\fastboot flash abl_a C:\LGAT\files\platform-tools\abl_g7.bin
C:\LGAT\files\platform-tools\fastboot flash abl_b C:\LGAT\files\platform-tools\abl_g7.bin
C:\LGAT\files\platform-tools\fastboot flash dtbo_a C:\LGAT\files\platform-tools\dtbo_g7.bin
C:\LGAT\files\platform-tools\fastboot flash dtbo_b C:\LGAT\files\platform-tools\dtbo_g7.bin
echo Device will REBOOT in 5 seconds!
echo NOW IMMIDIATELY HOLD YOUR VOLUME+ KEY TO GO TO THE DOWNLOAD MODE. IF YOU SEE THE RED CASE JUST IGNORE IT, THE PHONE WILL AUTOMATICALLY GO TO DOWNLOAD MODE.
timeout 5
C:\LGAT\files\platform-tools\fastboot reboot
echo If your phone connected in Download Mode, then press Enter.
pause
echo Starting LGUP_DEV 1.15.0.6...
echo Make sure to select correct KDZ of your model.
echo Crossflashing can cause lost VoLTE/VoWiFi function. Proceed at risk!
timeout 5
powershell -Command "$temp=Get-WmiObject -Class Win32_PnPEntity | where { $_.Description -eq 'LGE AndroidNet USB Serial Port' } | Select-Object Name | out-string;  $temp=[Regex]::Matches($temp, '(?<=\()(.*?)(?=\))') | Select -ExpandProperty Value; $temp.SubString(3, $temp.length-3)" > comport
set /p COMB=<comport
del comport
set /p var3="Drag and drop your KDZ in the tool (Example: D:\G710N30g.kdz):  "
echo Flashing operation will start in 10 seconds.
echo DO NOT DISCONNECT THE CABLE WHILE FLASHING DEVICE!
timeout 10
echo FLASHING OPERATION STARTED!
C:\LGAT\files\LGUP\LGUP_Cmd.exe com%COMB% "C:\LGAT\files\LGUP\LGUP_Common.dll" "%var3%" 
echo FLASHING OPERATION DONE!
timeout 20
echo. Press Enter to go back to the Main Menu.
pause
cls
goto :MENU

:V40L								:: If LG V40 is chosen (function 2)
cls
echo Now plug your device in EDL mode, and press Enter.
pause
powershell -Command "$temp=Get-WmiObject -Class Win32_PnPEntity | where { $_.Description -eq 'Qualcomm HS-USB QDLoader 9008' } | Select-Object Name | out-string;  $temp=[Regex]::Matches($temp, '(?<=\()(.*?)(?=\))') | Select -ExpandProperty Value; $temp.SubString(3, $temp.length-3)" > comport
set /p COM=<comport
del comport
C:\LGAT\files\QFIL\QFIL.exe -Mode=3 -COM=%COM% -RawProgram=C:\LGAT\files\v35abl\rawprogram4-V40.xml -Sahara=true -SEARCHPATH=C:\LGAT\files\v35abl -RESETAFTERDOWNLOAD=true -AckRawDataEveryNumPackets=TRUE;100 -FLATBUILDPATH=C:\LGAT\files\v35abl -PROGRAMMER=true;"C:\LGAT\files\Firehose\prog_ufs_firehose_Sdm845_lge.elf" -DEVICETYPE=ufs -DOWNLOADFLAT -RESETTIMEOUT=”10”
echo If you see the Red triangle then just ignore it, because you flashed the V35 engineering abl and the system just detected you modify the abl. No need to worry, just ignore it
echo If it stuck in the <waiting for devices>, then follow the step:
echo Step 1: Go to Device Manager, you should see Android with a yellow sign. If not, extend "Other devices", now you should see it
echo Step 2: Right click on it, select "Update Driver" or "Update Driver Software", then click "Browse my computer for drivers"
echo Step 3: Click on "Let me pick from a list of available on my computer"
echo Step 4: Click on "Show All Devices", then click "Have Disk", and click Browse. After that go to C:\LGAT\Fastboot Driver(manually install it)
echo Step 5: Double-click on "android_winusb.inf" then select OK. Select Android Bootloader Interface and click Next. A warning should appears, just ignore it and press OK. Now you got Fastboot driver installed.
C:\LGAT\files\platform-tools\fastboot flash frp C:\LGAT\files\v35abl\frp.img
C:\LGAT\files\platform-tools\fastboot reboot bootloader
timeout 3
echo Unlocking your Bootloader...
C:\LGAT\files\platform-tools\fastboot oem lock
echo Rebooting to Bootloader one last time:
C:\LGAT\files\platform-tools\fastboot reboot bootloader
timeout 3
echo Checking your unlocked state:
C:\LGAT\files\platform-tools\fastboot getvar unlocked
timeout 10
echo Flashing necessary partition...
C:\LGAT\files\platform-tools\fastboot erase laf_a
C:\LGAT\files\platform-tools\fastboot erase abl_a
C:\LGAT\files\platform-tools\fastboot erase abl_b
C:\LGAT\files\platform-tools\fastboot erase laf_b
C:\LGAT\files\platform-tools\fastboot erase dtbo_a
C:\LGAT\files\platform-tools\fastboot erase dtbo_b
C:\LGAT\files\platform-tools\fastboot flash boot_a C:\LGAT\files\platform-tools\boot_v40.bin
C:\LGAT\files\platform-tools\fastboot flash boot_b C:\LGAT\files\platform-tools\boot_v40.bin
C:\LGAT\files\platform-tools\fastboot flash laf_a C:\LGAT\files\platform-tools\laf_v40.bin
C:\LGAT\files\platform-tools\fastboot flash laf_b C:\LGAT\files\platform-tools\laf_v40.bin
C:\LGAT\files\platform-tools\fastboot flash abl_a C:\LGAT\files\platform-tools\abl_v40.bin
C:\LGAT\files\platform-tools\fastboot flash abl_b C:\LGAT\files\platform-tools\abl_v40.bin
C:\LGAT\files\platform-tools\fastboot flash dtbo_a C:\LGAT\files\platform-tools\dtbo_v40.bin
C:\LGAT\files\platform-tools\fastboot flash dtbo_b C:\LGAT\files\platform-tools\dtbo_v40.bin
echo Device will REBOOT in 5 seconds!
echo NOW IMMIDIATELY HOLD YOUR VOLUME+ KEY TO GO TO THE DOWNLOAD MODE. IF YOU SEE THE RED CASE JUST IGNORE IT, THE PHONE WILL AUTOMATICALLY GO TO DOWNLOAD MODE.
timeout 5
C:\LGAT\files\platform-tools\fastboot reboot
echo If your phone connected in Download Mode, then press Enter.
pause
echo Starting LGUP_DEV 1.15.0.6...
echo Make sure to select correct KDZ of your model.
echo Crossflashing can cause lost VoLTE/VoWiFi function. Proceed at risk!
timeout 5
powershell -Command "$temp=Get-WmiObject -Class Win32_PnPEntity | where { $_.Description -eq 'LGE AndroidNet USB Serial Port' } | Select-Object Name | out-string;  $temp=[Regex]::Matches($temp, '(?<=\()(.*?)(?=\))') | Select -ExpandProperty Value; $temp.SubString(3, $temp.length-3)" > comport
set /p COMB=<comport
del comport
set /p var3="Drag and drop your KDZ in the tool (Example: D:\G710N30g.kdz):  "
echo Flashing operation will start in 10 seconds.
echo DO NOT DISCONNECT THE CABLE WHILE FLASHING DEVICE!
timeout 10
echo FLASHING OPERATION STARTED!
C:\LGAT\files\LGUP\LGUP_Cmd.exe com%COMB% "C:\LGAT\files\LGUP\LGUP_Common.dll" "%var3%" 
echo FLASHING OPERATION DONE!
echo. Press Enter to go back to the Main Menu.
pause
cls
goto :MENU

:NLAF 						:: This is where function 3 defined.
cls
echo Nuke LAF
echo These are 2 phones are currently supported.
echo 1 - LG V40 (judypn)
echo 2 - LG G7 (judyln)
echo 3 - Exit
set /p choice1=Choose an option: 
if not "%choice1%"=="" set choice=%choice:~0,1%
if /i "%choice1%"=="1" goto V40NLAF
if /i "%choice1%"=="2" goto G7NLAF
if /i "%choice1%"=="3" goto CLM
ECHO.
ECHO.
ECHO. Invalid option. Please check again. Going back to Main NukeLAF Screen...
timeout /t 2 /nobreak >NUL
ECHO.
cls
goto :NLAF

:G7NLAF						:: If G7 is chosen (function 3)
cls
echo Now plug your device in EDL mode, and press Enter.
pause
powershell -Command "$temp=Get-WmiObject -Class Win32_PnPEntity | where { $_.Description -eq 'Qualcomm HS-USB QDLoader 9008' } | Select-Object Name | out-string;  $temp=[Regex]::Matches($temp, '(?<=\()(.*?)(?=\))') | Select -ExpandProperty Value; $temp.SubString(3, $temp.length-3)" > comport
set /p COM=<comport
del comport
C:\LGAT\files\QFIL\QFIL.exe -Mode=3 -COM=%COM% -RawProgram=C:\LGAT\files\NukeLAF\NukedLAF-G7.xml -Sahara=true -SEARCHPATH=C:\LGAT\files\v35abl -RESETAFTERDOWNLOAD=true -AckRawDataEveryNumPackets=TRUE;100 -FLATBUILDPATH=C:\LGAT\files\v35abl -PROGRAMMER=true;"C:\LGAT\files\Firehose\prog_ufs_firehose_Sdm845_lge.elf" -DEVICETYPE=ufs -DOWNLOADFLAT -RESETTIMEOUT=”10”
echo 
echo
echo Done. Rebooting...
echo. Press Enter to go back to the Main Menu.
pause
cls
goto :MENU

:V40NLAF					:: If V40 is chosen (function 3)
cls
echo Now plug your device in EDL mode, and press Enter.
pause
powershell -Command "$temp=Get-WmiObject -Class Win32_PnPEntity | where { $_.Description -eq 'Qualcomm HS-USB QDLoader 9008' } | Select-Object Name | out-string;  $temp=[Regex]::Matches($temp, '(?<=\()(.*?)(?=\))') | Select -ExpandProperty Value; $temp.SubString(3, $temp.length-3)" > comport
set /p COM=<comport
del comport
C:\LGAT\files\QFIL\QFIL.exe -Mode=3 -COM=%COM% -RawProgram=C:\LGAT\files\NukeLAF\NukedLAF-V40.xml -Sahara=true -SEARCHPATH=C:\LGAT\files\v35abl -RESETAFTERDOWNLOAD=true -AckRawDataEveryNumPackets=TRUE;100 -FLATBUILDPATH=C:\LGAT\files\v35abl -PROGRAMMER=true;"C:\LGAT\files\Firehose\prog_ufs_firehose_Sdm845_lge.elf" -DEVICETYPE=ufs -DOWNLOADFLAT -RESETTIMEOUT=”10”
echo 
echo
echo Done. Rebooting...
echo. Press Enter to go back to the Main Menu.
pause
cls
goto :MENU

:RLAF							:: This is where function 4 defined.
cls
echo Recover LAF
echo These are 2 phones are currently supported.
echo 1 - LG V40 (judypn)
echo 2 - LG G7 (judyln)
echo 3 - Exit
set /p choice1=Choose an option: 
if not "%choice1%"=="" set choice=%choice:~0,1%
if /i "%choice1%"=="1" goto V40RLAF
if /i "%choice1%"=="2" goto G7RLAF
if /i "%choice1%"=="3" goto CLM
ECHO.
ECHO.
ECHO. Invalid option. Please check again. Going back to Main Recover LAF Screen...
timeout /t 2 /nobreak >NUL
ECHO.
cls
goto :RLAF

:G7RLAF							:: If G7 is chosen (function 4)
cls
echo Now plug your device in EDL mode, and press Enter.
pause
powershell -Command "$temp=Get-WmiObject -Class Win32_PnPEntity | where { $_.Description -eq 'Qualcomm HS-USB QDLoader 9008' } | Select-Object Name | out-string;  $temp=[Regex]::Matches($temp, '(?<=\()(.*?)(?=\))') | Select -ExpandProperty Value; $temp.SubString(3, $temp.length-3)" > comport
set /p COM=<comport
del comport
C:\LGAT\file\QFIL\QFIL.exe -Mode=3 -COM=%COM% -RawProgram=C:\LGAT\files\v35abl\rawprogram4-G7.xml -Sahara=true -SEARCHPATH=C:\LGAT\files\v35abl -RESETAFTERDOWNLOAD=true -AckRawDataEveryNumPackets=TRUE;100 -FLATBUILDPATH=C:\LGAT\files\v35abl -PROGRAMMER=true;"C:\LGAT\files\Firehose\prog_ufs_firehose_Sdm845_lge.elf" -DEVICETYPE=ufs -DOWNLOADFLAT -RESETTIMEOUT=”10”
echo If you see the Red triangle then just ignore it, because you flashed the V35 engineering abl and the system just detected you modify the abl. No need to worry, just ignore it
echo If it stuck in the <waiting for devices>, then follow the step:
echo Step 1: Go to Device Manager, you should see Android with a yellow sign. If not, extend "Other devices", now you should see it
echo Step 2: Right click on it, select "Update Driver" or "Update Driver Software", then click "Browse my computer for drivers"
echo Step 3: Click on "Let me pick from a list of available on my computer"
echo Step 4: Click on "Show All Devices", then click "Have Disk", and click Browse. After that go to C:\LGAT\Fastboot Driver(manually install it)
echo Step 5: Double-click on "android_winusb.inf" then select OK. Select Android Bootloader Interface and click Next. A warning should appear, just ignore it and press OK. Now you got Fastboot driver installed.
C:\LGAT\files\platform-tools\fastboot flash frp C:\LGAT\files\v35abl\frp.img
C:\LGAT\files\platform-tools\fastboot reboot bootloader
timeout 3
echo Rebooting to Bootloader one last time:
C:\LGAT\files\platform-tools\fastboot reboot bootloader
timeout 3
timeout 10
echo Flashing necessary partition...
C:\LGAT\files\platform-tools\fastboot erase laf_a
C:\LGAT\files\platform-tools\fastboot erase abl_a
C:\LGAT\files\platform-tools\fastboot erase abl_b
C:\LGAT\files\platform-tools\fastboot erase laf_b
C:\LGAT\files\platform-tools\fastboot erase dtbo_a
C:\LGAT\files\platform-tools\fastboot erase dtbo_b
C:\LGAT\files\platform-tools\fastboot flash boot_a C:\LGAT\files\platform-tools\boot_g7.bin
C:\LGAT\files\platform-tools\fastboot flash boot_b C:\LGAT\files\platform-tools\boot_g7.bin
C:\LGAT\files\platform-tools\fastboot flash laf_a C:\LGAT\files\platform-tools\laf_g7.bin
C:\LGAT\files\platform-tools\fastboot flash laf_b C:\LGAT\files\platform-tools\laf_g7.bin
C:\LGAT\files\platform-tools\fastboot flash abl_a C:\LGAT\files\platform-tools\abl_g7.bin
C:\LGAT\files\platform-tools\fastboot flash abl_b C:\LGAT\files\platform-tools\abl_g7.bin
C:\LGAT\files\platform-tools\fastboot flash dtbo_a C:\LGAT\files\platform-tools\dtbo_g7.bin
C:\LGAT\files\platform-tools\fastboot flash dtbo_b C:\LGAT\files\platform-tools\dtbo_g7.bin
echo Device will REBOOT in 5 seconds!
echo NOW IMMIDIATELY HOLD YOUR VOLUME+ KEY TO GO TO THE DOWNLOAD MODE. IF YOU SEE THE RED CASE JUST IGNORE IT, THE PHONE WILL AUTOMATICALLY GO TO DOWNLOAD MODE.
timeout 5
C:\LGAT\files\platform-tools\fastboot reboot
echo If your phone connected in Download Mode, then press Enter.
pause
echo Starting LGUP_DEV 1.15.0.6...
echo Make sure to select correct KDZ of your model.
echo Crossflashing can cause lost VoLTE/VoWiFi function. Proceed at risk!
timeout 5
powershell -Command "$temp=Get-WmiObject -Class Win32_PnPEntity | where { $_.Description -eq 'LGE AndroidNet USB Serial Port' } | Select-Object Name | out-string;  $temp=[Regex]::Matches($temp, '(?<=\()(.*?)(?=\))') | Select -ExpandProperty Value; $temp.SubString(3, $temp.length-3)" > comport
set /p COMB=<comport
del comport
set /p var3="Drag and drop your KDZ in the tool (Example: D:\G710N30g.kdz):  "
echo Flashing operation will start in 10 seconds.
echo DO NOT DISCONNECT THE CABLE WHILE FLASHING DEVICE!
timeout 10
echo FLASHING OPERATION STARTED!
C:\LGAT\files\LGUP\LGUP_Cmd.exe com%COMB% "C:\LGAT\files\LGUP\LGUP_Common.dll" "%var3%" 
echo FLASHING OPERATION DONE!
timeout 20
echo. Press Enter to go back to the Main Menu.
pause
cls
goto :MENU


:V40 							:: If V40 is chosen (function 4)
cls
echo Now plug your device in EDL mode, and press Enter.
pause
powershell -Command "$temp=Get-WmiObject -Class Win32_PnPEntity | where { $_.Description -eq 'Qualcomm HS-USB QDLoader 9008' } | Select-Object Name | out-string;  $temp=[Regex]::Matches($temp, '(?<=\()(.*?)(?=\))') | Select -ExpandProperty Value; $temp.SubString(3, $temp.length-3)" > comport
set /p COM=<comport
del comport
C:\LGAT\file\QFIL\QFIL.exe -Mode=3 -COM=%COM% -RawProgram=C:\LGAT\files\v35abl\rawprogram4-V40.xml -Sahara=true -SEARCHPATH=C:\LGAT\files\v35abl -RESETAFTERDOWNLOAD=true -AckRawDataEveryNumPackets=TRUE;100 -FLATBUILDPATH=C:\LGAT\files\v35abl -PROGRAMMER=true;"C:\LGAT\files\Firehose\prog_ufs_firehose_Sdm845_lge.elf" -DEVICETYPE=ufs -DOWNLOADFLAT -RESETTIMEOUT=”10”
echo If you see the Red triangle then just ignore it, because you flashed the V35 engineering abl and the system just detected you modify the abl. No need to worry, just ignore it
echo If it stuck in the <waiting for devices>, then follow the step:
echo Step 1: Go to Device Manager, you should see Android with a yellow sign. If not, extend "Other devices", now you should see it
echo Step 2: Right click on it, select "Update Driver" or "Update Driver Software", then click "Browse my computer for drivers"
echo Step 3: Click on "Let me pick from a list of available on my computer"
echo Step 4: Click on "Show All Devices", then click "Have Disk", and click Browse. After that go to C:\LGAT\Fastboot Driver(manually install it)
echo Step 5: Double-click on "android_winusb.inf" then select OK. Select Android Bootloader Interface and click Next. A warning should appear, just ignore it and press OK. Now you got Fastboot driver installed.
C:\LGAT\files\platform-tools\fastboot flash frp C:\LGAT\files\v35abl\frp.img
C:\LGAT\files\platform-tools\fastboot reboot bootloader
timeout 3
echo Rebooting to Bootloader one last time:
C:\LGAT\files\platform-tools\fastboot reboot bootloader
timeout 3
timeout 10
echo Flashing necessary partition...
C:\LGAT\files\platform-tools\fastboot erase laf_a
C:\LGAT\files\platform-tools\fastboot erase abl_a
C:\LGAT\files\platform-tools\fastboot erase abl_b
C:\LGAT\files\platform-tools\fastboot erase laf_b
C:\LGAT\files\platform-tools\fastboot erase dtbo_a
C:\LGAT\files\platform-tools\fastboot erase dtbo_b
C:\LGAT\files\platform-tools\fastboot flash boot_a C:\LGAT\files\platform-tools\boot_v40.bin
C:\LGAT\files\platform-tools\fastboot flash boot_b C:\LGAT\files\platform-tools\boot_v40.bin
C:\LGAT\files\platform-tools\fastboot flash laf_a C:\LGAT\files\platform-tools\laf_v40.bin
C:\LGAT\files\platform-tools\fastboot flash laf_b C:\LGAT\files\platform-tools\laf_v40.bin
C:\LGAT\files\platform-tools\fastboot flash abl_a C:\LGAT\files\platform-tools\abl_v40.bin
C:\LGAT\files\platform-tools\fastboot flash abl_b C:\LGAT\files\platform-tools\abl_v40.bin
C:\LGAT\files\platform-tools\fastboot flash dtbo_a C:\LGAT\files\platform-tools\dtbo_v40.bin
C:\LGAT\files\platform-tools\fastboot flash dtbo_b C:\LGAT\files\platform-tools\dtbo_v40.bin
echo Device will REBOOT in 5 seconds!
echo NOW IMMIDIATELY HOLD YOUR VOLUME+ KEY TO GO TO THE DOWNLOAD MODE. IF YOU SEE THE RED CASE JUST IGNORE IT, THE PHONE WILL AUTOMATICALLY GO TO DOWNLOAD MODE.
timeout 5
C:\LGAT\files\platform-tools\fastboot reboot
echo If your phone connected in Download Mode, then press Enter.
pause
echo Starting LGUP_DEV 1.15.0.6...
echo Make sure to select correct KDZ of your model.
echo Crossflashing can cause lost VoLTE/VoWiFi function. Proceed at risk!
timeout 5
powershell -Command "$temp=Get-WmiObject -Class Win32_PnPEntity | where { $_.Description -eq 'LGE AndroidNet USB Serial Port' } | Select-Object Name | out-string;  $temp=[Regex]::Matches($temp, '(?<=\()(.*?)(?=\))') | Select -ExpandProperty Value; $temp.SubString(3, $temp.length-3)" > comport
set /p COMB=<comport
del comport
set /p var3="Drag and drop your KDZ in the tool (Example: D:\G710N30g.kdz):  "
echo Flashing operation will start in 10 seconds.
echo DO NOT DISCONNECT THE CABLE WHILE FLASHING DEVICE!
timeout 10
echo FLASHING OPERATION STARTED!
C:\LGAT\files\LGUP\LGUP_Cmd.exe com%COMB% "C:\LGAT\files\LGUP\LGUP_Common.dll" "%var3%" 
echo FLASHING OPERATION DONE!
timeout 20
echo. Press Enter to go back to the Main Menu.
pause
cls
goto :MENU

:REC 						:: This is where function 5 is defined.
cls
echo Now plug your device in Fastboot mode, and press Enter.
pause
set /p recovery="Drag and drop your recovery file in the tool (Example: D:\recovery.img):  "
C:\LGAT\files\platform-tools\fastboot boot %recovery%
echo Your recovery is booting... 
echo. Press Enter to go back to the Main Menu.
pause
cls
goto :MENU

:GSI						:: This is where function 6 is defined.
cls
echo Make sure your vbmeta is disabled!
set /p var4="Now, type your GSI image path: (Eg: D:\gsi.img)"
C:\LGAT\files\fastboot erase system_a
C:\LGAT\files\fastboot erase system_b
C:\LGAT\files\fastboot flash system_a %var4%
C:\LGAT\files\fastboot -w
echo Flashing operation completed. Now you need to boot recovery image and flash Disable DM-Verity in order to boot GSI.
set /p recovery="Drag and drop your recovery file in the tool (Example: D:\recovery.img):  "
C:\LGAT\files\platform-tools\fastboot boot %recovery%
echo Get Disable DM-Verity zip here: https://drive.google.com/file/d/1JVql4BwfNCaXiN-2hKzvuGURxK3q6eFq/view?usp=sharing
echo Use left mouse button and then drag from the start of the link till the end of the link
echo After that press Right Mouse Button to copy. Then press Ctrl + V to paste the link and go to the download site
echo Press any key to close.
pause
goto :MENU

:KDZ 							:: This is where function 7 is defined.
cls
echo Starting LGUP_DEV 1.15.0.6...
echo Make sure to select correct KDZ of your model.
echo Crossflashing can cause lost VoLTE/VoWiFi function, or even lost Wi-Fi connection. Proceed at risk!
timeout 5
powershell -Command "$temp=Get-WmiObject -Class Win32_PnPEntity | where { $_.Description -eq 'LGE AndroidNet USB Serial Port' } | Select-Object Name | out-string;  $temp=[Regex]::Matches($temp, '(?<=\()(.*?)(?=\))') | Select -ExpandProperty Value; $temp.SubString(3, $temp.length-3)" > comport
set /p COMB=<comport
del comport
set /p var3="Drag and drop your KDZ in the tool (Example: D:\G710N30g.kdz):  "
echo Flashing operation will start in 10 seconds.
echo DO NOT DISCONNECT THE CABLE WHILE FLASHING DEVICE!
timeout 10
echo FLASHING OPERATION STARTED!
C:\LGAT\files\LGUP\LGUP_Cmd.exe com%COMB% "C:\LGAT\files\LGUP\LGUP_Common.dll" "%var3%" 
echo FLASHING OPERATION DONE!
timeout 20
echo. Press Enter to go back to the Main Menu.
pause
goto :MENU

:QFILFLASH						:: This is where function 8 defined.
cls
echo Working in progress. Please come back later!
timeout 30
goto :MENU
:UNKDZ						:: This is where function 9 defined.
cls
set /p KDZ="Drag and drop your KDZ here (Example: D:\G710N30g.kdz): "
echo  [91mMAKE SURE TO HAVE MORE THAN >20GB OR MORE IN YOUR CURRENT DRIVE! [0m
@echo off&Title KDZTools 20200305
echo [Script INFO] This KDZTools is compiled by @gress on Mar. 5, 2020
echo=
echo=
echo [Script INFO] Released at:
echo [Script INFO] https://bbs.lge.fun/thread-69.htm
echo=
echo=
echo [Script INFO] All KDZ files under this folder are going to be processed. Continue? YES[Y] or NO[N].

choice /c:YN /n
if %errorlevel%==2 goto no
if %errorlevel%==1 goto yes

:no
exit

:yes
for /f %KDZ% in ('dir /b *.kdz') do (
echo= 
echo= 
echo [Script INFO] Processing KDZ file: %KDZ%
echo= 
echo= 
C:\LGAT\files\kdztools\unkdz -f %KDZ% -x -d .

del /f /s /q .\*.params
del /f /s /q .\*.bin
del /f /s /q .\*UP*.*
echo= 
echo= 
echo [Script INFO] Processed KDZ file: %KDZ%
)
echo= 
echo= 
echo [Script INFO] All KDZ files are processed, PLEASE CHECK!

for /f %%i in ('dir /b *.dz') do (
echo=
echo=
echo [Script INFO] Processing DZ file: %%i Using model: S
echo=
echo=
C:\LGAT\files\kdztools\undz -f %%i -s -d .\%%~ni_img

del /f /s /q .\%%~ni_img\*.params
del /f /s /q .\%%~ni_img\userdata.image

ren .\%%~ni_img\*.image *.img
echo=
echo=
echo [Script INFO] Processed DZ file: %%i
)
echo=
echo=
echo [Script INFO] All DZ files are processed, PLEASE CHECK!
echo=
echo=
echo [Script INFO] Finished!. Press any key to go to Main Menu.
echo Extracted KDZ can be found in C:\LGAT\files\kdztools
echo [91m Thanks for @gress for this unpack KDZ script! [0m
pause 
goto :MENU

:FBD							:: This is where function 13 defined.
cls
echo [91m How to install fastboot driver: [0m
echo Step 1: Go to Device Manager, you should see Android with a yellow sign. If not, extend "Other devices", now you should see it
echo Step 2: Right click on it, select "Update Driver" or "Update Driver Software", then click "Browse my computer for drivers"
echo Step 3: Click on "Let me pick from a list of available on my computer"
echo Step 4: Click on "Show All Devices", then click "Have Disk", and click Browse. After that go to C:\LGAT\Fastboot Driver(manually install it)
echo
echo
echo
echo Press any key to go back to Main Menu.
goto :MENU

:CL							:: This is where function 15 defined.
cls
echo Changelog:
echo - Moved whole project from Unlock845 to LG Advanced Tool. Unlock845 is still on my GitHub repos so you dont need to worry about that. Just no more updates.
echo - Initial release.
echo
echo
echo Press any key to go to the main menu.
goto :MENU
:EXIT 							:: This is where function 16 defined.
exit