@ECHO OFF
moonc .
IF %errorlevel% == 0 (
    love .
)