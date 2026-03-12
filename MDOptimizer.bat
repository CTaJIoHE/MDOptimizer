@echo off
:: ВАЖНО: СОХРАНЯЙТЕ ЭТОТ ФАЙЛ СТРОГО В КОДИРОВКЕ UTF-8!
chcp 65001 >nul
title MDOptimizer - Windows 10/11 Ultimate Setup
:: Увеличиваем размер окна по умолчанию, чтобы всё помещалось
mode con: cols=110 lines=42

:: ==========================================
:: ИНИЦИАЛИЗАЦИЯ ЦВЕТОВ (НАДЕЖНЫЙ МЕТОД ИЗ БЭКАПА)
:: ==========================================
:: Принудительно включаем поддержку ANSI-цветов в реестре (для надежности)
reg add HKCU\Console /v VirtualTerminalLevel /t REG_DWORD /d 1 /f >nul 2>&1

:: Классический 100% рабочий метод получения символа ESC (без PowerShell)
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
:: 1. ПРОВЕРКА ПРАВ АДМИНИСТРАТОРА
:: ==========================================
>nul 2>&1 "%SYSTEMROOT%\system32\cacls.exe" "%SYSTEMROOT%\system32\config\system"
if '%errorlevel%' NEQ '0' (
    echo %cYellow%Запрос прав Администратора...%cReset%
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
:: 2. ГЛАВНОЕ МЕНЮ
:: ==========================================
:MainMenu
cls
echo %cCyan%=======================================================%cReset%
echo %cBlue%   __  __ ___   ___        _   _       _              %cReset%
echo %cBlue%  ^|  \/  ^|   \ / _ \ _ __ ^| ^|_(_)_ __ (_)___ ___ _ _  %cReset%
echo %cBlue%  ^| ^|\/^| ^| ^|) ^| (_) ^| '_ \^|  _^| ^| '  \^| ^|_ // -_) '_^| %cReset%
echo %cBlue%  ^|_^|  ^|_^|___/ \___/^| .__/ \__^|_^|_^|_^|_^|_/__^|\___^|_^|   %cReset%
echo %cBlue%                    ^|_^|     %cYellow%[by Mishustin Danil - MDO]%cReset%
echo %cCyan%=======================================================%cReset%
echo.
echo %cYellow%[!] СОВЕТ:%cReset% Если шрифт в этом окне слишком мелкий, 
echo     зажмите клавишу CTRL и покрутите колесико мыши вверх.
echo.
echo %cCyan%=======================================================%cReset%
echo          %cGreen%[1] СПРАВКА (О программе и авторе)%cReset%
echo %cCyan%=======================================================%cReset%
echo.
echo %cWhite%[Enter]%cReset% Начать настройку (Ручной выбор каждого пункта)
echo %cWhite%[Подтверждаю]%cReset% Начать настройку (Полностью автоматический режим)
echo %cCyan%-------------------------------------------------------%cReset%
echo.
set "automode=0"
set "user_input="
set /p user_input="%cWhite%Ввод:%cReset% "

if "%user_input%"=="1" goto HelpMenu
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
echo  - Устанавливает базовый набор ПО: Steam, Discord, qBittorrent, 7-Zip, VLC.
echo  - Обновляет критически важные библиотеки: Java 17, VC++, .NET 8, DirectX.
echo  - Автоматизирует установку Zapret (обход блокировок):
echo    * Сам качает последнюю версию с GitHub на Рабочий стол.
echo    * Дает подробную инструкцию по тестированию и выбору стратегии.
echo    * Вшивает ваши пользовательские списки (lists.zip) и обновляет hosts.
echo  - Очищает систему от мусора (Удаляет OneDrive, Карты, Zune, Виджеты).
echo  - Включает режим максимальной производительности электропитания.
echo.
echo %cYellow%[!] УПРАВЛЕНИЕ:%cReset% Вы можете отвечать на вопросы скрипта 
echo клавишами Y/N на английском, или Н/Т на русской раскладке. 
echo Нажатие Enter всегда означает "Да".
echo.
echo %cRed%ВАЖНОЕ ПРЕДУПРЕЖДЕНИЕ:%cReset%
echo Автор скрипта (Мишустин Данил) лично перепроверил каждую ссылку, 
echo команду и программу. Скрипт не содержит вирусов и вредоносного ПО.
echo Тем не менее, вы используете данное ПО на свой страх и риск, 
echo и берете всю ответственность за изменения в системе на себя.
echo.
echo %cCyan%-------------------------------------------------------%cReset%
echo %cWhite%[2]%cReset% Открыть страницу твикера на GitHub
echo %cWhite%[3]%cReset% Вернуться на главный экран
echo %cCyan%-------------------------------------------------------%cReset%
echo.
set "h_input="
set /p h_input="%cWhite%Ввод:%cReset% "
if "%h_input%"=="2" (
    start https://github.com/MishustinDanil
    goto HelpMenu
)
if "%h_input%"=="3" goto MainMenu
goto HelpMenu


:: ==========================================
:: СТАРТ ОСНОВНОГО ПРОЦЕССА
:: ==========================================
:StartSetup

:: ==========================================
:: 4. АКТИВАЦИЯ WINDOWS (MAS)
:: ==========================================
cls
echo %cCyan%--- Активация Windows ---%cReset%
if "%automode%"=="1" goto :run_mas
set "do_mas=Y"
set /p do_mas="%cWhite%Активировать Windows 10/11? [Y/n] (Enter/Н = Да, N/Т = Пропустить):%cReset% "
if /I "%do_mas%"=="N" goto :skip_mas
if /I "%do_mas%"=="Т" goto :skip_mas
if /I "%do_mas%"=="T" goto :skip_mas

:run_mas
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

:: Умный и безопасный поиск MAS
set "MAS_PATH="
if exist "%~dp0..\..\MAS_AIO.cmd" set "MAS_PATH=%~dp0..\..\MAS_AIO.cmd"
if exist "%~dp0..\MAS_AIO.cmd" set "MAS_PATH=%~dp0..\MAS_AIO.cmd"
if exist "%~dp0MAS_AIO.cmd" set "MAS_PATH=%~dp0MAS_AIO.cmd"
if exist "%~dp0Files\MAS_AIO.cmd" set "MAS_PATH=%~dp0Files\MAS_AIO.cmd"

if not defined MAS_PATH goto :run_mas_online

echo %cGreen%Запуск локального файла MAS_AIO.cmd...%cReset%
start "" cmd /c ""%MAS_PATH%""
goto :mas_started

:run_mas_online
echo %cRed%Локальный файл MAS_AIO.cmd не найден!%cReset%
echo %cYellow%Запуск резервного скрипта активации по прямой ссылке...%cReset%
start "" powershell -NoProfile -Command "irm https://get.activated.win | iex; exit"

:mas_started
echo.
echo %cMagenta%[!] После того как вы активируете систему и ЗАКРОЕТЕ окно MAS,%cReset%
echo %cMagenta%    нажмите любую клавишу здесь, чтобы продолжить работу твикера!%cReset%
pause >nul
echo.
echo %cGreen%[OK] Идем дальше...%cReset%

:skip_mas

:: ==========================================
:: 5. УСТАНОВКА БАЗОВЫХ ПРОГРАММ
:: ==========================================
cls
echo %cCyan%--- Установка программ и библиотек ---%cReset%
if "%automode%"=="1" goto :run_soft
set "do_soft=Y"
set /p do_soft="%cWhite%Установить Steam, Discord, qBit, 7-Zip, VLC, Java 17, VC++, .NET, DirectX? [Y/n] (Enter/Н = Да, N/Т = Пропуск):%cReset% "
if /I "%do_soft%"=="N" goto :skip_soft
if /I "%do_soft%"=="Т" goto :skip_soft
if /I "%do_soft%"=="T" goto :skip_soft

:run_soft
echo %cYellow%Идет установка пакетов в фоне (это займет время)...%cReset%

:: Фикс для общих системных протоколов
reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Internet Settings\WinHttp" /v DefaultSecureProtocols /t REG_DWORD /d 0x00000A00 /f >nul 2>&1
reg add "HKLM\SOFTWARE\Wow6432Node\Microsoft\Windows\CurrentVersion\Internet Settings\WinHttp" /v DefaultSecureProtocols /t REG_DWORD /d 0x00000A00 /f >nul 2>&1

winget install -e --id Valve.Steam --accept-package-agreements --accept-source-agreements --silent
winget install -e --id Discord.Discord --accept-package-agreements --silent
winget install -e --id qBittorrent.qBittorrent --accept-package-agreements --silent
winget install -e --id 7zip.7zip --accept-package-agreements --silent
winget install -e --id VideoLAN.VLC --accept-package-agreements --silent
winget install -e --id Microsoft.VCRedist.2015+.x64 --accept-package-agreements --silent
winget install -e --id Oracle.JavaRuntimeEnvironment --accept-package-agreements --silent
winget install -e --id Microsoft.DotNet.DesktopRuntime.8 --accept-package-agreements --silent
winget install -e --id Microsoft.DirectX --accept-package-agreements --silent
echo %cGreen%[OK] Программы успешно установлены!%cReset%
:skip_soft

:: ==========================================
:: 6. УСТАНОВКА ZAPRET (Обход блокировок)
:: ==========================================
cls
echo %cCyan%--- Настройка обхода блокировок (Zapret) ---%cReset%
if "%automode%"=="1" goto :run_zapret
set "do_zapret=Y"
set /p do_zapret="%cWhite%Скачать Zapret и подготовить инструкцию? [Y/n] (Enter/Н = Да, N/Т = Пропустить):%cReset% "
if /I "%do_zapret%"=="N" goto :skip_zapret
if /I "%do_zapret%"=="Т" goto :skip_zapret
if /I "%do_zapret%"=="T" goto :skip_zapret

:run_zapret
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

echo %cYellow%Подготовка пользовательских списков (lists.zip или .rar)...%cReset%

:: Безопасный поиск списков (Избегаем любых крашей из-за скобок)
set "LISTS_PATH="
set "LISTS_EXT="
if exist "%~dp0..\..\lists.zip" set "LISTS_PATH=%~dp0..\..\lists.zip"&set "LISTS_EXT=zip"
if exist "%~dp0..\..\lists.rar" set "LISTS_PATH=%~dp0..\..\lists.rar"&set "LISTS_EXT=rar"
if exist "%~dp0..\lists.zip" set "LISTS_PATH=%~dp0..\lists.zip"&set "LISTS_EXT=zip"
if exist "%~dp0..\lists.rar" set "LISTS_PATH=%~dp0..\lists.rar"&set "LISTS_EXT=rar"
if exist "%~dp0lists.zip" set "LISTS_PATH=%~dp0lists.zip"&set "LISTS_EXT=zip"
if exist "%~dp0lists.rar" set "LISTS_PATH=%~dp0lists.rar"&set "LISTS_EXT=rar"
if exist "%~dp0Files\lists.zip" set "LISTS_PATH=%~dp0Files\lists.zip"&set "LISTS_EXT=zip"
if exist "%~dp0Files\lists.rar" set "LISTS_PATH=%~dp0Files\lists.rar"&set "LISTS_EXT=rar"

if not defined LISTS_PATH goto :skip_lists_extract

md "%temp%\zap_lists" >nul 2>&1
if "%LISTS_EXT%"=="zip" goto :extract_zip

:extract_rar
if not exist "%ProgramFiles%\7-Zip\7z.exe" goto :no_7zip
"%ProgramFiles%\7-Zip\7z.exe" x "%LISTS_PATH%" -o"%temp%\zap_lists" -y >nul 2>&1
goto :lists_extracted

:no_7zip
echo %cRed%[ОШИБКА] Для распаковки .rar нужен 7-Zip, но он не найден!%cReset%
goto :skip_lists_extract

:extract_zip
powershell -Command "Expand-Archive -Path '%LISTS_PATH%' -DestinationPath '%temp%\zap_lists' -Force" >nul 2>&1

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
if "%automode%"=="0" (
    echo.
    echo %cMagenta%Нажмите любую клавишу для вывода инструкции по Zapret...%cReset%
    pause >nul
)

:: Очищаем экран, чтобы инструкция всегда была полностью видна с самого верха!
cls
echo %cCyan%=======================================================%cReset%
echo %cYellow%ИНСТРУКЦИЯ ПО НАСТРОЙКЕ ZAPRET (Выполните ПОСЛЕ работы твикера):%cReset%
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
echo    (Это значит, что автообновление ВЫКЛЮЧЕНО).
echo.
echo 4. Нажмите %cGreen%[7] Game Filter%cReset% и выберите %cYellow%[1] TCP and UDP%cReset%.
echo    (Это включит фильтр для всех нужных протоколов).
echo.
echo 5. Нажмите %cGreen%[5] IPSet Filter%cReset% и выберите %cYellow%loaded%cReset%.
echo    (ВАЖНО: Это чинит скачивание файлов и сетевые игры вроде Roblox).
echo    %cRed%[!]%cReset% Если при loaded сам Zapret выдает ошибку скачивания:
echo        Временно поставьте none и установите службу (Шаг 6).
echo.
echo 6. Нажмите %cGreen%[1] Install Service%cReset% для установки службы обхода в систему.
echo    Когда программа спросит, какую стратегию использовать, выберите ту,
echo    которую вам выдал тест на шаге 2 (например, general ALT11).
echo.
echo 7. Нажмите %cGreen%[8] Update Hosts File%cReset% (чтобы работал Telegram Web и др.).
echo    Откроется 1 текстовое окно (zapret_hosts.txt) и 1 окно с папкой hosts.
echo    Просто оставьте их открытыми и вернитесь в это окно твикера!
echo.
echo 8. Закройте окно Zapret крестиком.
echo %cCyan%=======================================================%cReset%
echo.

if "%automode%"=="1" goto :skip_zapret_pause

echo %cMagenta%Нажмите любую клавишу здесь, КОГДА ВЫПОЛНИТЕ ВСЕ 8 ШАГОВ...%cReset%
pause >nul

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

:skip_zapret_pause
:skip_zapret

:: ==========================================
:: 7. ОПТИМИЗАЦИЯ И DEBLOAT (Удаление мусора)
:: ==========================================
cls
echo %cCyan%--- Оптимизация системы ---%cReset%
if "%automode%"=="1" goto :run_opt
set "do_opt=Y"
set /p do_opt="%cWhite%Удалить мусор (OneDrive, Виджеты) и вкл. Макс. Производительность? [Y/n] (Enter/Н = Да, N/Т = Пропуск):%cReset% "
if /I "%do_opt%"=="N" goto :skip_opt
if /I "%do_opt%"=="Т" goto :skip_opt
if /I "%do_opt%"=="T" goto :skip_opt

:run_opt
echo %cYellow%Настройка электропитания...%cReset%
powercfg -setactive 8c5e7fda-e8bf-4a96-9a85-a6e23a8c635c

echo %cYellow%Удаление телеметрии и мусорных UWP приложений...%cReset%
taskkill /f /im OneDrive.exe >nul 2>&1
"%SystemRoot%\SysWOW64\OneDriveSetup.exe" /uninstall >nul 2>&1
"%SystemRoot%\System32\OneDriveSetup.exe" /uninstall >nul 2>&1

powershell -command "Get-AppxPackage *Microsoft.YourPhone* -AllUsers | Remove-AppxPackage" >nul 2>&1
powershell -command "Get-AppxPackage *Microsoft.GetHelp* -AllUsers | Remove-AppxPackage" >nul 2>&1
powershell -command "Get-AppxPackage *Microsoft.WindowsMaps* -AllUsers | Remove-AppxPackage" >nul 2>&1
powershell -command "Get-AppxPackage *ZuneVideo* -AllUsers | Remove-AppxPackage" >nul 2>&1
powershell -command "Get-AppxPackage *ZuneMusic* -AllUsers | Remove-AppxPackage" >nul 2>&1
powershell -command "Get-AppxPackage *WebExperience* -AllUsers | Remove-AppxPackage" >nul 2>&1

echo %cGreen%[OK] Система оптимизирована!%cReset%
:skip_opt

:: ==========================================
:: 8. ОЧИСТКА ВРЕМЕННЫХ ФАЙЛОВ
:: ==========================================
cls
echo %cCyan%--- Очистка мусора ---%cReset%
if "%automode%"=="1" goto :run_clean
set "do_clean=Y"
set /p do_clean="%cWhite%Очистить временные файлы и кэш (Рекомендуется)? [Y/n] (Enter/Н = Да, N/Т = Пропустить):%cReset% "
if /I "%do_clean%"=="N" goto :skip_clean
if /I "%do_clean%"=="Т" goto :skip_clean
if /I "%do_clean%"=="T" goto :skip_clean

:run_clean
echo %cYellow%Очистка папки Temp...%cReset%
del /s /f /q "%temp%\*.*" >nul 2>&1
rd /s /q "%temp%" >nul 2>&1
md "%temp%" >nul 2>&1

echo %cYellow%Очистка кэша обновлений Windows...%cReset%
net stop wuauserv >nul 2>&1
del /s /f /q "%Windir%\SoftwareDistribution\Download\*.*" >nul 2>&1
net start wuauserv >nul 2>&1

echo %cGreen%[OK] Диск очищен!%cReset%
:skip_clean

:: ==========================================
:: 9. ФИНАЛ И ПЕРЕЗАГРУЗКА
:: ==========================================
cls
echo %cGreen%=======================================================%cReset%
echo          %cGreen%НАСТРОЙКА MDOptimizer УСПЕШНО ЗАВЕРШЕНА!%cReset%
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
echo библиотеки (DirectX, VC++, .NET) и настройки электропитания 
echo заработали корректно, вам необходимо перезагрузить ПК вручную!
echo %cCyan%=======================================================%cReset%
echo.
echo %cMagenta%Нажмите любую клавишу для выхода из программы...%cReset%
pause >nul