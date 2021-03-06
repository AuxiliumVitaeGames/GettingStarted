@echo off
cd \

set errormsg=ERROR:

set msi=.msi
set ps=.ps1

set blenderurl="https://ftp.nluug.nl/pub/graphics/blender/release/Blender2.82/blender-2.82a-windows64.msi"


if not "%1"=="" (
    set programDatadir=%1
    goto:noinputsframework
)
:notselectedframework
set ps_cmdframework=powershell "Add-Type -AssemblyName System.windows.forms|Out-Null;$f=New-Object System.Windows.Forms.FolderBrowserDialog;$f.ShowDialog()|Out-Null;$f.SelectedPath"
for /f "delims=" %%I in ('%ps_cmdframework%') do set "selectedpathframework=%%I"
if not defined selectedpathframework (
    echo.
    echo %errormsg% Did not choose a folder.
    echo.
    goto:notselectedframework
)
set programDatadir=%selectedpathframework%
>nul 2>&1 mkdir %programDatadir%
:noinputsframework

set tempdir=%programDatadir%\Temp
>nul 2>&1 mkdir %tempdir%


set blendermsi=%tempdir%\blender%msi%
set blenderps="%tempdir%\blender%ps%"

echo $client = new-object System.Net.WebClient;$client.DownloadFile(%blenderurl%,"%blendermsi%");> %blenderps%
start /wait powershell -windowstyle hidden -file %blenderps%
del /f %blenderps%

start /wait msiexec /i %blendermsi% /quiet /qn /norestart
del /f "%blendermsi%"
