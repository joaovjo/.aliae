# URL do tema
$THEME_URL = "https://raw.githubusercontent.com/JanDeDobbeleer/oh-my-posh/refs/heads/main/themes/montys.omp.json"

# Inicializar o oh-my-posh
oh-my-posh init pwsh --config $THEME_URL | Invoke-Expression

# Lista de módulos necessários
$modules = @("PSReadLine", "Get-ChildItemColor", "Terminal-Icons")

foreach ($module in $modules) {
    if (-not (Get-Module -ListAvailable -Name $module)) {
        Write-Host "Módulo $module não encontrado. Instalando..."
        Install-Module -Name $module -Force -Scope CurrentUser
    } else {
        Write-Host "Módulo $module já está instalado."
    }
    # Importa o módulo
    Import-Module -Name $module
}

Write-Host "Todos os módulos foram instalados e importados com sucesso."


Set-PSReadLineOption -HistorySearchCursorMovesToEnd
Set-PSReadlineKeyHandler -Key UpArrow -Function HistorySearchBackward
Set-PSReadlineKeyHandler -Key DownArrow -Function HistorySearchForward
Set-PSReadLineOption -PredictionSource History
Set-PSReadLineOption -PredictionViewStyle ListView
Set-PSReadLineOption -EditMode Windows
Set-PSReadLineOption -ShowToolTips
Set-PSReadLineOption -PredictionSource History
Set-PSReadLineKeyHandler -Key Tab -Function MenuComplete

$MaximumHistoryCount = 30000

# History definitions
$HistoryFilePath = Join-Path ([Environment]::GetFolderPath('UserProfile')) .ps_history
Register-EngineEvent PowerShell.Exiting -Action { Get-History | Export-Clixml $HistoryFilePath } | out-null
if (Test-path $HistoryFilePath) { Import-Clixml $HistoryFilePath | Add-History }

# Compute file hashes - useful for checking successful downloads
function md5    { Get-FileHash -Algorithm MD5 $args }
function sha1   { Get-FileHash -Algorithm SHA1 $args }
function sha256 { Get-FileHash -Algorithm SHA256 $args }

function tail { Get-Content $args -Tail 30 -Wait }

function take {
  New-Item -ItemType directory $args
  Set-Location "$args"
}

# Aliases
Set-Alias which Get-Command
Set-Alias open Invoke-Item

function ll() { Get-ChildItem | Format-Table }
function la() { Get-ChildItem | Format-Wide }
function lb() { Get-ChildItem | Format-List }

Set-Alias ls la
Set-Alias l lb

# Criando funções de navegação

function study() {
    Set-Location -Path "D:\study"
}

function pjts() {
    Set-Location -Path "D:\projects"
}

function college() {
    Set-Location -Path "D:\college"
}

Set-Alias -Name a -Value "php artisan"
Set-Alias -Name pa -Value "php artisan"
Set-Alias -Name phpa -Value "php artisan"
Set-Alias -Name art -Value "php artisan"
Set-Alias -Name arti -Value "php artisan"

Set-Alias -Name ars -Value "php artisan serve"

Set-Alias -Name cclear -Value "php artisan cache:clear"
Set-Alias -Name mfs -Value "php artisan migrate:fresh --seed"
Set-Alias -Name mfsr -Value "php artisan migrate:fresh --seed --refresh"
Set-Alias -Name tinker -Value "php artisan tinker"

Set-Alias -Name nah -Value "git reset --hard; git clean -df"
Set-Alias -Name wip -Value "git add .; git commit -m 'WIP'"

# Rust completions
$RUST_COMPLETIONS_URL = "https://gist.github.com/joaovjo/68e48d6090230e937e482d794bba9282/raw/3216bffd72dd84f68f1fe0d243fce5a4d1580620/rust_completions.ps1"
# Baixa as infos
iex ((New-Object System.Net.WebClient).DownloadString("$RUST_COMPLETIONS_URL"))