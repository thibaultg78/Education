<# 
.SYNOPSIS
    Microsoft Graph disconnection script for Microsoft 365 operations.
.DESCRIPTION
    Safely disconnects from Microsoft Graph session that was established using Service Principal authentication.
    Ensures proper cleanup of authentication tokens and session resources.
    Used to terminate Microsoft 365 user management operations sessions.
#>

# Disconnect
Disconnect-MgGraph | Out-Null