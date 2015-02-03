echo off
if %1x == x goto usage

:nextdir
for %%file in (%1\*.m[id]) do %GMDLIB%\GetImports.exe -l%GMDLIB%/makemake < %%file >> awk$$
shift
if %1x != x goto nextdir

gawk -f %GMDLIB%/makemake/makemake.awk < awk$$
del awk$$
goto end

:usage
echo usage: makemake [directories]
:end
