<#
.Synopsis
   Short description
    This script will be used for installing silently the Putty application by downloading the latest version its official site.
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

#import the external module into this script.
. "$PSScriptRoot\Get-ConfigurationValue.ps1"
. "$PSScriptRoot\Get-OSArchitecture.ps1"
. "$PSScriptRoot\Get-Putty.ps1"
. "$PSScriptRoot\Get-PuttyBinary.ps1"

#get the script file name.
$ScriptFileName = $MyInvocation.MyCommand.Name

#configuration file name.
$ConfigurationFileName = "Install-Putty.cfg.ini"

#get the ini configuration file name.
$ConfigurationIniFile = "$PSScriptRoot\$ConfigurationFileName"

#get the configuration values.
$PuttySourceInstallerUrl = Get-ConfigurationValue -ConfigurationIniFile $ConfigurationIniFile -ConfigurationIniSection $ScriptFileName -ConfigurationIniKey "PUTTY_SOURCE_INSTALLER_PATH"

#function to install silently the Putty application.
function Install-Putty
{
    Param
    (
    #parameter for the base Putty binary directory.
        [ValidateNotNullOrEmpty()]
        [String]
        $PuttySourceInstallerUrl = $PuttySourceInstallerUrl
    )

    Begin
    {
        #throw an error exception if no available for the source url.
        if (!$PuttySourceInstallerUrl)
        {
            Write-Error -Message "There was NO Putty URL available from [Install-Putty.cfg.ini] file" -ErrorAction Stop
        }
    }
    Process
    {
        #pre-validate to check for the availability in the target system.

        #if available, then show its version on console.
        $isPutty = Get-Putty
        if ($isPutty[0] -eq $true)
        {
            exit
        }

        #if not available, then install it accordingly.
        #pre-validate the OS architecture for the target system.
        #download the latest version of Putty application from its official site.
        $BinaryFile = Get-PuttyBinary -InstallerSourceUrl $PuttySourceInstallerUrl

        #install it silently.
        $InstallationProcess = Start-Process -FilePath "msiexec.exe" -ArgumentList "/i", $BinaryFile, "/passive", "/norestart" -Wait -NoNewWindow -Verbose -ErrorAction Stop

        #throw an error exception if failure to install its binary.
        if ($InstallationProcess.ExitCode -ne 0)
        {
            Write-Error -Message "[$BinaryFile] failed to install with exit code [$( $InstallationProcess.ExitCode )]." -ErrorAction Stop
        }
    }
    End
    {
        #final validation step.
        $isPutty = Get-Putty
        if ($isPutty[0] -eq $false)
        {
            Write-Warning -Message "The Putty application is not successfully installed in this system." -ErrorAction Continue
        }
    }
}

#start to write the log into a log file.
Start-Transcript -Path "$PSScriptRoot\$( $MyInvocation.MyCommand.Name )`.log"

#execute the function.
Install-Putty

#stop the logging.
Stop-Transcript