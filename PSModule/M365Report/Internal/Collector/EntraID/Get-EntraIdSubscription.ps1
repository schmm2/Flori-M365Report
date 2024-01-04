Function Get-EntraIdSubscription() {
    <#
    .SYNOPSIS
    This function is used to get the Subscription/Licenses details from the Graph API REST interface
    .DESCRIPTION
    The function connects to the Graph API Interface and gets the Subscription details from EntraID
    .EXAMPLE
    Get-EntraIdSubscription
    Returns the Subscription defined in EntraID.
    .NOTES
    NAME: Get-EntraIdSubscription(){

    #>
    [OutputType('ReportSection')]
    [cmdletbinding()]
    param()

    $ReportSection = New-Object ReportSection

    $ReportSection.Title = "Subscriptions"
    $ReportSection.Text = "Contains information about Subscription/Online Services that a company is subscribed to."
    $ReportSection.Objects = (Invoke-ReportGraph -Path "/subscribedSkus").value
    $ReportSection.Transpose = $true
    
    if ($null -eq $ReportSection.Objects) {
        return $null
    }
    else {
        return $ReportSection
    }
}