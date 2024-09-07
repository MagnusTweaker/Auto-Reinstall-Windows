@echo off

:seleccionar_unidad
set /p installdir="Escribe la letra de la unidad donde instalarás KernelOS: "

:: Eliminar posibles espacios en la entrada
set installdir=%installdir: =%

:: Validar entrada vacía o con espacios
if "%installdir%" equ " =" goto inválido
if "%installdir%" equ "=" goto inválido

:: Verificar si la letra ingresada es válida
for %%i in (a b d e f g h i j k l m n o p q r s t u v w x y z A B D E F G H I J K L M O P Q R S T U V W X Y Z) do (
    echo Verificando si %%i es una letra válida...
    if /i "%installdir%" equ "%%i" goto éxito
)

:inválido
cls
echo [ERROR] Entrada inválida. Intenta de nuevo.
echo.
goto seleccionar_unidad

:éxito
cls
echo Aplicando imagen a %installdir%:\ ...

:: Buscar install.esd en el directorio del script
DISM /Apply-Image /ImageFile:"%~dp0sources\install.esd" /Apply-Unattend:"%~dp0autounattend.xml" /Index:1 /ApplyDir:%installdir%:\

echo Copiando archivo de respuesta...
copy /y "%~dp0autounattend.xml" %installdir%:\Windows\System32\Sysprep\unattend.xml

echo Configurando el arranque...
bcdboot %installdir%:\Windows
bcdedit /timeout 0

cls
echo [COMPLETADO] Reinicia para acceder a KernelOS.
pause
exit /b
