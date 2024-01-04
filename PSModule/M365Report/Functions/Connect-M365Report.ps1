Function Connect-M365Report() {
    <#
    .SYNOPSIS
        Establish connection to M365 Tenant
    .DESCRIPTION
        Establish connection to M365 Tenant
     #>
    [CmdletBinding(DefaultParameterSetName = 'Interactive')]
    param(
        [parameter(Mandatory = $false, ParameterSetName = 'Interactive')]
        [switch]$Interactive
    )

    switch -Wildcard ($PSCmdlet.ParameterSetName) {
        "Interactive" {
            Connect-MgGraph -Scopes "User.Read.All", "Group.Read.All", "AuditLog.Read.All" -NoWelcome
        }
    }
}