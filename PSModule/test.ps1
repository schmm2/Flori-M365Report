$scriptPath = split-path -parent $MyInvocation.MyCommand.Definition

import-module "$scriptPath\M365Report\M365Report.psm1" -force 

Connect-M365Report -Interactive

$report = Get-M365Report -Components EntraID

$report = $report | Set-M365ReportLanguage -Language DE

$report | Write-M365ReportWord -FullReportPath "c:\temp\$($report.CreationDate.ToString("yyyyMMddHHmm"))-Report.docx"

Write-Host "Report Created"