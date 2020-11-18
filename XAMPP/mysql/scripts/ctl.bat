@echo off
rem START or STOP Services
rem ----------------------------------
rem Check if argument is STOP or START

if not ""%1"" == ""START"" goto stop


"C:\Users\ajkol\Documents\School\CS 461\wave-lab-app\XAMPP\mysql\bin\mysqld" --defaults-file="C:\Users\ajkol\Documents\School\CS 461\wave-lab-app\XAMPP\mysql\bin\my.ini" --standalone
if errorlevel 1 goto error
goto finish

:stop
cmd.exe /C start "" /MIN call "C:\Users\ajkol\Documents\School\CS 461\wave-lab-app\XAMPP\killprocess.bat" "mysqld.exe"

if not exist "C:\Users\ajkol\Documents\School\CS 461\wave-lab-app\XAMPP\mysql\data\%computername%.pid" goto finish
echo Delete %computername%.pid ...
del "C:\Users\ajkol\Documents\School\CS 461\wave-lab-app\XAMPP\mysql\data\%computername%.pid"
goto finish


:error
echo MySQL could not be started

:finish
exit
