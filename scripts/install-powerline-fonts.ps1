# Create the temporary directory
md -Force "$env:TEMP\Powerline-Fonts"

# Download the zipped content of branch:master of powerline
$source = "https://github.com/powerline/fonts/archive/master.zip"
$destination = Join-Path -Path $env:TEMP -ChildPath "powerline.zip"
$wc = New-Object system.net.webclient
$wc.downloadFile($source,$destination)

# Extract contents into the directory
$shell_app = New-Object -com shell.application
$zip_file = $shell_app.namespace($destination)
$destination = Join-Path -Path $env:TEMP -ChildPath "Powerline-Fonts"
$destination = $shell_app.namespace($destination)
$destination.Copyhere($zip_file.items())

# Install the fonts recursively
$sa = new-object -comobject shell.application
$fonts =  $sa.NameSpace(0x14)
gci "$env:TEMP\Powerline-Fonts" -i *.ttf, *.otf -Recurse | %{$fonts.CopyHere($_.FullName)}

# Cleanup temp folder
Remove-Item -Force -Recurse "$env:TEMP\Powerline-Fonts" 
Remove-Item "$env:TEMP\powerline.zip" -Force