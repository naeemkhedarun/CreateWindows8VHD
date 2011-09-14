function Create-Windows8VHD($vhdLocation, $vhdSize, $driveLetter)
{
	Set-ExecutionPolicy bypass
	
	$iso = Get-PSDrive | Where {$_.Provider.Name -eq "FileSystem"} | Where { Test-Path (join-path $_.Root "\sources\install.wim") }
	
	if($iso -eq $null)
	{
		Write-Host "Please mount the Windows 8 Developer preview ISO. You can download it from: http://msdn.microsoft.com/en-us/windows/home/"
		return
	}

	if((Test-Path $vhdLocation) -eq $true)
	{
		"This VHD already exists, please delete it or choose a new one."
		return
	}
	
	if(Get-PSDrive | Where {$_.Name -eq $driveLetter})
	{
		"The specified drive letter is in use, please select one which is free to assign."
		return
	}

	$vhdFile = New-Item $vhdLocation -type File -Force
	Remove-Item $vhdFile

	$diskpart = [System.IO.Path]::GetTempFileName()
	$diskpart = [System.IO.Path]::ChangeExtension($diskpart, ".txt")
	
	"create vdisk file=$vhdLocation maximum=$vhdSize type=expandable`n
select vdisk file=$vhdLocation`n
attach vdisk`n
create partition primary`n
assign letter=$driveLetter`n
format quick FS=NTFS label=Windows8`n
exit" | out-file -encoding ASCII $diskpart;

	diskpart /s $diskpart

	#$installer = join-path (get-location) Install-WindowsImage.ps1
	#& $installer -WIM "$iso:\sources\install.wim" -Apply -Index 1 -Destination $driveLetter
	
	.\Install-WindowsImage.ps1 -WIM ($iso.Name+":\sources\install.wim") -Apply -Index 1 -Destination ($driveLetter+":")
}
