Function Set-M365ReportLanguage() {
    <#
    .SYNOPSIS
    Replace all "TRANSLATE-" strings with the corresponding value in the selected Language.

    .DESCRIPTION
    This function takes the report and is replacing text strings.

    .PARAMETER Language
    Language to which the report should be translated

    .PARAMETER Data
    M365 report object which shoult be translated 
    
    .EXAMPLE
    Set-M365ReportLanguage -Language DE -Data $Data

    .NOTES
    NAME: M.Schmidli 5.1.2024

    #>
    [OutputType('Report')]
    param(
        [Parameter(Mandatory)]
        [ValidateSet('EN', 'DE')]
        [System.String]$Language,
        [Parameter(ValueFromPipeline, Mandatory)]
        [ValidateScript({
                if ($_.Translated -eq $true) {
                    throw "You passed an already translated M365 report. This is not supported."
                }
                return $true
            })]
        [Report]$Data
    )
    Begin {

    }
    Process {
        $DataNew = New-Object Report
        $DataNew.Organization = $Data.Organization
        $DataNew.Components = $Data.Components
        $DataNew.SubSections = @()
        $DataNew.CreationDate = $Data.CreationDate
        $DataNew.Translated = $true

        Write-Log -Message "Language Parameter: $Language" -Type Info
               
        #region Load Translation JSON
        Write-Progress -Id 10 -Activity "Translate Report" -Status "Load Translation file" -PercentComplete 0
        $translationJSONPath = "$PSScriptRoot\..\Data\translation.json"

        if ((Test-Path -Path $translationJSONPath)) {
            Write-Log "File ($translationJSONPath) exists" -Type Info
        }
        else {
            Write-Log "File ($translationJSONPath) does not exists, abort translation" -Type Warn
            return
        }

        $translations = Get-Content -Raw -Path $translationJSONPath | ConvertFrom-Json

        Write-Progress -Id 10 -Activity "Translate Report" -Status "Translation File loaded" -PercentComplete 10
        #endregion
        
        $progress = 0
        foreach ($Section in $Data.SubSections) {
            $progress++
            Write-Progress -Id 10 -Activity "Translate Report" -Status "Lookup String ID" -CurrentOperation $Section.Title -PercentComplete (($progress / $Data.SubSections.count) * 100)
            
            if ($Section) {
                $DataNew.SubSections += Set-M365ReportSectionLanguage -Section $Section -Language $Language -Translations $translations 
            }
        }

        Write-Progress -Id 10 -Activity "Translate Report" -Status "Language was set" -Completed

        return $DataNew
    }
    End {
        
    }
}