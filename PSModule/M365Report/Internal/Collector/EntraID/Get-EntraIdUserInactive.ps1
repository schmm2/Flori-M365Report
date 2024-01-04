Function Get-EntraIdUserInactive() {
    <#
    .SYNOPSIS
    This function is used to get all inactive users via Graph API
    .DESCRIPTION
    The function connects to the Graph API Interface and gets all inactive users.
    An inactive User is somebody which was never logged in or not logged in since 2 months.
    .EXAMPLE
    Get-EntraIdUserInactive
    Returns the list of users
    .NOTES
    NAME: Get-EntraIdUserInactive
    #>
    [OutputType('ReportSection')]
    [cmdletbinding()]
    param()

    $sixtyDaysAgo = (Get-Date).AddDays(-60)

    # Get Users, filter for not logged in since 3 months
    $users = (Invoke-ReportGraph -Beta -Path "/users?`$select=signInActivity").value

    # Filter users who haven't logged in within the last 60 days
    $inactiveUsers = $users | Where-Object { $_.signInActivity.lastSignInDateTime -lt $sixtyDaysAgo }

    $newUserObjects = @()

    foreach ($inactiveUser in $inactiveUsers) {
        if ($inactiveUser.signInActivity.lastSignInDateTime) {
            $timeSinceLastSignIn = ((Get-Date) - $inactiveUser.signInActivity.lastSignInDateTime)
        }

        $userObject = New-Object -Type PSObject
        $userObject | Add-Member Noteproperty "Name" $inactiveUser.displayName
        $userObject | Add-Member Noteproperty "LastSignIn" $inactiveUser.signInActivity.lastSignInDateTime
        $userObject | Add-Member Noteproperty "DaysSinceLastSignIn" $timeSinceLastSignIn.Days

        $newUserObjects += $userObject
    }

    $ReportSectionMember = New-Object ReportSection
    $ReportSectionMember.Title = "Inactive Users"
    $ReportSectionMember.Objects = $newUserObjects
    $ReportSectionMember.Transpose = $false

    $ReportSectionGuest = New-Object ReportSection
    $ReportSectionGuest.Title = "Inactive Guests"
    $ReportSectionGuest.Objects = $newUserObjects
    $ReportSectionGuest.Transpose = $false

    $ReportSection = New-Object ReportSection
    $ReportSection.Title = "Inactive Accounts"
    $ReportSection.SubSections = @($ReportSectionMember,$ReportSectionGuest)
    $ReportSection.Transpose = $false


    if ($null -eq $ReportSection.SubSections) {
        return $null
    }
    else {
        return $ReportSection
    }
}