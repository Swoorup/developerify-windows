# https://www.autoitscript.com/forum/topic/174609-powershell-script-to-self-elevate/

# Test if admin
function Test-IsAdmin() {
    # Get the current ID and its security principal
    $windowsID = [System.Security.Principal.WindowsIdentity]::GetCurrent()
    $windowsPrincipal = new-object System.Security.Principal.WindowsPrincipal($windowsID)

    # Get the Admin role security principal
    $adminRole=[System.Security.Principal.WindowsBuiltInRole]::Administrator

    # Are we an admin role?
    if ($windowsPrincipal.IsInRole($adminRole)) {
        $true
    }
    else {
        $false
    }
}


# Get UNC path from mapped drive
function Get-UNCFromPath {
   Param(
    [Parameter(Position=0, Mandatory=$true, ValueFromPipeline=$true)]
    [String]
    $Path)

    if ($Path.Contains([io.path]::VolumeSeparatorChar)) {
        $psdrive = Get-PSDrive -Name $Path.Substring(0, 1) -PSProvider 'FileSystem'

        # Is it a mapped drive?
        if ($psdrive.DisplayRoot) {
            $Path = $Path.Replace($psdrive.Name + [io.path]::VolumeSeparatorChar, $psdrive.DisplayRoot)
        }
    }

    return $Path
 }


# Relaunch the script if not admin
function Invoke-RequireAdmin {
    Param(
    [Parameter(Position=0, Mandatory=$true, ValueFromPipeline=$true)]
    [System.Management.Automation.InvocationInfo]
    $MyInvocation)

    if (-not (Test-IsAdmin)) {
        # Get the script path
        $scriptPath = $MyInvocation.MyCommand.Path
        $scriptPath = Get-UNCFromPath -Path $scriptPath

        # Need to quote the paths in case of spaces
        $scriptPath = '"' + $scriptPath + '"'

        # Build base arguments for powershell.exe
        [string[]]$argList = @('-NoLogo -NoProfile', '-ExecutionPolicy Bypass', '-File', $scriptPath)

        # Add 
        $argList += $MyInvocation.BoundParameters.GetEnumerator() | Foreach {"-$($_.Key)", "$($_.Value)"}
        $argList += $MyInvocation.UnboundArguments

        try {    
            $process = Start-Process PowerShell.exe -PassThru -Verb Runas -Wait -WorkingDirectory $pwd -ArgumentList $argList
            exit $process.ExitCode
        }
        catch {}

        # Generic failure code
        exit 1 
    }
}

# Relaunch if not admin
Invoke-RequireAdmin $script:MyInvocation

# Running as admin
# Install Chocolatey - the package manager for Windows {{{
    iex ((new-object net.webclient).DownloadString('https://chocolatey.org/install.ps1'))
    
    # install the following applications using chocolatey
    cinst babun
    cinst f.lux
    cinst atom
    cinst sysinternals
    cinst windbg
    cinst notepadplusplus
    cinst regexpixie
    cinst autohotkey
    cinst linqpad
    cinst beyondcompare
# }}}

# Install powerline fonts {{{
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
#}}}

# Run post babun install script {{{
    $ENV:BABUN_HOME = "$ENV:UserProfile\.babun"
    $ENV:CYGWIN_HOME = "$ENV:BABUN_HOME\cygwin"
    $cwd = (Get-Item -Path ".\" -Verbose).FullName
    
    # get cygwin path representation for the post installation script file
    $script_file = & "$ENV:CYGWIN_HOME\bin\cygpath.exe" "$cwd\babun-post-install.sh"
    
    # start zsh as an interactive shell
    Start-Process "$ENV:CYGWIN_HOME\bin\zsh" "-l -i $script_file"
#}}}