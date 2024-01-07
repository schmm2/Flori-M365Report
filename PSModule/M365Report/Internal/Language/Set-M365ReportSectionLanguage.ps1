Function Set-M365ReportSectionLanguage() {
    <#
    .SYNOPSIS
    
    .DESCRIPTION
    
    .PARAMETER Language
    
    .PARAMETER Data
    
    .EXAMPLE
    Set-M365ReportSectionLanguage -Language DE -Data $Data

    .NOTES
    NAME: M.Schmidli 5.1.2024

    #>
    param(
        [Parameter(ValueFromPipeline, Mandatory)]
        [ReportSection]$Section,
        [Parameter(Mandatory)]
        [ValidateSet('EN', 'DE')]
        [System.String]$Language,
        [Parameter(Mandatory)]
        $Translations
    )
    Begin {

    }
    Process {
        $DataNew = New-Object ReportSection
        $DataNew.Title = if ($Section.Title) { Get-TranslationString -TranslateString $Section.Title -Translations $Translations -Language $Language }
        $DataNew.Text = if ($Section.Text) { Get-TranslationString -TranslateString $Section.Text -Translations $Translations -Language $Language }
        $DataNew.SubSections = @()
        $DataNew.Objects = @()
        $DataNew.Transpose = $Section.Transpose
        
        foreach ($SubSection in $Section.SubSections) {
            $DataNew.SubSections += Set-M365ReportSectionLanguage -Language $Language -Section $SubSection -Translations $Translations
        }

        # Foreach Property of the Object to translate it to the requested language
        # This feature makes the report trully multilanguage

        $translatedObjects = @()

        foreach ($Object in $Section.Objects) {
            
            # Try to translate the Object Property name like "displayName"
            # We have to create a new object as the name in the original one is write-protected
            $translatedObject = New-Object -Type PSObject
      
            foreach ($property in $Object.PSObject.Properties) {
                $propertyName = Get-TranslationString -Translations $Translations -TranslateString $property.name -Language $Language
                $translatedObject | Add-Member Noteproperty $propertyName $property.value
            }

            $translatedObjects += $translatedObject
        }

        $DataNew.Objects = $translatedObjects

        return $DataNew
    }
    End {
        
    }
}