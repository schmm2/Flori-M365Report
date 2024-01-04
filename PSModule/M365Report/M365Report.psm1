$functionFolders = @('Functions', 'Internal')

# Importing all the Functions required for the module from the subfolders.
ForEach ($functionFolder in $functionFolders) {
    $folderPath = Join-Path -Path $PSScriptRoot -ChildPath $functionFolder
    Write-Verbose -Message "Set Folderpath $folderPath"

    If (Test-Path -Path $folderPath) {
        Write-Verbose -Message "Importing from $folderPath"
        $functions = Get-ChildItem -Path $folderPath -Recurse -Filter '*.ps1'
        ForEach ($function in $functions) {
            Write-Verbose -Message "  Loading $($function.FullName)"
            . ($function.FullName)
        }
    }
    else {
        Write-Warning "Path $folderPath not found. Some parts of the module will not work."
    }
}

$PSModuleMicrosoftGraphAuthentication = Get-Module -Name Microsoft.Graph.Authentication
if ($PSModuleMicrosoftGraphAuthentication) {
    Write-Verbose -Message "MicrosoftGraph Autentication Module is loaded."
}
else {
    Write-Warning -Message "MicrosoftGraphAuthentication Module is not loaded, importing now."
    Import-Module -Name Microsoft.Graph.Authentication -ErrorAction Stop
}

$PSModulePSWriteWord = Get-Module -Name PSWriteWord
if ($PSModulePSWriteWord) {
    Write-Verbose -Message "PSWriteWord Module is loaded."
}
else {
    Write-Warning -Message "PSWriteWord Module is not loaded, importing now."
    Import-Module -Name PSWriteWord -ErrorAction Stop
}

# Classes
class ReportSection {
    [ReportSection[]]$SubSections
    [string]$Title
    [string]$Text
    [object]$Objects
    [bool]$Transpose
}
class Report {
    [ReportSection[]]$SubSections
    [string]$Organization
    [string[]]$Components
    [DateTime]$CreationDate
    [bool]$Translated
}