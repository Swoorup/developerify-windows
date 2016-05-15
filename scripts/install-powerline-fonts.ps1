# Download the file
$source = "https://github.com/powerline/fonts/archive/master.zip"
$destination = Join-Path -Path $env:TEMP -ChildPath "powerline.zip"
$dscHome = md -Force "$env:TEMP\Powerline-Fonts"

$wc = New-Object system.net.webclient
$wc.downloadFile($source,$destination)

$shell = New-Object -com shell.application
$files = $shell.namespace($destination).items()
$shell.NameSpace($dscHome).copyHere($files)