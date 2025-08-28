@echo off
setlocal enabledelayedexpansion

:: Налаштування
set "base_url=https://sepaev.github.io/pictures"
set "output=index.html"

:: Початок HTML
echo ^<!DOCTYPE html^> > %output%
echo ^<html lang='uk'^> >> %output%
echo ^<head^> >> %output%
echo     ^<meta charset='UTF-8'^> >> %output%
echo     ^<title^>Файловий провідник^</title^> >> %output%
echo     ^<link rel="icon" type="image/png" href="favicon.png"^> >> %output%
echo     ^<style^> >> %output%
echo         body { font-family: Arial, sans-serif; background: linear-gradient(180deg, #000000, #ffffff); } >> %output%
echo         h1 { font-size: 30px; color: gold; text-align: center; } >> %output%
echo         h2 { margin-top: 20px; text-align: center; } >> %output%
echo         ul { list-style: none; padding: 0; } >> %output%
echo         .grid { display: grid; grid-template-columns: repeat(4, 1fr); gap: 10px; } >> %output%
echo         .item { padding: 5px; text-align: center; border: 1px solid #ddd; border-radius: 5px; } >> %output%
echo         .folder-icon { margin-right: 8px; } >> %output%
echo         .folder_container, .photo_container { border: 1px solid #ccc; border-radius: 10px; box-shadow: 0 4px 8px rgba(0,0,0,0.1); padding: 15px 20px; margin: 20px 60px; background-color: #fff; } >> %output%
echo     ^</style^> >> %output%
echo ^</head^> >> %output%
echo ^<body^> >> %output%
echo ^<h1^>Файловий провідник^</h1^> >> %output%

:: Сканування тек
echo ^<section class="folder_container"^> >> %output%
echo ^<h2^>Наявні теки^</h2^> >> %output%
echo ^<ul^> >> %output%

for /d %%D in (*) do (
    echo ^<li^> >> %output%
    echo ^<details^> >> %output%
    echo ^<summary class='folder-icon'^>^<img src='%base_url%/folder.png' alt='Папка' width='20' height='20'^>%%D/^</summary^> >> %output%

    :: 0–9: окремі спойлери
    for %%N in (0 1 2 3 4 5 6 7 8 9) do (
        set "hasFiles="
        for %%F in ("%%D\*.jpg") do (
            set "name=%%~nxF"
            call set "first=%%name:~0,1%%"
            if "!first!"=="%%N" (
                set "hasFiles=1"
            )
        )
        if defined hasFiles (
            echo ^<details^> >> %output%
            echo ^<summary^>%%N^</summary^> >> %output%
            echo ^<div class='grid'^> >> %output%
            for %%F in ("%%D\*.jpg") do (
                set "name=%%~nxF"
                call set "first=%%name:~0,1%%"
                if "!first!"=="%%N" (
                    echo ^<div class='item'^>^<a href='%base_url%/%%D/%%~nF.jpg' target='_blank'^>%%~nF^</a^>^</div^> >> %output%
                )
            )
            echo ^</div^> >> %output%
            echo ^</details^> >> %output%
        )
    )

    :: Літерні файли
    set "hasLetters="
    for %%F in ("%%D\*.jpg") do (
        set "name=%%~nxF"
        call set "first=%%name:~0,1%%"
        echo %%first%% | findstr /r "^[A-Za-zА-Яа-яІіЇїЄє]" >nul
        if not errorlevel 1 (
            set "hasLetters=1"
        )
    )
    if defined hasLetters (
        echo ^<details^> >> %output%
        echo ^<summary^>Літери^</summary^> >> %output%
        echo ^<div class='grid'^> >> %output%
        for %%F in ("%%D\*.jpg") do (
            set "name=%%~nxF"
            call set "first=%%name:~0,1%%"
            echo %%first%% | findstr /r "^[A-Za-zА-Яа-яІіЇїЄє]" >nul
            if not errorlevel 1 (
                echo ^<div class='item'^>^<a href='%base_url%/%%D/%%~nF.jpg' target='_blank'^>%%~nF^</a^>^</div^> >> %output%
            )
        )
        echo ^</div^> >> %output%
        echo ^</details^> >> %output%
    )

    echo ^</details^> >> %output%
    echo ^</li^> >> %output%
)

echo ^</ul^> >> %output%
echo ^</section^> >> %output%

:: Фото без тек
set "hasRoot="
for %%F in (*.jpg) do (
    set "file=%%~nxF"
    if defined file (
        set "hasRoot=1"
    )
)
if defined hasRoot (
    echo ^<h2^>Фотографії^</h2^> >> %output%
    echo ^<section class="photo_container"^> >> %output%
    echo ^<div class="grid"^> >> %output%
    for %%F in (*.jpg) do (
        set "file=%%~nxF"
        echo ^<div class='item'^>^<a href='%base_url%/%%F' target='_blank'^>%%~nF^</a^>^</div^> >> %output%
    )
    echo ^</div^> >> %output%
    echo ^</section^> >> %output%
)

echo ^</body^> >> %output%
echo ^</html^> >> %output%

:: Відкриття HTML-файлу
start "" "%output%"
exit
