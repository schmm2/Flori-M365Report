Function Write-M365ReportWord() {
    <#
    .SYNOPSIS
    Outputs the documentation as Word file.

    .DESCRIPTION
    This function takes the passed data and is outputing it to the Word file.

    .PARAMETER FullReportPath
    Path including filename where the documentation should be created. The filename has to end with .docx.

    Note:
    If there is already a file present, the documentation will be added at the end of the existing document.

    .PARAMETER Data
    M365 documentation object which shoult be written to DOCX.

    .EXAMPLE
    Write-M365DocWord -FullReportPath $FullReportPath -Data $Data

    .NOTES
    NAME: Thomas Kurth / 3.3.2021

    .CHANGES
    M.Schmidli / 4.1.2024 Remove all WPNinjas Reference.
    M.Schmidli / 4.1.2024 Naming changes from FullDocumentationPath to FullReportPath. 
    M.Schmidli / 4.1.2024 Custom Theme. Add the possibility to use a custom template

    #>
    param(
        [ValidateScript({
                if ($_ -notmatch "(\.docx)") {
                    throw "The file specified in the path argument must be of type docx."
                }
                return $true 
            })]
        [System.IO.FileInfo]$FullReportPath = ".\$($Data.CreationDate.ToString("yyyyMMddHHmm"))-Report.docx",
        [Parameter(ValueFromPipeline, Mandatory)]
        [Report]$Data
    )
    Begin {

    }
    Process {

        #region CopyTemplate
        Write-Progress -Id 10 -Activity "Create Word File" -Status "Prepare File template" -PercentComplete 0
        
        if ((Test-Path -Path $FullReportPath)) {
            Write-Log "File ($FullReportPath) already exists! Therefore, built-in template will not be used." -Type Warn
            $WordDocument = New-WordDocument $FullReportPath
        }
        else {
            Copy-Item "$PSScriptRoot\..\Data\Template.docx" -Destination $FullReportPath
            $WordDocument = Get-WordDocument $FullReportPath.FullName
            foreach ($Paragraph in $WordDocument.Paragraphs) {
                $Paragraph.ReplaceText('DATE', (Get-Date -Format "HH:mm dd.MM.yyyy"))
                $Paragraph.ReplaceText('SYSTEM', ($Data.Components -join ", "))
                $Paragraph.ReplaceText('TENANT', $Data.Organization)
            }
        }
        Write-Progress -Id 10 -Activity "Create Word File" -Status "Prepared File template" -PercentComplete 10
        #endregion
    
        
        $progress = 0
        foreach ($Section in $Data.SubSections) {
            $progress++
            Write-Progress -Id 10 -Activity "Create Word File" -Status "Write Section" -CurrentOperation $Section.Title -PercentComplete (($progress / $Data.SubSections.count) * 100)
            Write-DocumentationWordSection -WordDocument $WordDocument -Data $Section -Level ($Level + 1)
            Save-WordDocument $WordDocument -Supress $True -FilePath $FullReportPath.FullName
        }

        Save-WordDocument $WordDocument -Supress $True -FilePath $FullReportPath.FullName
        Write-Progress -Id 10 -Activity "Create Word File" -Status "Finished creation" -Completed

        Write-Information "Press Ctrl + A and then F9 to Update the table of contents and other dynamic fields in the Word document."
    }
    End {
        
    }
}