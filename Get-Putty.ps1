<#
.Synopsis
   Short description
    This script will be used for checking the existence of Putty application in the target system.
.DESCRIPTION
   Long description
    2021-02-13 Sukri Created.
.EXAMPLE
   Example of how to use this cmdlet
.EXAMPLE
   Another example of how to use this cmdlet
.INPUTS
   Inputs to this cmdlet (if any)
.OUTPUTS
   Output from this cmdlet (if any)
.NOTES
   General notes
    Author : Sukri Kadir
    Email  : msmak1990@gmail.com
.COMPONENT
   The component this cmdlet belongs to
.ROLE
   The role this cmdlet belongs to
.FUNCTIONALITY
   The functionality that best describes this cmdlet
#>

function Get-Putty
{
    param
    ()

    begin
    {
        <#BEGIN: VARIABLES DECLARATION#>
        $FileName = $MyInvocation.MyCommand.Name
        $TimeStamp = Get-Date
        $ComputerName = $env:COMPUTERNAME
        $LoggingStamp = "$TimeStamp $FileName"
        # Gets the properties of a specified item in registry for windows 32-bit/64-bit
        $HklmWow6432NodeRegistryPath = "HKLM:\Software\Wow6432Node\Microsoft\Windows\CurrentVersion\Uninstall"
        $HklmWindowsRegistryPath = "HKLM:\Software\Microsoft\Windows\CurrentVersion\Uninstall"
        <#END: VARIABLES DECLARATION#>
    }
    process
    {
        #check Putty installed??
        Write-Host "$LoggingStamp::Check Putty installed in system: `"$ComputerName`"." -ForegroundColor Yellow

        #store registry paths to static array.
        $RegistryPathArray = @($HklmWow6432NodeRegistryPath, $HklmWindowsRegistryPath)

        #find which registry path store value.
        foreach ($RegistryPath in $RegistryPathArray)
        {
            $PuttyProperties = Get-ItemProperty "$RegistryPath\*" | where-Object DisplayName -like 'Putty*'
            if ($PuttyProperties)
            {
                $PuttyRegistryPath = $RegistryPath
                $PuttyProperty = $PuttyProperties
            }
        }
    }
    end
    {
        #show status result if exists.
        #return true
        if ($PuttyProperty)
        {
            $PuttyVersion = $PuttyProperty.DisplayName
            Write-Host "$LoggingStamp::Use Putty registry path: `"$PuttyRegistryPath`"." -ForegroundColor Yellow
            Write-Host "$LoggingStamp::$PuttyVersion is already installed on system: `"$ComputerName`"." -ForegroundColor Green
            return $true, $PuttyProperty
        }

        #show status result if not exists.
        #return false
        if (!$PuttyProperty)
        {
            Write-Host "$LoggingStamp::Putty is not installed on system: `"$ComputerName`"." -ForegroundColor Red
            return $false
        }
    }
}