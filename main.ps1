Add-Type -AssemblyName System.Windows.Forms
Add-Type -AssemblyName System.Drawing

# Create a form
$Form = New-Object System.Windows.Forms.Form

# Set the properties of the form
$Form.ControlBox = $true
$Form.MaximizeBox = $false
$Form.MinimizeBox = $false
$Form.Text = "Joe's PowerApps"
$Form.FormBorderStyle = [System.Windows.Forms.FormBorderStyle]::FixedSingle
$Form.Size = New-Object System.Drawing.Size(1000, 950)
$Form.StartPosition = "CenterScreen"

# Set the background image of the form
$Form.BackgroundImage = [System.Drawing.Image]::FromFile("$PSScriptRoot\shoebill.jpg")

# Create a sound player for background music
$SoundPlayer = New-Object System.Media.SoundPlayer
$SoundPlayer.SoundLocation = "$PSScriptRoot\assets\background_music.wav"

$MuteButton = New-Object System.Windows.Forms.Button
$MuteButton.Width = 20
$MuteButton.Height = 20
$MuteButton.Left = $Form.Width - $MuteButton.Width - 20
$MuteButton.Top = 10
# O botão deve ser em formato de circle

$MuteButton.BackgroundImage = [System.Drawing.Image]::FromFile("$PSScriptRoot\assets\stop_red.png")
$MuteButton.BackgroundImage.Tag = "Mute"
$MuteButton.BackColor = "Red"
# Define the event handler for the mute button
$MuteButton.Add_Click({
    if ($SoundPlayer.IsLoadCompleted) {
        if ($MuteButton.BackgroundImage.Tag -eq "Mute") {
            $SoundPlayer.Stop()
            $MuteButton.BackgroundImage = [System.Drawing.Image]::FromFile("$PSScriptRoot\assets\play.png")
            $MuteButton.BackgroundImage.Tag = "Unmute"
            $MuteButton.BackColor = "Green"
        } else {
            $SoundPlayer.PlayLooping()
            $MuteButton.BackgroundImage = [System.Drawing.Image]::FromFile("$PSScriptRoot\assets\stop_red.png")
            $MuteButton.BackgroundImage.Tag = "Mute"
            $MuteButton.BackColor = "Red"
        }
    }
})

# Add the mute button to the form

# Add the mute button to the form
$Form.Controls.Add($MuteButton)

# Load and play the background music
$SoundPlayer.LoadAsync()
$SoundPlayer.PlayLooping()

# Include buttons based on the configuration file
$ButtonWidth = 100
$ButtonHeight = 30
$ButtonMargin = 10
$ColumnMargin = 50

$RowY = ($Form.Height / 2) - (($ButtonHeight + $ButtonMargin) * 9)

# Read the configuration file
$config = Get-Content -Path './config.json' | ConvertFrom-Json

$i = 1
foreach ($key in $config.PSObject.Properties.Name) {
    $Button = New-Object System.Windows.Forms.Button
    $Button.Text = $config.$key.alias
    $Button.Width = $ButtonWidth
    $Button.Height = $ButtonHeight
    $Button.Left = ($Form.Width / 2) - (($ButtonWidth + $ButtonMargin) * 4.5) + (($ButtonWidth + $ButtonMargin) * (($i - 1) % 2))
    $Button.Top = $RowY + (($ButtonHeight + $ButtonMargin) * [math]::Floor(($i - 1) / 2))

    # Add a click event to the button
    $Button.Add_Click({
        # Store the file path in a variable
        $filePath = $config.$key.'file.ps1'
        # Check if the file exists before trying to execute it
        if (Test-Path $filePath) {
            # Execute the script specified in the configuration file
            & $filePath
        } else {
            Write-Host "The file $filePath does not exist."
        }
    }.GetNewClosure())

    $Form.Controls.Add($Button)
    $i++
}

# Show the form
$Form.ShowDialog()

# Stop the background music when the form is closed
$SoundPlayer.Stop()