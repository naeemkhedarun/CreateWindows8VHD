Parameters:

1. Full path and name of the VHD you would like to create.
2. The maximum size of the image.
3. The drive letter to assign the VDH to (must not be in use).

Example:


C:\projects\CreateWindows8VHD> 
C:\projects\CreateWindows8VHD> 


# Move into the directory where the scripts list.
cd C:\projects\CreateWindows8VHD

#Import the function
Import-Module .\Create-Windows8VHD.ps1

# Create the VHD noting the paramters
Create-Windows8VHD "C:\vhd\windows8preview.vhd" "30000" "X"

# Following this to set up a dual boot record you can do (where driveletter is what you choose above):

C:\Windows\sysnative\bcdboot driveletter:\Windows

You should now be able to restart into the Windows 8 Preview!