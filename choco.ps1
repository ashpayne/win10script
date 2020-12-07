
##########
# Tweaked Win10 Initial Setup Script
# Primary Author: Disassembler <disassembler@dasm.cz>
# Primary Author Source: https://github.com/Disassembler0/Win10-Initial-Setup-Script
# Tweaked Source: https://gist.github.com/alirobe/7f3b34ad89a159e6daa1/
#
#    If you're a power user looking to tweak your machinea, or doing larger roll-out.. 
#    Use the @Disassembler0 script instead. It'll probably be more up-to-date than mine:
#    https://github.com/Disassembler0/Win10-Initial-Setup-Script
# 
#    Note from author: Never run scripts without reading them & understanding what they do.
#
#	Addition: One command to rule them all, One command to find it, and One command to Run it! 
#
#     > powershell -nop -c "iex(New-Object Net.WebClient).DownloadString('https://git.io/JJ8R4')"
#
#	Chris Titus Additions:
#
#	- Dark Mode
#	- One Command to launch and run
#	- Chocolatey Install
#	- O&O Shutup10 CFG and Run
#	- Added Install Programs
#	- Added Debloat Microsoft Store Apps
#
##########
# Default preset
$tweaks = @(
	### Require administrator privileges ###
	"RequireAdmin",

	### External Program Setup
	"InstallTitusProgs", #REQUIRED FOR OTHER PROGRAM INSTALLS!
	"InstallVLC",
	"InstallPostman",
	"InstallPowerToys",
	"InstallTeraCopy",
	"InstallMirc",
	"InstallTorrent",
	"InstallPutty",
	"InstallOpenSSHClient",

	### Unpinning ###
	"UnpinStartMenuTiles",
	#"UnpinTaskbarIcons",

	### Auxiliary Functions ###
	"InstallWSL2",
	"WaitForKey"
	"Restart"
)

#########
# Recommended Titus Programs
#########

Function InstallTitusProgs {
	Write-Output "Installing Chocolatey"
	Set-ExecutionPolicy Bypass -Scope Process -Force; [System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072; iex ((New-Object System.Net.WebClient).DownloadString('https://chocolatey.org/install.ps1'))
	choco install chocolatey-core.extension -y
	Write-Output "Running O&O Shutup with Recommended Settings"
	Import-Module BitsTransfer
	Start-BitsTransfer -Source "https://raw.githubusercontent.com/ChrisTitusTech/win10script/master/ooshutup10.cfg" -Destination ooshutup10.cfg
	Start-BitsTransfer -Source "https://dl5.oo-software.com/files/ooshutup10/OOSU10.exe" -Destination OOSU10.exe
	./OOSU10.exe ooshutup10.cfg /quiet
}

Function InstallVLC {
	Write-Output "Installing VLC"
	choco install VLC -y
}
Function InstallOpenSSHClient {
	Write-Output "Installing OpenSSH Client"
	Add-WindowsCapability -Online -Name OpenSSH.Client~~~~0.0.1.0
}
Function InstallWSL2 {
	Write-Output "Installing VLC"
	Enable-WindowsOptionalFeature -Online -FeatureName VirtualMachinePlatform
	
}
Function InstallPostman {
	Write-Output "Installing Postman"
	choco install postman -y
}

Function InstallPowerToys {
	Write-Output "Installing PowerToys"
	choco install powertoys -y
}

Function InstallStreamDeck {
	Write-Output "Installing StreamDeck"
	choco install streamdeck -y
}



Function InstallTeraCopy {
	Write-Output "Installing TeraCopy"
	choco install teracopy -y
}


Function InstallMirc {
	Write-Output "Installing mIRC"
	choco install mirc -y
}


Function InstallSteam {
	Write-Output "Installing Steam"
	choco steam VLC -y
}

Function InstallTorrent {
	Write-Output "Installing Torrent"
	choco install qbittorrent -y
}


Function InstallPutty {
	Write-Output "Installing Putty"
	choco install putty.install -y
}

Function InstallAzureStorage {
	Write-Output "Installing Azure Storage Explorer"
	choco install microsoftazurestorageexplorer -y
}

Function InstallVSCode {
	Write-Output "Installing VS Code"
	choco install vscode -y
}




Function InstallAdobe {
	Write-Output "Installing Adobe Acrobat Reader"
	choco install adobereader -y
}

Function InstallJava {
	Write-Output "Installing Java"
	choco install jre8 -y
}

Function Install7Zip {
	Write-Output "Installing 7-Zip"
	choco install 7zip -y
}

Function InstallNotepadplusplus {
	Write-Output "Installing Notepad++"
	choco install notepadplusplus -y
}

Function InstallMediaPlayerClassic {
	Write-Output "Installing Media Player Classic (VLC Alternative)"
	choco install mpc-hc -y
}



##########
# Unpinning
##########

# Unpin all Start Menu tiles - Note: This function has no counterpart. You have to pin the tiles back manually.
Function UnpinStartMenuTiles {
	Write-Output "Unpinning all Start Menu tiles..."
	If ([System.Environment]::OSVersion.Version.Build -ge 15063 -And [System.Environment]::OSVersion.Version.Build -le 16299) {
		Get-ChildItem -Path "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\CloudStore\Store\Cache\DefaultAccount" -Include "*.group" -Recurse | ForEach-Object {
			$data = (Get-ItemProperty -Path "$($_.PsPath)\Current" -Name "Data").Data -Join ","
			$data = $data.Substring(0, $data.IndexOf(",0,202,30") + 9) + ",0,202,80,0,0"
			Set-ItemProperty -Path "$($_.PsPath)\Current" -Name "Data" -Type Binary -Value $data.Split(",")
		}
	} ElseIf ([System.Environment]::OSVersion.Version.Build -eq 17133) {
		$key = Get-ChildItem -Path "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\CloudStore\Store\Cache\DefaultAccount" -Recurse | Where-Object { $_ -like "*start.tilegrid`$windows.data.curatedtilecollection.tilecollection\Current" }
		$data = (Get-ItemProperty -Path $key.PSPath -Name "Data").Data[0..25] + ([byte[]](202,50,0,226,44,1,1,0,0))
		Set-ItemProperty -Path $key.PSPath -Name "Data" -Type Binary -Value $data
	}
}

# Unpin all Taskbar icons - Note: This function has no counterpart. You have to pin the icons back manually.
Function UnpinTaskbarIcons {
	Write-Output "Unpinning all Taskbar icons..."
	Set-ItemProperty -Path "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Taskband" -Name "Favorites" -Type Binary -Value ([byte[]](255))
	Remove-ItemProperty -Path "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Taskband" -Name "FavoritesResolve" -ErrorAction SilentlyContinue
}



##########
# Auxiliary Functions
##########

# Relaunch the script with administrator privileges
Function RequireAdmin {
	If (!([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]"Administrator")) {
		Start-Process powershell.exe "-NoProfile -ExecutionPolicy Bypass -File `"$PSCommandPath`" $PSCommandArgs" -WorkingDirectory $pwd -Verb RunAs
		Exit
	}
}

# Wait for key press
Function WaitForKey {
	Write-Output "Press any key to continue..."
	[Console]::ReadKey($true) | Out-Null
}

# Restart computer
Function Restart {
	Write-Output "Restarting..."
	Restart-Computer
}

##########
# Parse parameters and apply tweaks
##########

# Normalize path to preset file
$preset = ""
$PSCommandArgs = $args
If ($args -And $args[0].ToLower() -eq "-preset") {
	$preset = Resolve-Path $($args | Select-Object -Skip 1)
	$PSCommandArgs = "-preset `"$preset`""
}

# Load function names from command line arguments or a preset file
If ($args) {
	$tweaks = $args
	If ($preset) {
		$tweaks = Get-Content $preset -ErrorAction Stop | ForEach { $_.Trim() } | Where { $_ -ne "" -and $_[0] -ne "#" }
	}
}

# Call the desired tweak functions
$tweaks | ForEach { Invoke-Expression $_ }
