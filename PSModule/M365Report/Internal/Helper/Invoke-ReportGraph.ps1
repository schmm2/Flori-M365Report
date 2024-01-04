Function Invoke-ReportGraph(){
    <#
    .SYNOPSIS
    This function Requests information from Microsoft Graph
    .DESCRIPTION
    This function Requests information from Microsoft Graph and returns the value as Object[]
    .EXAMPLE
    Invoke-ReportGraph -url ""
    Returns "Type"
    .NOTES
    Original File by Thomas Kurth 3.3.2021: https://github.com/ThomasKur/M365Documentation/blob/main/PSModule/M365Documentation/Internal/Helper/Invoke-DocGraph.ps1
    
    .CHANGES
    M. Schmidli / 4.1.2024: 
    Adjusted fot the Report Project. 
    Renamed the function. 
    Switch to Invoke-MgGraph.
    Add paging (TODO).
    
    #>
    [OutputType('System.Object[]')]
    [cmdletbinding()]
    param
    (
        [Parameter(Mandatory=$true,ParameterSetName = "FullPath")]
        $FullUrl,

        [Parameter(Mandatory=$true,ParameterSetName = "Path")]
        [string]$Path,

        [Parameter(Mandatory=$false,ParameterSetName = "Path")]
        [string]$BaseUrl = "https://graph.microsoft.com/",

        [Parameter(Mandatory=$false,ParameterSetName = "Path")]
        [switch]$Beta,

        [Parameter(Mandatory=$false,ParameterSetName = "Path")]
        [string]$AcceptLanguage

    )
    if($PSCmdlet.ParameterSetName -eq "Path"){
        if($Beta){
            $version = "beta"
        } else {
            $version = "v1.0"
        }
        $FullUrl = "$BaseUrl$version$Path"
    }

    try{
        $headers = @{}
        if($AcceptLanguage){
            $header.Add("Accept-Language",$AcceptLanguage)
        }
        $value = Invoke-MgGraphRequest -Headers $headers -Uri $FullUrl -Method Get -ErrorAction Stop
    } catch {
        
        if($_.Exception.Response.StatusCode -eq "Forbidden"){
            throw "Used application does not have sufficiant permission to access: $FullUrl"
        } elseif ($_.Exception.Response.StatusCode -eq "NotFound" -and $_.Exception.Response.ResponseUri -like "https://graph.microsoft.com/v1.0/groups*"){
            Write-Debug "Some Profiles/Apps are assigned to groups which do no longer exist. They are not displayed in the output $($_.Exception.Response.ResponseUri)."
        }  else  {
            Write-Error $_
        }
    }
    return $value
}