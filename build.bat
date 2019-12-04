@ECHO OFF
moonc -t build *.moon
IF %errorlevel% == 0 (
    love ./build
)