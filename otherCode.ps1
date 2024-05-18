Add-Type -AssemblyName System.Windows.Forms
$Form = New-Object System.Windows.Forms.Form

$Form.FormBorderStyle = [System.Windows.Forms.FormBorderStyle]::FixedSingle
$Form.Size = New-Object System.Drawing.Size(1000, 950)
$Form.BackgroundImage = [System.Drawing.Image]::FromFile("$PSScriptRoot\shoebill2.jpg")

$Form.ShowDialog()
