Add-Type -AssemblyName System.Windows.Forms

# Cria uma janela
$Form = New-Object System.Windows.Forms.Form

# Define a cor dos botões da barra de título
$Form.ControlBox = $true
$Form.MaximizeBox = $false
$Form.MinimizeBox = $false
$Form.Text = "Joe's PowerApps"

$Form.FormBorderStyle = [System.Windows.Forms.FormBorderStyle]::FixedSingle
$Form.Size = New-Object System.Drawing.Size(1000, 950)

$Form.StartPosition = "CenterScreen"

# Colocar imagem shoebill.jpg de fundo na janela, que deve estar na mesma pasta que o script
$Form.BackgroundImage = [System.Drawing.Image]::FromFile("$PSScriptRoot\shoebill.jpg")


# Incluir botões com base no arquivo de configuração
$ButtonWidth = 100
$ButtonHeight = 30
$ButtonMargin = 10
$ColumnMargin = 50

$RowY = ($Form.Height / 2) - (($ButtonHeight + $ButtonMargin) * 9)

# Lê o arquivo de configuração
$config = Get-Content -Path './config.json' | ConvertFrom-Json

$i = 1
foreach ($key in $config.PSObject.Properties.Name) {
    $Button = New-Object System.Windows.Forms.Button
    $Button.Text = $config.$key.alias
    $Button.Width = $ButtonWidth
    $Button.Height = $ButtonHeight
    $Button.Left = ($Form.Width / 2) - (($ButtonWidth + $ButtonMargin) * 4.5) + (($ButtonWidth + $ButtonMargin) * (($i - 1) % 2))
    $Button.Top = $RowY + (($ButtonHeight + $ButtonMargin) * [math]::Floor(($i - 1) / 2))

    # Adiciona um evento de clique ao botão
    $Button.Add_Click({
        # Armazena o caminho do arquivo em uma variável
        $filePath = $config.$key.'file.ps1'
        # Verifica se o arquivo existe antes de tentar executá-lo
        if (Test-Path $filePath) {
            # Executa o script especificado no arquivo de configuração
            & $filePath
        } else {
            Write-Host "O arquivo $filePath não existe."
        }
    }.GetNewClosure())

    $Form.Controls.Add($Button)
    $i++
}

# Exibe a janela
$Form.ShowDialog()