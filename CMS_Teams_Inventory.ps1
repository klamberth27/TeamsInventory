<#
.SYNOPSIS
This script pulls inventory data for a given list of users from a CSV file, processes Microsoft Teams data for each user, and exports the results to a new CSV file.

.DESCRIPTION
The script ensures the necessary MicrosoftTeams module is installed and imported, reads the list of users from a CSV file, connects to Microsoft Teams, fetches all teams, processes each user and team to gather information about team owners and members, and exports the results to a new CSV file.

.NOTES
The script requires an account with the Teams Admin role for authentication.

.AUTHOR
SubjectData

.EXAMPLE
.\CMS_SharePoint_Inventory.ps1
This will run the script in the current directory, processing the 'Users.csv' file and generating 'CMSTeamswithMembers.csv' with the team details for each user in the list.

.EXAMPLE
powershell.exe -File .\CMS_SharePoint_Inventory.ps1
This command runs the script using the PowerShell executable, useful for scheduling the script in task scheduler or other automation tools.
#>


$moduleName = "MicrosoftTeams"

# Check if the module is already installed
if (-not(Get-Module -Name $moduleName)) {
    # Install the module
    Install-Module -Name $moduleName -Force
}

# Import the module
Import-Module MicrosoftTeams -Force

$myDir = Split-Path -Parent $MyInvocation.MyCommand.Path

$XLloc = "$myDir\"
$ReportsPath = "$myDir\"

$results = @()

try
{
    $UsersList = import-csv ($XLloc+"Users.csv").ToString()
}
catch
{
    Write-Host "No CSV file to read" -BackgroundColor Black -ForegroundColor Red
    exit
}

###########################
###   Connect MSTeams   ###
###########################

Connect-MicrosoftTeams

# Fetch all teams to filter
$AllTeams = Get-Team

#LastContentModifiedDate, Url

if($UsersList.Count -gt 0)
{
    foreach ($CMSUser in $UsersList)
    {   
        try
        {
            Write-Host "Processing User $($CMSUser.'UserEmail')" -BackgroundColor Yellow

            foreach($Team in $AllTeams)
            {
                Write-Host "Processing Team $($Team.'DisplayName')"

                $teamUser = Get-TeamUser -GroupId $Team.GroupId | ?{$_.User -eq $CMSUser.'UserEmail'}
        
                if($teamUser.Count -gt 0)
                {                
                    $teamOwners = Get-TeamUser -GroupId $Team.GroupId | ?{$_.Role -eq "owner"}

                    $teamMembers = Get-TeamUser -GroupId $Team.GroupId | ?{$_.Role -eq "member"}

                    $details = @{            
                    
                        SourceMailNickname   = $Team.MailNickName

                        GroupId              = $Team.GroupId

                        DisplayName          = $Team.DisplayName

                        Description          = $Team.Description

                        Visibility           = $Team.Visibility

                        TeamOwnersEmail      = $teamOwners.User -join ";"

                        TeamOwnersName       = $teamOwners.Name -join ","

                        TeamMembersEmail     = $teamMembers.User -join ";"

                        TeamMembersName      = $teamMembers.Name -join ","

                        CMSUser              = $CMSUser.'UserEmail'
                        
                             
                    }

                    <#
                    if ($Team.Description -ne "") {
                        $details["Description"] = $Team.Description.ToString()
                    }
                    #>

                    $results += New-Object PSObject -Property $details   
                }
            }
        }
        catch
        {
            Write-Host "Exception occured " $Team.DisplayName -BackgroundColor Black -ForegroundColor Red
            continue
        }
    }
}

#$results

$results | export-csv -Path "$($XLloc)\CMSTeamswithMembers.csv" -NoTypeInformation


