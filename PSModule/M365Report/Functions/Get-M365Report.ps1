function Get-ValidSectionValue {
    [CmdletBinding()]
    param()
    $AllCommands = Get-ChildItem -Path "$PSScriptRoot\..\Internal\Collector" -File -Recurse -Depth 1
    return $AllCommands.Name.Replace(".ps1", "").Replace("Get-", "")
}

function Get-ValidComponentsValue {
    [CmdletBinding()]
    param()
    $AllCommands = Get-ChildItem -Path "$PSScriptRoot\..\Internal\Collector" -Directory 
    return $AllCommands.Name
}

Function Get-M365Report() {
    <#
    .DESCRIPTION
   
    .PARAMETER Components
        Path including filename where the documentation should be created. The filename has to end with .docx.
        Note:
        If there is already a file present, the documentation will be added at the end of the existing document.

    .PARAMETER ExcludeSections
        
    .PARAMETER IncludeSections
   
    .PARAMETER BackupFile
        Path to a previously generated JSON file.
     
    .NOTES

    .CHANGES
    M. Schmidli / 4.1.2024: 
    Rename Doc to Report
    Rename ScriptName
    
    #>
    [OutputType('Doc')]
    [CmdletBinding(DefaultParameterSetName = "Online-Exclude")]
    Param(
 
        [Parameter(ParameterSetName = "Online-Exclude", Mandatory = $true)]
        [Parameter(ParameterSetName = "Online-Include", Mandatory = $true)]
        [ArgumentCompleter(
            {
                
                param(
                    $Command, 
                    $Parameter, 
                    $WordToComplete, 
                    $CommandAst, 
                    $FakeBoundParams)

                Get-ValidComponentsValue 
            }
        )]
        [ValidateScript(
            {
                $_ -in (Get-ValidComponentsValue)
            }
        )]
        [string[]]$Components,

        [Parameter(ParameterSetName = "Online-Exclude", Mandatory = $false)]
        [ArgumentCompleter(
            {
                
                param($Command, $Parameter, $WordToComplete, $CommandAst, $FakeBoundParams)

                Get-ValidSectionValue 
            }
        )]
        [ValidateScript(
            {
                $_ -in (Get-ValidSectionValue)
            }
        )]
        [string[]]$ExcludeSections,

        [Parameter(ParameterSetName = "Online-Include", Mandatory = $true)]
        [ArgumentCompleter(
            {
                
                param($Command, $Parameter, $WordToComplete, $CommandAst, $FakeBoundParams)

                Get-ValidSectionValue 
            }
        )]
        [ValidateScript(
            {
                $_ -in (Get-ValidSectionValue)
            }
        )]
        [string[]]$IncludeSections
    )

    ## Manual Variable Definition
    ########################################################
    #$DebugPreference = "Continue"
    $ScriptName = "Get-M365Report"


    #region Initialization
    ########################################################
    Write-Log "Start Script $Scriptname"
    
    $Data = New-Object Report
    $org = Invoke-ReportGraph -Path "/organization"
    $Data.Organization = $org.Value.displayName
    $Data.Components = $Components
    $Data.SubSections = @()
    $Data.CreationDate = Get-Date
    $Data.Translated = $false

    #endregion

    #region Collection Script
    ########################################################

    foreach ($Component in $Components) {
        # Get all collector commands
        $AllCommands = Get-ChildItem -Path "$PSScriptRoot\..\Internal\Collector\$Component" -File 
            
        #Exclude excluded commands
        if ( $PsCmdlet.ParameterSetName -eq "Online-Exclude") {
            $SelectedCommands = @()
            foreach ($AllCommand in $AllCommands) {
                $Excluded = $false
                foreach ($ExcludeSection in $ExcludeSections) {
                    if ($AllCommand -match $ExcludeSection) {
                        $Excluded = $true
                        Write-Verbose  "Section $AllCommand will be excluded."
                    }
                }
                    
                if ($Excluded -eq $false) {
                    $SelectedCommands += $AllCommand
                }
            }
        }

        #Include only Included commands from the current component
        if ($PsCmdlet.ParameterSetName -eq "Online-Include") {
            $SelectedCommands = @()
            foreach ($AllCommand in $AllCommands) {
                $Included = $false
                foreach ($IncludeSection in $IncludeSections) {
                    if ($AllCommand -match $IncludeSection) {
                        $Included = $true
                        Write-Verbose  "Section $AllCommand will be included."
                    }
                }
                    
                if ($Included) {
                    $SelectedCommands += $AllCommand
                }
            }
        }

        # Start data collection
        $progress = 0
        $CollectedData = @()
        foreach ($SelectedCommand in $SelectedCommands) {
            $progress++
            Write-Progress -Id 1 -Activity "Collecting Data" -Status (($SelectedCommand.Name -replace ".ps1", "") -replace "Get-", "") -PercentComplete (($progress / $SelectedCommands.count) * 100)
            $CollectedData += Invoke-Expression -Command ($SelectedCommand.Name -replace ".ps1", "")
        }
        Write-Progress -Id 1 -Activity "Collecting Data" -Status "Finished collection" -Completed
            
        # Build return object, depending if multiple components are documented in subsections.
        if ($Components.count -gt 1) {
            $ReportSection = New-Object ReportSectiontion
            $ReportSection.Title = $Component
            $ReportSection.Text = ""
            $ReportSection.SubSections = $CollectedData
            $Data.SubSections += $ReportSection
        }
        else {
            $Data.SubSections = $CollectedData
        }

    }

    #endregion

    #region Finishing
    ########################################################
        
    return $Data
        
    Write-Information "End Script $Scriptname"
    #endregion
}