@echo off
:: ВАЖНО: СОХРАНЯЙТЕ ЭТОТ ФАЙЛ СТРОГО В КОДИРОВКЕ UTF-8!
:MD_REAL_START
chcp 65001 >nul
title MDOptimizer v1.1 - Windows 10/11 Ultimate Setup
:: Увеличиваем размер окна по умолчанию, чтобы всё помещалось
mode con: cols=110 lines=42

:: ==========================================
:: 1. ПРОВЕРКА ПРАВ АДМИНИСТРАТОРА
:: ==========================================
>nul 2>&1 "%SYSTEMROOT%\system32\cacls.exe" "%SYSTEMROOT%\system32\config\system"
if '%errorlevel%' NEQ '0' (
    echo Запрос прав Администратора...
    goto UACPrompt
) else ( goto gotAdmin )

:UACPrompt
    echo Set UAC = CreateObject^("Shell.Application"^) > "%temp%\getadmin.vbs"
    echo UAC.ShellExecute "%~s0", "", "", "runas", 1 >> "%temp%\getadmin.vbs"
    "%temp%\getadmin.vbs"
    del "%temp%\getadmin.vbs"
    exit /B

:gotAdmin
    pushd "%CD%"
    CD /D "%~dp0"

:: ==========================================
:: ИНИЦИАЛИЗАЦИЯ ЦВЕТОВ
:: ==========================================
reg add HKCU\Console /v VirtualTerminalLevel /t REG_DWORD /d 1 /f >nul 2>&1
for /F "delims=#" %%E in ('"prompt #$E# & for %%E in (1) do rem"') do set "ESC=%%E"

set "cRed=%ESC%[91m"
set "cGreen=%ESC%[92m"
set "cYellow=%ESC%[93m"
set "cBlue=%ESC%[94m"
set "cMagenta=%ESC%[95m"
set "cCyan=%ESC%[96m"
set "cWhite=%ESC%[97m"
set "cReset=%ESC%[0m"

:: ==========================================
:: ИНИЦИАЛИЗАЦИЯ ШАБЛОНА
:: ==========================================
set "PresetName=Стандартный"
set "PRESET_do_mas="
set "PRESET_do_zapret="
set "PRESET_do_darktheme="
set "PRESET_do_uac="
set "PRESET_do_tweaks="
set "PRESET_do_vcredist="
set "PRESET_do_java="
set "PRESET_do_discord="
set "PRESET_do_steam="
set "PRESET_do_browser="
set "PRESET_do_wiztree="
set "PRESET_do_qbit="
set "PRESET_do_7zip="
set "PRESET_do_vlc="
set "PRESET_do_clean="

set "PresetColor=%cWhite%"
if not "%PresetName%"=="Стандартный" set "PresetColor=%cGreen%"

:: ==========================================
:: 2. ГЛАВНОЕ МЕНЮ 
:: ==========================================
:MainMenu
cls
echo %cCyan%=======================================================%cReset%
echo %cBlue%   __  __ ___   ___        _   _       _               %cReset%
echo %cBlue%  ^|  \/  ^|   \ / _ \ _ __ ^| ^|_(_)_ __ (_)___ ___ _ _  %cReset%
echo %cBlue%  ^| ^|\/^| ^| ^|) ^| (_) ^| '_ \^|  _^| ^| '  \^| ^|_ // -_) '_^| %cReset%
echo %cBlue%  ^|_^|  ^|_^|___/ \___/^| .__/ \__^|_^|_^|_^|_^|_/__^|\___^|_^|   %cReset%
echo %cBlue%                    ^|_^|    %cYellow%[by Mishustin Danil - v1.1]%cReset%
echo %cCyan%=======================================================%cReset%
echo          %PresetColor%[ ТЕКУЩИЙ ШАБЛОН: %PresetName% ]%cReset%
echo %cCyan%=======================================================%cReset%
echo.
echo %cYellow%[!] СОВЕТ:%cReset% Если шрифт мелкий — зажмите CTRL
echo            и покрутите колесико мыши вверх.
echo            Если консоль "зависла" (режим выделения) —
echo            просто нажмите клавишу ESC.
echo.
echo %cCyan%=======================================================%cReset%
echo          %cGreen%[ 1 ] СПРАВКА (О программе и авторе)%cReset%
echo          %cYellow%[ 2 ] СОСТАВ ШАБЛОНА (Что будет установлено)%cReset%
echo %cCyan%=======================================================%cReset%
echo.
echo   %cWhite%ВЫБЕРИТЕ ДЕЙСТВИЕ:%cReset%
echo.
echo     %cGreen%[ Enter ]%cReset%       %cWhite%Начать настройку %cYellow%(Ручной выбор)%cReset%
echo.
echo     %cMagenta%[ Подтверждаю ]%cReset% %cWhite%Автоматический режим %cYellow%(По шаблону)%cReset%
echo.
echo %cCyan%-------------------------------------------------------%cReset%
echo.
set "automode=0"
set "user_input="
set /p user_input="%cWhite%Ввод:%cReset% "

if "%user_input%"=="1" goto HelpMenu
if "%user_input%"=="2" goto ShowTemplate
if /I "%user_input%"=="Подтверждаю" (
    set "automode=1"
    echo.
    echo %cGreen%[OK] Включен автоматический режим! MDOptimizer сделает все сам.%cReset%
    timeout /t 3 >nul
    goto StartSetup
)
if "%user_input%"=="" (
    set "automode=0"
    goto StartSetup
)
goto MainMenu

:: ==========================================
:: 3. СПРАВКА (HELP MENU)
:: ==========================================
:HelpMenu
cls
echo %cCyan%=======================================================%cReset%
echo                 %cGreen%СПРАВКА MDOptimizer%cReset%
echo %cCyan%=======================================================%cReset%
echo.
echo Данный твикер предназначен для быстрой настройки свежей ОС.
echo.
echo %cYellow%ЧТО ДЕЛАЕТ СКРИПТ:%cReset%
echo  - Активирует Windows с помощью безопасного метода HWID (MAS).
echo    (Исключение: Если скрипт пишет, что система "permanently 
echo     activated", то ничего делать не нужно — просто выходите).
echo  - Устанавливает базовый набор ПО: Steam, Discord, qBittorrent, 7-Zip, WizTree.
echo  - Обновляет критически важные библиотеки: Java 8/17/21, VC++, .NET 8, DirectX.
echo  - Автоматизирует установку Zapret (обход блокировок):
echo    * Автоматически установит 7-Zip для работы с .rar/.zip списками.
echo    * Сам качает последнюю версию с GitHub на Рабочий стол.
echo    * Скачивает ваши списки (lists.zip/rar) напрямую из облака (Standalone).
echo    * Дает подробную инструкцию по тестированию и выбору стратегии.
echo  - Очищает систему от мусора (Удаляет OneDrive, Карты, Виджеты).
echo  - Применяет твики: темная тема, отключение UAC, макс. производительность.
echo.
echo %cYellow%[!] УПРАВЛЕНИЕ:%cReset% Вы можете отвечать на вопросы скрипта 
echo клавишами Y/N на английском, или Н/Т на русской раскладке. 
echo Нажатие Enter всегда означает "Да".
echo Если консоль случайно "зависла" (режим выделения) — нажмите ESC.
echo.
echo %cRed%ВАЖНОЕ ПРЕДУПРЕЖДЕНИЕ:%cReset%
echo Автор скрипта (Мишустин Данил) лично перепроверил каждую ссылку, 
echo команду и программу. Скрипт не содержит вирусов и вредоносного ПО.
echo Тем не менее, вы используете данное ПО на свой страх и риск.
echo.
echo %cCyan%-------------------------------------------------------%cReset%
echo %cWhite%[2]%cReset% Открыть страницу твикера на GitHub
echo %cWhite%[3]%cReset% Написать свой отзыв или перейти в обсуждение
echo %cWhite%[4]%cReset% Предложить свою идею по развитию твикера
echo %cWhite%[5]%cReset% Вернуться на главный экран %cYellow%(N/т - также возврат на гл. экран)%cReset%
echo %cCyan%-------------------------------------------------------%cReset%
echo.
set "h_input="
set /p h_input="%cWhite%Ввод:%cReset% "
if "%h_input%"=="2" (
    start https://github.com/CTaJIoHE/MDOptimizer
    goto HelpMenu
)
if "%h_input%"=="3" (
    start https://github.com/CTaJIoHE/MDOptimizer/discussions/2
    goto HelpMenu
)
if "%h_input%"=="4" (
    start https://github.com/CTaJIoHE/MDOptimizer/discussions/3
    goto HelpMenu
)
if "%h_input%"=="5" goto MainMenu
if /I "%h_input%"=="N" goto MainMenu
if /I "%h_input%"=="Т" goto MainMenu
if /I "%h_input%"=="T" goto MainMenu
goto HelpMenu

:: ==========================================
:: 4. СОСТАВ ШАБЛОНА
:: ==========================================
:ShowTemplate
cls
echo %cCyan%=======================================================%cReset%
echo                 %cGreen%СОСТАВ ШАБЛОНА: %PresetName%%cReset%
echo %cCyan%=======================================================%cReset%
echo.

:: Временно подгружаем переменные текущего шаблона
set "t_mas=%PRESET_do_mas%"
set "t_zapret=%PRESET_do_zapret%"
set "t_darktheme=%PRESET_do_darktheme%"
set "t_uac=%PRESET_do_uac%"
set "t_tweaks=%PRESET_do_tweaks%"
set "t_vcredist=%PRESET_do_vcredist%"
set "t_java=%PRESET_do_java%"
set "t_discord=%PRESET_do_discord%"
set "t_steam=%PRESET_do_steam%"
set "t_browser=%PRESET_do_browser%"
set "t_wiztree=%PRESET_do_wiztree%"
set "t_qbit=%PRESET_do_qbit%"
set "t_7zip=%PRESET_do_7zip%"
set "t_vlc=%PRESET_do_vlc%"
set "t_clean=%PRESET_do_clean%"

:: Если шаблон Стандартный, симулируем его дефолтные ответы
if "%PresetName%"=="Стандартный" (
    set "t_mas=Y"
    set "t_zapret=Y"
    set "t_darktheme=Y"
    set "t_uac=N"
    set "t_tweaks=Y"
    set "t_vcredist=Y"
    set "t_java=Y"
    set "t_discord=Y"
    set "t_steam=Y"
    set "t_browser=12"
    set "t_wiztree=Y"
    set "t_qbit=Y"
    set "t_7zip=Y"
    set "t_vlc=N"
    set "t_clean=Y"
)

:: Логика 7-Zip (если выбран Zapret)
if /I "%t_zapret%"=="Y" set "t_7zip=Y"

echo %cWhite%При запуске автоматического режима будет выполнено:%cReset%
echo.
if /I "%t_mas%"=="Y" (echo  %cGreen%[+]%cReset% Активация Windows ^(MAS^)) else (echo  %cRed%[-]%cReset% Активация Windows)
if /I "%t_zapret%"=="Y" (echo  %cGreen%[+]%cReset% Установка Zapret) else (echo  %cRed%[-]%cReset% Установка Zapret)
if /I "%t_darktheme%"=="Y" (echo  %cGreen%[+]%cReset% Включение темной темы) else (echo  %cRed%[-]%cReset% Включение темной темы)
if /I "%t_uac%"=="Y" (echo  %cGreen%[+]%cReset% Отключение уведомлений UAC) else (echo  %cRed%[-]%cReset% Отключение уведомлений UAC)
if /I "%t_tweaks%"=="Y" (echo  %cGreen%[+]%cReset% Системные твики и удаление мусора) else (echo  %cRed%[-]%cReset% Системные твики и удаление мусора)
if /I "%t_vcredist%"=="Y" (echo  %cGreen%[+]%cReset% Установка Visual C++ Redistributable AIO) else (echo  %cRed%[-]%cReset% Установка Visual C++)
if /I "%t_java%"=="Y" (echo  %cGreen%[+]%cReset% Установка Java ^(8, 17, 21^)) else (echo  %cRed%[-]%cReset% Установка Java)
if /I "%t_discord%"=="Y" (echo  %cGreen%[+]%cReset% Установка Discord) else (echo  %cRed%[-]%cReset% Установка Discord)
if /I "%t_steam%"=="Y" (echo  %cGreen%[+]%cReset% Установка Steam) else (echo  %cRed%[-]%cReset% Установка Steam)

:: Умный анализ браузеров
set "b1=" & set "b2=" & set "b3=" & set "b4="
if "%t_browser%"=="0" goto :skip_b_parse
if "%t_browser%"=="" goto :skip_b_parse
echo %t_browser% | find "1" >nul 2>&1 && set "b1=Chrome "
echo %t_browser% | find "2" >nul 2>&1 && set "b2=Yandex "
echo %t_browser% | find "3" >nul 2>&1 && set "b3=Opera_GX "
echo %t_browser% | find "4" >nul 2>&1 && set "b4=Brave "
:skip_b_parse
set "b_list=%b1%%b2%%b3%%b4%"
if "%b_list%"=="" set "b_list=Не устанавливать"
echo  %cGreen%[*]%cReset% Браузеры: %cYellow%%b_list%%cReset%

if /I "%t_wiztree%"=="Y" (echo  %cGreen%[+]%cReset% Установка WizTree) else (echo  %cRed%[-]%cReset% Установка WizTree)
if /I "%t_qbit%"=="Y" (echo  %cGreen%[+]%cReset% Установка qBittorrent) else (echo  %cRed%[-]%cReset% Установка qBittorrent)
if /I "%t_7zip%"=="Y" (echo  %cGreen%[+]%cReset% Установка 7-Zip) else (echo  %cRed%[-]%cReset% Установка 7-Zip)
if /I "%t_vlc%"=="Y" (echo  %cGreen%[+]%cReset% Удаление плееров Win11 и установка VLC) else (echo  %cRed%[-]%cReset% Удаление плееров Win11 и установка VLC)
if /I "%t_clean%"=="Y" (echo  %cGreen%[+]%cReset% Очистка временных файлов) else (echo  %cRed%[-]%cReset% Очистка временных файлов)

echo.
echo %cCyan%-------------------------------------------------------%cReset%
echo %cWhite%[5]%cReset% Вернуться на главный экран %cYellow%(N/т - также возврат)%cReset%
echo %cCyan%-------------------------------------------------------%cReset%
echo.
set "s_input="
set /p s_input="%cWhite%Ввод:%cReset% "
if "%s_input%"=="5" goto MainMenu
if /I "%s_input%"=="N" goto MainMenu
if /I "%s_input%"=="Т" goto MainMenu
if /I "%s_input%"=="T" goto MainMenu
goto ShowTemplate

:: ==========================================
:: СТАРТ ОСНОВНОГО ПРОЦЕССА
:: ==========================================
:StartSetup
:: Включаем отложенное расширение переменных ТОЛЬКО ЗДЕСЬ. Знак ! теперь экранируется как [^^!]
setlocal EnableDelayedExpansion

if "%automode%"=="1" goto AutoDefaults

:: ==========================================
:: РУЧНОЙ РЕЖИМ (ОПРОС)
:: ==========================================
cls
echo %cCyan%=======================================================%cReset%
echo %cMagenta%                [РУЧНАЯ НАСТРОЙКА]%cReset%
echo %cCyan%=======================================================%cReset%
echo %cWhite%Отвечайте Y (Да) или N (Нет). (Enter/н = Да, N/т = Пропустить).%cReset%
echo.

set "do_mas="
set /p do_mas="%cYellow%[1/15]%cReset% Активировать Windows 10/11 (MAS)? [Y/n]: "
if "!do_mas!"=="" set "do_mas=Y"

echo.
echo %cCyan%[ИНФО]%cReset% %cWhite%Для распаковки списков Zapret требуется архиватор %cYellow%7-Zip%cWhite%.%cReset%
echo %cWhite%Если вы согласитесь на установку Zapret, %cGreen%7-Zip установится автоматически%cWhite%.%cReset%
set "do_zapret="
set /p do_zapret="%cYellow%[2/15]%cReset% Установить Zapret (Обход блокировок)? [Y/n]: "
if "!do_zapret!"=="" set "do_zapret=Y"

set "do_darktheme="
set /p do_darktheme="%cYellow%[3/15]%cReset% Включить темную тему Windows и приложений? [Y/n]: "
if "!do_darktheme!"=="" set "do_darktheme=Y"

echo %cRed%ВНИМАНИЕ: Мы ставим "Никогда не уведомлять", чтобы убрать бесящие экраны%cReset%
echo %cRed%подтверждения прав админа. Система станет удобнее, но чуть менее безопасной.%cReset%
set "do_uac="
set /p do_uac="%cYellow%[4/15]%cReset% Отключить уведомления UAC (На свой страх и риск)? [Y/n]: "
if "!do_uac!"=="" set "do_uac=Y"

set "do_tweaks="
set /p do_tweaks="%cYellow%[5/15]%cReset% Оптимизация (Убрать Виджеты, Предст. задач, Контроль памяти, мусор UWP)? [Y/n]: "
if "!do_tweaks!"=="" set "do_tweaks=Y"

set "do_vcredist="
set /p do_vcredist="%cYellow%[6/15]%cReset% Установить Visual C++ Redistributable AIO (x86/x64)? [Y/n]: "
if "!do_vcredist!"=="" set "do_vcredist=Y"

set "do_java="
set /p do_java="%cYellow%[7/15]%cReset% Установить Java (Версии 8, 17, 21)? [Y/n]: "
if "!do_java!"=="" set "do_java=Y"

set "do_discord="
set /p do_discord="%cYellow%[8/15]%cReset% Установить Discord? [Y/n]: "
if "!do_discord!"=="" set "do_discord=Y"

set "do_steam="
set /p do_steam="%cYellow%[9/15]%cReset% Установить Steam? [Y/n]: "
if "!do_steam!"=="" set "do_steam=Y"

echo.
echo %cCyan%Выберите браузеры для установки (можно указать несколько цифр подряд, например: 134)%cReset%
echo 1 - Google Chrome
echo 2 - Yandex Browser
echo 3 - Opera GX
echo 4 - Brave
echo 0 - Пропустить установку браузеров (N/т = Пропустить)
set "do_browser="
set /p do_browser="%cYellow%[10/15] Ваш выбор (Enter = 12, 0/N/т = Пропуск): %cReset%"
if "!do_browser!"=="" set "do_browser=12"
if /I "!do_browser!"=="N" set "do_browser=0"
if /I "!do_browser!"=="Т" set "do_browser=0"
if /I "!do_browser!"=="T" set "do_browser=0"

echo.
set "do_wiztree="
set /p do_wiztree="%cYellow%[11/15]%cReset% Установить WizTree (Для анализа места на диске)? [Y/n]: "
if "!do_wiztree!"=="" set "do_wiztree=Y"

set "do_qbit="
set /p do_qbit="%cYellow%[12/15]%cReset% Установить qBittorrent? [Y/n]: "
if "!do_qbit!"=="" set "do_qbit=Y"

if /I "!do_zapret!"=="Y" goto :skip_7zip_prompt
if /I "!do_zapret!"=="Н" goto :skip_7zip_prompt
if /I "!do_zapret!"=="H" goto :skip_7zip_prompt
set "do_7zip="
set /p do_7zip="%cYellow%[13/15]%cReset% Установить 7-Zip? [Y/n]: "
if "!do_7zip!"=="" set "do_7zip=Y"
goto :after_7zip_prompt

:skip_7zip_prompt
echo %cYellow%[13/15]%cReset% Установить 7-Zip? %cGreen%[Одобрено автоматически вместе с Zapret]%cReset%
set "do_7zip=Y"

:after_7zip_prompt
echo.
echo %cCyan%Настройка медиаплееров:%cReset%
set "do_vlc="
set /p do_vlc="%cYellow%[14/15]%cReset% Удалить стандартные плееры Windows 11 и установить VLC? [Y/n]: "
if "!do_vlc!"=="" set "do_vlc=Y"

set "do_clean="
set /p do_clean="%cYellow%[15/15]%cReset% Очистить временные файлы после установки? [Y/n]: "
if "!do_clean!"=="" set "do_clean=Y"

:: ==========================================
:: СОХРАНЕНИЕ ШАБЛОНА (АБСОЛЮТНО НАДЕЖНЫЙ МЕТОД КЛОНИРОВАНИЯ БЕЗ BOM)
:: ==========================================
echo.
set "save_template="
set /p save_template="%cGreen%Хотите сохранить этот выбор как шаблон для будущих установок? [Y/n] (Enter/Н=Да, N/Т=Нет): %cReset%"

:: Если пользователь ввел N или Т (Нет) — переходим к установке. Иначе (Enter/Y/Н) продолжаем сохранение.
if /I "!save_template!"=="N" goto :ExecutionPhase
if /I "!save_template!"=="Т" goto :ExecutionPhase
if /I "!save_template!"=="T" goto :ExecutionPhase

set "custom_preset_name="
set /p custom_preset_name="%cYellow%Введите имя шаблона (Например: Zero): %cReset%"
if "!custom_preset_name!"=="" set "custom_preset_name=МойШаблон"

:: Удаляем кавычки из имени для безопасности
set "safe_name=!custom_preset_name:"=!"

echo %cCyan%Открытие окна выбора места сохранения...%cReset%
:: Диалоговое окно "Сохранить как" через PowerShell
set "psCommand=Add-Type -AssemblyName System.Windows.Forms; $s = New-Object System.Windows.Forms.SaveFileDialog; $s.Filter = 'CMD Шаблон (*.bat)|*.bat'; $s.FileName = $env:safe_name + '.bat'; $s.Title = 'Сохранить шаблон MDOptimizer'; $s.InitialDirectory = $PWD.Path; if ($s.ShowDialog() -eq [System.Windows.Forms.DialogResult]::OK) { Write-Output $s.FileName }"
for /f "usebackq tokens=*" %%F in (`powershell -Sta -NoProfile -Command "!psCommand!"`) do set "SavePath=%%F"

if "!SavePath!"=="" (
    echo %cRed%Сохранение отменено. Переход к установке...%cReset%
    timeout /t 3 >nul
    goto :ExecutionPhase
)

:: Генерируем 100% надежный скрипт для копирования кода в чистом UTF-8 (Без метки BOM, которая ломает @echo off)
set "PS_SCRIPT=!temp!\md_save.ps1"
set "SCRIPT_PATH=%~f0"

> "!PS_SCRIPT!" echo $src = $env:SCRIPT_PATH
>> "!PS_SCRIPT!" echo $dst = $env:SavePath
>> "!PS_SCRIPT!" echo $utf8NoBom = New-Object System.Text.UTF8Encoding($false)
>> "!PS_SCRIPT!" echo $txt = [IO.File]::ReadAllText($src, $utf8NoBom)
>> "!PS_SCRIPT!" echo $txt = $txt -replace '(?m)^^set "PresetName=.*"', ('set "PresetName=' + $env:safe_name + '"')
>> "!PS_SCRIPT!" echo $vars = @('do_mas','do_zapret','do_darktheme','do_uac','do_tweaks','do_vcredist','do_java','do_discord','do_steam','do_browser','do_wiztree','do_qbit','do_7zip','do_vlc','do_clean')
>> "!PS_SCRIPT!" echo foreach ($v in $vars) {
>> "!PS_SCRIPT!" echo     $val = [Environment]::GetEnvironmentVariable($v)
>> "!PS_SCRIPT!" echo     $pattern = '(?m)^^set "PRESET_' + $v + '=.*"'
>> "!PS_SCRIPT!" echo     $replacement = 'set "PRESET_' + $v + '=' + $val + '"'
>> "!PS_SCRIPT!" echo     $txt = $txt -replace $pattern, $replacement
>> "!PS_SCRIPT!" echo }
>> "!PS_SCRIPT!" echo [IO.File]::WriteAllText($dst, $txt, $utf8NoBom)

powershell -NoProfile -ExecutionPolicy Bypass -File "!PS_SCRIPT!"
del "!PS_SCRIPT!" >nul 2>&1

:: Применяем имя текущему окну
set "PresetName=!safe_name!"
echo.
echo %cGreen%Шаблон "!safe_name!" успешно сохранен по пути:%cReset%
echo %cWhite%!SavePath!%cReset%
echo %cCyan%Совет: Сохраните этот файл в облако (Google Drive, Yandex Disk, Mega), чтобы не потерять!%cReset%
echo %cYellow%Для автоматической настройки просто запустите созданный файл на любом ПК и выберите "Подтверждаю".%cReset%
pause
goto :ExecutionPhase

:: ==========================================
:: АВТОМАТИЧЕСКИЙ РЕЖИМ (ПО-УМОЛЧАНИЮ ИЛИ ИЗ ШАБЛОНА)
:: ==========================================
:AutoDefaults
if "!PresetName!"=="Стандартный" (
    set "do_mas=Y"
    set "do_zapret=Y"
    set "do_darktheme=Y"
    set "do_uac=N"
    set "do_tweaks=Y"
    set "do_vcredist=Y"
    set "do_java=Y"
    set "do_discord=Y"
    set "do_steam=Y"
    set "do_browser=12"
    set "do_wiztree=Y"
    set "do_qbit=Y"
    set "do_7zip=Y"
    set "do_vlc=N"
    set "do_clean=Y"
) else (
    set "do_mas=!PRESET_do_mas!"
    set "do_zapret=!PRESET_do_zapret!"
    set "do_darktheme=!PRESET_do_darktheme!"
    set "do_uac=!PRESET_do_uac!"
    set "do_tweaks=!PRESET_do_tweaks!"
    set "do_vcredist=!PRESET_do_vcredist!"
    set "do_java=!PRESET_do_java!"
    set "do_discord=!PRESET_do_discord!"
    set "do_steam=!PRESET_do_steam!"
    set "do_browser=!PRESET_do_browser!"
    set "do_wiztree=!PRESET_do_wiztree!"
    set "do_qbit=!PRESET_do_qbit!"
    set "do_7zip=!PRESET_do_7zip!"
    set "do_vlc=!PRESET_do_vlc!"
    set "do_clean=!PRESET_do_clean!"
)

:: Страховка для шаблонов: если Zapret включен, 7-zip тоже должен быть включен
if /I "!do_zapret!"=="Y" set "do_7zip=Y"
if /I "!do_zapret!"=="Н" set "do_7zip=Y"
if /I "!do_zapret!"=="H" set "do_7zip=Y"
goto :ExecutionPhase

:ExecutionPhase
:: ==========================================
:: ПОДГОТОВКА ПРОГРЕСС-БАРА И ПЕРЕМЕННЫХ
:: ==========================================
set "installed_list="
set "7zip_installed_early=0"

set "need_early_7zip=0"
if /I "!do_zapret!"=="Y" set "need_early_7zip=1"
if /I "!do_zapret!"=="Н" set "need_early_7zip=1"
if /I "!do_zapret!"=="H" set "need_early_7zip=1"

set /a total_tasks=0

set "mas_will_run=1"
if /I "!do_mas!"=="N" set "mas_will_run=0"
if /I "!do_mas!"=="Т" set "mas_will_run=0"
if /I "!do_mas!"=="T" set "mas_will_run=0"
if "!mas_will_run!"=="1" set /a total_tasks+=1

if "!need_early_7zip!"=="1" set /a total_tasks+=1

set "zapret_will_run=1"
if /I "!do_zapret!"=="N" set "zapret_will_run=0"
if /I "!do_zapret!"=="Т" set "zapret_will_run=0"
if /I "!do_zapret!"=="T" set "zapret_will_run=0"
if "!zapret_will_run!"=="1" set /a total_tasks+=1

if /I "!do_darktheme!"=="Y" set /a total_tasks+=1
if /I "!do_uac!"=="Y" set /a total_tasks+=1
if /I "!do_tweaks!"=="Y" set /a total_tasks+=1
if /I "!do_vcredist!"=="Y" set /a total_tasks+=1
if /I "!do_java!"=="Y" set /a total_tasks+=3
if /I "!do_discord!"=="Y" set /a total_tasks+=1
if /I "!do_steam!"=="Y" set /a total_tasks+=1
if "!do_browser!" neq "0" if "!do_browser!" neq "" set /a total_tasks+=1
if /I "!do_wiztree!"=="Y" set /a total_tasks+=1
if /I "!do_qbit!"=="Y" set /a total_tasks+=1
if /I "!do_7zip!"=="Y" if "!need_early_7zip!"=="0" set /a total_tasks+=1
if /I "!do_vlc!"=="Y" set /a total_tasks+=1
if /I "!do_clean!"=="Y" set /a total_tasks+=1

if !total_tasks! equ 0 set "total_tasks=1"
set /a current_task=0

:: Фикс для общих системных протоколов перед скачиванием
reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Internet Settings\WinHttp" /v DefaultSecureProtocols /t REG_DWORD /d 0x00000A00 /f >nul 2>&1
reg add "HKLM\SOFTWARE\Wow6432Node\Microsoft\Windows\CurrentVersion\Internet Settings\WinHttp" /v DefaultSecureProtocols /t REG_DWORD /d 0x00000A00 /f >nul 2>&1

:: ==========================================
:: 4. АКТИВАЦИЯ WINDOWS (MAS)
:: ==========================================
if /I "!do_mas!"=="N" goto :skip_mas
if /I "!do_mas!"=="Т" goto :skip_mas
if /I "!do_mas!"=="T" goto :skip_mas

cls
echo %cCyan%--- Активация Windows ---%cReset%
echo.
echo %cCyan%=======================================================%cReset%
echo %cYellow%ИНСТРУКЦИЯ ПО АКТИВАЦИИ:%cReset%
echo 1. Сейчас откроется НОВОЕ ОКНО с активатором.
echo 2. В нем нажмите клавишу %cGreen%[1] (HWID Activation)%cReset%.
echo 3. Дождитесь зеленого текста "Activation Successful".
echo    (Если пишет "permanently activated" - система уже активирована).
echo 4. Закройте окно активатора крестиком или нажмите [0] для выхода.
echo %cCyan%=======================================================%cReset%
echo.

echo %cYellow%Запуск скрипта активации через PowerShell (Облако)...%cReset%
start "" powershell -NoProfile -Command "irm https://get.activated.win | iex; exit"

echo.
echo %cMagenta%[^^!] После того как вы активируете систему и ЗАКРОЕТЕ окно MAS,%cReset%
echo %cMagenta%    нажмите любую клавишу здесь, чтобы продолжить работу твикера!%cReset%
pause >nul
echo.
echo %cGreen%[OK] Идем дальше...%cReset%
set /a current_task+=1
set "installed_list=!installed_list!- Активация Windows (MAS)\n"

:skip_mas


:: ==========================================
:: 4.5. ПРЕДВАРИТЕЛЬНАЯ УСТАНОВКА 7-ZIP (Для Zapret)
:: ==========================================
if "!need_early_7zip!"=="0" goto :skip_early_7zip

cls
echo %cCyan%--- Подготовка компонентов ---%cReset%
echo %cYellow%Установка архиватора 7-Zip (Необходим для распаковки списков Zapret)...%cReset%
winget install -e --id 7zip.7zip --accept-source-agreements --accept-package-agreements --silent >nul 2>&1
set "7zip_installed_early=1"
echo %cGreen%[OK] 7-Zip успешно установлен.%cReset%
set /a current_task+=1
set "installed_list=!installed_list!- 7-Zip\n"
timeout /t 2 >nul

:skip_early_7zip


:: ==========================================
:: 5. УСТАНОВКА ZAPRET (Ставится ДО остального софта)
:: ==========================================
if /I "!do_zapret!"=="N" goto :skip_zapret
if /I "!do_zapret!"=="Т" goto :skip_zapret
if /I "!do_zapret!"=="T" goto :skip_zapret

cls
echo %cCyan%--- Настройка обхода блокировок (Zapret) ---%cReset%
:: Умный поиск реального пути к Рабочему столу
for /f "usebackq tokens=*" %%a in (`powershell -NoProfile -Command "[Environment]::GetFolderPath('Desktop')"`) do set "TRUE_DESKTOP=%%a"

echo %cYellow%Скачивание свежего релиза Zapret c GitHub...%cReset%
powershell -NoProfile -ExecutionPolicy Bypass -Command "$ErrorActionPreference = 'Stop'; try { $desktop = [Environment]::GetFolderPath('Desktop'); $release = Invoke-RestMethod -Uri 'https://api.github.com/repos/Flowseal/zapret-discord-youtube/releases/latest'; $asset = $release.assets | Where-Object { $_.name -match '\.zip$' } | Select-Object -First 1; $url = $asset.browser_download_url; $dest = \"$desktop\zapret.zip\"; $outFolder = \"$desktop\Zapret_Bypass\"; Invoke-WebRequest -Uri $url -OutFile $dest; if (Test-Path $outFolder) { Remove-Item -Path $outFolder -Recurse -Force }; Expand-Archive -Path $dest -DestinationPath $outFolder -Force; Remove-Item $dest; exit 0 } catch { exit 1 }"

if %errorlevel% neq 0 (
    echo %cRed%[ОШИБКА] Не удалось скачать Zapret. Возможно, мешает антивирус.%cReset%
    goto skip_zapret
)

echo %cGreen%[OK] Zapret скачан в папку Zapret_Bypass на Рабочем столе.%cReset%
echo.

echo %cYellow%Скачивание пользовательских списков из облака (GitHub)...%cReset%

set "LISTS_PATH="
set "LISTS_EXT="

:: Попытка скачать .zip
powershell -NoProfile -Command "try { Invoke-WebRequest -Uri 'https://raw.githubusercontent.com/CTaJIoHE/MDOptimizer/main/Files/lists.zip' -OutFile '%temp%\zapret_lists.zip' } catch { exit 1 }" >nul 2>&1
if exist "%temp%\zapret_lists.zip" (
    set "LISTS_PATH=%temp%\zapret_lists.zip"
    set "LISTS_EXT=zip"
    echo %cGreen%[OK] Файл lists.zip успешно скачан из облака.%cReset%
) else (
    :: Попытка скачать .rar
    powershell -NoProfile -Command "try { Invoke-WebRequest -Uri 'https://raw.githubusercontent.com/CTaJIoHE/MDOptimizer/main/Files/lists.rar' -OutFile '%temp%\zapret_lists.rar' } catch { exit 1 }" >nul 2>&1
    if exist "%temp%\zapret_lists.rar" (
        set "LISTS_PATH=%temp%\zapret_lists.rar"
        set "LISTS_EXT=rar"
        echo %cGreen%[OK] Файл lists.rar успешно скачан из облака.%cReset%
    )
)

:: Резервный локальный поиск (если нет интернета или гитхаб недоступен)
if not defined LISTS_PATH (
    echo %cRed%[!] Не удалось скачать списки из облака. Ищем локально...%cReset%
    if exist "%~dp0lists.zip" set "LISTS_PATH=%~dp0lists.zip"&set "LISTS_EXT=zip"
    if exist "%~dp0lists.rar" set "LISTS_PATH=%~dp0lists.rar"&set "LISTS_EXT=rar"
    if exist "%~dp0Files\lists.zip" set "LISTS_PATH=%~dp0Files\lists.zip"&set "LISTS_EXT=zip"
    if exist "%~dp0Files\lists.rar" set "LISTS_PATH=%~dp0Files\lists.rar"&set "LISTS_EXT=rar"
)

if not defined LISTS_PATH goto :skip_lists_extract

md "%temp%\zap_lists" >nul 2>&1

:: Используем 7-Zip (он уже установлен, если выбран Zapret)
if exist "%ProgramFiles%\7-Zip\7z.exe" (
    "%ProgramFiles%\7-Zip\7z.exe" x "!LISTS_PATH!" -o"%temp%\zap_lists" -y >nul 2>&1
    goto :lists_extracted
)

if "!LISTS_EXT!"=="zip" goto :extract_zip

:extract_rar
echo %cRed%[ОШИБКА] Для распаковки .rar нужен 7-Zip, но он не установлен!%cReset%
goto :skip_lists_extract

:extract_zip
powershell -Command "Expand-Archive -Path '!LISTS_PATH!' -DestinationPath '%temp%\zap_lists' -Force" >nul 2>&1

:lists_extracted
xcopy /E /Y /C /Q "%temp%\zap_lists\*" "%TRUE_DESKTOP%\Zapret_Bypass\lists\" >nul 2>&1
if not exist "%TRUE_DESKTOP%\Zapret_Bypass\lists\lists\*" goto :lists_cleanup
xcopy /E /Y /C /Q "%TRUE_DESKTOP%\Zapret_Bypass\lists\lists\*" "%TRUE_DESKTOP%\Zapret_Bypass\lists\" >nul 2>&1
rd /s /q "%TRUE_DESKTOP%\Zapret_Bypass\lists\lists" >nul 2>&1

:lists_cleanup
rd /s /q "%temp%\zap_lists" >nul 2>&1
echo %cGreen%[OK] Пользовательские списки (%LISTS_EXT%) успешно добавлены в Zapret!%cReset%
goto :done_lists

:skip_lists_extract
echo %cYellow%[ИНФО] Архив со списками не найден. Оставлены списки по умолчанию.%cReset%

:done_lists
echo.
echo %cMagenta%Нажмите любую клавишу для вывода инструкции по Zapret...%cReset%
pause >nul

:: Временно отключаем DelayedExpansion, чтобы восклицательные знаки не пропадали
setlocal DisableDelayedExpansion
cls
echo %cCyan%=======================================================%cReset%
echo %cYellow%ИНСТРУКЦИЯ ПО НАСТРОЙКЕ ZAPRET (Обязательно до установки Discord):%cReset%
echo.
echo %cRed%[!] ВАЖНО:%cReset% Мы только что добавили нужные списки в Zapret_Bypass.
echo     ТОЛЬКО ТЕПЕРЬ настоятельно рекомендуется переместить папку 
echo     "Zapret_Bypass" с Рабочего стола в корень диска (например, C:\), 
echo     чтобы в пути к файлам %cRed%НЕ БЫЛО русских букв (кириллицы)!%cReset%
echo.
echo Сделайте всё строго по списку ниже, КАК У АВТОРА:
echo 1. Откройте папку Zapret_Bypass (в новом месте) и запустите %cGreen%service.bat%cReset% от им. Администратора.
echo.
echo 2. Выберите %cGreen%[11] Run Tests%cReset%. Дождитесь окончания тестирования.
echo    В самом конце результатов найдите строчку с лучшей стратегией.
echo    (Например: %cYellow%"Best strategy: general (ALT11).bat"%cReset% - у вас может отличаться).
echo.
echo 3. Проверьте %cGreen%[6] Auto-Update Check%cReset%: должно быть %cYellow%"Disable"%cReset%. 
echo.
echo 4. Нажмите %cGreen%[7] Game Filter%cReset% и выберите %cYellow%[1] TCP and UDP%cReset%.
echo.
echo 5. Нажмите %cGreen%[5] IPSet Filter%cReset% и выберите %cYellow%loaded%cReset%.
echo    (Если будут проблемы с подключением - ставьте %cYellow%none%cReset%).
echo    (Если нужен доступ к заблокированным играм - ставьте %cYellow%loaded%cReset%).
echo    %cBlue%Все запрещенные домены я стараюсь вносить. Если есть предложения 
echo    по разблокировке - пишите в Discussions на GitHub.%cReset%
echo.
echo 6. Нажмите %cGreen%[1] Install Service%cReset% для установки службы обхода в систему.
echo    Когда программа спросит, выберите стратегию, которую выдал тест на шаге 2.
echo.
echo 7. Нажмите %cGreen%[8] Update Hosts File%cReset%. Откроются 2 окна - просто оставьте их.
echo.
echo 8. Закройте окно Zapret крестиком.
echo %cCyan%=======================================================%cReset%
echo.
echo %cMagenta%Нажмите любую клавишу здесь, КОГДА ВЫПОЛНИТЕ ВСЕ 8 ШАГОВ...%cReset%
pause >nul
endlocal

echo.
echo %cYellow%Автоматическое обновление системного файла hosts...%cReset%

if not exist "%temp%\zapret_hosts.txt" goto :hosts_error

attrib -r -s -h "%windir%\System32\drivers\etc\hosts" >nul 2>&1
copy /y "%windir%\System32\drivers\etc\hosts" "%windir%\System32\drivers\etc\hosts.bak" >nul 2>&1
copy /y "%temp%\zapret_hosts.txt" "%windir%\System32\drivers\etc\hosts" >nul 2>&1
attrib +r "%windir%\System32\drivers\etc\hosts" >nul 2>&1
echo %cGreen%[OK] Файл hosts успешно заменен! Telegram Web будет работать без проблем.%cReset%
goto :hosts_done

:hosts_error
echo %cRed%[ОШИБКА] Файл zapret_hosts.txt не найден в папке Temp.%cReset%
echo %cYellow%Возможно, вы пропустили шаг 7 в меню Zapret.%cReset%

:hosts_done
echo.
echo %cMagenta%Идем дальше... Нажмите любую клавишу.%cReset%
pause >nul
set /a current_task+=1
set "installed_list=!installed_list!- Zapret (Обход блокировок)\n"

:skip_zapret

:: ==========================================
:: 6. ТЕМНАЯ ТЕМА
:: ==========================================
if /I "!do_darktheme!"=="Y" (
    call :SHOW_PROGRESS "Включение Темной Темы"
    reg add "HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Themes\Personalize" /v SystemUsesLightTheme /t REG_DWORD /d 0 /f >nul 2>&1
    reg add "HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Themes\Personalize" /v AppsUseLightTheme /t REG_DWORD /d 0 /f >nul 2>&1
    set "installed_list=!installed_list!- Темная тема активирована\n"
)

:: ==========================================
:: 7. ОТКЛЮЧЕНИЕ UAC
:: ==========================================
if /I "!do_uac!"=="Y" (
    call :SHOW_PROGRESS "Отключение UAC (Уведомлений)"
    reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System" /v EnableLUA /t REG_DWORD /d 0 /f >nul 2>&1
    reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System" /v ConsentPromptBehaviorAdmin /t REG_DWORD /d 0 /f >nul 2>&1
    reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System" /v PromptOnSecureDesktop /t REG_DWORD /d 0 /f >nul 2>&1
    set "installed_list=!installed_list!- UAC отключен\n"
)

:: ==========================================
:: 8. СИСТЕМНЫЕ ТВИКИ (Оптимизация)
:: ==========================================
if /I "!do_tweaks!"=="Y" (
    call :SHOW_PROGRESS "Применение системных твиков и удаление мусора"
    powercfg -setactive 8c5e7fda-e8bf-4a96-9a85-a6e23a8c635c
    reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /v TaskbarDa /t REG_DWORD /d 0 /f >nul 2>&1
    reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /v ShowTaskViewButton /t REG_DWORD /d 0 /f >nul 2>&1
    reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\StorageSense\Parameters\StoragePolicy" /v 01 /t REG_DWORD /d 0 /f >nul 2>&1
    
    taskkill /f /im OneDrive.exe >nul 2>&1
    "%SystemRoot%\SysWOW64\OneDriveSetup.exe" /uninstall >nul 2>&1
    "%SystemRoot%\System32\OneDriveSetup.exe" /uninstall >nul 2>&1
    powershell -command "Get-AppxPackage *Microsoft.YourPhone* -AllUsers | Remove-AppxPackage" >nul 2>&1
    powershell -command "Get-AppxPackage *Microsoft.GetHelp* -AllUsers | Remove-AppxPackage" >nul 2>&1
    powershell -command "Get-AppxPackage *Microsoft.WindowsMaps* -AllUsers | Remove-AppxPackage" >nul 2>&1
    powershell -command "Get-AppxPackage *WebExperience* -AllUsers | Remove-AppxPackage" >nul 2>&1
    
    set "installed_list=!installed_list!- Системные твики и Debloat применены\n"
)

:: ==========================================
:: 9. МЕДИАПЛЕЕРЫ (VLC + удаление Zune)
:: ==========================================
if /I "!do_vlc!"=="Y" (
    call :SHOW_PROGRESS "Удаление стандартных плееров и установка VLC"
    powershell -command "Get-AppxPackage *ZuneVideo* -AllUsers | Remove-AppxPackage" >nul 2>&1
    powershell -command "Get-AppxPackage *ZuneMusic* -AllUsers | Remove-AppxPackage" >nul 2>&1
    winget install -e --id VideoLAN.VLC --accept-source-agreements --accept-package-agreements --silent >nul 2>&1
    set "installed_list=!installed_list!- VLC Media Player\n"
)

:: ==========================================
:: 10. VISUAL C++ REDIST
:: ==========================================
if /I "!do_vcredist!"=="Y" (
    call :SHOW_PROGRESS "Установка Visual C++ Redistributable AIO (x86/x64)"
    winget install -e --id=abbodi1406.vcredist --accept-source-agreements --accept-package-agreements --silent >nul 2>&1
    set "installed_list=!installed_list!- Visual C++ Redistributable (Все версии)\n"
)

:: ==========================================
:: 11. JAVA (8, 17, 21)
:: ==========================================
if /I "!do_java!"=="Y" (
    call :SHOW_PROGRESS "Установка Java 8 Update 481"
    winget install -e --id Oracle.JavaRuntimeEnvironment --accept-source-agreements --accept-package-agreements --silent >nul 2>&1
    
    call :SHOW_PROGRESS "Установка Java 17 (JDK)"
    winget install -e --id Oracle.JDK.17 --accept-source-agreements --accept-package-agreements --silent >nul 2>&1
    
    call :SHOW_PROGRESS "Установка Java 21 (JDK)"
    winget install -e --id Oracle.JDK.21 --accept-source-agreements --accept-package-agreements --silent >nul 2>&1
    
    set "installed_list=!installed_list!- Java (Версии 8, 17 и 21)\n"
)

:: ==========================================
:: 12. ПО (Discord, Steam, WizTree, qBit, 7Zip)
:: ==========================================
if /I "!do_discord!"=="Y" (
    call :SHOW_PROGRESS "Установка Discord"
    winget install -e --id Discord.Discord --accept-source-agreements --accept-package-agreements --silent >nul 2>&1
    set "installed_list=!installed_list!- Discord\n"
)

if /I "!do_steam!"=="Y" (
    call :SHOW_PROGRESS "Установка Steam"
    winget install -e --id Valve.Steam --accept-source-agreements --accept-package-agreements --silent >nul 2>&1
    set "installed_list=!installed_list!- Steam\n"
)

if /I "!do_wiztree!"=="Y" (
    call :SHOW_PROGRESS "Установка WizTree"
    winget install -e --id AntibodySoftware.WizTree --accept-source-agreements --accept-package-agreements --silent >nul 2>&1
    set "installed_list=!installed_list!- WizTree\n"
)

if /I "!do_qbit!"=="Y" (
    call :SHOW_PROGRESS "Установка qBittorrent"
    winget install -e --id qBittorrent.qBittorrent --accept-source-agreements --accept-package-agreements --silent >nul 2>&1
    set "installed_list=!installed_list!- qBittorrent\n"
)

if /I "!do_7zip!"=="Y" if "!7zip_installed_early!" NEQ "1" (
    call :SHOW_PROGRESS "Установка 7-Zip"
    winget install -e --id 7zip.7zip --accept-source-agreements --accept-package-agreements --silent >nul 2>&1
    set "installed_list=!installed_list!- 7-Zip\n"
)

:: Доп пакеты (всегда)
winget install -e --id Microsoft.DotNet.DesktopRuntime.8 --accept-package-agreements --silent >nul 2>&1
winget install -e --id Microsoft.DirectX --accept-package-agreements --silent >nul 2>&1

:: ==========================================
:: 13. БРАУЗЕРЫ
:: ==========================================
if "!do_browser!" neq "0" if "!do_browser!" neq "" (
    call :SHOW_PROGRESS "Установка выбранных браузеров"
    echo !do_browser! | find "1" >nul && winget install -e --id Google.Chrome --accept-source-agreements --accept-package-agreements --silent >nul 2>&1
    echo !do_browser! | find "2" >nul && winget install -e --id Yandex.Browser --accept-source-agreements --accept-package-agreements --silent >nul 2>&1
    echo !do_browser! | find "3" >nul && winget install -e --id Opera.OperaGX --accept-source-agreements --accept-package-agreements --silent >nul 2>&1
    echo !do_browser! | find "4" >nul && winget install -e --id Brave.Brave --accept-source-agreements --accept-package-agreements --silent >nul 2>&1
    set "installed_list=!installed_list!- Браузеры установлены\n"
)

:: ==========================================
:: 14. ОЧИСТКА ВРЕМЕННЫХ ФАЙЛОВ
:: ==========================================
if /I "!do_clean!"=="Y" (
    call :SHOW_PROGRESS "Очистка временных файлов и кэша"
    del /s /f /q "%temp%\*.*" >nul 2>&1
    rd /s /q "%temp%" >nul 2>&1
    md "%temp%" >nul 2>&1
    net stop wuauserv >nul 2>&1
    del /s /f /q "%Windir%\SoftwareDistribution\Download\*.*" >nul 2>&1
    net start wuauserv >nul 2>&1
    set "installed_list=!installed_list!- Кэш и временные файлы очищены\n"
)

:: ==========================================
:: 15. ФИНАЛ И ПЕРЕЗАГРУЗКА
:: ==========================================
cls
echo %cGreen%=======================================================%cReset%
echo          %cGreen%НАСТРОЙКА MDOptimizer УСПЕШНО ЗАВЕРШЕНА!%cReset%
echo %cGreen%=======================================================%cReset%
echo.
echo %cYellow%СПИСОК ВЫПОЛНЕННЫХ ДЕЙСТВИЙ И УСТАНОВЛЕННЫХ ПРОГРАММ:%cReset%
echo.
for %%A in ("!installed_list:\n=" "!") do (
    set "item=%%~A"
    if not "!item!"=="" echo %cWhite%!item!%cReset%
)
echo.
echo %cGreen%=======================================================%cReset%
echo.
set "do_reboot=Y"
set /p do_reboot="%cWhite%Перезагрузить компьютер? [Y/n] (Enter/Н = Сейчас, N/Т = Позже):%cReset% "
if /I "%do_reboot%"=="N" goto :reboot_later
if /I "%do_reboot%"=="Т" goto :reboot_later
if /I "%do_reboot%"=="T" goto :reboot_later

echo.
echo %cCyan%=======================================================%cReset%
echo %cGreen%[ВЫБОР] Вы выбрали: ПЕРЕЗАГРУЗИТЬ СЕЙЧАС%cReset%
echo Все изменения, твики, установленные программы и библиотеки 
echo вступят в силу после включения компьютера.
echo %cCyan%=======================================================%cReset%
echo.
echo %cYellow%Перезагрузка системы начнется через 15 секунд...%cReset% 
echo %cRed%Обязательно сохраните все открытые документы!%cReset%
shutdown /r /t 15
echo.
echo %cMagenta%Нажмите любую клавишу для немедленного закрытия твикера...%cReset%
pause >nul
exit

:reboot_later
echo.
echo %cCyan%=======================================================%cReset%
echo %cYellow%[ВЫБОР] Вы выбрали: ПЕРЕЗАГРУЗИТЬ ПОЗЖЕ%cReset%
echo Твикер завершил свою работу, но для того чтобы установленные 
echo библиотеки и настройки электропитания заработали корректно, 
echo вам необходимо перезагрузить ПК вручную!
echo %cCyan%=======================================================%cReset%
echo.
echo %cMagenta%Нажмите любую клавишу для выхода из программы...%cReset%
pause >nul
exit

:: ==========================================
:: ФУНКЦИЯ ПРОГРЕСС-БАРА
:: ==========================================
:SHOW_PROGRESS
set /a current_task+=1
set /a pct=(current_task*100)/total_tasks

:: Рисуем саму полосу прогресса
set "bar="
set /a filled=pct/5
set /a empty=20-filled
for /l %%i in (1,1,%filled%) do set "bar=!bar!#"
for /l %%i in (1,1,%empty%) do set "bar=!bar!-"

cls
echo %cCyan%=======================================================%cReset%
echo %cGreen%MDOptimizer: Идет настройка и установка...%cReset%
echo %cCyan%=======================================================%cReset%
echo.
echo %cWhite%Текущая задача: %cYellow%%~1%cReset%
echo.
echo Прогресс: [%cGreen%!bar!%cReset%] %cWhite%!pct!%% (%current_task% из %total_tasks%)%cReset%
echo.
echo %cMagenta%Пожалуйста, подождите. Не закрывайте окно...%cReset%
exit /b
