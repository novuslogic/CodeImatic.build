# Enviroment Variable Sample

In PowerShell, you can set an environment variable using the Set-EnvironmentVariable cmdlet. You can either set it for the current process (which means it will last only as long as your PowerShell session) or system-wide (which will affect all future sessions and requires administrative privileges).

Here's how you can do it for both scopes:

 Winapi.Windows
powershell
Copy code
# Define your variable
$myVariable = "This is my value"

## Set it as an environment variable for the current process
[System.Environment]::SetEnvironmentVariable('MY_ENV_VARIABLE', $myVariable, [System.EnvironmentVariableTarget]::Process)
In this example, MY_ENV_VARIABLE is the name of the new environment variable, and $myVariable is the value assigned to it. This environment variable will only exist for the duration of the current PowerShell session.

Setting a System-Wide Environment Variable
powershell
Copy code
# Define your variable
$myVariable = "This is my value"

## Set it as a system-wide environment variable (requires admin privileges)
[System.Environment]::SetEnvironmentVariable('MY_ENV_VARIABLE', $myVariable, [System.EnvironmentVariableTarget]::Machine)
In this case, MY_ENV_VARIABLE will be available system-wide and will persist beyond the current session. You must run PowerShell as an administrator to set a system-wide environment variable.

Setting a User-Level Environment Variable
powershell
Copy code
# Define your variable
$myVariable = "This is my value"

## Set it as an environment variable at the user level
[System.Environment]::SetEnvironmentVariable('MY_ENV_VARIABLE', $myVariable, [System.EnvironmentVariableTarget]::User)
This will set MY_ENV_VARIABLE for the current user only and does not require administrative privileges.

Verifying the Environment Variable
To verify if your environment variable is set, use:

powershell
Copy code
Get-ChildItem Env:MY_ENV_VARIABLE
Replace MY_ENV_VARIABLE with the name of your environment variable. This command will show the value of the environment variable if it exists