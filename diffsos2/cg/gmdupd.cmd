cmp -s %1 %2
if errorlevel 1 goto touch
echo rm %2
goto end
:touch
echo mv %2 %1
:end
