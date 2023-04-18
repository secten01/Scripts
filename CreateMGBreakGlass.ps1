Connect-MgGraph -Scopes "DeviceManagementApps.ReadWrite.All","DeviceManagementConfiguration.ReadWrite.All","DeviceManagementManagedDevices.ReadWrite.All","DeviceManagementServiceConfig.ReadWrite.All","Directory.ReadWrite.All","User.ReadWrite.All","Directory.Read.All","Domain.Read.All","Domain.ReadWrite.All","Group.ReadWrite.All","EntitlementManagement.ReadWrite.All","RoleManagement.ReadWrite.Directory"

# Create Security Group for Emergency BreakGlass Accounts
$SecureGroupName1 = "Emergency BreakGlass"
$SecureGroupMailName1 = "EmergencyBreakGlass"
$SecureGroup1 = New-MgGroup `
   -Description "$($SecureGroupName1)" `
   -DisplayName "$($SecureGroupName1)" `
   -MailEnabled:$False `
   -SecurityEnabled `
   -MailNickname "$($SecureGroupMailName1)"

$PasswordProfile = @{
  Password = 'abcd.1234'
  ForceChangePasswordNextSignIn = $true
  ForceChangePasswordNextSignInWithMfa = $true
}

# Create Break Glass User 1
$BreakGlassDomain = Get-MgDomain
$BreakGlassDomain = $($BreakGlassDomain).Id
$BreakGlassName1 = "Break Glass User 1"
$BreakGlassUPN1 = "BreakGlass1@$($BreakGlassDomain)"
$BreakGlassMailNickname1 = "BreakGlass1"
$BreakGlass1 = New-MgUser `
   -DisplayName "$($BreakGlassName1)" `
   -PasswordProfile $PasswordProfile `
   -UserPrincipalName "$($BreakGlassUPN1)" `
   -AccountEnabled `
   -MailNickName "$($BreakGlassMailNickname1)"
$BreakGlass1 = Get-MgUser -UserId $BreakGlassUPN1
$BreakGlass1 = $($BreakGlass1).Id
$BreakGlassGroup = Get-MgGroup -Filter "DisplayName eq 'Emergency BreakGlass'"
$BreakGlassGroup = $($BreakGlassGroup).Id
New-MgGroupMember -GroupId $BreakGlassGroup -DirectoryObjectId $BreakGlass1

$params = @{
	"@odata.type" = "#microsoft.graph.unifiedRoleAssignment"
	RoleDefinitionId = "62e90394-69f5-4237-9190-012177145e10"
	PrincipalId = $BreakGlass1
	DirectoryScopeId = "/"
}
New-MgRoleManagementDirectoryRoleAssignment -BodyParameter $params

# Create Break Glass User 2
$BreakGlassDomain = Get-MgDomain
$BreakGlassDomain = $($BreakGlassDomain).Id
$BreakGlassName2 = "Break Glass User 2"
$BreakGlassUPN2 = "BreakGlass2@$($BreakGlassDomain)"
$BreakGlassMailNickname2 = "BreakGlass2"
$BreakGlass2 = New-MgUser `
   -DisplayName "$($BreakGlassName2)" `
   -PasswordProfile $PasswordProfile `
   -UserPrincipalName "$($BreakGlassUPN2)" `
   -AccountEnabled `
   -MailNickName "$($BreakGlassMailNickname2)"
$BreakGlass2 = Get-MgUser -UserId $BreakGlassUPN2
$BreakGlass2 = $($BreakGlass2).Id
New-MgGroupMember -GroupId $BreakGlassGroup -DirectoryObjectId $BreakGlass2

$params = @{
	"@odata.type" = "#microsoft.graph.unifiedRoleAssignment"
	RoleDefinitionId = "62e90394-69f5-4237-9190-012177145e10"
	PrincipalId = $BreakGlass2
	DirectoryScopeId = "/"
}
New-MgRoleManagementDirectoryRoleAssignment -BodyParameter $params
