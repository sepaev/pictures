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
    $html += "<li><details><summary class='folder-icon'><img src='$baseUrl/folder.png' width='20' height='20'>$folder/</summary>"

    $files = Get-ChildItem "$folder" -Filter *.jpg

    # Цифрові групи 0–9
    foreach ($digit in 0..9) {
        $group = $files | Where-Object { $_.Name -like "$digit*" }
        if ($group.Count -gt 0) {
            $html += "<details><summary>$digit</summary><div class='grid'>"
            foreach ($file in $group) {
                $name = $file.BaseName
                $html += "<div class='item'><a href='$baseUrl/$folder/$($file.Name)' target='_blank'>$name</a></div>"
            }
            $html += "</div></details>"
        }
    }

    # Літерні файли
    $letters = $files | Where-Object { $_.Name -match "^[A-Za-zА-Яа-яІіЇїЄє]" }
    if ($letters.Count -gt 0) {
        $html += "<details><summary>Літери</summary><div class='grid'>"
        foreach ($file in $letters) {
            $name = $file.BaseName
            $html += "<div class='item'><a href='$baseUrl/$folder/$($file.Name)' target='_blank'>$name</a></div>"
        }
        $html += "</div></details>"
    }

    $html += "</details></li>"
}

$html += "</ul></section>"

# Фото без тек
$rootFiles = Get-ChildItem -File -Filter *.jpg
if ($rootFiles.Count -gt 0) {
    $html += "<h2>Фотографії</h2><section class='photo_container'><div class='grid'>"
    foreach ($file in $rootFiles) {
        $name = $file.BaseName
        $html += "<div class='item'><a href='$baseUrl/$($file.Name)' target='_blank'>$name</a></div>"
    }
    $html += "</div></section>"
}

$html += "</body></html>"

# Запис у файл
$html | Out-File -Encoding UTF8 $output

# Відкриття HTML
Start-Process $output
