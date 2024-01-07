function Get-TranslationString {
    <#
    .DESCRIPTION
    Write text to a logfile with the current time.

    .PARAMETER TranslateString
    String to identify the text

    .PARAMETER Language
    Language to translate to

    .PARAMETER Translations
    Translation table / translation.json

    .EXAMPLE
    Get-Translation -TranslationString "TRANSLATE-INACTIVEACCOUNTS"

    .NOTES

    #>
    param(
        [Parameter(Mandatory = $true)]
        [String] $TranslateString,
        [Parameter(Mandatory = $true)]
        [String] $Language,
        [Parameter(Mandatory = $true)]
        $Translations
    )

    # Check Translation.json to find ID of the Text
    if ($TranslateString.startsWith("TRANSLATE-")) {
        Write-Log -Message "Found ID starting with TRANSLATE: $TranslateString, lookup string" -Type Info
    
        $stringId = $TranslateString.Replace("TRANSLATE-", "")
        Write-Log -Message "ID found $stringId" -Type Info
    
        $Translations = $Translations."$stringId"

        if ($Translations."$Language") {
            $translatedValue = $Translations."$Language"
            Write-Log -Message "Translation for language $Language was found." -Type Info
            Write-Log -Message "Translated value: $translatedValue" -Type Info
            return $translatedValue
        }
        else {
            Write-Log -Message "Translation for language $Language was not found. Return original value." -Type Info
            return $TranslateString
        }
    }
    else {
        Write-Log -Message "String does not start with TRANSLATE: $TranslateString, translation not possible. Return original value." -Type Info
        return $TranslateString
    }
}