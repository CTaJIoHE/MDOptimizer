@echo off
:: ВАЖНО: СОХРАНЯЙТЕ ЭТОТ ФАЙЛ СТРОГО В КОДИРОВКЕ UTF-8!
set "EXC=!"
setlocal EnableDelayedExpansion

:MD_REAL_START
chcp 65001 >nul
title MDOptimizer v1.2 - Windows 10/11 Ultimate Setup
:: Делаем окно компактным, уютным и фиксированным
mode con: cols=90 lines=40

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
:: ИНИЦИАЛИЗАЦИЯ ЦВЕТОВ И ANSI
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
set "cGray=%ESC%[90m"
set "cReset=%ESC%[0m"

:: Команда для затирания введенной строки
set "UpEr=%ESC%[1A%ESC%[2K"

:: Линии разделителей
set "LineEq=%cCyan%    ================================================================================%cReset%"
set "LineDash=%cCyan%    --------------------------------------------------------------------------------%cReset%"

:: ==========================================
:: ИНИЦИАЛИЗАЦИЯ ШАБЛОНА И СТАТУСОВ
:: ==========================================
set "PresetName=Стандартный"
set "PRESET_do_mas="
set "PRESET_do_zapret="
set "PRESET_do_zapret_lists="
set "PRESET_do_darktheme="
set "PRESET_do_uac="
set "PRESET_do_tweaks="
set "PRESET_do_pagefile="
set "PRESET_do_vcredist="
set "PRESET_do_directx="
set "PRESET_do_java="
set "PRESET_do_discord="
set "PRESET_do_steam="
set "PRESET_do_browser="
set "PRESET_do_wiztree="
set "PRESET_do_qbit="
set "PRESET_do_7zip="
set "PRESET_do_vlc="
set "PRESET_do_clean="

:: Кастомные переменные (Меню 3 и 4)
set "PRESET__Power=0"
set "PRESET__BackApps=1"
set "PRESET__DelOpt=1"
set "PRESET__Edge=1" 
set "PRESET__Tele=1"
set "PRESET__Copilot=1"
set "PRESET__UAC=1"
set "PRESET__Mouse=0" 
set "PRESET__Sticky=1"
set "PRESET__MenuDelay=1"
set "PRESET__WallComp=1"
set "PRESET__RecSec=1" 
set "PRESET__Hiber=0"
set "PRESET__FastBoot=0"
set "PRESET__BitLocker=1"
set "PRESET__Cam=1"
set "PRESET__Dev=1"
set "PRESET__Quick=1"
set "PRESET__Hub=1" 
set "PRESET__CopilotBloat=1"
set "PRESET__Bing=1"
set "PRESET__News=1"
set "PRESET__Teams=1" 
set "PRESET__ToDo=1"
set "PRESET__Outlook=1"
set "PRESET__PowerApp=1"
set "PRESET__StickyApp=1" 
set "PRESET__Clip=1"
set "PRESET__Sound=1"
set "PRESET__Sol=1"
set "PRESET__OneDrive=1"

:: ==========================================
:: 2. ЗАСТАВКА И ИНИЦИАЛИЗАЦИЯ
:: ==========================================
if defined SplashDone goto SkipSplash
set "SplashDone=1"
cls
echo.
echo.
echo.
echo.
echo.
echo.
echo.
echo %cBlue%           __  __ ___   ___        _   _       _               %cReset%
echo %cBlue%          ^|  \/  ^|   \ / _ \ _ __ ^| ^|_(_)_ __ (_)___ ___ _ _  %cReset%
echo %cBlue%          ^| ^|\/^| ^| ^|) ^| (_) ^| '_ \^|  _^| ^| '  \^| ^|_ // -_) '_^| %cReset%
echo %cBlue%          ^|_^|  ^|_^|___/ \___/^| .__/ \__^|_^|_^|_^|_^|_/__^|\___^|_^|   %cReset%
echo %cBlue%                            ^|_^|     %cYellow%[by Mishustin Danil - v1.2]%cReset%
echo.
echo.
<nul set /p="         %cGray%Инициализация системы и сканирование компонентов... %cReset%"

call :CheckOptStatus
call :CheckBloatStatus

echo %cGreen%[OK]%cReset%
powershell -nop -c "Start-Sleep -m 400" >nul 2>&1
goto MainMenu

:SkipSplash
call :CheckOptStatus
call :CheckBloatStatus

:: ==========================================
:: 3. ГЛАВНОЕ МЕНЮ 
:: ==========================================
:MainMenu
mode con: cols=90 lines=40
setlocal DisableDelayedExpansion
set "PresetColor=%cWhite%"
if not "%PresetName%"=="Стандартный" set "PresetColor=%cGreen%"

cls
echo %LineEq%
echo %cBlue%           __  __ ___   ___        _   _       _               %cReset%
echo %cBlue%          ^|  \/  ^|   \ / _ \ _ __ ^| ^|_(_)_ __ (_)___ ___ _ _  %cReset%
echo %cBlue%          ^| ^|\/^| ^| ^|) ^| (_) ^| '_ \^|  _^| ^| '  \^| ^|_ // -_) '_^| %cReset%
echo %cBlue%          ^|_^|  ^|_^|___/ \___/^| .__/ \__^|_^|_^|_^|_^|_/__^|\___^|_^|   %cReset%
echo %cBlue%                            ^|_^|     %cYellow%[by Mishustin Danil - v1.2]%cReset%
echo %LineEq%
echo                  %PresetColor%[ ТЕКУЩИЙ ШАБЛОН: %PresetName% ]%cReset%
echo %LineEq%
echo.
echo     %cYellow%[%EXC%] СОВЕТ:%cReset% Для ручной настройки шаг за шагом просто нажмите Enter.
echo.
echo %LineDash%
echo.
echo          %cWhite%[ 1 ]%cReset%  %cGreen%СПРАВКА%cReset% %cGray%(Детально о функциях и твиках)%cReset%
echo.
echo          %cWhite%[ 2 ]%cReset%  %cYellow%СОСТАВ ШАБЛОНА%cReset% %cGray%(Что будет установлено)%cReset%
echo.
echo          %cWhite%[ 3 ]%cReset%  %cCyan%МЕНЮ: РАСШИРЕННАЯ ОПТИМИЗАЦИЯ%cReset%
echo.
echo          %cWhite%[ 4 ]%cReset%  %cMagenta%МЕНЮ: УДАЛЕНИЕ МУСОРНОГО ПО%cReset%
echo.
echo %LineEq%
echo.
echo     %cWhite%ВЫБЕРИТЕ ДЕЙСТВИЕ:%cReset%
echo.
echo       %cGreen%[ Enter ]%cReset%       %cWhite%Начать базовую установку %cGray%(Ручной выбор)%cReset%
echo.
echo       %cMagenta%[ Подтверждаю ]%cReset% %cWhite%Автоматический режим %cGray%(По шаблону)%cReset%
echo.
echo %LineDash%
echo.
endlocal

set "automode=0"
set "user_input="
set /p user_input="    %cWhite%Ввод:%cReset% "

if "!user_input!"=="1" goto HelpMenu1
if "!user_input!"=="2" goto ShowTemplate1
if "!user_input!"=="3" goto MenuOpt
if "!user_input!"=="4" goto MenuBloat
if /I "!user_input!"=="Подтверждаю" (
    set "automode=1"
    echo.
    echo      %cGreen%[+] Включен автоматический режим!EXC! MDOptimizer сделает все сам.%cReset%
    timeout /t 3 >nul
    goto StartSetup
)
if "!user_input!"=="" (
    set "automode=0"
    goto StartSetup
)
goto MainMenu

:: ==========================================
:: 4. СПРАВКА (ПОСТРАНИЧНАЯ)
:: ==========================================
:HelpMenu1
mode con: cols=90 lines=55
setlocal DisableDelayedExpansion
cls
echo %LineEq%
echo                           %cGreen%СПРАВКА [Страница 1/4: Основные функции]%cReset%
echo %LineEq%
echo.
echo  %cYellow%БАЗОВЫЙ ФУНКЦИОНАЛ:%cReset%
echo.
echo   - %cWhite%Активация (MAS)%cReset%: Надежная HWID активация. Привязывается к железу ПК, 
echo     работает без вирусов и сторонних программ в фоне.
echo.
echo   - %cWhite%ПО и Библиотеки%cReset%: Тихая установка программ через пакетный менеджер Winget
echo     (официальный инструмент Microsoft).
echo.
echo   - %cWhite%DirectX и VCRedist%cReset%: Базовые библиотеки. DirectX скачивается в формате
echo     End-User Runtimes, что критически важно для работы старых игр и движков.
echo.
echo  %cYellow%ОБХОД БЛОКИРОВОК (ZAPRET):%cReset%
echo.
echo   - Скрипт скачивает Zapret в корень диска (C:\Zapret_Bypass) и ставит в исключения.
echo.
echo   - %cWhite%О вирусах и троянах:%cReset% В сети много слухов о зараженных сборках. Это
echo     происходит из-за скачивания с сомнительных сайтов. Наш твикер берет архив
echo     СТРОГО с первоисточника: %cCyan%github.com/Flowseal/zapret-discord-youtube%cReset%
echo.
echo   - %cWhite%Прозрачность:%cReset% Вы можете открыть этот .bat файл через обычный Блокнот
echo     и лично проверить все ссылки. Никакой маскировки кода, только факты.
echo.
echo   - Кастомные списки доменов (lists) умно сливаются со списками автора,
echo     чтобы Telegram Web и Discord работали стабильно и без задержек.
echo.
echo  %cYellow%ОПТИМИЗАЦИЯ И МУСОР (Меню 3 и 4):%cReset%
echo.
echo   - Вы можете сохранить настройки этих меню в свой личный "Авто-шаблон".
echo     Нажмите [2] для перехода к подробному описанию каждого твика.
echo.
echo %LineDash%
echo.
echo     %cWhite%[2]%cReset% След. стр. (Оптимизация: Часть 1)   %cWhite%[4]%cReset% Предложить идею (GitHub)
echo.
echo     %cWhite%[3]%cReset% Страница проекта (GitHub)             %cWhite%[0]%cReset% В Главное меню (или N/Т)
echo.
echo %LineEq%
echo.
endlocal
set "h_input="
set /p h_input="    %cWhite%Ввод:%cReset% "
if "!h_input!"=="2" goto HelpMenu2
if "!h_input!"=="3" start https://github.com/CTaJIoHE/MDOptimizer & goto HelpMenu1
if "!h_input!"=="4" start https://github.com/CTaJIoHE/MDOptimizer/discussions/3 & goto HelpMenu1
if "!h_input!"=="0" goto MainMenu
if /I "!h_input!"=="N" goto MainMenu
if /I "!h_input!"=="Т" goto MainMenu
goto HelpMenu1

:HelpMenu2
mode con: cols=90 lines=55
setlocal DisableDelayedExpansion
cls
echo %LineEq%
echo                       %cCyan%СПРАВКА [Страница 2/4: Твики Оптимизации - Часть 1]%cReset%
echo %LineEq%
echo.
echo  Подробное описание настроек из %cCyan%[ Меню 3 ]%cReset% и ручного режима:
echo.
echo  %cYellow%ПРОИЗВОДИТЕЛЬНОСТЬ И ФАЙЛ ПОДКАЧКИ:%cReset%
echo   * %cWhite%[1] Схема электропитания%cReset%: Режимы "Высокая" и "Максимальная" запрещают
echo     процессору снижать частоты и отключают паркинг ядер. Максимум FPS в играх, 
echo     но на ноутбуках это приведет к более быстрому разряду батареи.
echo.
echo   * %cWhite%[2] Файл подкачки (Виртуальная память)%cReset%: Жизненно важный твик для геймеров.
echo     Если оставить на "Авто", Windows будет менять размер прямо во время игры,
echo     вызывая жесткие статтеры и 100%% загрузку диска.
echo     %cYellow%- Для 8 ГБ ОЗУ:%cReset% Ставим жесткие 16 ГБ. Современным играм не хватает 
echo       памяти, своп спасает от вылетов.
echo     %cCyan%- Для 16 ГБ ОЗУ:%cReset% Ставим 12 ГБ. Идеальный баланс для тяжелых игр (Tarkov, Rust).
echo     %cMagenta%- Для 32+ ГБ ОЗУ:%cReset% Оставляем 8 ГБ. Полностью отключать нельзя (баги в старых движках).
echo.
echo   * %cWhite%[3] Фоновые UWP приложения%cReset%: Windows держит множество UWP-программ в фоне.
echo     Твик убивает эту привычку, экономя от 300 до 600 МБ оперативной памяти.
echo.
echo   * %cWhite%[4] Оптимизация доставки (Обновы)%cReset%: Windows раздает скачанные обновления
echo     другим ПК в интернете (как торрент). Это постоянно нагружает ваш жесткий диск
echo     и сеть, повышая пинг в играх. %cGreen%Строго рекомендуется отключать.%cReset%
echo.
echo   * %cWhite%[5] Ускоренный запуск Edge%cReset%: Выгружает браузер из ОЗУ при его закрытии.
echo     %cRed%ВНИМАНИЕ:%cReset% Отключение этого твика может заблокировать функцию "Использовать 
echo     безопасный DNS" (Secure DNS) в настройках самого браузера Edge.
echo.
echo   * %cWhite%[6-7] Гибернация и Быстрый запуск%cReset%: Удаляет файл hiberfil.sys на гигабайты.
echo     Отключение "Быстрого запуска" лечит многие баги с драйверами, так как ПК
echo     начнет загружаться "чисто", с нуля, а не выходить из забагованного сна.
echo.
echo %LineDash%
echo.
echo     %cWhite%[1]%cReset% Пред. стр. (Базовая)                %cWhite%[3]%cReset% След. стр. (Оптимизация: Часть 2)
echo.
echo     %cWhite%[0]%cReset% Вернуться в Главное меню (или N/Т)
echo.
echo %LineEq%
echo.
endlocal
set "h_input="
set /p h_input="    %cWhite%Ввод:%cReset% "
if "!h_input!"=="1" goto HelpMenu1
if "!h_input!"=="3" goto HelpMenu3
if "!h_input!"=="0" goto MainMenu
if /I "!h_input!"=="N" goto MainMenu
if /I "!h_input!"=="Т" goto MainMenu
goto HelpMenu2

:HelpMenu3
mode con: cols=90 lines=55
setlocal DisableDelayedExpansion
cls
echo %LineEq%
echo                       %cCyan%СПРАВКА [Страница 3/4: Твики Оптимизации - Часть 2]%cReset%
echo %LineEq%
echo.
echo  %cYellow%ПРИВАТНОСТЬ И ИНТЕРФЕЙС:%cReset%
echo   * %cWhite%[8] Телеметрия и реклама%cReset%: Жесткое отключение служб сбора диагностики
echo     (DiagTrack) и встроенной рекламы в Пуске. Ощутимо снижает фоновую нагрузку.
echo.
echo   * %cWhite%[9] Windows Copilot AI%cReset%: Полное отключение ИИ-помощника и его фоновых
echo     процессов. Полезно, если вы не пользуетесь нейросетями от Microsoft.
echo.
echo   * %cWhite%[10] UAC (Уведомления)%cReset%: Отключает бесящее затемнение экрана при запуске
echo     любой программы от им. Администратора. Делает работу за ПК комфортнее.
echo.
echo   * %cWhite%[11] BitLocker (Шифрование)%cReset%: Служба шифрования дисков от Microsoft.
echo     Если вы не агент спецслужб, её работа в фоне только изнашивает SSD и 
echo     снижает скорость чтения/записи до 15%%. Рекомендуется отключать.
echo.
echo   * %cWhite%[12] Задержка открытия меню%cReset%: Твик снижает задержку со стандартных 400 мс 
echo     до 20 мс. Контекстные меню начинают открываться визуально моментально.
echo.
echo   * %cWhite%[13] Качество обоев раб. стола%cReset%: Система всегда сжимает (шакалит до 85%) 
echo     картинку на рабочем столе. Твик возвращает 100%% качество без сжатия.
echo.
echo   * %cWhite%[15] Акселерация мыши%cReset%: Отключает программное ускорение курсора.
echo     %cGreen%Мастхэв для шутеров:%cReset% курсор будет двигаться строго 1:1 с движением руки.
echo.
echo   * %cWhite%Очистка кэша панели задач / Глубокая очистка%cReset%: [T] Лечит баги с "пустыми"
echo     белыми иконками на панели задач. [X] Удаляет гигабайты мусора из папок Temp, 
echo     Prefetch, кэша обновлений и старых логов.
echo.
echo %LineDash%
echo.
echo     %cWhite%[2]%cReset% Пред. стр. (Оптимизация: Часть 1)   %cWhite%[4]%cReset% След. стр. (Удаление мусора)
echo.
echo     %cWhite%[0]%cReset% Вернуться в Главное меню (или N/Т)
echo.
echo %LineEq%
echo.
endlocal
set "h_input="
set /p h_input="    %cWhite%Ввод:%cReset% "
if "!h_input!"=="2" goto HelpMenu2
if "!h_input!"=="4" goto HelpMenu4
if "!h_input!"=="0" goto MainMenu
if /I "!h_input!"=="N" goto MainMenu
if /I "!h_input!"=="Т" goto MainMenu
goto HelpMenu3

:HelpMenu4
mode con: cols=90 lines=55
setlocal DisableDelayedExpansion
cls
echo %LineEq%
echo                           %cMagenta%СПРАВКА [Страница 4/4: Удаление мусора]%cReset%
echo %LineEq%
echo.
echo  Описание настроек из %cMagenta%[ Меню 4 ]%cReset%. Что удалять, а что оставить:
echo.
echo   * %cWhite%Ультимативное удаление [A]%cReset%: Сносит ВЕСЬ список разом. Идеально для 
echo     игровых сборок, где важен каждый мегабайт ОЗУ.
echo.
echo   * %cWhite%Microsoft OneDrive%cReset%: Облачное хранилище. Постоянно висит в фоне,
echo     синхронизирует файлы без спроса, ест интернет-трафик и место на диске. 
echo     Если вы используете Яндекс.Диск или Google Drive — сносите без раздумий.
echo.
echo   * %cWhite%Copilot, Teams, Dev Home%cReset%: Тяжеловесные приложения. Если вы не 
echo     пользуетесь корпоративной средой и ИИ, удаляйте смело. Система "вздохнет".
echo.
echo   * %cWhite%Bing, Feedback Hub, News%cReset%: Маркетинговый мусор. Удаление 
echo     очистит меню Пуск и ускорит локальный системный поиск.
echo.
echo   * %cWhite%Почему тут нет Xbox и Microsoft Store?%cReset% Потому что их удаление часто
echo     ломает системные зависимости, лицензионные игры (Forza, Minecraft). 
echo     Удалять их %cRed%категорически небезопасно%cReset%.
echo.
echo %LineDash%
echo.
echo     %cWhite%[3]%cReset% Пред. страница (Оптимизация: Часть 2)
echo.
echo     %cWhite%[0]%cReset% Вернуться в Главное меню (или N/Т)
echo.
echo %LineEq%
echo.
endlocal
set "h_input="
set /p h_input="    %cWhite%Ввод:%cReset% "
if "!h_input!"=="3" goto HelpMenu3
if "!h_input!"=="0" goto MainMenu
if /I "!h_input!"=="N" goto MainMenu
if /I "!h_input!"=="Т" goto MainMenu
goto HelpMenu4

:: ==========================================
:: 5. СОСТАВ ШАБЛОНА (ПОСТРАНИЧНО)
:: ==========================================
:ShowTemplate1
mode con: cols=90 lines=55
cls
echo %LineEq%
echo                               %cGreen%СОСТАВ ШАБЛОНА: !PresetName! [Стр 1/2]%cReset%
echo %LineEq%
echo.

if "!PresetName!"=="Стандартный" (
    set "PRESET_do_mas=Y" & set "PRESET_do_zapret=Y" & set "PRESET_do_zapret_lists=Y" & set "PRESET_do_darktheme=Y" & set "PRESET_do_uac=N"
    set "PRESET_do_tweaks=A" & set "PRESET_do_pagefile=A" & set "PRESET_do_vcredist=Y" & set "PRESET_do_directx=Y" 
    set "PRESET_do_java=Y" & set "PRESET_do_discord=Y" & set "PRESET_do_steam=Y" & set "PRESET_do_browser=12" 
    set "PRESET_do_wiztree=Y" & set "PRESET_do_qbit=Y" & set "PRESET_do_7zip=Y" & set "PRESET_do_vlc=N" & set "PRESET_do_clean=Y"
)
if /I "!PRESET_do_zapret!"=="Y" set "PRESET_do_7zip=Y"

echo      %cWhite%БАЗОВЫЕ КОМПОНЕНТЫ УСТАНОВКИ:%cReset%
echo.
echo    %cYellow%--- СИСТЕМА И ТВИКИ ---%cReset%
echo.
if /I "!PRESET_do_mas!"=="Y" (echo       %cGreen%[+]%cReset% Активация Windows ^(MAS^)) else (echo       %cRed%[-]%cReset% Активация Windows)
echo.
if /I "!PRESET_do_zapret!"=="Y" (
    if /I "!PRESET_do_zapret_lists!"=="N" (
        echo       %cGreen%[+]%cReset% Установка Zapret ^(Стандартные списки^)
    ) else (
        echo       %cGreen%[+]%cReset% Установка Zapret ^(С кастомными списками^)
    )
) else (
    echo       %cRed%[-]%cReset% Установка Zapret
)
echo.
if /I "!PRESET_do_darktheme!"=="Y" (echo       %cGreen%[+]%cReset% Включение темной темы) else (echo       %cRed%[-]%cReset% Включение темной темы)
echo.
if /I "!PRESET_do_uac!"=="Y" (echo       %cGreen%[+]%cReset% Отключение уведомлений UAC) else (echo       %cRed%[-]%cReset% Отключение уведомлений UAC)
echo.
if /I "!PRESET_do_tweaks!"=="A" (echo       %cGreen%[+]%cReset% Оптимизация: %cYellow%УЛЬТИМАТИВНАЯ ^(Все твики и удаление мусора^)%cReset%) else if /I "!PRESET_do_tweaks!"=="C" (echo       %cGreen%[+]%cReset% Оптимизация: %cCyan%КАСТОМНАЯ ^(См. Страницу 2^)%cReset%) else (echo       %cRed%[-]%cReset% Оптимизация системы пропущена)
echo.
if "!PRESET_do_pagefile!"=="1" (echo       %cGreen%[+]%cReset% Файл подкачки: %cYellow%16 ГБ ^(Для 8 ГБ ОЗУ^)%cReset%) else if "!PRESET_do_pagefile!"=="2" (echo       %cGreen%[+]%cReset% Файл подкачки: %cCyan%12 ГБ ^(Для 16 ГБ ОЗУ^)%cReset%) else if "!PRESET_do_pagefile!"=="3" (echo       %cGreen%[+]%cReset% Файл подкачки: %cMagenta%8 ГБ ^(Для 32+ ГБ ОЗУ^)%cReset%) else (echo       %cGreen%[+]%cReset% Файл подкачки: %cGreen%Автоматически%cReset%)
echo.
echo    %cYellow%--- ПРОГРАММЫ И БИБЛИОТЕКИ ---%cReset%
echo.
if /I "!PRESET_do_vcredist!"=="Y" (echo       %cGreen%[+]%cReset% Установка Visual C++ Redistributable AIO) else (echo       %cRed%[-]%cReset% Установка Visual C++)
echo.
if /I "!PRESET_do_directx!"=="Y" (echo       %cGreen%[+]%cReset% Установка DirectX ^(End-User Runtimes^)) else (echo       %cRed%[-]%cReset% Установка DirectX)
echo.
if /I "!PRESET_do_java!"=="Y" (echo       %cGreen%[+]%cReset% Установка Java ^(8, 17, 21^)) else (echo       %cRed%[-]%cReset% Установка Java)
echo.
if /I "!PRESET_do_discord!"=="Y" (echo       %cGreen%[+]%cReset% Установка Discord) else (echo       %cRed%[-]%cReset% Установка Discord)
echo.
if /I "!PRESET_do_steam!"=="Y" (echo       %cGreen%[+]%cReset% Установка Steam) else (echo       %cRed%[-]%cReset% Установка Steam)
echo.
set "b1=" & set "b2=" & set "b3=" & set "b4="
if "!PRESET_do_browser!"=="0" goto :skip_b_parse
if "!PRESET_do_browser!"=="" goto :skip_b_parse
echo !PRESET_do_browser! | find "1" >nul 2>&1 && set "b1=%cBlue%G%cRed%o%cYellow%o%cBlue%g%cGreen%l%cRed%e %cRed%C%cYellow%h%cGreen%r%cBlue%o%cRed%m%cYellow%e%cReset% | "
echo !PRESET_do_browser! | find "2" >nul 2>&1 && set "b2=%cWhite%Yandex Browser%cReset% | "
echo !PRESET_do_browser! | find "3" >nul 2>&1 && set "b3=%cRed%Opera GX%cReset% | "
echo !PRESET_do_browser! | find "4" >nul 2>&1 && set "b4=%cYellow%Brave%cReset% | "
:skip_b_parse
set "b_list=!b1!!b2!!b3!!b4!"
if "!b_list!"=="" (
    echo       %cRed%[-]%cReset% Браузеры: %cYellow%Не устанавливать%cReset%
) else (
    set "b_list=!b_list:~0,-3!"
    echo       %cGreen%[*]%cReset% Браузеры: !b_list!
)
echo.
if /I "!PRESET_do_wiztree!"=="Y" (echo       %cGreen%[+]%cReset% Установка WizTree) else (echo       %cRed%[-]%cReset% Установка WizTree)
echo.
if /I "!PRESET_do_qbit!"=="Y" (echo       %cGreen%[+]%cReset% Установка qBittorrent) else (echo       %cRed%[-]%cReset% Установка qBittorrent)
echo.
if /I "!PRESET_do_7zip!"=="Y" (echo       %cGreen%[+]%cReset% Установка 7-Zip и WinRAR) else (echo       %cRed%[-]%cReset% Установка архиваторов)
echo.
if /I "!PRESET_do_vlc!"=="Y" (echo       %cGreen%[+]%cReset% Замена плееров Win11 на VLC) else (echo       %cRed%[-]%cReset% Замена плееров Win11 на VLC)
echo.
if /I "!PRESET_do_clean!"=="Y" (echo       %cGreen%[+]%cReset% Очистка временных файлов после установки) else (echo       %cRed%[-]%cReset% Очистка временных файлов)
echo.
echo %LineDash%
echo.
echo      %cWhite%[2]%cReset% След. страница (Кастомная оптимизация)
echo.
echo      %cWhite%[0]%cReset% Вернуться на главный экран %cGray%(или нажмите N/Т)%cReset%
echo.
echo %LineEq%
echo.
set "s_input="
set /p s_input="    %cWhite%Ввод:%cReset% "
if "!s_input!"=="2" goto ShowTemplate2
if "!s_input!"=="0" goto MainMenu
if /I "!s_input!"=="N" goto MainMenu
if /I "!s_input!"=="Т" goto MainMenu
goto ShowTemplate1

:ShowTemplate2
mode con: cols=90 lines=55
cls
echo %LineEq%
echo                               %cGreen%СОСТАВ ШАБЛОНА: !PresetName! [Стр 2/2]%cReset%
echo %LineEq%
echo.
if "!PresetName!"=="Стандартный" (
    echo  %cYellow%Внимание:%cReset% В "Стандартном" шаблоне по умолчанию включена 
    echo  %cYellow%Ультимативная%cReset% оптимизация. Это значит, что будут применены 
    echo  АБСОЛЮТНО ВСЕ твики и удалены ВСЕ мусорные приложения.
    echo.
    echo  Если вы хотите выборочную настройку — создайте свой шаблон
    echo  через ручной режим, выбрав тип оптимизации [C].
) else (
    echo      %cWhite%КАСТОМНЫЕ ПАРАМЕТРЫ ^(Из Меню 3 и 4^) В ДАННОМ ШАБЛОНЕ:%cReset%
    echo.
    if "!PRESET__Tele!"=="0" (echo       %cGreen%[+]%cReset% Телеметрия: Отключена) else (echo       %cRed%[-]%cReset% Телеметрия: Оставлена)
    echo.
    if "!PRESET__BackApps!"=="0" (echo       %cGreen%[+]%cReset% Фоновые UWP: Отключены) else (echo       %cRed%[-]%cReset% Фоновые UWP: Работают)
    echo.
    if "!PRESET__BitLocker!"=="0" (echo       %cGreen%[+]%cReset% Служба BitLocker: Отключена) else (echo       %cRed%[-]%cReset% Служба BitLocker: Включена)
    echo.
    if "!PRESET__Copilot!"=="0" (echo       %cGreen%[+]%cReset% ИИ Copilot: Отключен) else (echo       %cRed%[-]%cReset% ИИ Copilot: Оставлен)
    echo.
    if "!PRESET__OneDrive!"=="0" (echo       %cGreen%[+]%cReset% MS OneDrive: Удален) else (echo       %cRed%[-]%cReset% MS OneDrive: Оставлен)
    echo.
    if "!PRESET__Bing!"=="0" (echo       %cGreen%[+]%cReset% Поиск Bing: Удален) else (echo       %cRed%[-]%cReset% Поиск Bing: Оставлен)
    echo.
    echo       %cGray%*Остальные параметры подтягиваются автоматически.%cReset%
)

echo.
echo %LineDash%
echo.
echo      %cWhite%[1]%cReset% Пред. страница (Базовые программы)
echo.
echo      %cWhite%[0]%cReset% Вернуться на главный экран %cGray%(или нажмите N/Т)%cReset%
echo.
echo %LineEq%
echo.
set "s_input="
set /p s_input="    %cWhite%Ввод:%cReset% "
if "!s_input!"=="1" goto ShowTemplate1
if "!s_input!"=="0" goto MainMenu
if /I "!s_input!"=="N" goto MainMenu
if /I "!s_input!"=="Т" goto MainMenu
goto ShowTemplate2

:: ==========================================
:: 6. МЕНЮ 3: РАСШИРЕННАЯ ОПТИМИЗАЦИЯ
:: ==========================================
:MenuOpt
mode con: cols=90 lines=65
:OptLoop
cls
call :CheckOptStatus

set "s1=%cRed%Сбалансированная%cReset%"
if "!_Power!"=="1" set "s1=%cGreen%Выс. Производительность%cReset%"
if "!_Power!"=="2" set "s1=%cCyan%Максимальная%cReset%"

set "s_pf=%cRed%Неизвестно%cReset%"
if "!_Pagefile!"=="A" set "s_pf=%cGreen%Автоматически%cReset%"
if "!_Pagefile!"=="1" set "s_pf=%cYellow%16 ГБ (Жесткий)%cReset%"
if "!_Pagefile!"=="2" set "s_pf=%cCyan%12 ГБ (Жесткий)%cReset%"
if "!_Pagefile!"=="3" set "s_pf=%cMagenta%8 ГБ (Жесткий)%cReset%"
if "!_Pagefile!"=="C" set "s_pf=%cGray%Кастомный%cReset%"

if "!_BackApps!"=="1" (set "s3=%cRed%Включены%cReset%") else (set "s3=%cGreen%Отключены%cReset%")
if "!_DelOpt!"=="1" (set "s4=%cRed%Включена%cReset%") else (set "s4=%cGreen%Отключена%cReset%")
if "!_Edge!"=="1" (set "s5=%cRed%Включен%cReset%") else (set "s5=%cGreen%Отключен%cReset%")
if "!_Hiber!"=="1" (set "s6=%cRed%Включена%cReset%") else (set "s6=%cGreen%Отключена%cReset%")
if "!_FastBoot!"=="1" (set "s7=%cRed%Включен%cReset%") else (set "s7=%cGreen%Отключен%cReset%")
if "!_Tele!"=="1" (set "s8=%cRed%Включены%cReset%") else (set "s8=%cGreen%Отключены%cReset%")
if "!_Copilot!"=="1" (set "s9=%cRed%Включен%cReset%") else (set "s9=%cGreen%Отключен%cReset%")
if "!_UAC!"=="1" (set "s10=%cRed%Включен%cReset%") else (set "s10=%cGreen%Отключен%cReset%")
if "!_BitLocker!"=="1" (set "s11=%cRed%Включена%cReset%") else (set "s11=%cGreen%Отключена%cReset%")
if "!_MenuDelay!"=="1" (set "s12=%cRed%400 мс (Стандарт)%cReset%") else (set "s12=%cGreen%20 мс (Быстро)%cReset%")
if "!_WallComp!"=="1" (set "s13=%cRed%Сжатие вкл.%cReset%") else (set "s13=%cGreen%Без сжатия (100%%)%cReset%")
if "!_RecSec!"=="1" (set "s14=%cRed%Отображаются%cReset%") else (set "s14=%cGreen%Скрыты%cReset%")
if "!_Mouse!"=="1" (set "s15=%cRed%Включена%cReset%") else (set "s15=%cGreen%Отключена%cReset%")
if "!_Sticky!"=="1" (set "s16=%cRed%Включено%cReset%") else (set "s16=%cGreen%Отключено%cReset%")

echo %LineEq%
echo                       %cCyan%РАСШИРЕННАЯ ОПТИМИЗАЦИЯ СИСТЕМЫ%cReset%
echo %LineEq%
echo.
echo    %cYellow%--- ПРОИЗВОДИТЕЛЬНОСТЬ ---%cReset%
echo.
echo    [1] Схема электропитания             : !s1!
echo.
echo    [2] Файл подкачки (Своп)             : !s_pf!
echo.
echo    [3] Фоновые UWP приложения           : !s3!
echo.
echo    [4] Оптимизация доставки (Обновы)    : !s4!
echo.
echo    [5] Ускоренный запуск Edge           : !s5!
echo.
echo    [6] Гибернация                       : !s6!
echo.
echo    [7] Быстрый запуск (Fast Boot)       : !s7!
echo.
echo    %cYellow%--- ПРИВАТНОСТЬ И БЕЗОПАСНОСТЬ ---%cReset%
echo.
echo    [8] Телеметрия и реклама             : !s8!
echo.
echo    [9] Windows Copilot AI               : !s9!
echo.
echo    [10] UAC (Контроль учетных записей)  : !s10!
echo.
echo    [11] Служба BitLocker (Шифрование)   : !s11!
echo.
echo    %cYellow%--- ИНТЕРФЕЙС И УДОБСТВО ---%cReset%
echo.
echo    [12] Задержка открытия меню          : !s12!
echo.
echo    [13] Качество обоев раб. стола       : !s13!
echo.
echo    [14] Раздел "Рекомендуем" (Пуск)     : !s14!
echo.
echo    [15] Акселерация мыши                : !s15!
echo.
echo    [16] Залипание клавиш                : !s16!
echo.
echo %LineDash%
echo    %cWhite%[T]%cReset% %cYellow%Очистить кэш панели задач%cReset%     %cWhite%[X]%cReset% %cYellow%Глубокая очистка системы%cReset%
echo %LineDash%
echo.
echo    %cWhite%[A]%cReset% %cGreen%ПРИМЕНИТЬ ВСЕ ТВИКИ СРАЗУ%cReset%       %cWhite%[D]%cReset% %cRed%СБРОСИТЬ ПО УМОЛЧАНИЮ%cReset%
echo.
echo    %cWhite%[0]%cReset% Вернуться в Главное меню %cGray%(* Файл подкачки настраивается отдельно)%cReset%
echo.
set /p "c=    %cWhite%Ввод:%cReset% "

if "!c!"=="0" goto MainMenu
if /i "!c!"=="N" goto MainMenu
if /i "!c!"=="Т" goto MainMenu
if /i "!c!"=="A" goto ApplyAllOpt
if /i "!c!"=="D" goto RestoreAllOpt
if /i "!c!"=="T" goto Action_TaskbarOpt
if /i "!c!"=="X" goto Action_CleanupOpt
if "!c!"=="1" goto TogglePower
if "!c!"=="2" goto MenuPagefile
if "!c!"=="3" goto ToggleBackApps
if "!c!"=="4" goto ToggleDelOpt
if "!c!"=="5" goto ToggleEdge
if "!c!"=="6" goto ToggleHiber
if "!c!"=="7" goto ToggleFastBoot
if "!c!"=="8" goto ToggleTele
if "!c!"=="9" goto ToggleCopilotOpt
if "!c!"=="10" goto ToggleUAC
if "!c!"=="11" goto ToggleBitLocker
if "!c!"=="12" goto ToggleMenuDelay
if "!c!"=="13" goto ToggleWall
if "!c!"=="14" goto ToggleRec
if "!c!"=="15" goto ToggleMouse
if "!c!"=="16" goto ToggleSticky
goto OptLoop

:TogglePower
if "!_Power!"=="0" goto Power_High
if "!_Power!"=="1" goto Power_Ult
goto Power_Bal
:Power_High
powershell -NoProfile -Command "$schemes = powercfg /l | Where-Object { $_ -match '8c5e7fda-e8bf-4a96-9a85-a6e23a8c635c|High|\u0412\u044b\u0441\u043e\u043a\u0430\u044f' }; if (-not $schemes) { $new = powercfg -duplicatescheme 8c5e7fda-e8bf-4a96-9a85-a6e23a8c635c; $guid = $new -replace '.*([0-9a-f]{8}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{12}).*', '$1'; powercfg /setactive $guid } else { $keep = $schemes | Select-Object -First 1; $guid = $keep -replace '.*([0-9a-f]{8}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{12}).*', '$1'; powercfg /setactive $guid }" >nul 2>&1
goto OptLoop
:Power_Ult
powershell -NoProfile -Command "$schemes = powercfg /l | Where-Object { $_ -match 'e9a42b02-d5df-448d-aa00-03f14749eb61|Ultimate|\u041c\u0430\u043a\u0441\u0438\u043c\u0430\u043b\u044c\u043d\u0430\u044f' }; if (-not $schemes) { $new = powercfg -duplicatescheme e9a42b02-d5df-448d-aa00-03f14749eb61; $guid = $new -replace '.*([0-9a-f]{8}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{12}).*', '$1'; powercfg /setactive $guid } else { $keep = $schemes | Select-Object -First 1; $guid = $keep -replace '.*([0-9a-f]{8}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{12}).*', '$1'; powercfg /setactive $guid }" >nul 2>&1
goto OptLoop
:Power_Bal
powershell -NoProfile -Command "$schemes = powercfg /l | Where-Object { $_ -match '381b4222-f694-41f0-9685-ff5bb260df2e|Balanced|\u0421\u0431\u0430\u043b\u0430\u043d\u0441\u0438\u0440\u043e\u0432\u0430\u043d\u043d\u0430\u044f' }; if (-not $schemes) { $new = powercfg -duplicatescheme 381b4222-f694-41f0-9685-ff5bb260df2e; $guid = $new -replace '.*([0-9a-f]{8}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{12}).*', '$1'; powercfg /setactive $guid } else { $keep = $schemes | Select-Object -First 1; $guid = $keep -replace '.*([0-9a-f]{8}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{12}).*', '$1'; powercfg /setactive $guid }" >nul 2>&1
goto OptLoop

:ToggleBackApps
if "!_BackApps!"=="0" goto BackApps_Enable
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\BackgroundAccessApplications" /v GlobalUserDisabled /t REG_DWORD /d 1 /f >nul
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Search" /v BackgroundAppGlobalToggle /t REG_DWORD /d 0 /f >nul
reg add "HKLM\SYSTEM\CurrentControlSet\Services\embeddedmode" /v Start /t REG_DWORD /d 4 /f >nul
goto OptLoop
:BackApps_Enable
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\BackgroundAccessApplications" /v GlobalUserDisabled /t REG_DWORD /d 0 /f >nul
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Search" /v BackgroundAppGlobalToggle /t REG_DWORD /d 1 /f >nul
reg add "HKLM\SYSTEM\CurrentControlSet\Services\embeddedmode" /v Start /t REG_DWORD /d 3 /f >nul
goto OptLoop

:ToggleDelOpt
if "!_DelOpt!"=="0" goto DelOpt_Enable
cmd /c "reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\DeliveryOptimization" /v DODownloadMode /t REG_DWORD /d 0 /f" >nul 2>&1
cmd /c "sc config DoSvc start= disabled" >nul 2>&1
cmd /c "net stop DoSvc" >nul 2>&1
goto OptLoop
:DelOpt_Enable
cmd /c "reg delete "HKLM\SOFTWARE\Policies\Microsoft\Windows\DeliveryOptimization" /v DODownloadMode /f" >nul 2>&1
cmd /c "sc config DoSvc start= demand" >nul 2>&1
cmd /c "net start DoSvc" >nul 2>&1
goto OptLoop

:ToggleEdge
if "!_Edge!"=="0" goto Edge_Enable
reg add "HKLM\SOFTWARE\Policies\Microsoft\Edge" /v StartupBoostEnabled /t REG_DWORD /d 0 /f >nul 2>&1
reg add "HKLM\SOFTWARE\Policies\Microsoft\Edge" /v BackgroundModeEnabled /t REG_DWORD /d 0 /f >nul 2>&1
goto OptLoop
:Edge_Enable
reg delete "HKLM\SOFTWARE\Policies\Microsoft\Edge" /v StartupBoostEnabled /f >nul 2>&1
reg delete "HKLM\SOFTWARE\Policies\Microsoft\Edge" /v BackgroundModeEnabled /f >nul 2>&1
goto OptLoop

:ToggleTele
if "!_Tele!"=="0" goto Tele_Enable
sc config DiagTrack start= disabled >nul 2>&1
sc stop DiagTrack >nul 2>&1
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\DataCollection" /v AllowTelemetry /t REG_DWORD /d 0 /f >nul 2>&1
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\UserProfileEngagement" /v ScoobeSystemSettingEnabled /t REG_DWORD /d 0 /f >nul 2>&1
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\ContentDeliveryManager" /v SubscribedContent-338389Enabled /t REG_DWORD /d 0 /f >nul 2>&1
goto OptLoop
:Tele_Enable
sc config DiagTrack start= auto >nul 2>&1
sc start DiagTrack >nul 2>&1
reg delete "HKLM\SOFTWARE\Policies\Microsoft\Windows\DataCollection" /v AllowTelemetry /f >nul 2>&1
reg delete "HKCU\Software\Microsoft\Windows\CurrentVersion\UserProfileEngagement" /v ScoobeSystemSettingEnabled /f >nul 2>&1
reg delete "HKCU\Software\Microsoft\Windows\CurrentVersion\ContentDeliveryManager" /v SubscribedContent-338389Enabled /f >nul 2>&1
goto OptLoop

:ToggleCopilotOpt
if "!_Copilot!"=="0" goto Copilot_Enable
reg add "HKCU\SOFTWARE\Policies\Microsoft\Windows\WindowsCopilot" /v TurnOffWindowsCopilot /t REG_DWORD /d 1 /f >nul 2>&1
reg add "HKCU\SOFTWARE\Policies\Microsoft\Windows\WindowsAI" /v DisableAIDataAnalysis /t REG_DWORD /d 1 /f >nul 2>&1
goto OptLoop
:Copilot_Enable
reg delete "HKCU\SOFTWARE\Policies\Microsoft\Windows\WindowsCopilot" /v TurnOffWindowsCopilot /f >nul 2>&1
reg delete "HKCU\SOFTWARE\Policies\Microsoft\Windows\WindowsAI" /v DisableAIDataAnalysis /f >nul 2>&1
goto OptLoop

:ToggleUAC
if "!_UAC!"=="0" goto UAC_Enable
reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System" /v PromptOnSecureDesktop /t REG_DWORD /d 0 /f >nul 2>&1
reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System" /v ConsentPromptBehaviorAdmin /t REG_DWORD /d 0 /f >nul 2>&1
reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System" /v EnableLUA /t REG_DWORD /d 1 /f >nul 2>&1
goto OptLoop
:UAC_Enable
reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System" /v PromptOnSecureDesktop /t REG_DWORD /d 1 /f >nul 2>&1
reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System" /v ConsentPromptBehaviorAdmin /t REG_DWORD /d 5 /f >nul 2>&1
reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System" /v EnableLUA /t REG_DWORD /d 1 /f >nul 2>&1
goto OptLoop

:ToggleMouse
if "!_Mouse!"=="0" goto Mouse_Enable
reg add "HKCU\Control Panel\Mouse" /v MouseSpeed /t REG_SZ /d 0 /f >nul
reg add "HKCU\Control Panel\Mouse" /v MouseThreshold1 /t REG_SZ /d 0 /f >nul
reg add "HKCU\Control Panel\Mouse" /v MouseThreshold2 /t REG_SZ /d 0 /f >nul
powershell -NoProfile -Command "$code='using System.Runtime.InteropServices; public class W32 { [DllImport(\"user32.dll\")] public static extern bool SystemParametersInfo(uint a, uint b, int[] c, uint d); }'; Add-Type -TypeDefinition $code; $p=[int[]]@(0,0,0); [W32]::SystemParametersInfo(4,0,$p,3)" >nul 2>&1
goto OptLoop
:Mouse_Enable
reg add "HKCU\Control Panel\Mouse" /v MouseSpeed /t REG_SZ /d 1 /f >nul
reg add "HKCU\Control Panel\Mouse" /v MouseThreshold1 /t REG_SZ /d 6 /f >nul
reg add "HKCU\Control Panel\Mouse" /v MouseThreshold2 /t REG_SZ /d 10 /f >nul
powershell -NoProfile -Command "$code='using System.Runtime.InteropServices; public class W32 { [DllImport(\"user32.dll\")] public static extern bool SystemParametersInfo(uint a, uint b, int[] c, uint d); }'; Add-Type -TypeDefinition $code; $p=[int[]]@(6,10,1); [W32]::SystemParametersInfo(4,0,$p,3)" >nul 2>&1
goto OptLoop

:ToggleSticky
if "!_Sticky!"=="0" goto Sticky_Enable
reg add "HKCU\Control Panel\Accessibility\StickyKeys" /v Flags /t REG_SZ /d 506 /f >nul 2>&1
reg add "HKCU\Control Panel\Accessibility\Keyboard Response" /v Flags /t REG_SZ /d 122 /f >nul 2>&1
reg add "HKCU\Control Panel\Accessibility\ToggleKeys" /v Flags /t REG_SZ /d 58 /f >nul 2>&1
goto OptLoop
:Sticky_Enable
reg add "HKCU\Control Panel\Accessibility\StickyKeys" /v Flags /t REG_SZ /d 510 /f >nul 2>&1
reg add "HKCU\Control Panel\Accessibility\Keyboard Response" /v Flags /t REG_SZ /d 126 /f >nul 2>&1
reg add "HKCU\Control Panel\Accessibility\ToggleKeys" /v Flags /t REG_SZ /d 62 /f >nul 2>&1
goto OptLoop

:ToggleMenuDelay
if "!_MenuDelay!"=="0" goto MenuDelay_Enable
reg add "HKCU\Control Panel\Desktop" /v MenuShowDelay /t REG_SZ /d 20 /f >nul 2>&1
goto RestartExplorerOpt
:MenuDelay_Enable
reg add "HKCU\Control Panel\Desktop" /v MenuShowDelay /t REG_SZ /d 400 /f >nul 2>&1
goto RestartExplorerOpt

:ToggleWall
if "!_WallComp!"=="0" goto Wall_Enable
reg add "HKCU\Control Panel\Desktop" /v JPEGImportQuality /t REG_DWORD /d 100 /f >nul 2>&1
goto RestartExplorerOpt
:Wall_Enable
reg delete "HKCU\Control Panel\Desktop" /v JPEGImportQuality /f >nul 2>&1
goto RestartExplorerOpt

:ToggleRec
if "!_RecSec!"=="0" goto Rec_Enable
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\Explorer" /v HideRecommendedSection /t REG_DWORD /d 1 /f >nul 2>&1
reg add "HKLM\SOFTWARE\Microsoft\PolicyManager\current\device\Start" /v HideRecommendedSection /t REG_DWORD /d 1 /f >nul 2>&1
reg add "HKLM\SOFTWARE\Microsoft\PolicyManager\current\device\Education" /v IsEducationEnvironment /t REG_DWORD /d 1 /f >nul 2>&1
goto RestartExplorerOpt
:Rec_Enable
reg delete "HKLM\SOFTWARE\Policies\Microsoft\Windows\Explorer" /v HideRecommendedSection /f >nul 2>&1
reg delete "HKLM\SOFTWARE\Microsoft\PolicyManager\current\device\Start" /v HideRecommendedSection /f >nul 2>&1
reg delete "HKLM\SOFTWARE\Microsoft\PolicyManager\current\device\Education" /v IsEducationEnvironment /f >nul 2>&1
goto RestartExplorerOpt

:ToggleHiber
if "!_Hiber!"=="0" goto Hiber_Enable
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\Power" /v HiberbootEnabled /t REG_DWORD /d 0 /f >nul 2>&1
powercfg /h off >nul 2>&1
goto OptLoop
:Hiber_Enable
powercfg /h on >nul 2>&1
goto OptLoop

:ToggleFastBoot
if "!_FastBoot!"=="0" goto FastBoot_Enable
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\Power" /v HiberbootEnabled /t REG_DWORD /d 0 /f >nul 2>&1
goto OptLoop
:FastBoot_Enable
powercfg /h on >nul 2>&1
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\Power" /v HiberbootEnabled /t REG_DWORD /d 1 /f >nul 2>&1
goto OptLoop

:ToggleBitLocker
if "!_BitLocker!"=="0" goto BitLocker_Enable
manage-bde -off %SystemDrive% >nul 2>&1
sc config BDESVC start= disabled >nul 2>&1
net stop BDESVC >nul 2>&1
goto OptLoop
:BitLocker_Enable
sc config BDESVC start= demand >nul 2>&1
goto OptLoop

:MenuPagefile
cls
echo %LineEq%
echo                       %cCyan%НАСТРОЙКА ФАЙЛА ПОДКАЧКИ (СВОП)%cReset%
echo %LineEq%
echo.
echo  %cYellow%Факты:%cReset% Игры вроде Rust, Tarkov или MSFS 2020 могут требовать до 24-32 ГБ
echo  общей памяти (ОЗУ + Подкачка). Если оставить систему управлять размером
echo  автоматически, она будет расширять файл прямо во время игры, что
echo  гарантированно вызовет фризы и 100%% загрузку диска.
echo.
echo    %cWhite%[1]%cReset% - %cYellow%16 ГБ%cReset% (Идеально для систем с 8 ГБ ОЗУ)
echo    %cWhite%[2]%cReset% - %cCyan%12 ГБ%cReset% (Золотой стандарт для 16 ГБ ОЗУ)
echo    %cWhite%[3]%cReset% - %cMagenta%8 ГБ%cReset% (Оптимально для 32+ ГБ ОЗУ)
echo    %cWhite%[A]%cReset% - %cGreen%Автоматически%cReset% (Вернуть управление Windows)
echo.
echo    %cWhite%[0]%cReset% Отмена (Вернуться назад)
echo.
set /p "pf_choice=    %cWhite%Ваш выбор:%cReset% "

if "!pf_choice!"=="0" goto OptLoop
if "!pf_choice!"=="1" set "pf_sz=16384" & set "pf_txt=16 ГБ" & goto ConfirmPagefile
if "!pf_choice!"=="2" set "pf_sz=12288" & set "pf_txt=12 ГБ" & goto ConfirmPagefile
if "!pf_choice!"=="3" set "pf_sz=8192" & set "pf_txt=8 ГБ" & goto ConfirmPagefile
if /i "!pf_choice!"=="A" set "pf_sz=Auto" & set "pf_txt=Автоматически" & goto ConfirmPagefile
goto MenuPagefile

:ConfirmPagefile
echo.
echo  Вы выбрали: %cGreen%!pf_txt!%cReset%
set /p "pf_conf=  Применить эти настройки? [Y/n]: "
if /i "!pf_conf!"=="N" goto MenuPagefile

echo.
echo  %cYellow%Применение настроек...%cReset%
if "!pf_sz!"=="Auto" (
    wmic computersystem where name="%computername%" set AutomaticManagedPagefile=True >nul 2>&1
) else (
    wmic computersystem where name="%computername%" set AutomaticManagedPagefile=False >nul 2>&1
    wmic pagefilesetting where name="C:\\pagefile.sys" set InitialSize=!pf_sz!,MaximumSize=!pf_sz! >nul 2>&1
    if errorlevel 1 powershell -Command "Set-CimInstance -Query 'Select * from Win32_PageFileSetting where name=\"C:\\\\pagefile.sys\"' -Property @{InitialSize=!pf_sz!; MaximumSize=!pf_sz!}" >nul 2>&1
)
echo  %cGreen%Готово!%cReset%
echo.
echo  %cRed%[!EXC!] ВАЖНО:%cReset% Для того, чтобы новый размер файла подкачки вступил в силу,
echo  необходимо перезагрузить компьютер. Ядро Windows должно пересоздать файл
echo  pagefile.sys при старте системы.
echo.
set /p "pf_reboot=  Перезагрузить ПК сейчас? [Y/n]: "
if /i "!pf_reboot!"=="Y" (
    shutdown /r /t 5
    exit
)
goto OptLoop

:Action_TaskbarOpt
reg delete "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\Taskband" /v Favorites /f >nul 2>&1
reg delete "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\Taskband" /v FavoritesResolve /f >nul 2>&1
goto RestartExplorerOpt

:Action_CleanupOpt
cls
echo.
echo  %cYellow%Глубокая очистка системы...%cReset%
echo  ----------------------------------------------
call :CleanStepOpt "%temp%" "Пользовательские временные файлы (Temp)"
call :CleanStepOpt "%windir%\Temp" "Системные временные файлы"
call :CleanStepOpt "%windir%\Prefetch" "Папка Prefetch"
echo.
echo  Кэш обновлений Windows:
net stop wuauserv >nul 2>&1
net stop bits >nul 2>&1
call :CalcAndCleanOpt "%windir%\SoftwareDistribution\Download"
net start wuauserv >nul 2>&1
net start bits >nul 2>&1
call :CleanStepOpt "%localappdata%\D3DSCache" "Кэш шейдеров DirectX"
echo.
echo  Корзина:
powershell -NoProfile -Command "Clear-RecycleBin -Force -ErrorAction SilentlyContinue" >nul 2>&1
echo  Очищено.
echo.
echo  Системные журналы событий (Event Logs):
for /F "tokens=*" %%1 in ('wevtutil.exe el') do (
    wevtutil.exe cl "%%1" >nul 2>&1
)
echo  Очищено.
echo.
echo  %cGreen%Очистка успешно завершена!EXC!%cReset%
timeout /t 3 >nul
goto OptLoop

:CleanStepOpt
echo.
echo  %~2:
if exist "%~1" ( call :CalcAndCleanOpt "%~1" ) else ( echo  Не найдено / Уже чисто. )
exit /b
:CalcAndCleanOpt
if not exist "%~1" exit /b
for /f "usebackq tokens=*" %%a in (`powershell -NoProfile -Command "try { $x = Get-ChildItem -Path '%~1' -Recurse -File -Force -ErrorAction SilentlyContinue | Measure-Object -Property Length -Sum; '{0} файлов ({1:N2} MB)' -f $x.Count, ($x.Sum / 1MB) } catch { '0 файлов (0.00 MB)' }"`) do set "info=%%a"
del /f /s /q "%~1\*" >nul 2>&1
for /d %%x in ("%~1\*") do rd /s /q "%%x" >nul 2>&1
echo  Удалено: !info!
exit /b

:RestartExplorerOpt
taskkill /f /im explorer.exe >nul 2>&1
start explorer.exe
timeout /t 1 >nul
goto OptLoop

:ApplyAllOpt
echo.
echo %cYellow%Применение всех твиков оптимизации...%cReset%
call :ApplyAllOptSilent
echo %cGreen%Готово!EXC!%cReset%
timeout /t 2 >nul
goto OptLoop

:RestoreAllOpt
echo.
echo %cRed%Возврат к стандартным настройкам...%cReset%
powershell -NoProfile -Command "$schemes = powercfg /l | Where-Object { $_ -match '381b4222-f694-41f0-9685-ff5bb260df2e|Balanced|\u0421\u0431\u0430\u043b\u0430\u043d\u0441\u0438\u0440\u043e\u0432\u0430\u043d\u043d\u0430\u044f' }; if (-not $schemes) { $new = powercfg -duplicatescheme 381b4222-f694-41f0-9685-ff5bb260df2e; $guid = $new -replace '.*([0-9a-f]{8}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{12}).*', '$1'; powercfg /setactive $guid } else { $keep = $schemes | Select-Object -First 1; $guid = $keep -replace '.*([0-9a-f]{8}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{12}).*', '$1'; powercfg /setactive $guid }" >nul 2>&1
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\BackgroundAccessApplications" /v GlobalUserDisabled /t REG_DWORD /d 0 /f >nul
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Search" /v BackgroundAppGlobalToggle /t REG_DWORD /d 1 /f >nul
reg add "HKLM\SYSTEM\CurrentControlSet\Services\embeddedmode" /v Start /t REG_DWORD /d 3 /f >nul
cmd /c "reg delete "HKLM\SOFTWARE\Policies\Microsoft\Windows\DeliveryOptimization" /v DODownloadMode /f" >nul 2>&1
reg delete "HKLM\SOFTWARE\Policies\Microsoft\Edge" /v StartupBoostEnabled /f >nul 2>&1
reg delete "HKLM\SOFTWARE\Policies\Microsoft\Edge" /v BackgroundModeEnabled /f >nul 2>&1
sc config DiagTrack start= auto >nul 2>&1
sc start DiagTrack >nul 2>&1
reg delete "HKLM\SOFTWARE\Policies\Microsoft\Windows\DataCollection" /v AllowTelemetry /f >nul 2>&1
reg delete "HKCU\Software\Microsoft\Windows\CurrentVersion\UserProfileEngagement" /v ScoobeSystemSettingEnabled /f >nul 2>&1
reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System" /v PromptOnSecureDesktop /t REG_DWORD /d 1 /f >nul 2>&1
reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System" /v ConsentPromptBehaviorAdmin /t REG_DWORD /d 5 /f >nul 2>&1
reg add "HKCU\Control Panel\Mouse" /v MouseSpeed /t REG_SZ /d 1 /f >nul
powershell -NoProfile -Command "$code='using System.Runtime.InteropServices; public class W32 { [DllImport(\"user32.dll\")] public static extern bool SystemParametersInfo(uint a, uint b, int[] c, uint d); }'; Add-Type -TypeDefinition $code; $p=[int[]]@(6,10,1); [W32]::SystemParametersInfo(4,0,$p,3)" >nul 2>&1
reg add "HKCU\Control Panel\Accessibility\StickyKeys" /v Flags /t REG_SZ /d 510 /f >nul 2>&1
reg add "HKCU\Control Panel\Desktop" /v MenuShowDelay /t REG_SZ /d 400 /f >nul 2>&1
reg delete "HKCU\Control Panel\Desktop" /v JPEGImportQuality /f >nul 2>&1
powercfg /h on >nul 2>&1
echo %cGreen%Сброс завершен!EXC!%cReset%
timeout /t 2 >nul
goto RestartExplorerOpt

:CheckOptStatus
set "_Power=0"
for /f "usebackq tokens=*" %%a in (`powershell -NoProfile -Command "$a = powercfg /getactivescheme; if ($a -match '8c5e7fda-e8bf-4a96-9a85-a6e23a8c635c|High|\u0412\u044b\u0441\u043e\u043a\u0430\u044f') { Write-Output '1' } elseif ($a -match 'e9a42b02-d5df-448d-aa00-03f14749eb61|Ultimate|\u041c\u0430\u043a\u0441\u0438\u043c\u0430\u043b\u044c\u043d\u0430\u044f') { Write-Output '2' } else { Write-Output '0' }"`) do set "_Power=%%a"
set "_BackApps=1"
for /f "tokens=3" %%b in ('reg query "HKCU\Software\Microsoft\Windows\CurrentVersion\BackgroundAccessApplications" /v GlobalUserDisabled 2^>nul') do (if "%%b"=="0x1" set "_BackApps=0")
set "_DelOpt=1"
for /f "tokens=3" %%c in ('reg query "HKLM\SOFTWARE\Policies\Microsoft\Windows\DeliveryOptimization" /v DODownloadMode 2^>nul') do (if "%%c"=="0x0" set "_DelOpt=0")
set "_Edge=1"
for /f "tokens=3" %%d in ('reg query "HKLM\SOFTWARE\Policies\Microsoft\Edge" /v StartupBoostEnabled 2^>nul') do (if "%%d"=="0x0" set "_Edge=0")
set "_Tele=1"
reg query "HKLM\SOFTWARE\Policies\Microsoft\Windows\DataCollection" /v AllowTelemetry 2>nul | find "0x0" >nul
if %errorlevel% EQU 0 set "_Tele=0"
set "_Copilot=1"
for /f "tokens=3" %%i in ('reg query "HKCU\SOFTWARE\Policies\Microsoft\Windows\WindowsCopilot" /v TurnOffWindowsCopilot 2^>nul') do (if "%%i"=="0x1" set "_Copilot=0")
set "_UAC=1"
for /f "tokens=3" %%e in ('reg query "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System" /v ConsentPromptBehaviorAdmin 2^>nul') do (if "%%e"=="0x0" set "_UAC=0")
set "_Mouse=0"
for /f "tokens=3" %%a in ('reg query "HKCU\Control Panel\Mouse" /v MouseSpeed 2^>nul') do (if "%%a"=="1" set "_Mouse=1")
set "_Sticky=1"
reg query "HKCU\Control Panel\Accessibility\StickyKeys" /v Flags 2>nul | find "506" >nul
if %errorlevel% EQU 0 set "_Sticky=0"
set "_MenuDelay=1"
for /f "tokens=3" %%h in ('reg query "HKCU\Control Panel\Desktop" /v MenuShowDelay 2^>nul') do (if "%%h"=="20" set "_MenuDelay=0")
set "_WallComp=1"
for /f "tokens=3" %%g in ('reg query "HKCU\Control Panel\Desktop" /v JPEGImportQuality 2^>nul') do (if "%%g"=="0x64" set "_WallComp=0")
set "_RecSec=1"
reg query "HKLM\SOFTWARE\Microsoft\PolicyManager\current\device\Education" /v IsEducationEnvironment 2>nul | find "0x1" >nul
if %errorlevel% EQU 0 set "_RecSec=0"
set "_Hiber=0"
for /f "tokens=3" %%a in ('reg query "HKLM\SYSTEM\CurrentControlSet\Control\Power" /v HibernateEnabled 2^>nul') do (if "%%a"=="0x1" set "_Hiber=1")
set "_FastBoot=0"
for /f "tokens=3" %%a in ('reg query "HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\Power" /v HiberbootEnabled 2^>nul') do (if "%%a"=="0x1" set "_FastBoot=1")

set "_Pagefile=C"
for /f "usebackq tokens=*" %%a in (`powershell -NoProfile -Command "$cs=Get-WmiObject Win32_ComputerSystem; if($cs.AutomaticManagedPagefile){Write-Output 'A'}else{$pf=Get-WmiObject Win32_PageFileSetting | Select-Object -First 1; if($pf.InitialSize -eq 16384){Write-Output '1'}elseif($pf.InitialSize -eq 12288){Write-Output '2'}elseif($pf.InitialSize -eq 8192){Write-Output '3'}else{Write-Output 'C'}} "`) do set "_Pagefile=%%a"

set "_BitLocker=0"
for /f "usebackq tokens=*" %%a in (`powershell -NoProfile -Command "try { $v=Get-WmiObject -Namespace root\CIMv2\Security\MicrosoftVolumeEncryption -Class Win32_EncryptableVolume -Filter \"DriveLetter='%SystemDrive%'\" -ErrorAction Stop; if($v -and $v.ProtectionStatus -eq 1){Write-Output '1'}else{Write-Output '0'} } catch { Write-Output '0' }"`) do set "_BitLocker=%%a"

exit /b

:: Скрытое применение всех твиков для основного процесса
:ApplyAllOptSilent
powershell -NoProfile -Command "$schemes = powercfg /l | Where-Object { $_ -match 'e9a42b02-d5df-448d-aa00-03f14749eb61|Ultimate|\u041c\u0430\u043a\u0441\u0438\u043c\u0430\u043b\u044c\u043d\u0430\u044f' }; if (-not $schemes) { $new = powercfg -duplicatescheme e9a42b02-d5df-448d-aa00-03f14749eb61; $guid = $new -replace '.*([0-9a-f]{8}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{12}).*', '$1'; powercfg /setactive $guid } else { $keep = $schemes | Select-Object -First 1; $guid = $keep -replace '.*([0-9a-f]{8}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{12}).*', '$1'; powercfg /setactive $guid }" >nul 2>&1
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\BackgroundAccessApplications" /v GlobalUserDisabled /t REG_DWORD /d 1 /f >nul
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Search" /v BackgroundAppGlobalToggle /t REG_DWORD /d 0 /f >nul
cmd /c "reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\DeliveryOptimization" /v DODownloadMode /t REG_DWORD /d 0 /f" >nul 2>&1
reg add "HKLM\SOFTWARE\Policies\Microsoft\Edge" /v StartupBoostEnabled /t REG_DWORD /d 0 /f >nul 2>&1
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\DataCollection" /v AllowTelemetry /t REG_DWORD /d 0 /f >nul 2>&1
reg add "HKCU\SOFTWARE\Policies\Microsoft\Windows\WindowsCopilot" /v TurnOffWindowsCopilot /t REG_DWORD /d 1 /f >nul 2>&1
reg add "HKCU\Control Panel\Mouse" /v MouseSpeed /t REG_SZ /d 0 /f >nul
powershell -NoProfile -Command "$code='using System.Runtime.InteropServices; public class W32 { [DllImport(\"user32.dll\")] public static extern bool SystemParametersInfo(uint a, uint b, int[] c, uint d); }'; Add-Type -TypeDefinition $code; $p=[int[]]@(0,0,0); [W32]::SystemParametersInfo(4,0,$p,3)" >nul 2>&1
reg add "HKCU\Control Panel\Accessibility\StickyKeys" /v Flags /t REG_SZ /d 506 /f >nul 2>&1
reg add "HKCU\Control Panel\Desktop" /v MenuShowDelay /t REG_SZ /d 20 /f >nul 2>&1
reg add "HKCU\Control Panel\Desktop" /v JPEGImportQuality /t REG_DWORD /d 100 /f >nul 2>&1
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\Explorer" /v HideRecommendedSection /t REG_DWORD /d 1 /f >nul 2>&1
powercfg /h off >nul 2>&1
manage-bde -off %SystemDrive% >nul 2>&1
sc config BDESVC start= disabled >nul 2>&1
net stop BDESVC >nul 2>&1
exit /b

:: ==========================================
:: МЕНЮ 4: УДАЛЕНИЕ МУСОРНОГО ПО
:: ==========================================
:MenuBloat
mode con: cols=90 lines=60
:BloatLoop
cls
echo.
echo    %cYellow%Сканирование установленных приложений...%cReset%
call :CheckBloatStatus
cls
echo %LineEq%
echo                               %cCyan%УДАЛЕНИЕ МУСОРНОГО ПО (BLOATWARE)%cReset%
echo %LineEq%
echo.
echo    %cYellow%--- СИСТЕМНЫЕ И ВСТРОЕННЫЕ ---%cReset%
echo.
if "!_Cam!"=="1" (set "s1=%cRed%Установлено%cReset%") else (set "s1=%cGreen%Удалено%cReset%")
echo    [1]  Камера (Windows Camera)               : !s1!
echo.
if "!_Dev!"=="1" (set "s2=%cRed%Установлено%cReset%") else (set "s2=%cGreen%Удалено%cReset%")
echo    [2]  Dev Home                              : !s2!
echo.
if "!_Quick!"=="1" (set "s3=%cRed%Установлено%cReset%") else (set "s3=%cGreen%Удалено%cReset%")
echo    [3]  Быстрая помощь (Quick Assist)         : !s3!
echo.
if "!_Hub!"=="1" (set "s4=%cRed%Установлено%cReset%") else (set "s4=%cGreen%Удалено%cReset%")
echo    [4]  Центр отзывов (Feedback Hub)          : !s4!
echo.
echo    %cYellow%--- ОФИС И ИНТЕРНЕТ ---%cReset%
echo.
if "!_CopilotBloat!"=="1" (set "s5=%cRed%Установлено%cReset%") else (set "s5=%cGreen%Удалено%cReset%")
echo    [5]  Microsoft 365 Copilot                 : !s5!
echo.
if "!_Bing!"=="1" (set "s6=%cRed%Установлено%cReset%") else (set "s6=%cGreen%Удалено%cReset%")
echo    [6]  Поиск Bing                            : !s6!
echo.
if "!_News!"=="1" (set "s7=%cRed%Установлено%cReset%") else (set "s7=%cGreen%Удалено%cReset%")
echo    [7]  Microsoft News (Новости)              : !s7!
echo.
if "!_Teams!"=="1" (set "s8=%cRed%Установлено%cReset%") else (set "s8=%cGreen%Удалено%cReset%")
echo    [8]  Microsoft Teams                       : !s8!
echo.
if "!_ToDo!"=="1" (set "s9=%cRed%Установлено%cReset%") else (set "s9=%cGreen%Удалено%cReset%")
echo    [9]  Microsoft To Do                       : !s9!
echo.
if "!_Outlook!"=="1" (set "s10=%cRed%Установлено%cReset%") else (set "s10=%cGreen%Удалено%cReset%")
echo    [10] Новый Outlook (UWP)                   : !s10!
echo.
if "!_PowerApp!"=="1" (set "s11=%cRed%Установлено%cReset%") else (set "s11=%cGreen%Удалено%cReset%")
echo    [11] Power Automate                        : !s11!
echo.
if "!_StickyApp!"=="1" (set "s12=%cRed%Установлено%cReset%") else (set "s12=%cGreen%Удалено%cReset%")
echo    [12] Записки (Sticky Notes)                : !s12!
echo.
if "!_OneDrive!"=="1" (set "s13=%cRed%Установлено%cReset%") else (set "s13=%cGreen%Удалено%cReset%")
echo    [13] Microsoft OneDrive                    : !s13!
echo.
echo    %cYellow%--- МУЛЬТИМЕДИА И ИГРЫ ---%cReset%
echo.
if "!_Clip!"=="1" (set "s14=%cRed%Установлено%cReset%") else (set "s14=%cGreen%Удалено%cReset%")
echo    [14] Microsoft Clipchamp (Видеоредактор)   : !s14!
echo.
if "!_Sound!"=="1" (set "s15=%cRed%Установлено%cReset%") else (set "s15=%cGreen%Удалено%cReset%")
echo    [15] Звукозапись (Sound Recorder)          : !s15!
echo.
if "!_Sol!"=="1" (set "s16=%cRed%Установлено%cReset%") else (set "s16=%cGreen%Удалено%cReset%")
echo    [16] Solitaire Collection (Пасьянсы)       : !s16!
echo.
echo %LineDash%
echo.
echo    %cWhite%[A]%cReset% %cGreen%УДАЛИТЬ ВЕСЬ ПЕРЕЧИСЛЕННЫЙ МУСОР РАЗОМ%cReset%
echo.
echo    %cWhite%[0]%cReset% Вернуться в Главное меню %cGray%(Или нажмите N/Т)%cReset%
echo.
set /p "choice=    %cWhite%Ввод:%cReset% "

if "!choice!"=="0" goto MainMenu
if /I "!choice!"=="N" goto MainMenu
if /I "!choice!"=="Т" goto MainMenu
if "!choice!"=="1" goto ToggleCam
if "!choice!"=="2" goto ToggleDev
if "!choice!"=="3" goto ToggleQuick
if "!choice!"=="4" goto ToggleHub
if "!choice!"=="5" goto ToggleCopilotBloat
if "!choice!"=="6" goto ToggleBing
if "!choice!"=="7" goto ToggleNews
if "!choice!"=="8" goto ToggleTeams
if "!choice!"=="9" goto ToggleToDo
if "!choice!"=="10" goto ToggleOutlook
if "!choice!"=="11" goto TogglePowerApp
if "!choice!"=="12" goto ToggleStickyApp
if "!choice!"=="13" goto ToggleOneDrive
if "!choice!"=="14" goto ToggleClip
if "!choice!"=="15" goto ToggleSound
if "!choice!"=="16" goto ToggleSol
if /i "!choice!"=="a" goto ApplyAllBloat
goto BloatLoop

:ToggleCam
call :RemoveApp "Microsoft.WindowsCamera"
goto BloatLoop
:ToggleDev
call :RemoveApp "Microsoft.Windows.DevHome"
goto BloatLoop
:ToggleQuick
call :RemoveApp "MicrosoftCorporationII.QuickAssist"
goto BloatLoop
:ToggleHub
call :RemoveApp "Microsoft.WindowsFeedbackHub"
goto BloatLoop

:ToggleCopilotBloat
echo. & echo %cYellow%Удаление Microsoft 365 Copilot...%cReset%
taskkill /f /im msedgewebview2.exe >nul 2>&1
taskkill /f /im msedge.exe >nul 2>&1
reg add "HKCU\Software\Policies\Microsoft\Windows\WindowsCopilot" /v "TurnOffWindowsCopilot" /t REG_DWORD /d 1 /f >nul
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /v ShowCopilotButton /t REG_DWORD /d 0 /f >nul
winget uninstall --name "Microsoft 365 Copilot" --silent --accept-source-agreements >nul 2>&1
powershell -NoProfile -Command "Get-AppxPackage -AllUsers | Where-Object { $_.Name -match 'Copilot|Windows.Ai' } | ForEach-Object { Remove-AppxPackage -Package $_.PackageFullName -AllUsers -ErrorAction SilentlyContinue }" >nul 2>&1
goto BloatLoop
:ToggleBing
echo. & echo %cYellow%Удаление Microsoft Bing...%cReset%
powershell -NoProfile -Command "Get-AppxPackage *BingSearch* -AllUsers | Remove-AppxPackage -AllUsers" >nul 2>&1
reg add "HKCU\Software\Policies\Microsoft\Windows\Explorer" /v DisableSearchBoxSuggestions /t REG_DWORD /d 1 /f >nul
goto BloatLoop
:ToggleNews
call :RemoveApp "Microsoft.BingNews"
goto BloatLoop
:ToggleTeams
taskkill /f /im msteams.exe >nul 2>&1
call :RemoveApp "MSTeams"
goto BloatLoop
:ToggleToDo
taskkill /f /im Todo.exe >nul 2>&1
call :RemoveApp "Microsoft.Todos"
goto BloatLoop
:ToggleOutlook
taskkill /f /im olk.exe >nul 2>&1
call :RemoveApp "Microsoft.OutlookForWindows"
goto BloatLoop
:TogglePowerApp
taskkill /f /im PowerAutomate.exe >nul 2>&1
call :RemoveApp "Microsoft.PowerAutomateDesktop"
goto BloatLoop
:ToggleStickyApp
call :RemoveApp "Microsoft.MicrosoftStickyNotes"
goto BloatLoop
:ToggleOneDrive
echo. & echo %cYellow%Удаление Microsoft OneDrive...%cReset%
call :RemoveOneDrive
goto BloatLoop

:ToggleClip
call :RemoveApp "Clipchamp.Clipchamp"
goto BloatLoop
:ToggleSound
call :RemoveApp "Microsoft.WindowsSoundRecorder"
goto BloatLoop
:ToggleSol
call :RemoveApp "Microsoft.MicrosoftSolitaireCollection"
goto BloatLoop

:ApplyAllBloat
echo.
echo %cGreen%УДАЛЕНИЕ ВСЕГО ПЕРЕЧИСЛЕННОГО МУСОРА...%cReset%
call :ApplyAllBloatSilent
echo %cGreen%Готово!EXC!%cReset%
timeout /t 3 >nul
goto BloatLoop

:RemoveApp
echo. & echo %cYellow%Удаление %~1...%cReset%
powershell -NoProfile -Command "Get-AppxPackage -Name '*%~1*' -AllUsers | Remove-AppxPackage -AllUsers -ErrorAction SilentlyContinue; $prov = Get-AppxProvisionedPackage -Online -ErrorAction SilentlyContinue; if ($prov) { $prov | Where-Object { $_.DisplayName -like '*%~1*' } | Remove-AppxProvisionedPackage -Online -ErrorAction SilentlyContinue }" >nul 2>&1
exit /b

:RemoveOneDrive
taskkill /f /im OneDrive.exe >nul 2>&1
"%SystemRoot%\SysWOW64\OneDriveSetup.exe" /uninstall >nul 2>&1
"%SystemRoot%\System32\OneDriveSetup.exe" /uninstall >nul 2>&1
rd /s /q "%LocalAppData%\Microsoft\OneDrive" >nul 2>&1
rd /s /q "%ProgramData%\Microsoft OneDrive" >nul 2>&1
rd /s /q "C:\OneDriveTemp" >nul 2>&1
exit /b

:CheckBloatStatus
set "_Cam=0" & set "_Dev=0" & set "_Quick=0" & set "_Hub=0" & set "_CopilotBloat=0" & set "_Bing=0" & set "_News=0" & set "_Teams=0" & set "_ToDo=0" & set "_Outlook=0" & set "_PowerApp=0" & set "_StickyApp=0" & set "_Clip=0" & set "_Sound=0" & set "_Sol=0"
powershell -NoProfile -Command "Get-AppxPackage -AllUsers | Select-Object -ExpandProperty Name" > "%temp%\apps.txt"
findstr /i "WindowsCamera" "%temp%\apps.txt" >nul && set "_Cam=1"
findstr /i "DevHome" "%temp%\apps.txt" >nul && set "_Dev=1"
findstr /i "QuickAssist" "%temp%\apps.txt" >nul && set "_Quick=1"
findstr /i "WindowsFeedbackHub" "%temp%\apps.txt" >nul && set "_Hub=1"
findstr /i "Copilot Windows.Ai" "%temp%\apps.txt" >nul && set "_CopilotBloat=1"
findstr /i "BingNews" "%temp%\apps.txt" >nul && set "_News=1"
findstr /i "MSTeams" "%temp%\apps.txt" >nul && set "_Teams=1"
findstr /i "Todos" "%temp%\apps.txt" >nul && set "_ToDo=1"
findstr /i "OutlookForWindows" "%temp%\apps.txt" >nul && set "_Outlook=1"
findstr /i "PowerAutomateDesktop" "%temp%\apps.txt" >nul && set "_PowerApp=1"
findstr /i "StickyNotes" "%temp%\apps.txt" >nul && set "_StickyApp=1"
findstr /i "Clipchamp" "%temp%\apps.txt" >nul && set "_Clip=1"
findstr /i "WindowsSoundRecorder" "%temp%\apps.txt" >nul && set "_Sound=1"
findstr /i "SolitaireCollection" "%temp%\apps.txt" >nul && set "_Sol=1"

reg query "HKCU\Software\Policies\Microsoft\Windows\Explorer" /v DisableSearchBoxSuggestions >nul 2>&1
if %errorlevel% NEQ 0 set "_Bing=1"
del "%temp%\apps.txt" >nul

set "_OneDrive=0"
if exist "%LocalAppData%\Microsoft\OneDrive\OneDrive.exe" set "_OneDrive=1"
if exist "%ProgramFiles%\Microsoft OneDrive\OneDrive.exe" set "_OneDrive=1"
if exist "%ProgramFiles(x86)%\Microsoft OneDrive\OneDrive.exe" set "_OneDrive=1"
exit /b

:: Скрытое удаление мусора для основного процесса
:ApplyAllBloatSilent
taskkill /f /im PowerAutomate.exe >nul 2>&1
taskkill /f /im Todo.exe >nul 2>&1
taskkill /f /im msteams.exe >nul 2>&1
taskkill /f /im olk.exe >nul 2>&1
powershell -NoProfile -Command "$apps = '*WindowsCamera*,*DevHome*,*WindowsFeedbackHub*,*Clipchamp*,*BingNews*,*MSTeams*,*Todos*,*OutlookForWindows*,*PowerAutomateDesktop*,*QuickAssist*,*SolitaireCollection*,*WindowsSoundRecorder*,*StickyNotes*,*Copilot*,*Windows.Ai*,*BingSearch*'.Split(','); $prov = Get-AppxProvisionedPackage -Online -ErrorAction SilentlyContinue; foreach($a in $apps){ Get-AppxPackage -Name $a -AllUsers | Remove-AppxPackage -AllUsers -ErrorAction SilentlyContinue; if ($prov) { $prov | Where-Object {$_.DisplayName -like $a} | Remove-AppxProvisionedPackage -Online -ErrorAction SilentlyContinue } }" >nul 2>&1
call :RemoveOneDrive
exit /b

:: Применение кастомных настроек из меню 3 и 4
:ApplyCustomSettings
if "!_Power!"=="1" call :Power_High
if "!_Power!"=="2" call :Power_Ult
if "!_Power!"=="0" call :Power_Bal
if "!_BackApps!"=="0" call :BackApps_Enable
if "!_DelOpt!"=="0" call :DelOpt_Enable
if "!_Edge!"=="0" call :Edge_Enable
if "!_Tele!"=="0" call :Tele_Enable
if "!_Copilot!"=="0" call :Copilot_Enable
if "!_UAC!"=="0" call :UAC_Enable
if "!_Mouse!"=="0" call :Mouse_Enable
if "!_Sticky!"=="0" call :Sticky_Enable
if "!_MenuDelay!"=="0" call :MenuDelay_Enable
if "!_WallComp!"=="0" call :Wall_Enable
if "!_RecSec!"=="0" call :Rec_Enable
if "!_Hiber!"=="1" call :Hiber_Enable
if "!_FastBoot!"=="1" call :FastBoot_Enable
if "!_BitLocker!"=="0" (manage-bde -off %SystemDrive% >nul 2>&1 & sc config BDESVC start= disabled >nul 2>&1 & net stop BDESVC >nul 2>&1)
if "!_Cam!"=="0" call :RemoveApp "Microsoft.WindowsCamera"
if "!_Dev!"=="0" call :RemoveApp "Microsoft.Windows.DevHome"
if "!_Quick!"=="0" call :RemoveApp "MicrosoftCorporationII.QuickAssist"
if "!_Hub!"=="0" call :RemoveApp "Microsoft.WindowsFeedbackHub"
if "!_Bing!"=="0" (powershell -NoProfile -Command "Get-AppxPackage *BingSearch* -AllUsers | Remove-AppxPackage -AllUsers" >nul 2>&1 & reg add "HKCU\Software\Policies\Microsoft\Windows\Explorer" /v DisableSearchBoxSuggestions /t REG_DWORD /d 1 /f >nul)
if "!_CopilotBloat!"=="0" call :ToggleCopilotBloat
if "!_News!"=="0" call :RemoveApp "Microsoft.BingNews"
if "!_Teams!"=="0" call :RemoveApp "MSTeams"
if "!_ToDo!"=="0" call :RemoveApp "Microsoft.Todos"
if "!_Outlook!"=="0" call :RemoveApp "Microsoft.OutlookForWindows"
if "!_PowerApp!"=="0" call :RemoveApp "Microsoft.PowerAutomateDesktop"
if "!_StickyApp!"=="0" call :RemoveApp "Microsoft.MicrosoftStickyNotes"
if "!_Clip!"=="0" call :RemoveApp "Clipchamp.Clipchamp"
if "!_Sound!"=="0" call :RemoveApp "Microsoft.WindowsSoundRecorder"
if "!_Sol!"=="0" call :RemoveApp "Microsoft.MicrosoftSolitaireCollection"
if "!_OneDrive!"=="0" call :RemoveOneDrive
exit /b

:: ==========================================
:: СТАРТ ОСНОВНОГО ПРОЦЕССА УСТАНОВКИ
:: ==========================================
:StartSetup
mode con: cols=90 lines=75

if "!automode!"=="1" goto AutoDefaults

:: ==========================================
:: РУЧНОЙ РЕЖИМ (ОПРОС С ВИЗУАЛОМ)
:: ==========================================
cls
echo %LineEq%
echo                                       %cMagenta%[ РУЧНАЯ НАСТРОЙКА ]%cReset%
echo %LineEq%
echo     %cWhite%Отвечайте Y (Да) или N (Нет). (Enter/н = Да, N/т = Пропустить).%cReset%
echo.
echo    %cYellow%--- СИСТЕМА И ТВИКИ ---%cReset%
echo.

:Ask_Mas
set "do_mas="
set /p do_mas="    %cYellow%[1/17]%cReset% Активировать Windows 10/11 (MAS)? [Y/n]: "
if "!do_mas!"=="" set "do_mas=Y"
if /I "!do_mas!"=="Y" (set "sym=%cGreen%[+] Да") else if /I "!do_mas!"=="Н" (set "do_mas=Y" & set "sym=%cGreen%[+] Да") else if /I "!do_mas!"=="N" (set "sym=%cRed%[-] Пропущено") else if /I "!do_mas!"=="Т" (set "do_mas=N" & set "sym=%cRed%[-] Пропущено") else (
    <nul set /p ="!UpEr!"
    goto Ask_Mas
)
<nul set /p ="!UpEr!"
echo     %cYellow%[1/17]%cReset% Активировать Windows 10/11 (MAS)? !sym!%cReset%
echo.

:Ask_Zapret
echo     %cCyan%[!EXC! ИНФО]%cReset% %cWhite%Для распаковки Zapret будет установлен архиватор 7-Zip.%cReset%
:ReAsk_Zapret
set "do_zapret="
set /p do_zapret="    %cYellow%[2/17]%cReset% Установить Zapret (Обход блокировок)? [Y/n]: "
if "!do_zapret!"=="" set "do_zapret=Y"
if /I "!do_zapret!"=="Y" (set "sym=%cGreen%[+] Да") else if /I "!do_zapret!"=="Н" (set "do_zapret=Y" & set "sym=%cGreen%[+] Да") else if /I "!do_zapret!"=="N" (set "sym=%cRed%[-] Пропущено") else if /I "!do_zapret!"=="Т" (set "do_zapret=N" & set "sym=%cRed%[-] Пропущено") else (
    <nul set /p ="!UpEr!"
    goto ReAsk_Zapret
)
<nul set /p ="!UpEr!!UpEr!"
echo     %cYellow%[2/17]%cReset% Установить Zapret (Обход блокировок)? !sym!%cReset%

set "do_zapret_lists=N"
if /I "!do_zapret!"=="Y" (
    echo.
    echo     %cCyan%[!EXC! ИНФО]%cReset% %cWhite%Какие списки доменов использовать для обхода?%cReset%
    echo       %cWhite%[1]%cReset% - %cYellow%Кастомные%cReset% ^(Слияние с вашими списками^)
    echo       %cWhite%[2]%cReset% - %cCyan%Стандартные%cReset% ^(Только списки разработчика^)
    call :HandleZapretLists
) else (
    echo.
)
goto Ask_Dark

:HandleZapretLists
set "zap_list_choice="
set /p zap_list_choice="    %cYellow%[*]%cReset% Ваш выбор [1/2] (Enter = 1): "
if "!zap_list_choice!"=="" set "zap_list_choice=1"
if "!zap_list_choice!"=="1" (set "do_zapret_lists=Y" & set "syml=%cYellow%[+] Кастомные") else if "!zap_list_choice!"=="2" (set "do_zapret_lists=N" & set "syml=%cCyan%[+] Стандартные") else (
    <nul set /p ="!UpEr!"
    goto HandleZapretLists
)
<nul set /p ="!UpEr!!UpEr!!UpEr!!UpEr!"
echo     %cYellow%[*]%cReset% Списки доменов: !syml!%cReset%
echo.
exit /b

:Ask_Dark
set "do_darktheme="
set /p do_darktheme="    %cYellow%[3/17]%cReset% Включить темную тему Windows? [Y/n]: "
if "!do_darktheme!"=="" set "do_darktheme=Y"
if /I "!do_darktheme!"=="Y" (set "sym=%cGreen%[+] Да") else if /I "!do_darktheme!"=="Н" (set "do_darktheme=Y" & set "sym=%cGreen%[+] Да") else if /I "!do_darktheme!"=="N" (set "sym=%cRed%[-] Пропущено") else if /I "!do_darktheme!"=="Т" (set "do_darktheme=N" & set "sym=%cRed%[-] Пропущено") else (
    <nul set /p ="!UpEr!"
    goto Ask_Dark
)
<nul set /p ="!UpEr!"
echo     %cYellow%[3/17]%cReset% Включить темную тему Windows? !sym!%cReset%
echo.

:Ask_UAC
set "do_uac="
set /p do_uac="    %cYellow%[4/17]%cReset% Отключить уведомления UAC (Опасно для новичков)? [Y/n]: "
if "!do_uac!"=="" set "do_uac=Y"
if /I "!do_uac!"=="Y" (set "sym=%cGreen%[+] Да") else if /I "!do_uac!"=="Н" (set "do_uac=Y" & set "sym=%cGreen%[+] Да") else if /I "!do_uac!"=="N" (set "sym=%cRed%[-] Пропущено") else if /I "!do_uac!"=="Т" (set "do_uac=N" & set "sym=%cRed%[-] Пропущено") else (
    <nul set /p ="!UpEr!"
    goto Ask_UAC
)
<nul set /p ="!UpEr!"
echo     %cYellow%[4/17]%cReset% Отключить уведомления UAC? !sym!%cReset%
echo.

:Ask_Tweaks
echo     %cCyan%[!EXC! ИНФО]%cReset% %cWhite%Выберите тип оптимизации системы:%cReset%
echo       %cWhite%[A]%cReset% - %cYellow%Ультимативная%cReset% (Все твики + удаление всего мусора)
echo       %cWhite%[C]%cReset% - %cCyan%Кастомная%cReset% (Использовать ваши параметры из Меню 3 и 4)
echo       %cWhite%[N]%cReset% - %cRed%Пропустить%cReset% оптимизацию
:ReAsk_Tweaks
set "do_tweaks="
set /p do_tweaks="    %cYellow%[5/17]%cReset% Ваш выбор [A/C/N] (Enter = A): "
if "!do_tweaks!"=="" set "do_tweaks=A"
if /I "!do_tweaks!"=="A" (set "do_tweaks=A" & set "sym=%cYellow%[+] УЛЬТИМАТИВНАЯ") else if /I "!do_tweaks!"=="Ф" (set "do_tweaks=A" & set "sym=%cYellow%[+] УЛЬТИМАТИВНАЯ") else if /I "!do_tweaks!"=="C" (set "do_tweaks=C" & set "sym=%cCyan%[+] КАСТОМНАЯ") else if /I "!do_tweaks!"=="С" (set "do_tweaks=C" & set "sym=%cCyan%[+] КАСТОМНАЯ") else if /I "!do_tweaks!"=="N" (set "do_tweaks=N" & set "sym=%cRed%[-] Пропущено") else if /I "!do_tweaks!"=="Т" (set "do_tweaks=N" & set "sym=%cRed%[-] Пропущено") else (
    <nul set /p ="!UpEr!"
    goto ReAsk_Tweaks
)
<nul set /p ="!UpEr!!UpEr!!UpEr!!UpEr!!UpEr!"
echo     %cYellow%[5/17]%cReset% Тип оптимизации системы: !sym!%cReset%
echo.

:Ask_Pagefile
echo     %cCyan%[!EXC! ИНФО]%cReset% %cWhite%Настройка файла подкачки (Виртуальная память):%cReset%
echo       %cWhite%[1]%cReset% - %cYellow%16 ГБ%cReset% (Рекомендуется для 8 ГБ ОЗУ)
echo       %cWhite%[2]%cReset% - %cCyan%12 ГБ%cReset% (Рекомендуется для 16 ГБ ОЗУ)
echo       %cWhite%[3]%cReset% - %cMagenta%8 ГБ%cReset% (Рекомендуется для 32+ ГБ ОЗУ)
echo       %cWhite%[A]%cReset% - %cGreen%Автоматически%cReset% (По выбору системы)
:ReAsk_Pagefile
set "do_pagefile="
set /p do_pagefile="    %cYellow%[6/17]%cReset% Ваш выбор [1/2/3/A] (Enter = A): "
if "!do_pagefile!"=="" set "do_pagefile=A"
if "!do_pagefile!"=="1" (set "sym=%cYellow%[+] 16 ГБ") else if "!do_pagefile!"=="2" (set "sym=%cCyan%[+] 12 ГБ") else if "!do_pagefile!"=="3" (set "sym=%cMagenta%[+] 8 ГБ") else if /I "!do_pagefile!"=="A" (set "do_pagefile=A" & set "sym=%cGreen%[+] Автоматически") else if /I "!do_pagefile!"=="Ф" (set "do_pagefile=A" & set "sym=%cGreen%[+] Автоматически") else (
    <nul set /p ="!UpEr!"
    goto ReAsk_Pagefile
)
<nul set /p ="!UpEr!!UpEr!!UpEr!!UpEr!!UpEr!!UpEr!"
echo     %cYellow%[6/17]%cReset% Файл подкачки: !sym!%cReset%
echo.

echo    %cYellow%--- ПРОГРАММЫ И БИБЛИОТЕКИ ---%cReset%
echo.

:Ask_VCR
set "do_vcredist="
set /p do_vcredist="    %cYellow%[7/17]%cReset% Установить Visual C++ AIO (Для игр и программ)? [Y/n]: "
if "!do_vcredist!"=="" set "do_vcredist=Y"
if /I "!do_vcredist!"=="Y" (set "sym=%cGreen%[+] Да") else if /I "!do_vcredist!"=="Н" (set "do_vcredist=Y" & set "sym=%cGreen%[+] Да") else if /I "!do_vcredist!"=="N" (set "sym=%cRed%[-] Пропущено") else if /I "!do_vcredist!"=="Т" (set "do_vcredist=N" & set "sym=%cRed%[-] Пропущено") else (
    <nul set /p ="!UpEr!"
    goto Ask_VCR
)
<nul set /p ="!UpEr!"
echo     %cYellow%[7/17]%cReset% Установить Visual C++ AIO? !sym!%cReset%
echo.

:Ask_DirectX
set "do_directx="
set /p do_directx="    %cYellow%[8/17]%cReset% Установить DirectX (Включая End-User Runtimes)? [Y/n]: "
if "!do_directx!"=="" set "do_directx=Y"
if /I "!do_directx!"=="Y" (set "sym=%cGreen%[+] Да") else if /I "!do_directx!"=="Н" (set "do_directx=Y" & set "sym=%cGreen%[+] Да") else if /I "!do_directx!"=="N" (set "sym=%cRed%[-] Пропущено") else if /I "!do_directx!"=="Т" (set "do_directx=N" & set "sym=%cRed%[-] Пропущено") else (
    <nul set /p ="!UpEr!"
    goto Ask_DirectX
)
<nul set /p ="!UpEr!"
echo     %cYellow%[8/17]%cReset% Установить DirectX (End-User Runtimes)? !sym!%cReset%
echo.

:Ask_Java
set "do_java="
set /p do_java="    %cYellow%[9/17]%cReset% Установить Java (Версии 8, 17, 21)? [Y/n]: "
if "!do_java!"=="" set "do_java=Y"
if /I "!do_java!"=="Y" (set "sym=%cGreen%[+] Да") else if /I "!do_java!"=="Н" (set "do_java=Y" & set "sym=%cGreen%[+] Да") else if /I "!do_java!"=="N" (set "sym=%cRed%[-] Пропущено") else if /I "!do_java!"=="Т" (set "do_java=N" & set "sym=%cRed%[-] Пропущено") else (
    <nul set /p ="!UpEr!"
    goto Ask_Java
)
<nul set /p ="!UpEr!"
echo     %cYellow%[9/17]%cReset% Установить Java (8, 17, 21)? !sym!%cReset%
echo.

:Ask_Discord
set "do_discord="
set /p do_discord="    %cYellow%[10/17]%cReset% Установить Discord? [Y/n]: "
if "!do_discord!"=="" set "do_discord=Y"
if /I "!do_discord!"=="Y" (set "sym=%cGreen%[+] Да") else if /I "!do_discord!"=="Н" (set "do_discord=Y" & set "sym=%cGreen%[+] Да") else if /I "!do_discord!"=="N" (set "sym=%cRed%[-] Пропущено") else if /I "!do_discord!"=="Т" (set "do_discord=N" & set "sym=%cRed%[-] Пропущено") else (
    <nul set /p ="!UpEr!"
    goto Ask_Discord
)
<nul set /p ="!UpEr!"
echo     %cYellow%[10/17]%cReset% Установить Discord? !sym!%cReset%
echo.

:Ask_Steam
set "do_steam="
set /p do_steam="    %cYellow%[11/17]%cReset% Установить Steam? [Y/n]: "
if "!do_steam!"=="" set "do_steam=Y"
if /I "!do_steam!"=="Y" (set "sym=%cGreen%[+] Да") else if /I "!do_steam!"=="Н" (set "do_steam=Y" & set "sym=%cGreen%[+] Да") else if /I "!do_steam!"=="N" (set "sym=%cRed%[-] Пропущено") else if /I "!do_steam!"=="Т" (set "do_steam=N" & set "sym=%cRed%[-] Пропущено") else (
    <nul set /p ="!UpEr!"
    goto Ask_Steam
)
<nul set /p ="!UpEr!"
echo     %cYellow%[11/17]%cReset% Установить Steam? !sym!%cReset%
echo.

:Ask_Browser
echo     %cCyan%Выберите браузеры (можно несколько, например: 134)%cReset%
echo     1 - Google Chrome   ^|   2 - Yandex Browser
echo     3 - Opera GX        ^|   4 - Brave
:ReAsk_Browser
set "do_browser="
set /p do_browser="    %cYellow%[12/17]%cReset% Введите цифры (Enter = 12, 0 = Пропуск): "
if "!do_browser!"=="" set "do_browser=12"
if /I "!do_browser!"=="N" (set "do_browser=0" & set "sym=%cRed%[-] Не устанавливать%cReset%") else if /I "!do_browser!"=="Т" (set "do_browser=0" & set "sym=%cRed%[-] Не устанавливать%cReset%") else if "!do_browser!"=="0" (set "sym=%cRed%[-] Не устанавливать%cReset%") else (
    set "valid=1"
    for /f "delims=1234" %%a in ("!do_browser!") do set "valid=0"
    if "!valid!"=="0" (
        <nul set /p ="!UpEr!"
        goto ReAsk_Browser
    )
    
    set "b_disp="
    echo !do_browser! | find "1" >nul && set "b_disp=!b_disp!%cBlue%G%cRed%o%cYellow%o%cBlue%g%cGreen%l%cRed%e %cRed%C%cYellow%h%cGreen%r%cBlue%o%cRed%m%cYellow%e%cReset% | "
    echo !do_browser! | find "2" >nul && set "b_disp=!b_disp!%cWhite%Yandex Browser%cReset% | "
    echo !do_browser! | find "3" >nul && set "b_disp=!b_disp!%cRed%Opera GX%cReset% | "
    echo !do_browser! | find "4" >nul && set "b_disp=!b_disp!%cYellow%Brave%cReset% | "
    
    if "!b_disp!"=="" (
        set "sym=%cRed%[-] Не устанавливать%cReset%"
    ) else (
        set "b_disp=!b_disp:~0,-3!"
        set "sym=%cGreen%[+] %cReset%!b_disp!"
    )
)
<nul set /p ="!UpEr!!UpEr!!UpEr!!UpEr!!UpEr!"
echo     %cYellow%[12/17]%cReset% Браузеры: !sym!
echo.

:Ask_WizTree
set "do_wiztree="
set /p do_wiztree="    %cYellow%[13/17]%cReset% Установить WizTree (Анализ места на диске)? [Y/n]: "
if "!do_wiztree!"=="" set "do_wiztree=Y"
if /I "!do_wiztree!"=="Y" (set "sym=%cGreen%[+] Да") else if /I "!do_wiztree!"=="Н" (set "do_wiztree=Y" & set "sym=%cGreen%[+] Да") else if /I "!do_wiztree!"=="N" (set "sym=%cRed%[-] Пропущено") else if /I "!do_wiztree!"=="Т" (set "do_wiztree=N" & set "sym=%cRed%[-] Пропущено") else (
    <nul set /p ="!UpEr!"
    goto Ask_WizTree
)
<nul set /p ="!UpEr!"
echo     %cYellow%[13/17]%cReset% Установить WizTree? !sym!%cReset%
echo.

:Ask_Qbit
set "do_qbit="
set /p do_qbit="    %cYellow%[14/17]%cReset% Установить qBittorrent? [Y/n]: "
if "!do_qbit!"=="" set "do_qbit=Y"
if /I "!do_qbit!"=="Y" (set "sym=%cGreen%[+] Да") else if /I "!do_qbit!"=="Н" (set "do_qbit=Y" & set "sym=%cGreen%[+] Да") else if /I "!do_qbit!"=="N" (set "sym=%cRed%[-] Пропущено") else if /I "!do_qbit!"=="Т" (set "do_qbit=N" & set "sym=%cRed%[-] Пропущено") else (
    <nul set /p ="!UpEr!"
    goto Ask_Qbit
)
<nul set /p ="!UpEr!"
echo     %cYellow%[14/17]%cReset% Установить qBittorrent? !sym!%cReset%
echo.

:Ask_Zip
if /I "!do_zapret!"=="Y" goto skip_7zip_prompt
set "do_7zip="
set /p do_7zip="    %cYellow%[15/17]%cReset% Установить архиваторы (7-Zip и WinRAR)? [Y/n]: "
if "!do_7zip!"=="" set "do_7zip=Y"
if /I "!do_7zip!"=="Y" (set "sym=%cGreen%[+] Да") else if /I "!do_7zip!"=="Н" (set "do_7zip=Y" & set "sym=%cGreen%[+] Да") else if /I "!do_7zip!"=="N" (set "sym=%cRed%[-] Пропущено") else if /I "!do_7zip!"=="Т" (set "do_7zip=N" & set "sym=%cRed%[-] Пропущено") else (
    <nul set /p ="!UpEr!"
    goto Ask_Zip
)
<nul set /p ="!UpEr!"
echo     %cYellow%[15/17]%cReset% Установить архиваторы? !sym!%cReset%
echo.
goto after_7zip_prompt

:skip_7zip_prompt
echo     %cYellow%[15/17]%cReset% Установить архиваторы? %cGreen%[+] Да (Одобрено для Zapret)%cReset%
echo.
set "do_7zip=Y"

:after_7zip_prompt
:Ask_Vlc
set "do_vlc="
set /p do_vlc="    %cYellow%[16/17]%cReset% Заменить стандартные плееры Win11 на VLC? [Y/n]: "
if "!do_vlc!"=="" set "do_vlc=Y"
if /I "!do_vlc!"=="Y" (set "sym=%cGreen%[+] Да") else if /I "!do_vlc!"=="Н" (set "do_vlc=Y" & set "sym=%cGreen%[+] Да") else if /I "!do_vlc!"=="N" (set "sym=%cRed%[-] Пропущено") else if /I "!do_vlc!"=="Т" (set "do_vlc=N" & set "sym=%cRed%[-] Пропущено") else (
    <nul set /p ="!UpEr!"
    goto Ask_Vlc
)
<nul set /p ="!UpEr!"
echo     %cYellow%[16/17]%cReset% Заменить стандартные плееры на VLC? !sym!%cReset%
echo.

:Ask_Clean
echo %LineDash%
echo     %cCyan%[+] ДОПОЛНИТЕЛЬНОЕ ОБСЛУЖИВАНИЕ%cReset%
echo %LineDash%
set "do_clean="
set /p do_clean="    %cYellow%[17/17]%cReset% Очистить временные файлы системы после установки? [Y/n]: "
if "!do_clean!"=="" set "do_clean=Y"
if /I "!do_clean!"=="Y" (set "sym=%cGreen%[+] Да") else if /I "!do_clean!"=="Н" (set "do_clean=Y" & set "sym=%cGreen%[+] Да") else if /I "!do_clean!"=="N" (set "sym=%cRed%[-] Пропущено") else if /I "!do_clean!"=="Т" (set "do_clean=N" & set "sym=%cRed%[-] Пропущено") else (
    <nul set /p ="!UpEr!"
    goto Ask_Clean
)
<nul set /p ="!UpEr!!UpEr!!UpEr!"
echo     %cYellow%[17/17]%cReset% Очистить временные файлы? !sym!%cReset%
echo %LineDash%
echo.

:: ==========================================
:: СОХРАНЕНИЕ ШАБЛОНА
:: ==========================================
:Ask_Save
set "save_template="
set /p save_template="    %cGreen%Сохранить этот выбор как авто-шаблон? [Y/n] (Enter=Да): %cReset%"
if "!save_template!"=="" set "save_template=Y"
if /I "!save_template!"=="N" (echo !UpEr!    Сохранить авто-шаблон? %cRed%[-] Нет%cReset% & goto Ask_StartInstall)
if /I "!save_template!"=="Т" (echo !UpEr!    Сохранить авто-шаблон? %cRed%[-] Нет%cReset% & goto Ask_StartInstall)
if /I "!save_template!"=="Y" (echo !UpEr!    Сохранить авто-шаблон? %cGreen%[+] Да%cReset%) else if /I "!save_template!"=="Н" (echo !UpEr!    Сохранить авто-шаблон? %cGreen%[+] Да%cReset%) else (
    <nul set /p ="!UpEr!"
    goto Ask_Save
)

set "custom_preset_name="
set /p custom_preset_name="    %cYellow%Введите имя шаблона (Например: Zero): %cReset%"
if "!custom_preset_name!"=="" set "custom_preset_name=МойШаблон"

set "safe_name=!custom_preset_name:"=!"

echo     %cCyan%Открытие окна выбора места сохранения...%cReset%
set "psCommand=Add-Type -AssemblyName System.Windows.Forms; $s = New-Object System.Windows.Forms.SaveFileDialog; $s.Filter = 'CMD Шаблон (*.bat)|*.bat'; $s.FileName = $env:safe_name + '.bat'; $s.Title = 'Сохранить шаблон MDOptimizer'; $s.InitialDirectory = $PWD.Path; if ($s.ShowDialog() -eq [System.Windows.Forms.DialogResult]::OK) { Write-Output $s.FileName }"
for /f "usebackq tokens=*" %%F in (`powershell -Sta -NoProfile -Command "!psCommand!"`) do set "SavePath=%%F"

if "!SavePath!"=="" (
    echo     %cRed%Сохранение отменено. Переход к установке...%cReset%
    timeout /t 3 >nul
    goto Ask_StartInstall
)

set "PS_SCRIPT=!temp!\md_save.ps1"
set "SCRIPT_PATH=%~f0"

> "!PS_SCRIPT!" echo $src = $env:SCRIPT_PATH
>> "!PS_SCRIPT!" echo $dst = $env:SavePath
>> "!PS_SCRIPT!" echo $utf8NoBom = New-Object System.Text.UTF8Encoding($false)
>> "!PS_SCRIPT!" echo $txt = [IO.File]::ReadAllText($src, $utf8NoBom)
>> "!PS_SCRIPT!" echo $txt = $txt -replace '(?m)^^set "PresetName=.*"', ('set "PresetName=' + $env:safe_name + '"')
>> "!PS_SCRIPT!" echo $vars = @('do_mas','do_zapret','do_zapret_lists','do_darktheme','do_uac','do_tweaks','do_pagefile','do_vcredist','do_directx','do_java','do_discord','do_steam','do_browser','do_wiztree','do_qbit','do_7zip','do_vlc','do_clean','_Power','_BackApps','_DelOpt','_Edge','_Tele','_Copilot','_UAC','_Mouse','_Sticky','_MenuDelay','_WallComp','_RecSec','_Hiber','_FastBoot','_BitLocker','_Cam','_Dev','_Hub','_Bing','_Clip','_News','_Teams','_ToDo','_Outlook','_PowerApp','_Quick','_Sol','_Sound','_StickyApp','_CopilotBloat','_OneDrive')
>> "!PS_SCRIPT!" echo foreach ($v in $vars) {
>> "!PS_SCRIPT!" echo     $val = [Environment]::GetEnvironmentVariable($v)
>> "!PS_SCRIPT!" echo     $pattern = '(?m)^^set "PRESET_' + $v + '=.*"'
>> "!PS_SCRIPT!" echo     $replacement = 'set "PRESET_' + $v + '=' + $val + '"'
>> "!PS_SCRIPT!" echo     $txt = $txt -replace $pattern, $replacement
>> "!PS_SCRIPT!" echo }
>> "!PS_SCRIPT!" echo [IO.File]::WriteAllText($dst, $txt, $utf8NoBom)

powershell -NoProfile -ExecutionPolicy Bypass -File "!PS_SCRIPT!"
del "!PS_SCRIPT!" >nul 2>&1

set "PresetName=!safe_name!"
echo.
echo     %cGreen%[+] Шаблон "!safe_name!" успешно сохранен по пути:%cReset%
echo     %cWhite%!SavePath!%cReset%

:: Синхронизируем переменные в памяти, чтобы меню "Состав шаблона" отображало корректные данные без перезапуска
set "PRESET_do_mas=!do_mas!"
set "PRESET_do_zapret=!do_zapret!"
set "PRESET_do_zapret_lists=!do_zapret_lists!"
set "PRESET_do_darktheme=!do_darktheme!"
set "PRESET_do_uac=!do_uac!"
set "PRESET_do_tweaks=!do_tweaks!"
set "PRESET_do_pagefile=!do_pagefile!"
set "PRESET_do_vcredist=!do_vcredist!"
set "PRESET_do_directx=!do_directx!"
set "PRESET_do_java=!do_java!"
set "PRESET_do_discord=!do_discord!"
set "PRESET_do_steam=!do_steam!"
set "PRESET_do_browser=!do_browser!"
set "PRESET_do_wiztree=!do_wiztree!"
set "PRESET_do_qbit=!do_qbit!"
set "PRESET_do_7zip=!do_7zip!"
set "PRESET_do_vlc=!do_vlc!"
set "PRESET_do_clean=!do_clean!"
set "PRESET__Power=!_Power!"
set "PRESET__BackApps=!_BackApps!"
set "PRESET__DelOpt=!_DelOpt!"
set "PRESET__Edge=!_Edge!"
set "PRESET__Tele=!_Tele!"
set "PRESET__Copilot=!_Copilot!"
set "PRESET__UAC=!_UAC!"
set "PRESET__Mouse=!_Mouse!"
set "PRESET__Sticky=!_Sticky!"
set "PRESET__MenuDelay=!_MenuDelay!"
set "PRESET__WallComp=!_WallComp!"
set "PRESET__RecSec=!_RecSec!"
set "PRESET__Hiber=!_Hiber!"
set "PRESET__FastBoot=!_FastBoot!"
set "PRESET__BitLocker=!_BitLocker!"
set "PRESET__Cam=!_Cam!"
set "PRESET__Dev=!_Dev!"
set "PRESET__Quick=!_Quick!"
set "PRESET__Hub=!_Hub!"
set "PRESET__CopilotBloat=!_CopilotBloat!"
set "PRESET__Bing=!_Bing!"
set "PRESET__News=!_News!"
set "PRESET__Teams=!_Teams!"
set "PRESET__ToDo=!_ToDo!"
set "PRESET__Outlook=!_Outlook!"
set "PRESET__PowerApp=!_PowerApp!"
set "PRESET__StickyApp=!_StickyApp!"
set "PRESET__Clip=!_Clip!"
set "PRESET__Sound=!_Sound!"
set "PRESET__Sol=!_Sol!"
set "PRESET__OneDrive=!_OneDrive!"

:Ask_StartInstall
echo.
set "start_now="
set /p start_now="    %cWhite%Начать установку сейчас? [Y/n] (N/Т = В Главное меню): %cReset%"
if "!start_now!"=="" set "start_now=Y"
if /I "!start_now!"=="Y" (echo !UpEr!    Начать установку сейчас? %cGreen%[+] Да%cReset% & timeout /t 2 >nul & goto ExecutionPhase)
if /I "!start_now!"=="Н" (echo !UpEr!    Начать установку сейчас? %cGreen%[+] Да%cReset% & timeout /t 2 >nul & goto ExecutionPhase)
if /I "!start_now!"=="N" (
    echo !UpEr!    Начать установку сейчас? %cRed%[-] Возврат в меню%cReset%
    timeout /t 2 >nul
    goto MainMenu
)
if /I "!start_now!"=="Т" (
    echo !UpEr!    Начать установку сейчас? %cRed%[-] Возврат в меню%cReset%
    timeout /t 2 >nul
    goto MainMenu
)
<nul set /p ="!UpEr!"
goto Ask_StartInstall

:: ==========================================
:: АВТОМАТИЧЕСКИЙ РЕЖИМ (ПО-УМОЛЧАНИЮ ИЛИ ИЗ ШАБЛОНА)
:: ==========================================
:AutoDefaults
if "!PresetName!"=="Стандартный" (
    set "do_mas=Y" & set "do_zapret=Y" & set "do_zapret_lists=Y" & set "do_darktheme=Y" & set "do_uac=N" & set "do_tweaks=A"
    set "do_pagefile=A" & set "do_vcredist=Y" & set "do_directx=Y" & set "do_java=Y" & set "do_discord=Y" & set "do_steam=Y"
    set "do_browser=12" & set "do_wiztree=Y" & set "do_qbit=Y" & set "do_7zip=Y" & set "do_vlc=N" & set "do_clean=Y"
) else (
    set "do_mas=!PRESET_do_mas!" & set "do_zapret=!PRESET_do_zapret!" & set "do_zapret_lists=!PRESET_do_zapret_lists!" & set "do_darktheme=!PRESET_do_darktheme!"
    set "do_uac=!PRESET_do_uac!" & set "do_tweaks=!PRESET_do_tweaks!" & set "do_pagefile=!PRESET_do_pagefile!"
    set "do_vcredist=!PRESET_do_vcredist!" & set "do_directx=!PRESET_do_directx!" & set "do_java=!PRESET_do_java!" 
    set "do_discord=!PRESET_do_discord!" & set "do_steam=!PRESET_do_steam!" & set "do_browser=!PRESET_do_browser!" 
    set "do_wiztree=!PRESET_do_wiztree!" & set "do_qbit=!PRESET_do_qbit!" & set "do_7zip=!PRESET_do_7zip!" 
    set "do_vlc=!PRESET_do_vlc!" & set "do_clean=!PRESET_do_clean!"
    
    set "_Power=!PRESET__Power!" & set "_BackApps=!PRESET__BackApps!" & set "_DelOpt=!PRESET__DelOpt!" 
    set "_Edge=!PRESET__Edge!" & set "_Tele=!PRESET__Tele!" & set "_Copilot=!PRESET__Copilot!" 
    set "_UAC=!PRESET__UAC!" & set "_Mouse=!PRESET__Mouse!" & set "_Sticky=!PRESET__Sticky!" 
    set "_MenuDelay=!PRESET__MenuDelay!" & set "_WallComp=!PRESET__WallComp!" & set "_RecSec=!PRESET__RecSec!" 
    set "_Hiber=!PRESET__Hiber!" & set "_FastBoot=!PRESET__FastBoot!" & set "_BitLocker=!PRESET__BitLocker!"
    set "_Cam=!PRESET__Cam!" & set "_Dev=!PRESET__Dev!" & set "_Hub=!PRESET__Hub!" 
    set "_Bing=!PRESET__Bing!" & set "_Clip=!PRESET__Clip!" & set "_News=!PRESET__News!" 
    set "_Teams=!PRESET__Teams!" & set "_ToDo=!PRESET__ToDo!" & set "_Outlook=!PRESET__Outlook!" 
    set "_PowerApp=!PRESET__PowerApp!" & set "_Quick=!PRESET__Quick!" & set "_Sol=!PRESET__Sol!" 
    set "_Sound=!PRESET__Sound!" & set "_StickyApp=!PRESET__StickyApp!" & set "_CopilotBloat=!PRESET__CopilotBloat!"
    set "_OneDrive=!PRESET__OneDrive!"
)

if /I "!do_zapret!"=="Y" set "do_7zip=Y"
goto :ExecutionPhase

:ExecutionPhase
:: ==========================================
:: ПОДГОТОВКА ПРОГРЕСС-БАРА И ПЕРЕМЕННЫХ
:: ==========================================
set "installed_list="
set "7zip_installed_early=0"
set "need_early_7zip=0"
if /I "!do_zapret!"=="Y" set "need_early_7zip=1"

set /a total_tasks=0
if /I "!do_mas!"=="Y" set /a total_tasks+=1
if "!need_early_7zip!"=="1" set /a total_tasks+=1
if /I "!do_zapret!"=="Y" set /a total_tasks+=1
if /I "!do_darktheme!"=="Y" set /a total_tasks+=1
if /I "!do_uac!"=="Y" set /a total_tasks+=1
if /I "!do_tweaks!"=="A" set /a total_tasks+=1
if /I "!do_tweaks!"=="C" set /a total_tasks+=1
if "!do_pagefile!" neq "A" if "!do_pagefile!" neq "" set /a total_tasks+=1
if /I "!do_vcredist!"=="Y" set /a total_tasks+=1
if /I "!do_directx!"=="Y" set /a total_tasks+=1
if /I "!do_java!"=="Y" set /a total_tasks+=3
if /I "!do_discord!"=="Y" set /a total_tasks+=1
if /I "!do_steam!"=="Y" set /a total_tasks+=1
if "!do_browser!" neq "0" if "!do_browser!" neq "" set /a total_tasks+=1
if /I "!do_wiztree!"=="Y" set /a total_tasks+=1
if /I "!do_qbit!"=="Y" set /a total_tasks+=1
if /I "!do_7zip!"=="Y" set /a total_tasks+=1
if /I "!do_vlc!"=="Y" set /a total_tasks+=1
if /I "!do_clean!"=="Y" set /a total_tasks+=1

if !total_tasks! equ 0 set "total_tasks=1"
set /a current_task=0

reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Internet Settings\WinHttp" /v DefaultSecureProtocols /t REG_DWORD /d 0x00000A00 /f >nul 2>&1
reg add "HKLM\SOFTWARE\Wow6432Node\Microsoft\Windows\CurrentVersion\Internet Settings\WinHttp" /v DefaultSecureProtocols /t REG_DWORD /d 0x00000A00 /f >nul 2>&1

:: ==========================================
:: 4. АКТИВАЦИЯ WINDOWS (MAS)
:: ==========================================
if /I "!do_mas!"=="N" goto :skip_mas

cls
echo %LineEq%
echo                                 %cCyan%Активация Windows%cReset%
echo %LineEq%
echo.
echo  %cYellow%ИНСТРУКЦИЯ ПО АКТИВАЦИИ:%cReset%
echo  1. Сейчас откроется НОВОЕ ОКНО с активатором.
echo  2. В нем нажмите клавишу %cGreen%[1] (HWID Activation)%cReset%.
echo  3. Дождитесь зеленого текста "Activation Successful".
echo     (Если пишет "permanently activated" - система уже активирована).
echo  4. Закройте окно активатора крестиком или нажмите [0] для выхода.
echo.
start "" powershell -NoProfile -Command "irm https://get.activated.win | iex; exit"

echo.
echo  %cMagenta%[!EXC!] После того как вы активируете систему и ЗАКРОЕТЕ окно MAS,%cReset%
echo  %cMagenta%          нажмите любую клавишу здесь, чтобы продолжить работу!EXC!%cReset%
pause >nul
echo.
echo  %cGreen%[+] Идем дальше...%cReset%
set /a current_task+=1
set "installed_list=!installed_list! - Активация Windows (MAS)\n"
:skip_mas

:: ==========================================
:: 4.5. ПРЕДВАРИТЕЛЬНАЯ УСТАНОВКА 7-ZIP (Для Zapret)
:: ==========================================
if "!need_early_7zip!"=="0" goto :skip_early_7zip

cls
echo %LineEq%
echo                               %cCyan%Подготовка компонентов%cReset%
echo %LineEq%
echo.
echo  %cYellow%Установка архиватора 7-Zip (Необходим для распаковки списков Zapret)...%cReset%

if exist "!ProgramFiles!\7-Zip\7z.exe" (
    echo  %cGreen%[+] 7-Zip уже установлен в системе. Быстрый пропуск.%cReset%
    set "7zip_installed_early=1"
    set /a current_task+=1
    set "installed_list=!installed_list! - 7-Zip (Был установлен ранее)\n"
    timeout /t 2 >nul
    goto :skip_early_7zip
)

winget install -e --id 7zip.7zip --accept-source-agreements --accept-package-agreements --silent >nul 2>&1
set "7zip_installed_early=1"
echo  %cGreen%[+] 7-Zip успешно установлен.%cReset%
set /a current_task+=1
set "installed_list=!installed_list! - 7-Zip\n"
timeout /t 2 >nul
:skip_early_7zip

:: ==========================================
:: 5. УСТАНОВКА ZAPRET
:: ==========================================
if /I "!do_zapret!"=="N" goto :skip_zapret

cls
echo %LineEq%
echo                         %cCyan%Настройка обхода блокировок (Zapret)%cReset%
echo %LineEq%
echo.
set "ZAPRET_DIR=%SystemDrive%\Zapret_Bypass"

echo  %cYellow%Добавление папки %ZAPRET_DIR% в исключения Защитника Windows...%cReset%
powershell -NoProfile -ExecutionPolicy Bypass -Command "try { Add-MpPreference -ExclusionPath '%ZAPRET_DIR%' -ErrorAction SilentlyContinue } catch {}" >nul 2>&1

echo  %cYellow%Создание папки и скачивание свежего релиза Zapret c GitHub...%cReset%
if not exist "%ZAPRET_DIR%" md "%ZAPRET_DIR%" >nul 2>&1

powershell -NoProfile -ExecutionPolicy Bypass -Command "$ErrorActionPreference = 'Stop'; try { $release = Invoke-RestMethod -Uri 'https://api.github.com/repos/Flowseal/zapret-discord-youtube/releases/latest'; $asset = $release.assets | Where-Object { $_.name -match '\.zip$' } | Select-Object -First 1; Invoke-WebRequest -Uri $asset.browser_download_url -OutFile '%ZAPRET_DIR%\zapret.zip'; exit 0 } catch { exit 1 }"

if %errorlevel% neq 0 (
    echo  %cRed%[-] Не удалось скачать Zapret. Возможно, мешает антивирус или нет интернета.%cReset%
    goto skip_zapret
)

if exist "!ProgramFiles!\7-Zip\7z.exe" (
    "!ProgramFiles!\7-Zip\7z.exe" x "%ZAPRET_DIR%\zapret.zip" -o"%ZAPRET_DIR%" -y >nul 2>&1
) else (
    powershell -Command "Expand-Archive -Path '%ZAPRET_DIR%\zapret.zip' -DestinationPath '%ZAPRET_DIR%' -Force" >nul 2>&1
)
del "%ZAPRET_DIR%\zapret.zip" >nul 2>&1
echo  %cGreen%[+] Zapret скачан и распакован в папку %ZAPRET_DIR%.%cReset%
echo.

if /I "!do_zapret_lists!"=="N" (
    echo  %cYellow%[i] Выбраны стандартные списки. Скачивание кастомных пропущено.%cReset%
    goto :done_lists
)

echo  %cYellow%Скачивание кастомных списков из облака (GitHub)...%cReset%

set "LISTS_PATH="
set "LISTS_EXT="
powershell -NoProfile -Command "try { Invoke-WebRequest -Uri 'https://raw.githubusercontent.com/CTaJIoHE/MDOptimizer/main/Files/lists.zip' -OutFile '%temp%\zapret_lists.zip' } catch { exit 1 }" >nul 2>&1
if exist "%temp%\zapret_lists.zip" (
    set "LISTS_PATH=%temp%\zapret_lists.zip"
    set "LISTS_EXT=zip"
    echo  %cGreen%[+] Файл lists.zip успешно скачан из облака.%cReset%
) else (
    powershell -NoProfile -Command "try { Invoke-WebRequest -Uri 'https://raw.githubusercontent.com/CTaJIoHE/MDOptimizer/main/Files/lists.rar' -OutFile '%temp%\zapret_lists.rar' } catch { exit 1 }" >nul 2>&1
    if exist "%temp%\zapret_lists.rar" (
        set "LISTS_PATH=%temp%\zapret_lists.rar"
        set "LISTS_EXT=rar"
        echo  %cGreen%[+] Файл lists.rar успешно скачан из облака.%cReset%
    )
)

if not defined LISTS_PATH (
    echo  %cRed%[!EXC!] Не удалось скачать списки из облака. Ищем локально...%cReset%
    if exist "%~dp0lists.zip" set "LISTS_PATH=%~dp0lists.zip"&set "LISTS_EXT=zip"
    if exist "%~dp0lists.rar" set "LISTS_PATH=%~dp0lists.rar"&set "LISTS_EXT=rar"
    if exist "%~dp0Files\lists.zip" set "LISTS_PATH=%~dp0Files\lists.zip"&set "LISTS_EXT=zip"
    if exist "%~dp0Files\lists.rar" set "LISTS_PATH=%~dp0Files\lists.rar"&set "LISTS_EXT=rar"
)

if not defined LISTS_PATH goto :skip_lists_extract
md "%temp%\zap_lists" >nul 2>&1

if exist "!ProgramFiles!\7-Zip\7z.exe" (
    "!ProgramFiles!\7-Zip\7z.exe" x "!LISTS_PATH!" -o"%temp%\zap_lists" -y >nul 2>&1
    goto :lists_extracted
)

if "!LISTS_EXT!"=="zip" goto :extract_zip

:extract_rar
echo  %cRed%[-] Для распаковки .rar нужен 7-Zip, но он не установлен!EXC!%cReset%
goto :skip_lists_extract

:extract_zip
powershell -Command "Expand-Archive -Path '!LISTS_PATH!' -DestinationPath '%temp%\zap_lists' -Force" >nul 2>&1

:lists_extracted
:: Избавляемся от вложенной папки lists, если архив был с ней
if exist "%temp%\zap_lists\lists\*" (
    xcopy /E /Y /C /Q "%temp%\zap_lists\lists\*" "%temp%\zap_lists\" >nul 2>&1
    rd /s /q "%temp%\zap_lists\lists" >nul 2>&1
)

:: СЛИЯНИЕ СПИСКОВ БЕЗ ПЕРЕЗАПИСИ ОРИГИНАЛОВ
for %%F in ("%temp%\zap_lists\*") do (
    if exist "%ZAPRET_DIR%\lists\%%~nxF" (
        :: Добавляем перенос строки и прикрепляем кастомные домены в конец
        echo.>> "%ZAPRET_DIR%\lists\%%~nxF"
        type "%%F" >> "%ZAPRET_DIR%\lists\%%~nxF"
    ) else (
        :: Если файла нет у автора - просто копируем
        copy /y "%%F" "%ZAPRET_DIR%\lists\%%~nxF" >nul 2>&1
    )
)

:lists_cleanup
rd /s /q "%temp%\zap_lists" >nul 2>&1
echo  %cGreen%[+] Кастомные списки (%LISTS_EXT%) успешно внедрены в Zapret!EXC!%cReset%
goto :done_lists

:skip_lists_extract
echo  %cYellow%[!EXC!] Архив со списками не найден. Оставлены списки по умолчанию.%cReset%

:done_lists
echo.
echo  %cYellow%Открытие папки с Zapret для дальнейшей настройки...%cReset%
start "" "%ZAPRET_DIR%"
echo  %cMagenta%Нажмите любую клавишу для вывода инструкции по Zapret...%cReset%
pause >nul

cls
echo %LineEq%
echo             %cYellow%ИНСТРУКЦИЯ ПО НАСТРОЙКЕ ZAPRET (Обязательно до Discord):%cReset%
echo %LineEq%
echo.
echo  %cGreen%[+] Папка с Zapret была автоматически открыта в новом окне.%cReset%
echo      Путь установки: %cWhite%%ZAPRET_DIR%%cReset%
echo      (Она уже добавлена в исключения антивируса и находится в корне диска)
echo.
echo  Сделайте всё строго по списку ниже, КАК У АВТОРА:
echo  1. В открытой папке запустите %cGreen%service.bat%cReset% от им. Администратора.
echo.
echo  2. Выберите %cGreen%[11] Run Tests%cReset%. Дождитесь окончания тестирования.
echo     В самом конце результатов найдите строчку с лучшей стратегией.
echo     (Например: %cYellow%"Best strategy: general (ALT11).bat"%cReset%).
echo.
echo  3. Проверьте %cGreen%[6] Auto-Update Check%cReset%: должно быть %cYellow%"Disable"%cReset%. 
echo.
echo  4. Нажмите %cGreen%[7] Game Filter%cReset% и выберите %cYellow%[1] TCP and UDP%cReset%.
echo.
echo  5. Нажмите %cGreen%[5] IPSet Filter%cReset% и выберите %cYellow%loaded%cReset%.
echo     (Если будут проблемы с подключением - ставьте %cYellow%none%cReset%).
echo.
echo  6. Нажмите %cGreen%[1] Install Service%cReset% для установки службы обхода в систему.
echo     Когда программа спросит, выберите стратегию, которую выдал тест на шаге 2.
echo.
echo  7. Нажмите %cGreen%[8] Update Hosts File%cReset%. Откроются 2 окна - просто оставьте их.
echo.
echo  8. Закройте окно Zapret крестиком.
echo %LineEq%
echo.
echo  %cMagenta%Нажмите любую клавишу здесь, КОГДА ВЫПОЛНИТЕ ВСЕ 8 ШАГОВ...%cReset%
pause >nul

echo.
echo  %cYellow%Автоматическое обновление системного файла hosts...%cReset%
if not exist "%temp%\zapret_hosts.txt" goto :hosts_error
attrib -r -s -h "%windir%\System32\drivers\etc\hosts" >nul 2>&1
copy /y "%windir%\System32\drivers\etc\hosts" "%windir%\System32\drivers\etc\hosts.bak" >nul 2>&1
copy /y "%temp%\zapret_hosts.txt" "%windir%\System32\drivers\etc\hosts" >nul 2>&1
attrib +r "%windir%\System32\drivers\etc\hosts" >nul 2>&1
echo  %cGreen%[+] Файл hosts успешно заменен!EXC! Telegram Web будет работать без проблем.%cReset%
goto :hosts_done
:hosts_error
echo  %cRed%[-] Файл zapret_hosts.txt не найден в папке Temp.%cReset%
:hosts_done
echo.
echo  %cMagenta%Идем дальше... Нажмите любую клавишу.%cReset%
pause >nul
set /a current_task+=1
set "installed_list=!installed_list! - Zapret (Обход блокировок)\n"
:skip_zapret

:: ==========================================
:: 6. ТЕМНАЯ ТЕМА
:: ==========================================
if /I "!do_darktheme!"=="Y" (
    call :SHOW_PROGRESS "Включение Темной Темы"
    reg add "HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Themes\Personalize" /v SystemUsesLightTheme /t REG_DWORD /d 0 /f >nul 2>&1
    reg add "HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Themes\Personalize" /v AppsUseLightTheme /t REG_DWORD /d 0 /f >nul 2>&1
    set "installed_list=!installed_list! - Темная тема активирована\n"
)

:: ==========================================
:: 7. ОТКЛЮЧЕНИЕ UAC
:: ==========================================
if /I "!do_uac!"=="Y" (
    call :SHOW_PROGRESS "Отключение UAC (Уведомлений)"
    reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System" /v EnableLUA /t REG_DWORD /d 0 /f >nul 2>&1
    reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System" /v ConsentPromptBehaviorAdmin /t REG_DWORD /d 0 /f >nul 2>&1
    reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System" /v PromptOnSecureDesktop /t REG_DWORD /d 0 /f >nul 2>&1
    set "installed_list=!installed_list! - UAC отключен\n"
)

:: ==========================================
:: 8. СИСТЕМНЫЕ ТВИКИ (ОПТИМИЗАЦИЯ)
:: ==========================================
if /I "!do_tweaks!"=="A" (
    call :SHOW_PROGRESS "Ультимативная оптимизация и удаление мусора"
    powercfg -setactive 8c5e7fda-e8bf-4a96-9a85-a6e23a8c635c
    reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /v TaskbarDa /t REG_DWORD /d 0 /f >nul 2>&1
    reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /v ShowTaskViewButton /t REG_DWORD /d 0 /f >nul 2>&1
    reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\StorageSense\Parameters\StoragePolicy" /v 01 /t REG_DWORD /d 0 /f >nul 2>&1
    call :ApplyAllOptSilent
    call :ApplyAllBloatSilent
    set "installed_list=!installed_list! - Ультимативная оптимизация системы применена\n"
) else if /I "!do_tweaks!"=="C" (
    call :SHOW_PROGRESS "Применение Кастомных твиков оптимизации"
    call :ApplyCustomSettings
    set "installed_list=!installed_list! - Кастомная оптимизация (Настройки из Меню 3/4)\n"
)

:: ==========================================
:: 8.5. ФАЙЛ ПОДКАЧКИ
:: ==========================================
if "!do_pagefile!"=="1" (
    call :SHOW_PROGRESS "Настройка файла подкачки (16 ГБ)"
    wmic computersystem where name="%computername%" set AutomaticManagedPagefile=False >nul 2>&1
    wmic pagefilesetting where name="C:\\pagefile.sys" set InitialSize=16384,MaximumSize=16384 >nul 2>&1
    if errorlevel 1 powershell -Command "Set-CimInstance -Query 'Select * from Win32_PageFileSetting where name=\"C:\\\\pagefile.sys\"' -Property @{InitialSize=16384; MaximumSize=16384}" >nul 2>&1
    set "installed_list=!installed_list! - Файл подкачки (16 ГБ)\n"
)
if "!do_pagefile!"=="2" (
    call :SHOW_PROGRESS "Настройка файла подкачки (12 ГБ)"
    wmic computersystem where name="%computername%" set AutomaticManagedPagefile=False >nul 2>&1
    wmic pagefilesetting where name="C:\\pagefile.sys" set InitialSize=12288,MaximumSize=12288 >nul 2>&1
    if errorlevel 1 powershell -Command "Set-CimInstance -Query 'Select * from Win32_PageFileSetting where name=\"C:\\\\pagefile.sys\"' -Property @{InitialSize=12288; MaximumSize=12288}" >nul 2>&1
    set "installed_list=!installed_list! - Файл подкачки (12 ГБ)\n"
)
if "!do_pagefile!"=="3" (
    call :SHOW_PROGRESS "Настройка файла подкачки (8 ГБ)"
    wmic computersystem where name="%computername%" set AutomaticManagedPagefile=False >nul 2>&1
    wmic pagefilesetting where name="C:\\pagefile.sys" set InitialSize=8192,MaximumSize=8192 >nul 2>&1
    if errorlevel 1 powershell -Command "Set-CimInstance -Query 'Select * from Win32_PageFileSetting where name=\"C:\\\\pagefile.sys\"' -Property @{InitialSize=8192; MaximumSize=8192}" >nul 2>&1
    set "installed_list=!installed_list! - Файл подкачки (8 ГБ)\n"
)

:: ==========================================
:: 9. МЕДИАПЛЕЕРЫ (VLC + удаление Zune)
:: ==========================================
if /I "!do_vlc!"=="Y" (
    call :SHOW_PROGRESS "Удаление стандартных плееров и установка VLC"
    powershell -command "Get-AppxPackage *ZuneVideo* -AllUsers | Remove-AppxPackage" >nul 2>&1
    powershell -command "Get-AppxPackage *ZuneMusic* -AllUsers | Remove-AppxPackage" >nul 2>&1
    winget install -e --id VideoLAN.VLC --accept-source-agreements --accept-package-agreements --silent >nul 2>&1
    set "installed_list=!installed_list! - VLC Media Player\n"
)

:: ==========================================
:: 10. VISUAL C++ REDIST
:: ==========================================
if /I "!do_vcredist!"=="Y" (
    call :SHOW_PROGRESS "Установка Visual C++ Redistributable AIO (x86/x64)"
    winget install -e --id=abbodi1406.vcredist --accept-source-agreements --accept-package-agreements --silent >nul 2>&1
    set "installed_list=!installed_list! - Visual C++ Redistributable (Все версии)\n"
)

:: ==========================================
:: 11. DIRECTX
:: ==========================================
if /I "!do_directx!"=="Y" (
    call :SHOW_PROGRESS "Установка DirectX (End-User Runtimes)"
    winget install -e --id Microsoft.DirectX --accept-source-agreements --accept-package-agreements --silent >nul 2>&1
    set "installed_list=!installed_list! - DirectX (End-User Runtimes)\n"
)

:: ==========================================
:: 12. JAVA (8, 17, 21)
:: ==========================================
if /I "!do_java!"=="Y" (
    call :SHOW_PROGRESS "Установка Java 8 Update 481"
    winget install -e --id Oracle.JavaRuntimeEnvironment --accept-source-agreements --accept-package-agreements --silent >nul 2>&1
    call :SHOW_PROGRESS "Установка Java 17 (JDK)"
    winget install -e --id Oracle.JDK.17 --accept-source-agreements --accept-package-agreements --silent >nul 2>&1
    call :SHOW_PROGRESS "Установка Java 21 (JDK)"
    winget install -e --id Oracle.JDK.21 --accept-source-agreements --accept-package-agreements --silent >nul 2>&1
    set "installed_list=!installed_list! - Java (Версии 8, 17 и 21)\n"
)

:: ==========================================
:: 13. ПО (Discord, Steam, WizTree, qBit, Архиваторы)
:: ==========================================
if /I "!do_discord!"=="Y" (
    call :SHOW_PROGRESS "Установка Discord"
    winget install -e --id Discord.Discord --accept-source-agreements --accept-package-agreements --silent >nul 2>&1
    set "installed_list=!installed_list! - Discord\n"
)

if /I "!do_steam!"=="Y" (
    call :SHOW_PROGRESS "Установка Steam"
    winget install -e --id Valve.Steam --accept-source-agreements --accept-package-agreements --silent >nul 2>&1
    set "installed_list=!installed_list! - Steam\n"
)

if /I "!do_wiztree!"=="Y" (
    call :SHOW_PROGRESS "Установка WizTree"
    winget install -e --id AntibodySoftware.WizTree --accept-source-agreements --accept-package-agreements --silent >nul 2>&1
    set "installed_list=!installed_list! - WizTree\n"
)

if /I "!do_qbit!"=="Y" (
    call :SHOW_PROGRESS "Установка qBittorrent"
    winget install -e --id qBittorrent.qBittorrent --accept-source-agreements --accept-package-agreements --silent >nul 2>&1
    set "installed_list=!installed_list! - qBittorrent\n"
)

if /I "!do_7zip!"=="Y" (
    call :SHOW_PROGRESS "Установка архиваторов (7-Zip и WinRAR)"
    
    if "!7zip_installed_early!" NEQ "1" (
        if exist "!ProgramFiles!\7-Zip\7z.exe" (
            echo  %cGreen%[+] 7-Zip уже установлен. Пропуск.%cReset%
        ) else (
            winget install -e --id 7zip.7zip --accept-source-agreements --accept-package-agreements --silent >nul 2>&1
        )
    )

    if exist "!ProgramFiles!\WinRAR\WinRAR.exe" (
        echo  %cGreen%[+] WinRAR уже установлен. Пропуск.%cReset%
    ) else (
        winget install -e --id RARLab.WinRAR --accept-source-agreements --accept-package-agreements --silent >nul 2>&1
    )
    
    :: Установка ассоциаций файлов по умолчанию
    reg add "HKCR\.zip" /ve /d "7-Zip.zip" /f >nul 2>&1
    reg add "HKCR\7-Zip.zip\shell\open\command" /ve /d "\"!ProgramFiles!\7-Zip\7zFM.exe\" \"%%1\"" /f >nul 2>&1
    reg add "HKCR\.rar" /ve /d "WinRAR" /f >nul 2>&1
    reg add "HKCR\WinRAR\shell\open\command" /ve /d "\"!ProgramFiles!\WinRAR\WinRAR.exe\" \"%%1\"" /f >nul 2>&1
    
    set "installed_list=!installed_list! - Архиваторы (7-Zip и WinRAR) и ассоциации\n"
)

:: Доп пакеты (всегда)
winget install -e --id Microsoft.DotNet.DesktopRuntime.8 --accept-package-agreements --silent >nul 2>&1

:: ==========================================
:: 14. БРАУЗЕРЫ
:: ==========================================
if "!do_browser!" neq "0" if "!do_browser!" neq "" (
    call :SHOW_PROGRESS "Установка выбранных браузеров"
    echo !do_browser! | find "1" >nul && winget install -e --id Google.Chrome --accept-source-agreements --accept-package-agreements --silent >nul 2>&1
    echo !do_browser! | find "2" >nul && winget install -e --id Yandex.Browser --accept-source-agreements --accept-package-agreements --silent >nul 2>&1
    echo !do_browser! | find "3" >nul && winget install -e --id Opera.OperaGX --accept-source-agreements --accept-package-agreements --silent >nul 2>&1
    echo !do_browser! | find "4" >nul && winget install -e --id Brave.Brave --accept-source-agreements --accept-package-agreements --silent >nul 2>&1
    set "installed_list=!installed_list! - Браузеры установлены\n"
)

:: ==========================================
:: 15. ОЧИСТКА ВРЕМЕННЫХ ФАЙЛОВ
:: ==========================================
if /I "!do_clean!"=="Y" (
    call :SHOW_PROGRESS "Очистка временных файлов и кэша"
    del /s /f /q "%temp%\*.*" >nul 2>&1
    rd /s /q "%temp%" >nul 2>&1
    md "%temp%" >nul 2>&1
    net stop wuauserv >nul 2>&1
    del /s /f /q "%Windir%\SoftwareDistribution\Download\*.*" >nul 2>&1
    net start wuauserv >nul 2>&1
    set "installed_list=!installed_list! - Кэш и временные файлы очищены\n"
)

:: ==========================================
:: 16. ФИНАЛ И ПЕРЕЗАГРУЗКА
:: ==========================================
cls
echo %LineEq%
echo                               %cGreen%НАСТРОЙКА MDOptimizer УСПЕШНО ЗАВЕРШЕНА!EXC!%cReset%
echo %LineEq%
echo.
echo  %cYellow%СПИСОК ВЫПОЛНЕННЫХ ДЕЙСТВИЙ И УСТАНОВЛЕННЫХ ПРОГРАММ:%cReset%
echo.

:: Умная проверка на пустоту перед выводом
if "!installed_list!"=="" (
    echo    %cGray%Ничего не было выбрано для установки или изменения.%cReset%
) else (
    for %%A in ("!installed_list:\n=" "!") do (
        set "item=%%~A"
        if not "!item!"=="" echo   %cWhite%!item!%cReset%
    )
)

echo.
echo %LineEq%
echo.
:AskReboot
set "do_reboot="
set /p do_reboot="  %cWhite%Перезагрузить компьютер? [Y/n] (Enter/Н = Сейчас, N/Т = Позже):%cReset% "
if "!do_reboot!"=="" set "do_reboot=Y"
if /I "!do_reboot!"=="Y" goto :reboot_now
if /I "!do_reboot!"=="Н" goto :reboot_now
if /I "!do_reboot!"=="N" goto :reboot_later
if /I "!do_reboot!"=="Т" goto :reboot_later
if /I "!do_reboot!"=="T" goto :reboot_later
<nul set /p ="!UpEr!"
goto AskReboot

:reboot_now
echo.
echo %LineEq%
echo  %cGreen%[+] Вы выбрали: ПЕРЕЗАГРУЗИТЬ СЕЙЧАС%cReset%
echo  Все изменения, твики, установленные программы и библиотеки 
echo  вступят в силу после включения компьютера.
echo %LineEq%
echo.
echo  %cYellow%Перезагрузка системы начнется через 15 секунд...%cReset% 
echo  %cRed%Обязательно сохраните все открытые документы!EXC!%cReset%
shutdown /r /t 15
echo.
echo  %cMagenta%Нажмите любую клавишу для немедленного закрытия твикера...%cReset%
pause >nul
exit

:reboot_later
echo.
echo %LineEq%
echo  %cYellow%[-] Вы выбрали: ПЕРЕЗАГРУЗИТЬ ПОЗЖЕ%cReset%
echo  Твикер завершил свою работу, но для того чтобы установленные 
echo  библиотеки и настройки электропитания заработали корректно, 
echo  вам необходимо перезагрузить ПК вручную!EXC!
echo %LineEq%
echo.
echo  %cMagenta%Нажмите любую клавишу для выхода из программы...%cReset%
pause >nul
exit

:: ==========================================
:: ФУНКЦИЯ ПРОГРЕСС-БАРА
:: ==========================================
:SHOW_PROGRESS
set /a current_task+=1
set /a pct=(current_task*100)/total_tasks

set "bar="
set /a filled=pct/5
set /a empty=20-filled
for /l %%i in (1,1,%filled%) do set "bar=!bar!#"
for /l %%i in (1,1,%empty%) do set "bar=!bar!-"

cls
echo %LineEq%
echo                                %cGreen%MDOptimizer: Идет настройка и установка...%cReset%
echo %LineEq%
echo.
echo  %cWhite%Текущая задача: %cYellow%%~1%cReset%
echo.
echo  Прогресс: [%cGreen%!bar!%cReset%] %cWhite%!pct!%% (%current_task% из %total_tasks%)%cReset%
echo.
exit /b