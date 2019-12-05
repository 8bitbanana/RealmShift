@ECHO OFF
moonc -t build *.moon
IF %errorlevel% == 0 (
    robocopy /E sprites build\sprites /NFL /NDL /NJH /NJS /nc /ns /np
    love ./build
)