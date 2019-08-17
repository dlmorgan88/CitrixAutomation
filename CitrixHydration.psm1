#Version 1.2 | 2019-04-23 | Citrix updated the revised script to dynamically recurse four directories then read all files with .dll and .exe extensions
#Version 1.1 | 2019-04-10 | Microsoft revised script to dynamically recurse the "Program Files" directory and read all files with .dll and .exe extensions
#Version 1.0 | 2019-02-07 | Microsoft created script to parse a text document with files to read.

#Main function of module
Function Read-CloudVMFiles {
    [cmdletbinding()]
    Param(
        [Parameter(Mandatory=$false, Position=1)]
        [ValidateScript({Test-Connection $_ -Count 1})]
        [string]
        $AdminAddress="localhost",

        [Parameter()]
        [switch]
        $VerboseLogging,

        #Location of path
        [Parameter(Mandatory=$false)]
        [ValidateScript({Test-Path $_ -IsValid})] 
        [string]
        $LogFileLocation
    )
    

    if (!([System.Diagnostics.EventLog]::Exists("Application")) {
        #logging function
        Write-Host "Windows Application Log does not exist.  Event Logging not available."
    }

}

Function Write-Log {
    [cmdletbinding()]
    Param (
        
    )
}

#checks for existence 

New-EventLog -LogName Application -Source CitrixHydration
$sw = [Diagnostics.Stopwatch]::StartNew()

function CacheFile([string]$filename)
{
    $bytes = [System.IO.File]::ReadAllBytes($filename) 
}

$filelist =  @(Get-ChildItem "C:\Windows\System32\*.*" -Recurse)
$filelist +=  @(Get-ChildItem "C:\Windows\SysWOW64\*.*" -Recurse)
$filelist +=  @(Get-ChildItem "C:\Program Files\*.*" -Recurse)
$filelist +=  @(Get-ChildItem "C:\Program Files (x86)\*.*" -Recurse)

foreach ($f in $filelist)
{
    $ext = [IO.Path]::GetExtension($f)
    Switch ($ext)
    {
     {($_ -eq ".dll") -or ($_ -eq ".exe")} {CacheFile($f)}
    }
} 

$sw.Stop()
$sw.Elapsed | Out-File -FilePath "C:\VDICache\CacheRunTime.log" -Force
