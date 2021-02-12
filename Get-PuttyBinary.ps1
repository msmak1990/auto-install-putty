<#
.Synopsis
   Short description
    This script will be used for downloading the latest Putty installer from its official site.
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

function Get-PuttyBinary
{
    Param
    (
    #parameter for Putty installer source url.
        [ValidateNotNullOrEmpty()]
        [String]
        $InstallerSourceUrl
    )

    Begin
    {
        #create the request.
        $HttpRequest = [System.Net.WebRequest]::Create($InstallerSourceUrl)

        #get a response from the site.
        $HttpResponse = $HttpRequest.GetResponse()

        #get the HTTP code as an integer.
        $HttpStatusCode = [int]$HttpResponse.StatusCode

        #throw exception if status code is not 200 (OK).
        if ($HttpStatusCode -ne 200)
        {
            Write-Error -Message "[$InstallerSourceUrl] unable to reach out with status code [$HttpStatusCode]." -ErrorAction Stop
        }

        #get OS architecture - 32 or 64-bit?.
        $OSArchitecture = Get-OSArchitecture

    }
    Process
    {
        #get site contents.
        $SiteContents = Invoke-WebRequest -Uri $InstallerSourceUrl -UseBasicParsing

        #get href link.
        $SiteHrefs = $SiteContents.Links

        #dynamic array for storing Putty version extracted from site.
        $ApplicationOSArchitecture = [system.Collections.ArrayList]@()

        #filter only uri contains the Putty versions.
        foreach ($SiteHref in $SiteHrefs)
        {
            if ($SiteHref.href -match "\bw\d\d\b")
            {
                $ApplicationOSArchitecture.Add($( $SiteHref.href )) | Out-Null
            }
        }

        #get OS architecture for Putty binary file name.
        if ($OSArchitecture[0] -eq $true)
        {
            #for 32-bit
            if ($OSArchitecture[1] -eq "32-bit")
            {
                #get latest Putty binary file name.
                $PuttyUrlOSArchitecture = "$InstallerSourceUrl/$( $ApplicationOSArchitecture[0] )"
            }

            #for 64-bit
            if ($OSArchitecture[1] -eq "64-bit")
            {
                #get latest Putty binary file name.
                $PuttyUrlOSArchitecture = "$InstallerSourceUrl/$( $ApplicationOSArchitecture[1] )"
            }

            $SiteContents = Invoke-WebRequest -Uri $PuttyUrlOSArchitecture -UseBasicParsing
            $SiteContents.Links | ForEach-Object {
                if ($_.href -match "(\.msi)$")
                {
                    #get full path of Putty binary source url.
                    $PuttyLatestVersion = $_.href
                    $BinarySourceUrl = "$PuttyUrlOSArchitecture/$PuttyLatestVersion"
                }
            }
        }

        #if no available for OS Architecture, then use 32-bit Putty binary file name.
        if ($OSArchitecture[0] -eq $false)
        {
            Write-Error -Message "We cannot find your system bit (32-bit or 64-bit)." -ErrorAction Stop
        }

        #get Putty download destination directory for specific user.
        $InstallerDownloadDirectory = "$( $env:USERPROFILE )\Downloads\$PuttyLatestVersion"

        #download latest Putty binary file from site.
        Invoke-WebRequest -Uri $BinarySourceUrl -OutFile $InstallerDownloadDirectory -Verbose -TimeoutSec 60

        #throw exception if no available for Putty installer.
        if (!$( Test-Path -Path $InstallerDownloadDirectory -PathType Leaf ))
        {
            Write-Error -Message "[$InstallerDownloadDirectory] does not exist." -Category ObjectNotFound -ErrorAction Stop
        }
    }
    End
    {
        #final validation to check the download directory.
        if (!$( Test-Path -Path $InstallerDownloadDirectory -PathType Leaf ))
        {
            Write-Error -Message "[$InstallerDownloadDirectory] does not exist." -Category ObjectNotFound -ErrorAction Stop
        }

        #return full path for Putty installer binary file.
        return $InstallerDownloadDirectory
    }
}