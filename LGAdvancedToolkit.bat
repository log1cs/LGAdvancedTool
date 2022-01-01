@shift /0
@ECHO OFF
title LG Advanced Toolkit (release_1)
set currentpath=%~dp0
:MENU
echo  [91m================================================================================[0m
echo  [91m LG Advanced Toolkit (judyln/judypn). Created by Log1cs (github.com/log1cs)[0m
echo  [91m================================================================================[0m
echo  [91mWindows 7 version under development. Stay tuned(tm)[0m
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
%currentpath%files\QFIL\QFIL.exe -Mode=3 -COM=%COM% -RawProgram=%currentpath%files\v35abl\rawprogram4-G7.xml -Sahara=true -SEARCHPATH=%currentpath%v35abl -RESETAFTERDOWNLOAD=true -AckRawDataEveryNumPackets=TRUE;100 -FLATBUILDPATH=%currentpath%v35abl -PROGRAMMER=true;"%currentpath%files\Firehose\prog_ufs_firehose_Sdm845_lge.elf" -DEVICETYPE=ufs -DOWNLOADFLAT -RESETTIMEOUT=”10”
echo If you see the Red triangle then just ignore it, because you flashed the V35 engineering abl and the system just detected you modify the abl. No need to worry, just ignore it
echo If it stuck in the <waiting for devices>, then follow the step:
echo Step 1: Go to Device Manager, you should see Android with a yellow sign. If not, extend "Other devices", now you should see it
echo Step 2: Right click on it, select "Update Driver" or "Update Driver Software", then click "Browse my computer for drivers"
echo Step 3: Click on "Let me pick from a list of available on my computer"
echo Step 4: Click on "Show All Devices", then click "Have Disk", and click Browse. After that go to %currentpath%Fastboot Driver(manually install it)
echo Step 5: Double-click on "android_winusb.inf" then select OK. Select Android Bootloader Interface and click Next. A warning should appear, just ignore it and press OK. Now you got Fastboot driver installed.
%currentpath%files\platform-tools\fastboot flash frp %currentpath%files\v35abl\frp.img
%currentpath%files\platform-tools\fastboot reboot bootloader
timeout 3
echo Unlocking your Bootloader...
%currentpath%files\platform-tools\fastboot oem unlock
echo Rebooting to Bootloader one last time:
%currentpath%files\platform-tools\fastboot reboot bootloader
timeout 3
echo Checking your unlocked state:
%currentpath%files\platform-tools\fastboot getvar unlocked
timeout 10
echo Flashing necessary partition...
%currentpath%files\platform-tools\fastboot erase laf_a
%currentpath%files\platform-tools\fastboot erase abl_a
%currentpath%files\platform-tools\fastboot erase abl_b
%currentpath%files\platform-tools\fastboot erase laf_b
%currentpath%files\platform-tools\fastboot erase dtbo_a
%currentpath%files\platform-tools\fastboot erase dtbo_b
%currentpath%files\platform-tools\fastboot flash boot_a %currentpath%files\platform-tools\boot_g7.bin
%currentpath%files\platform-tools\fastboot flash boot_b %currentpath%files\platform-tools\boot_g7.bin
%currentpath%files\platform-tools\fastboot flash laf_a %currentpath%files\platform-tools\laf_g7.bin
%currentpath%files\platform-tools\fastboot flash laf_b %currentpath%files\platform-tools\laf_g7.bin
%currentpath%files\platform-tools\fastboot flash abl_a %currentpath%files\platform-tools\abl_g7.bin
%currentpath%files\platform-tools\fastboot flash abl_b %currentpath%files\platform-tools\abl_g7.bin
%currentpath%files\platform-tools\fastboot flash dtbo_a %currentpath%files\platform-tools\dtbo_g7.bin
%currentpath%files\platform-tools\fastboot flash dtbo_b %currentpath%files\platform-tools\dtbo_g7.bin
echo Device will REBOOT in 5 seconds!
echo NOW IMMIDIATELY HOLD YOUR VOLUME+ KEY TO GO TO THE DOWNLOAD MODE. IF YOU SEE THE RED CASE JUST IGNORE IT, THE PHONE WILL AUTOMATICALLY GO TO DOWNLOAD MODE.
timeout 5
%currentpath%files\platform-tools\fastboot reboot
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
%currentpath%files\LGUP\LGUP_Cmd.exe com%COMB% "%currentpath%files\LGUP\LGUP_Common.dll" "%var3%" 
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
%currentpath%files\QFIL\QFIL.exe -Mode=3 -COM=%COM% -RawProgram=%currentpath%files\v35abl\rawprogram4-V40.xml -Sahara=true -SEARCHPATH=%currentpath%v35abl -RESETAFTERDOWNLOAD=true -AckRawDataEveryNumPackets=TRUE;100 -FLATBUILDPATH=%currentpath%v35abl -PROGRAMMER=true;"%currentpath%files\Firehose\prog_ufs_firehose_Sdm845_lge.elf" -DEVICETYPE=ufs -DOWNLOADFLAT -RESETTIMEOUT=”10”
echo If you see the Red triangle then just ignore it, because you flashed the V35 engineering abl and the system just detected you modify the abl. No need to worry, just ignore it
echo If it stuck in the <waiting for devices>, then follow the step:
echo Step 1: Go to Device Manager, you should see Android with a yellow sign. If not, extend "Other devices", now you should see it
echo Step 2: Right click on it, select "Update Driver" or "Update Driver Software", then click "Browse my computer for drivers"
echo Step 3: Click on "Let me pick from a list of available on my computer"
echo Step 4: Click on "Show All Devices", then click "Have Disk", and click Browse. After that go to %currentpath%Fastboot Driver(manually install it)
echo Step 5: Double-click on "android_winusb.inf" then select OK. Select Android Bootloader Interface and click Next. A warning should appear, just ignore it and press OK. Now you got Fastboot driver installed.
%currentpath%files\platform-tools\fastboot flash frp %currentpath%files\v35abl\frp.img
%currentpath%files\platform-tools\fastboot reboot bootloader
timeout 3
echo Unlocking your Bootloader...
%currentpath%files\platform-tools\fastboot oem unlock
echo Rebooting to Bootloader one last time:
%currentpath%files\platform-tools\fastboot reboot bootloader
timeout 3
echo Checking your unlocked state:
%currentpath%files\platform-tools\fastboot getvar unlocked
timeout 10
echo Flashing necessary partition...
%currentpath%files\platform-tools\fastboot erase laf_a
%currentpath%files\platform-tools\fastboot erase abl_a
%currentpath%files\platform-tools\fastboot erase abl_b
%currentpath%files\platform-tools\fastboot erase laf_b
%currentpath%files\platform-tools\fastboot erase dtbo_a
%currentpath%files\platform-tools\fastboot erase dtbo_b
%currentpath%files\platform-tools\fastboot flash boot_a %currentpath%files\platform-tools\boot_v40.bin
%currentpath%files\platform-tools\fastboot flash boot_b %currentpath%files\platform-tools\boot_v40.bin
%currentpath%files\platform-tools\fastboot flash laf_a %currentpath%files\platform-tools\laf_v40.bin
%currentpath%files\platform-tools\fastboot flash laf_b %currentpath%files\platform-tools\laf_v40.bin
%currentpath%files\platform-tools\fastboot flash abl_a %currentpath%files\platform-tools\abl_v40.bin
%currentpath%files\platform-tools\fastboot flash abl_b %currentpath%files\platform-tools\abl_v40.bin
%currentpath%files\platform-tools\fastboot flash dtbo_a %currentpath%files\platform-tools\dtbo_v40.bin
%currentpath%files\platform-tools\fastboot flash dtbo_b %currentpath%files\platform-tools\dtbo_v40.bin
echo Device will REBOOT in 5 seconds!
echo NOW IMMIDIATELY HOLD YOUR VOLUME+ KEY TO GO TO THE DOWNLOAD MODE. IF YOU SEE THE RED CASE JUST IGNORE IT, THE PHONE WILL AUTOMATICALLY GO TO DOWNLOAD MODE.
timeout 5
%currentpath%files\platform-tools\fastboot reboot
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
%currentpath%files\LGUP\LGUP_Cmd.exe com%COMB% "%currentpath%files\LGUP\LGUP_Common.dll" "%var3%" 
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
%currentpath%file\QFIL\QFIL.exe -Mode=3 -COM=%COM% -RawProgram=%currentpath%files\v35abl\rawprogram4-G7.xml -Sahara=true -SEARCHPATH=%currentpath%v35abl -RESETAFTERDOWNLOAD=true -AckRawDataEveryNumPackets=TRUE;100 -FLATBUILDPATH=%currentpath%v35abl -PROGRAMMER=true;"%currentpath%files\Firehose\prog_ufs_firehose_Sdm845_lge.elf" -DEVICETYPE=ufs -DOWNLOADFLAT -RESETTIMEOUT=”10”
echo If you see the Red triangle then just ignore it, because you flashed the V35 engineering abl and the system just detected you modify the abl. No need to worry, just ignore it
echo If it stuck in the <waiting for devices>, then follow the step:
echo Step 1: Go to Device Manager, you should see Android with a yellow sign. If not, extend "Other devices", now you should see it
echo Step 2: Right click on it, select "Update Driver" or "Update Driver Software", then click "Browse my computer for drivers"
echo Step 3: Click on "Let me pick from a list of available on my computer"
echo Step 4: Click on "Show All Devices", then click "Have Disk", and click Browse. After that go to %currentpath%Fastboot Driver(manually install it)
echo Step 5: Double-click on "android_winusb.inf" then select OK. Select Android Bootloader Interface and click Next. A warning should appear, just ignore it and press OK. Now you got Fastboot driver installed.
%currentpath%files\platform-tools\fastboot flash frp %currentpath%v35abl\frp.img
%currentpath%files\platform-tools\fastboot reboot bootloader
timeout 3
echo Unlocking your Bootloader...
%currentpath%files\platform-tools\fastboot oem unlock
echo Rebooting to Bootloader one last time:
%currentpath%files\platform-tools\fastboot reboot bootloader
timeout 3
echo Checking your unlocked state:
%currentpath%files\platform-tools\fastboot getvar unlocked
timeout 10
echo Flashing necessary partition...
%currentpath%files\platform-tools\fastboot erase laf_a
%currentpath%files\platform-tools\fastboot erase abl_a
%currentpath%files\platform-tools\fastboot erase abl_b
%currentpath%files\platform-tools\fastboot erase laf_b
%currentpath%files\platform-tools\fastboot erase dtbo_a
%currentpath%files\platform-tools\fastboot erase dtbo_b
%currentpath%files\platform-tools\fastboot flash boot_a %currentpath%files\platform-tools\boot_g7.bin
%currentpath%files\platform-tools\fastboot flash boot_b %currentpath%files\platform-tools\boot_g7.bin
%currentpath%files\platform-tools\fastboot flash laf_a %currentpath%files\platform-tools\laf_g7.bin
%currentpath%files\platform-tools\fastboot flash laf_b %currentpath%files\platform-tools\laf_g7.bin
%currentpath%files\platform-tools\fastboot flash abl_a %currentpath%files\platform-tools\abl_g7.bin
%currentpath%files\platform-tools\fastboot flash abl_b %currentpath%files\platform-tools\abl_g7.bin
%currentpath%files\platform-tools\fastboot flash dtbo_a %currentpath%files\platform-tools\dtbo_g7.bin
%currentpath%files\platform-tools\fastboot flash dtbo_b %currentpath%files\platform-tools\dtbo_g7.bin
echo Device will REBOOT in 5 seconds!
echo NOW IMMIDIATELY HOLD YOUR VOLUME+ KEY TO GO TO THE DOWNLOAD MODE. IF YOU SEE THE RED CASE JUST IGNORE IT, THE PHONE WILL AUTOMATICALLY GO TO DOWNLOAD MODE.
timeout 5
%currentpath%files\platform-tools\fastboot reboot
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
%currentpath%files\LGUP\LGUP_Cmd.exe com%COMB% "%currentpath%files\LGUP\LGUP_Common.dll" "%var3%" 
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
%currentpath%files\QFIL\QFIL.exe -Mode=3 -COM=%COM% -RawProgram=%currentpath%files\v35abl\rawprogram4-V40.xml -Sahara=true -SEARCHPATH=%currentpath%v35abl -RESETAFTERDOWNLOAD=true -AckRawDataEveryNumPackets=TRUE;100 -FLATBUILDPATH=%currentpath%v35abl -PROGRAMMER=true;"%currentpath%files\Firehose\prog_ufs_firehose_Sdm845_lge.elf" -DEVICETYPE=ufs -DOWNLOADFLAT -RESETTIMEOUT=”10”
echo If you see the Red triangle then just ignore it, because you flashed the V35 engineering abl and the system just detected you modify the abl. No need to worry, just ignore it
echo If it stuck in the <waiting for devices>, then follow the step:
echo Step 1: Go to Device Manager, you should see Android with a yellow sign. If not, extend "Other devices", now you should see it
echo Step 2: Right click on it, select "Update Driver" or "Update Driver Software", then click "Browse my computer for drivers"
echo Step 3: Click on "Let me pick from a list of available on my computer"
echo Step 4: Click on "Show All Devices", then click "Have Disk", and click Browse. After that go to %currentpath%Fastboot Driver(manually install it)
echo Step 5: Double-click on "android_winusb.inf" then select OK. Select Android Bootloader Interface and click Next. A warning should appears, just ignore it and press OK. Now you got Fastboot driver installed.
%currentpath%files\platform-tools\fastboot flash frp %currentpath%files\v35abl\frp.img
%currentpath%files\platform-tools\fastboot reboot bootloader
timeout 3
echo Unlocking your Bootloader...
%currentpath%files\platform-tools\fastboot oem lock
echo Rebooting to Bootloader one last time:
%currentpath%files\platform-tools\fastboot reboot bootloader
timeout 3
echo Checking your unlocked state:
%currentpath%files\platform-tools\fastboot getvar unlocked
timeout 10
echo Flashing necessary partition...
%currentpath%files\platform-tools\fastboot erase laf_a
%currentpath%files\platform-tools\fastboot erase abl_a
%currentpath%files\platform-tools\fastboot erase abl_b
%currentpath%files\platform-tools\fastboot erase laf_b
%currentpath%files\platform-tools\fastboot erase dtbo_a
%currentpath%files\platform-tools\fastboot erase dtbo_b
%currentpath%files\platform-tools\fastboot flash boot_a %currentpath%files\platform-tools\boot_v40.bin
%currentpath%files\platform-tools\fastboot flash boot_b %currentpath%files\platform-tools\boot_v40.bin
%currentpath%files\platform-tools\fastboot flash laf_a %currentpath%files\platform-tools\laf_v40.bin
%currentpath%files\platform-tools\fastboot flash laf_b %currentpath%files\platform-tools\laf_v40.bin
%currentpath%files\platform-tools\fastboot flash abl_a %currentpath%files\platform-tools\abl_v40.bin
%currentpath%files\platform-tools\fastboot flash abl_b %currentpath%files\platform-tools\abl_v40.bin
%currentpath%files\platform-tools\fastboot flash dtbo_a %currentpath%files\platform-tools\dtbo_v40.bin
%currentpath%files\platform-tools\fastboot flash dtbo_b %currentpath%files\platform-tools\dtbo_v40.bin
echo Device will REBOOT in 5 seconds!
echo NOW IMMIDIATELY HOLD YOUR VOLUME+ KEY TO GO TO THE DOWNLOAD MODE. IF YOU SEE THE RED CASE JUST IGNORE IT, THE PHONE WILL AUTOMATICALLY GO TO DOWNLOAD MODE.
timeout 5
%currentpath%files\platform-tools\fastboot reboot
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
%currentpath%files\LGUP\LGUP_Cmd.exe com%COMB% "%currentpath%files\LGUP\LGUP_Common.dll" "%var3%" 
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
%currentpath%files\QFIL\QFIL.exe -Mode=3 -COM=%COM% -RawProgram=%currentpath%files\NukeLAF\NukedLAF-G7.xml -Sahara=true -SEARCHPATH=%currentpath%v35abl -RESETAFTERDOWNLOAD=true -AckRawDataEveryNumPackets=TRUE;100 -FLATBUILDPATH=%currentpath%v35abl -PROGRAMMER=true;"%currentpath%files\Firehose\prog_ufs_firehose_Sdm845_lge.elf" -DEVICETYPE=ufs -DOWNLOADFLAT -RESETTIMEOUT=”10”
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
%currentpath%files\QFIL\QFIL.exe -Mode=3 -COM=%COM% -RawProgram=%currentpath%files\NukeLAF\NukedLAF-V40.xml -Sahara=true -SEARCHPATH=%currentpath%v35abl -RESETAFTERDOWNLOAD=true -AckRawDataEveryNumPackets=TRUE;100 -FLATBUILDPATH=%currentpath%v35abl -PROGRAMMER=true;"%currentpath%files\Firehose\prog_ufs_firehose_Sdm845_lge.elf" -DEVICETYPE=ufs -DOWNLOADFLAT -RESETTIMEOUT=”10”
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
%currentpath%file\QFIL\QFIL.exe -Mode=3 -COM=%COM% -RawProgram=%currentpath%files\v35abl\rawprogram4-G7.xml -Sahara=true -SEARCHPATH=%currentpath%v35abl -RESETAFTERDOWNLOAD=true -AckRawDataEveryNumPackets=TRUE;100 -FLATBUILDPATH=%currentpath%v35abl -PROGRAMMER=true;"%currentpath%files\Firehose\prog_ufs_firehose_Sdm845_lge.elf" -DEVICETYPE=ufs -DOWNLOADFLAT -RESETTIMEOUT=”10”
echo If you see the Red triangle then just ignore it, because you flashed the V35 engineering abl and the system just detected you modify the abl. No need to worry, just ignore it
echo If it stuck in the <waiting for devices>, then follow the step:
echo Step 1: Go to Device Manager, you should see Android with a yellow sign. If not, extend "Other devices", now you should see it
echo Step 2: Right click on it, select "Update Driver" or "Update Driver Software", then click "Browse my computer for drivers"
echo Step 3: Click on "Let me pick from a list of available on my computer"
echo Step 4: Click on "Show All Devices", then click "Have Disk", and click Browse. After that go to %currentpath%Fastboot Driver(manually install it)
echo Step 5: Double-click on "android_winusb.inf" then select OK. Select Android Bootloader Interface and click Next. A warning should appear, just ignore it and press OK. Now you got Fastboot driver installed.
%currentpath%files\platform-tools\fastboot flash frp %currentpath%files\v35abl\frp.img
%currentpath%files\platform-tools\fastboot reboot bootloader
timeout 3
echo Rebooting to Bootloader one last time:
%currentpath%files\platform-tools\fastboot reboot bootloader
timeout 3
timeout 10
echo Flashing necessary partition...
%currentpath%files\platform-tools\fastboot erase laf_a
%currentpath%files\platform-tools\fastboot erase abl_a
%currentpath%files\platform-tools\fastboot erase abl_b
%currentpath%files\platform-tools\fastboot erase laf_b
%currentpath%files\platform-tools\fastboot erase dtbo_a
%currentpath%files\platform-tools\fastboot erase dtbo_b
%currentpath%files\platform-tools\fastboot flash boot_a %currentpath%files\platform-tools\boot_g7.bin
%currentpath%files\platform-tools\fastboot flash boot_b %currentpath%files\platform-tools\boot_g7.bin
%currentpath%files\platform-tools\fastboot flash laf_a %currentpath%files\platform-tools\laf_g7.bin
%currentpath%files\platform-tools\fastboot flash laf_b %currentpath%files\platform-tools\laf_g7.bin
%currentpath%files\platform-tools\fastboot flash abl_a %currentpath%files\platform-tools\abl_g7.bin
%currentpath%files\platform-tools\fastboot flash abl_b %currentpath%files\platform-tools\abl_g7.bin
%currentpath%files\platform-tools\fastboot flash dtbo_a %currentpath%files\platform-tools\dtbo_g7.bin
%currentpath%files\platform-tools\fastboot flash dtbo_b %currentpath%files\platform-tools\dtbo_g7.bin
echo Device will REBOOT in 5 seconds!
echo NOW IMMIDIATELY HOLD YOUR VOLUME+ KEY TO GO TO THE DOWNLOAD MODE. IF YOU SEE THE RED CASE JUST IGNORE IT, THE PHONE WILL AUTOMATICALLY GO TO DOWNLOAD MODE.
timeout 5
%currentpath%files\platform-tools\fastboot reboot
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
%currentpath%files\LGUP\LGUP_Cmd.exe com%COMB% "%currentpath%files\LGUP\LGUP_Common.dll" "%var3%" 
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
%currentpath%file\QFIL\QFIL.exe -Mode=3 -COM=%COM% -RawProgram=%currentpath%files\v35abl\rawprogram4-V40.xml -Sahara=true -SEARCHPATH=%currentpath%v35abl -RESETAFTERDOWNLOAD=true -AckRawDataEveryNumPackets=TRUE;100 -FLATBUILDPATH=%currentpath%v35abl -PROGRAMMER=true;"%currentpath%files\Firehose\prog_ufs_firehose_Sdm845_lge.elf" -DEVICETYPE=ufs -DOWNLOADFLAT -RESETTIMEOUT=”10”
echo If you see the Red triangle then just ignore it, because you flashed the V35 engineering abl and the system just detected you modify the abl. No need to worry, just ignore it
echo If it stuck in the <waiting for devices>, then follow the step:
echo Step 1: Go to Device Manager, you should see Android with a yellow sign. If not, extend "Other devices", now you should see it
echo Step 2: Right click on it, select "Update Driver" or "Update Driver Software", then click "Browse my computer for drivers"
echo Step 3: Click on "Let me pick from a list of available on my computer"
echo Step 4: Click on "Show All Devices", then click "Have Disk", and click Browse. After that go to %currentpath%Fastboot Driver(manually install it)
echo Step 5: Double-click on "android_winusb.inf" then select OK. Select Android Bootloader Interface and click Next. A warning should appear, just ignore it and press OK. Now you got Fastboot driver installed.
%currentpath%files\platform-tools\fastboot flash frp %currentpath%files\v35abl\frp.img
%currentpath%files\platform-tools\fastboot reboot bootloader
timeout 3
echo Rebooting to Bootloader one last time:
%currentpath%files\platform-tools\fastboot reboot bootloader
timeout 3
timeout 10
echo Flashing necessary partition...
%currentpath%files\platform-tools\fastboot erase laf_a
%currentpath%files\platform-tools\fastboot erase abl_a
%currentpath%files\platform-tools\fastboot erase abl_b
%currentpath%files\platform-tools\fastboot erase laf_b
%currentpath%files\platform-tools\fastboot erase dtbo_a
%currentpath%files\platform-tools\fastboot erase dtbo_b
%currentpath%files\platform-tools\fastboot flash boot_a %currentpath%files\platform-tools\boot_v40.bin
%currentpath%files\platform-tools\fastboot flash boot_b %currentpath%files\platform-tools\boot_v40.bin
%currentpath%files\platform-tools\fastboot flash laf_a %currentpath%files\platform-tools\laf_v40.bin
%currentpath%files\platform-tools\fastboot flash laf_b %currentpath%files\platform-tools\laf_v40.bin
%currentpath%files\platform-tools\fastboot flash abl_a %currentpath%files\platform-tools\abl_v40.bin
%currentpath%files\platform-tools\fastboot flash abl_b %currentpath%files\platform-tools\abl_v40.bin
%currentpath%files\platform-tools\fastboot flash dtbo_a %currentpath%files\platform-tools\dtbo_v40.bin
%currentpath%files\platform-tools\fastboot flash dtbo_b %currentpath%files\platform-tools\dtbo_v40.bin
echo Device will REBOOT in 5 seconds!
echo NOW IMMIDIATELY HOLD YOUR VOLUME+ KEY TO GO TO THE DOWNLOAD MODE. IF YOU SEE THE RED CASE JUST IGNORE IT, THE PHONE WILL AUTOMATICALLY GO TO DOWNLOAD MODE.
timeout 5
%currentpath%files\platform-tools\fastboot reboot
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
%currentpath%files\LGUP\LGUP_Cmd.exe com%COMB% "%currentpath%files\LGUP\LGUP_Common.dll" "%var3%" 
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
%currentpath%files\platform-tools\fastboot boot %recovery%
echo Your recovery is booting... 
echo. Press Enter to go back to the Main Menu.
pause
cls
goto :MENU

:EXIT 							:: This is where function 16 defined.
exit