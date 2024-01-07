$scriptPath = split-path -parent $MyInvocation.MyCommand.Definition

import-module "$scriptPath\M365Report\M365Report.psm1" -force 

Connect-M365Report -Interactive

$report = Get-M365Report -Components EntraID

$reportDE = $report | Set-M365ReportLanguage -Language DE

$reportDE | Write-M365ReportWord -FullReportPath "c:\temp\$($reportDE.CreationDate.ToString("yyyyMMddHHmm"))-Report-DE.docx"

Write-Host "Report Created"