@echo off
setlocal enabledelayedexpansion

REM Log file path
set "logFile=C:\Logs\SystemUptimeLog.txt"

REM Calculate the number of seconds in 6 days
set /a "sixDays=6 * 24 * 60 * 60"

REM Get the system uptime in seconds
for /f "tokens=2" %%i in ('systeminfo ^| find "System Boot Time"') do (
    set "uptime=%%i"
)

REM Check if system uptime is more than 6 days
if !uptime! gtr %sixDays% (
    echo System uptime is more than 6 days. Rebooting...
    shutdown /r /t 0
    echo %date% %time% - Reboot scheduled >> "%logFile%"
    
    REM Schedule a task for next week
    schtasks /create /sc weekly /tn "RebootTask" /tr "shutdown /r /t 0" /st 02:00 /d MON /f
    echo %date% %time% - Task scheduled for next week >> "%logFile%"
) else (
    echo System uptime is less than 6 days. No action needed.
    echo %date% %time% - No action taken >> "%logFile%"
)

endlocal
