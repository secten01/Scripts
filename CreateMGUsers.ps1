Connect-MgGraph -Scopes "DeviceManagementApps.ReadWrite.All","DeviceManagementConfiguration.ReadWrite.All","DeviceManagementManagedDevices.ReadWrite.All","DeviceManagementServiceConfig.ReadWrite.All","Directory.ReadWrite.All","User.ReadWrite.All","Directory.Read.All","Domain.Read.All","Domain.ReadWrite.All","Group.ReadWrite.All"

$PasswordProfile = @{
  Password = 'abcd.1234'
  ForceChangePasswordNextSignIn = $true
  ForceChangePasswordNextSignInWithMfa = $true
}

# Create Secure Workstation User
$SecureUserFirstName1 = "<First Name>"
$SecureUserLastName1 = "<Last Name>"
$SecureUserDomain = Get-MgDomain
$SecureUserDomain = $($SecureUserDomain).Id
$SecureUserName1 = "Azure Admin $($SecureUserFirstName1) $($SecureUserLastName1)"
$SecureUserUPN1 = "AZADM-$($SecureUserFirstName1).$($SecureUserLastName1)@$($SecureUserDomain)"
$SecureUserMailNickname1 = "$($SecureUserFirstName1).$($SecureUserLastName1)"
$SecureUser1 = New-MgUser `
   -DisplayName "$($SecureUserName1)" `
   -PasswordProfile $PasswordProfile `
   -UserPrincipalName "$($SecureUserUPN1)" `
   -AccountEnabled `
   -MailNickName "$($SecureUserMailNickname1)"

# Create PAW Intune Admin 1
$SecureUserName2 = "PAW Intune Admin 1"
$SecureUserUPN2 = "PAWIntuneAdmin1@$($SecureUserDomain)"
$SecureUserMailNickname2 = "PAWIntuneAdmin1"
$SecureUser2 = New-MgUser `
   -DisplayName "$($SecureUserName2)" `
   -PasswordProfile $PasswordProfile `
   -UserPrincipalName "$($SecureUserUPN2)" `
   -AccountEnabled `
   -MailNickName "$($SecureUserMailNickname2)"
$SecureUser2 = Get-MgUser -UserId $SecureUserUPN2
$SecureUser2 = $($SecureUser2).Id
$SecureUserGroup2 = Get-MgGroup -Filter "DisplayName eq 'PAW Intune Administrators'"
$SecureUserGroup2 = $($SecureUserGroup2).Id
New-MgGroupMember -GroupId $SecureUserGroup2 -DirectoryObjectId $SecureUser2

# Create EUD Intune Admin 1
$SecureUserName3 = "EUD Intune Admin 1"
$SecureUserUPN3 = "EUDIntuneAdmin1@$($SecureUserDomain)"
$SecureUserMailNickname3 = "EUDIntuneAdmin1"
$SecureUser3 = New-MgUser `
   -DisplayName "$($SecureUserName3)" `
   -PasswordProfile $PasswordProfile `
   -UserPrincipalName "$($SecureUserUPN3)" `
   -AccountEnabled `
   -MailNickName "$($SecureUserMailNickname3)"
$SecureUser3 = Get-MgUser -UserId $SecureUserUPN3
$SecureUser3 = $($SecureUser3).Id
$SecureUserGroup3 = Get-MgGroup -Filter "DisplayName eq 'EUD Intune Administrators'"
$SecureUserGroup3 = $($SecureUserGroup3).Id
New-MgGroupMember -GroupId $SecureUserGroup3 -DirectoryObjectId $SecureUser3
