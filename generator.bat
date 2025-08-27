@echo off
setlocal enabledelayedexpansion

:: Налаштування
set "base_url=https://sepaev.github.io/pictures"
set "output=index.html"

:: Початок HTML
echo ^<!DOCTYPE html^> > %output%
echo ^<html lang='ru'^> >> %output%
echo ^<head^> >> %output%
echo     ^<meta charset='UTF-8'^> >> %output%
echo     ^<title^>Файловый проводник^</title^> >> %output%
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
    set "folder=%%D"
    echo ^<li^> ^<details^>^<summary class='folder-icon'^>^<img src='%base_url%/folder.png' alt='Папка' width='20' height='20'^>!folder!/^</summary^>^<div class='grid'^> >> %output%
    for %%F in ("%%D\*.jpg") do (
        set "file=%%~nxF"
        echo ^<div class='item'^>^<a href='%base_url%/!folder!/!file!' target='_blank'^>!file:~0,-4!^</a^>^</div^> >> %output%
    )
    echo ^</div^>^</details^>^</li^> >> %output%
)

echo ^</ul^> >> %output%
echo ^</section^> >> %output%

:: Фото без тек
echo ^<h2^>Фотографії^</h2^> >> %output%
echo ^<section class="photo_container"^> >> %output%
echo ^<div class="grid"^> >> %output%

for %%F in (*.jpg) do (
    set "file=%%~nxF"
    echo ^<div class='item'^>^<a href='%base_url%/!file!' target='_blank'^>!file:~0,-4!^</a^>^</div^> >> %output%
)

echo ^</div^> >> %output%
echo ^</section^> >> %output%
echo ^</body^> >> %output%
echo ^</html^> >> %output%

:: Відкриття HTML-файлу
start "" "%output%"

echo Готово! Файл index.html створено і відкрито.
exit
