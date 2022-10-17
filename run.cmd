@echo off
setlocal EnableDelayedExpansion

set cdir=%cd%
set ffmpeg=%cd%\ffmpeg\bin\ffmpeg.exe
set tspath=%1
set /A counter=1
set /A total=1

if exist %ffmpeg% (
   rem echo file exists
) else (
	echo ffmpeg cannot be found at %ffmpeg%
)

if "%1" == "" (
	set /p tspath="Enter path: "
)

rem echo %tspath%

if "%tspath:~-3%" == ".ts" (
	goto FILE
) else (
	goto FOLDER
)

:FILE

for /f "tokens=*" %%a in ("%tspath%") do (
	set FPATH=%%~dpa
	set FLE=%%~na
)
set FFREPORT=file='%FPATH%\%FLE%.log':level=32
%ffmpeg% -hide_banner -loglevel warning -i "%tspath%" -vcodec copy -acodec copy "%FPATH%\%FLE%.mp4"
goto:eof

:FOLDER
for /r "%tspath%" %%F in (*.ts) do (
	rem echo %%~nF
	rem echo %%~dpF
	
	rem echo %%~nF.mpg
		
	echo Processing file #!counter!: %%~nxF
	
	set FFREPORT=file='%%~dpF\%%~nF.log':level=32
	
	%ffmpeg% -hide_banner -loglevel warning -i "%%F" -vcodec copy -acodec copy "%%~dpF\%%~nF.mp4"
	
	set /A total=!counter!
	set /A counter=!counter!+1
)

echo Processed !total! files. Processing complete.

pause

rem ffmpeg -i input.ts -vcodec copy -acodec copy output.mpg