$baseUrl = "https://sepaev.github.io/pictures"
$output = "index.html"

$html = @"
<!DOCTYPE html>
<html lang='uk'>
<script>
function copyToClipboard(text) {
    navigator.clipboard.writeText(text).then(() => {
        showToast("Посилання скопійовано");
    }).catch(err => {
        console.error("Помилка копіювання:", err);
    });
}

function showToast(message) {
    const toast = document.createElement("div");
    toast.className = "copy-toast";
    toast.textContent = message;
    document.body.appendChild(toast);

    setTimeout(() => {
        toast.classList.add("visible");
    }, 100); // плавне з'явлення

    setTimeout(() => {
        toast.classList.remove("visible");
        setTimeout(() => toast.remove(), 500); // видалення після анімації
    }, 2000); // зникнення через 2 секунди
}
</script>

<head>
    <meta charset='UTF-8'>
    <title>Файловий провідник</title>
    <link rel="shortcut icon" href="favicon.png" type="image/png">
    <style>
        body {
            font-family: Arial, sans-serif;
            background: linear-gradient(180deg, #000000, #ffffff);
            margin: 0;
        }
        h1 {
            font-size: 30px;
            color: gold;
            text-align: center;
            position: sticky;
            top: 0;
            background: linear-gradient(180deg, #000000, #ffffff);
            padding: 10px;
            z-index: 100;
        }
        h2 {
            margin-top: 20px;
            text-align: center;
        }
        ul {
            list-style: none;
            padding: 0;
        }
        .grid {
            display: grid;
            grid-template-columns: repeat(auto-fill, minmax(150px, 1fr));
            gap: 10px;
        }
        .item {
            padding: 5px;
            text-align: center;
            border: 1px solid #ddd;
            border-radius: 5px;
            transition: all 0.2s ease-in-out;
        }
        .item:hover {
            background-color: #f9f9f9;
            transform: scale(1.03);
        }
        .folder-icon {
            margin-right: 8px;
        }
        .folder_container, .photo_container {
            border: 1px solid #ccc;
            border-radius: 10px;
            box-shadow: 0 4px 8px rgba(0,0,0,0.1);
            padding: 15px 20px;
            margin: 20px 60px;
            background-color: #fff;
        }
        details summary {
            font-weight: bold;
            cursor: pointer;
            padding: 5px;
            background-color: #eee;
            border-radius: 5px;
        }
        img.thumb {
            width: 100px;
            height: auto;
            border-radius: 5px;
            margin-bottom: 5px;
        }
        /* Папки — без маркера, чорний текст, жирний */
        details.folder > summary {
            font-weight: bold;
            color: #000;
            list-style: none;
        }
        details.folder > summary::marker {
            display: none;
        }
        /* Цифри та літери — стандартна стрілочка, чорний текст, не жирний */
        details.group > summary {
            padding-left: 50px;
            font-weight: normal;
            color: #000;
        }
        a {
            text-decoration: none;       /* без підчоркування */
            color: #228B22;              /* зелений колір */
            font-weight: bold;           /* жирний шрифт */
        }

        a:hover {
            color: DarkGoldenRod;              /* темніший зелений при наведенні */
        }
        img.thumb {
            width: 100px;
            height: auto;
            border-radius: 10px;              /* заокруглення */
            box-shadow: 0 4px 8px rgba(0,0,0,0.3); /* тінь */
            margin-bottom: 5px;
            transition: transform 0.2s ease-in-out;
        }

        img.thumb:hover {
            transform: scale(1.05);           /* легке збільшення при наведенні */
        }
        .copy-btn {
            background: none;
            border: none;
            cursor: pointer;
            margin-top: 5px;
        }
        .copy-btn img {
            vertical-align: middle;
            opacity: 0.7;
            transition: opacity 0.2s ease-in-out;
            padding-bottom: 5px;
        }
        .copy-btn:hover img {
            opacity: 1;
        }
        .copy-toast {
            position: fixed;
            top: 20px;
            right: 20px;
            background-color: #4CAF50; /* зелений */
            color: white;
            padding: 10px 20px;
            border-radius: 8px;
            box-shadow: 0 4px 8px rgba(0,0,0,0.2);
            opacity: 0;
            transform: translateY(-10px);
            transition: opacity 0.3s ease, transform 0.3s ease;
            z-index: 9999;
            font-size: 14px;
            pointer-events: none;
        }
        .copy-toast.visible {
            opacity: 1;
            transform: translateY(0);
        }

    </style>
</head>
<body>
<h1><a href='$baseUrl/' target='_blank' style="color: gold; text-decoration: none;">Файловий провідник</a></h1>
<section class="folder_container">
<h2>Наявні теки</h2>
<ul>
"@

# Обробка тек
Get-ChildItem -Directory | ForEach-Object {
    $folder = $_.Name
    # Назва папки
    $html += "<li><details class='folder'><summary class='folder-icon'><img src='$baseUrl/folder.png' width='20' height='20'>$folder/</summary>"


    $files = Get-ChildItem "$folder" -Filter *.jpg

    # Цифрові групи 0–9
    foreach ($digit in 0..9) {
        $group = $files | Where-Object { $_.Name -like "$digit*" }
        if ($group.Count -gt 0) {
            # Цифрові групи
            $html += "<details class='group'><summary>$digit - [$($group.Count) шт.]</summary><div class='grid'>"
            foreach ($file in $group) {
                $name = $file.BaseName
                $html += "<div class='item'><a href='$baseUrl/$folder/$($file.Name)' target='_blank'><img src='$baseUrl/$folder/$($file.Name)' class='thumb'><br>$name</a><br><button onclick='copyToClipboard(`"$baseUrl/$folder/$($file.Name)`")' class='copy-btn'><img src='copy.png' width='16' height='16' alt='Copy'></button></div>"
            }
            $html += "</div></details>"
        }
    }

    # Літерні файли
    $letters = $files | Where-Object { $_.Name -match "^[A-Za-zА-Яа-яІіЇїЄє]" }
    if ($letters.Count -gt 0) {
        # Літерні файли
        $html += "<details class='group'><summary>Літери - [$($letters.Count) шт.]</summary><div class='grid'>"
        foreach ($file in $letters) {
            $name = $file.BaseName
          $html += "<div class='item'><a href='$baseUrl/$folder/$($file.Name)' target='_blank'><img src='$baseUrl/$folder/$($file.Name)' class='thumb'><br><span>$name</a></span><button onclick='copyToClipboard(`"$baseUrl/$folder/$($file.Name)`")' class='copy-btn'><img src='copy.png' width='16' height='16' alt='Copy'></button></div>"

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
       $html += "<div class='item'><a href='$baseUrl/$($file.Name)' target='_blank'><img src='$baseUrl/$($file.Name)' class='thumb'><br><span>$name</a></span><button onclick='copyToClipboard(`"$baseUrl/$($file.Name)`")' class='copy-btn'><img src='copy.png' width='16' height='16' alt='Copy'></button></div>"
    }
    $html += "</div></section>"
}

$html += @"
<script>
document.addEventListener('DOMContentLoaded', function() {
    if (window.location.protocol === 'file:') {
        const localBase = 'file:///G:/GIT/';

        // Міняємо тільки адресу картинки, що відображається
        document.querySelectorAll('img.thumb').forEach(img => {
            img.src = img.src.replace('https://sepaev.github.io/', localBase);
        });

        // Посилання та кнопки копіювання не чіпаємо
    }
});
</script>

</body></html>
"@

# Запис у файл
$html | Out-File -Encoding UTF8 $output

# Відкриття HTML
Start-Process $output
