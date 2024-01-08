Function Get-EntraIdDeviceInactive() {
    <#
    .SYNOPSIS
    This function is used to get all inactive devices via Graph API

    .DESCRIPTION
    The function connects to the Graph API Interface and gets all inactive devices.
    An inactive devices is somebody which was never logged in or not logged in since x months.

    .EXAMPLE
    Get-EntraIdDeviceInactive
    Returns the list of inactive devices
    .NOTES
    NAME: Get-EntraIdDeviceInactive
    #>
    [OutputType('ReportSection')]
    [cmdletbinding()]
    param()


    # Get Devices, filter for not active in since x months
    $sixtyDaysAgo = (Get-Date).AddDays(-60)
    $sixtyDaysAgo = Get-Date -Format s -Date $sixtyDaysAgo
    $inactiveDevicesURL = "/devices?`$top=100&`$filter=approximateLastSignInDateTime ge 1970-01-01T00:00:00.000Z AND approximateLastSignInDateTime le $($sixtyDaysAgo)Z&`$count=true"   
    $inactiveDevices = (Invoke-ReportGraph -Beta -Path $inactiveDevicesURL).value
   
    $newDeviceObjects = @()

    foreach ($inactiveDevice in $inactiveDevices) {
        $deviceObject = New-Object -Type PSObject
        $deviceObject | Add-Member Noteproperty "TRANSLATE-DISPLAYNAME" $inactiveDevice.displayName
        #$deviceObject | Add-Member Noteproperty "TRANSLATE-OWNER" $inactiveDevice.owner
        $deviceObject | Add-Member Noteproperty "TRANSLATE-LASTSIGNIN" (Get-Date -Date $inactiveDevice.approximateLastSignInDateTime -Format "dd.MM.yyyy hh:mm:ss")
       
        $newDeviceObjects += $deviceObject
    }

    $ReportSection = New-Object ReportSection
    $ReportSection.Title = "TRANSLATE-INACTIVEDEVICES"
    $ReportSection.Text = "TRANSLATE-INACTIVEDEVICES-TEXT"
    $ReportSection.Objects = $newDeviceObjects
    $ReportSection.SubSections = @()
    $ReportSection.Transpose = $false


    if ($null -eq $ReportSection.SubSections) {
        return $null
    }
    else {
        return $ReportSection
    }
}