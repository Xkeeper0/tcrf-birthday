@echo off

echo Assembling...
tools\asm6f.exe tcrf9yrs.asm %* bin\tcrf9yrs.nes > bin\assembler.log
if %ERRORLEVEL% neq 0 goto buildfail
echo Done.
echo.

goto end

:buildfail
echo The build seems to have failed.

:end
echo on
