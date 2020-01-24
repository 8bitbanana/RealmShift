@ECHO OFF
moonc *.moon
IF %errorlevel% == 0 (
    love .
)