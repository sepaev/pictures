$baseUrl = "https://sepaev.github.io/pictures"
$output = "index.html"

$html = @"
<!DOCTYPE html>
<html lang='uk'>
<head>
    <meta charset='UTF-8'>
    <title>Файловий провідник</title>
    <link rel="icon" type="image/png" href="favicon.png">
    <style>
        body { font-family: Arial, sans-serif; background: linear-gradient(180deg, #000000, #ffffff); }
        h1 { font-size: 30px; color: gold; text-align: center; }
        h2 { margin-top: 20px; text-align: center; }
        ul { list-style: none; padding: 0; }
        .grid { display: grid; grid-template-columns: repeat(4, 1fr); gap: 10px; }
        .item { padding: 5px; text-align: center; border: 1px solid #ddd; border-radius: 5px; }
        .folder-icon { margin-right: 8px; }
        .folder_container, .photo_container {
            border: 1px solid #ccc; border-radius: 10px;
            box-shadow: 0 4px 8px rgba(0,0,0,0.1);
            padding: 15px 20px; margin: 20px 60px; background-color: #fff;
        }
    </style>
</head>
<body>
<h1>Файловий провідник</h1>
<section class="folder_container">
<h2>Наявні теки</h2>
<ul>
"@

# Обробка тек
Get-ChildItem -Directory | ForEach-Object {
    $folder = $_.Name
    $html += "<li><details><summary class='folder-icon'><img src='$baseUrl/folder.png' alt='Папка' width='20' height='20'>$folder/</summary>"

    # Отримати всі .jpg файли в теці
    $files = Get-ChildItem "$folder" -Filter *.jpg | Select-Object -ExpandProperty Name

    # Групування по першому символу
    for ($i = 0; $i -le 9; $i++) {
        $group = $files | Where-Object { $_ -match "^$i" }
        if ($group.Count -gt 0) {
            $html += "<details><summary>$i</summary><div class='grid'>"
            foreach ($file in $group) {
                $name = [System.IO.Path]::GetFileNameWithoutExtension($file)
                $html += "<div class='item'><a href='$baseUrl/$folder/$file' target='_blank'>$name</a></div>"
            }
            $html += "</div></details>"
        }
    }

    # Літерні файли
    $letters = $files | Where-Object { $_ -match "^[A-Za-zА-Яа-яІіЇїЄє]" }
    if ($letters.Count -gt 0) {
        $html += "<details><summary>Літери</summary><div class='grid'>"
        foreach ($file in $letters) {
            $name = [System.IO.Path]::GetFileNameWithoutExtension($file)
            $html += "<div class='item'><a href='$baseUrl/$folder/$file' target='_blank'>$name</a></div>"
        }
        $html += "</div></details>"
    }

    $html += "</details></li>"
}

$html += "</ul></section>"

# Фото без тек
$html += "<h2>Фотографії</h2><section class='photo_container'><div class='grid'>"
Get-ChildItem -File -Filter *.jpg | ForEach-Object {
    $file = $_.Name
    $name = [System.IO.Path]::GetFileNameWithoutExtension($file)
    $html += "<div class='item'><a href='$baseUrl/$file' target='_blank'>$name</a></div>"
}
$html += "</div></section></body></html>"

# Запис у файл
$html | Out-File -Encoding UTF8 $output

# Відкриття HTML
Start-Process $output
pause