# Microsoft Teams Inventory

# README

## Script Overview

This PowerShell script pulls inventory data for a given list of users from a CSV file, processes Microsoft Teams data for each user, and exports the results to a new CSV file. The script ensures that the necessary module (`MicrosoftTeams`) is installed and imported before proceeding.

## Prerequisites

1. **PowerShell**: Ensure you have PowerShell installed on your system.
2. **MicrosoftTeams Module**: The script installs the Microsoft Teams module if it is not already installed.
3. **CSV File**: Ensure you have a `Users.csv` file in the same directory as the script. This file should contain the list of users with at least a `UserEmail` column. (Example file uploaded)

## CSV File Format

The `Users.csv` file should have the following format:

```csv
UserEmail
user1@example.com
user2@example.com
...
```

## Script Details

1. **Module Installation and Import**:
   - The script first checks if the `MicrosoftTeams` module is installed. If not, it installs the module.
   - It then imports the `MicrosoftTeams` module.

2. **Directory and File Paths**:
   - The script sets the directory paths for the CSV files using `$myDir`, which is the directory where the script is located.

3. **Reading the Users List**:
   - It attempts to read the `Users.csv` file. If the file is not found, it displays an error message and exits.

4. **Connecting to Microsoft Teams**:
   - The script connects to Microsoft Teams using `Connect-MicrosoftTeams`.
   - You need to authenticate with an account that has the Teams Admin role.

5. **Fetching Teams and Processing Users**:
   - The script fetches all the teams using `Get-Team`.
   - For each user in the `Users.csv` file, it processes each team to find the user and gathers information about team owners and members.

6. **Exporting Results**:
   - The results are exported to a new CSV file named `CMSTeamswithMembers.csv` in the same directory.

## Script Execution

To run the script, follow these steps:

1. Open PowerShell with administrative privileges.
2. Navigate to the directory containing the script and the `Users.csv` file.
3. Execute the script by running:
   ```powershell
   .\YourScriptName.ps1
   ```

## Error Handling

- If the `Users.csv` file is not found, the script will display "No CSV file to read" and exit.
- If any exceptions occur during the processing of teams and users, the script will display an error message with the team display name and continue processing the next team/user.

## Output

The output CSV file (`CMSTeamswithMembers.csv`) will have the following columns:

- SourceMailNickname
- GroupId
- DisplayName
- Description
- Visibility
- TeamOwnersEmail
- TeamOwnersName
- TeamMembersEmail
- TeamMembersName
- CMSUser

This file will be located in the same directory as the script.

## Troubleshooting

- Ensure the `Users.csv` file is in the correct format and located in the same directory as the script.
- Ensure you have the necessary permissions to install modules and connect to Microsoft Teams.
- Check for any typos or syntax errors in the script if you encounter issues.

## Additional Notes

- The script uses `-Force` with `Install-Module` and `Import-Module` to ensure the commands execute without prompts.
- The `$results` array collects all processed data, which is then exported to the CSV file at the end of the script.
