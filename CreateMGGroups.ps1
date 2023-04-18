Connect-MgGraph -Scopes "DeviceManagementApps.ReadWrite.All","DeviceManagementConfiguration.ReadWrite.All","DeviceManagementManagedDevices.ReadWrite.All","DeviceManagementServiceConfig.ReadWrite.All","Directory.ReadWrite.All","User.ReadWrite.All","Directory.Read.All","Domain.Read.All","Domain.ReadWrite.All","Group.ReadWrite.All"

# Create Security Group for Secure Workstation Admins
$SecureGroupName1 = "Secure Workstation Admins"
$SecureGroupMailName1 = "SecureWorkstationsAdmins"
$SecureGroup1 = New-MgGroup `
   -Description "$($SecureGroupName1)" `
   -DisplayName "$($SecureGroupName1)" `
   -MailEnabled:$False `
   -SecurityEnabled `
   -MailNickname "$($SecureGroupMailName1)"

# Create Security Group for Enterprise Workstation Admins
$EnterpriseGroupName1 = "Enterprise Workstation Admins"
$EnterpriseGroupMailName1 = "EnterpriseWorkstationsAdmins"
$EnterpriseGroup1 = New-MgGroup `
   -Description "$($EnterpriseGroupName1)" `
   -DisplayName "$($EnterpriseGroupName1)" `
   -MailEnabled:$False `
   -SecurityEnabled `
   -MailNickname "$($EnterpriseGroupMailName1)"

# Create Dynamic Security Group for Secure Workstation Users
$SecureGroupName2 = "Secure Workstation Users"
$SecureGroupMailName2 = "SecureWorkstationsUsers"
$SecureGroupQuery2 = '(user.userPrincipalName -startsWith "AZADM-")'
$SecureGroup2 = New-MgGroup `
   -Description "$($SecureGroupName2)" `
   -DisplayName "$($SecureGroupName2)" `
   -MailEnabled:$False `
   -SecurityEnabled `
   -MailNickname "$($SecureGroupMailName2)" `
   -GroupTypes "DynamicMembership" `
   -MembershipRule "$($SecureGroupQuery2)" `
   -MembershipRuleProcessingState "Paused"
Update-MgGroup -GroupId $SecureGroup2.Id -MembershipRuleProcessingState "On"

# Create Security Group for Enterprise Workstation Users
$EnterpriseGroupName2 = "Enterprise Workstation Users"
$EnterpriseGroupMailName2 = "EnterpriseWorkstationsUsers"
$EnterpriseGroup2 = New-MgGroup `
   -Description "$($EnterpriseGroupName2)" `
   -DisplayName "$($EnterpriseGroupName2)" `
   -MailEnabled:$False `
   -SecurityEnabled `
   -MailNickname "$($EnterpriseGroupMailName2)"

# Create Dynamic Security Group for Secure Workstation Devices
$SecureGroupName4 = "Secure Workstation Devices"
$SecureGroupMailName4 = "SecureWorkstationsDevices"
$SecureGroupQuery4 = '(device.devicePhysicalIds -any _ -contains "[OrderID]:PAW")'
$SecureDevices1 = New-MgGroup `
   -Description "$($SecureGroupName4)" `
   -DisplayName "$($SecureGroupName4)" `
   -MailEnabled:$False `
   -SecurityEnabled `
   -MailNickname "$($SecureGroupMailName4)" `
   -GroupTypes "DynamicMembership" `
   -MembershipRule "$($SecureGroupQuery4)" `
   -MembershipRuleProcessingState "Paused"
Update-MgGroup -GroupId $SecureDevices1.Id -MembershipRuleProcessingState "On"

# Create Dynamic Security Group for Enterprise Workstation Devices
$EnterpriseGroupName4 = "Enterprise Workstation Devices"
$EnterpriseGroupMailName4 = "EnterpriseWorkstationsDevices"
$EnterpriseGroupQuery4 = '(device.devicePhysicalIds -any _ -contains "[OrderID]:EUD")'
$EnterpriseDevices1 = New-MgGroup `
   -Description "$($EnterpriseGroupName4)" `
   -DisplayName "$($EnterpriseGroupName4)" `
   -MailEnabled:$False `
   -SecurityEnabled `
   -MailNickname "$($EnterpriseGroupMailName4)" `
   -GroupTypes "DynamicMembership" `
   -MembershipRule "$($EnterpriseGroupQuery4)" `
   -MembershipRuleProcessingState "Paused"
Update-MgGroup -GroupId $EnterpriseDevices1.Id -MembershipRuleProcessingState "On"

# Create Security Group for PAW Intune Administrators
$SecureGroupName5 = "PAW Intune Administrators"
$SecureGroupMailName5 = "PAWIntuneAdministrators"
$SecureGroup5 = New-MgGroup `
   -Description "$($SecureGroupName5)" `
   -DisplayName "$($SecureGroupName5)" `
   -MailEnabled:$False `
   -SecurityEnabled `
   -MailNickname "$($SecureGroupMailName5)"

# Create Security Group for EUD Intune Administrators
$EnterpriseGroupName5 = "EUD Intune Administrators"
$EnterpriseGroupMailName5 = "EUDIntuneAdministrators"
$EnterpriseGroup5 = New-MgGroup `
   -Description "$($EnterpriseGroupName5)" `
   -DisplayName "$($EnterpriseGroupName5)" `
   -MailEnabled:$False `
   -SecurityEnabled `
   -MailNickname "$($EnterpriseGroupMailName5)"

# Create Dynamic Security Group for AADConnect Sync Accounts
$SecureGroupName6 = "AADConnect Sync Accounts"
$SecureGroupMailName6 = "AADConnectSyncAccounts"
$SecureGroupQuery6 = '(user.userPrincipalName -startsWith "Sync_")'
$SecureGroup6 = New-MgGroup `
   -Description "$($SecureGroupName6)" `
   -DisplayName "$($SecureGroupName6)" `
   -MailEnabled:$False `
   -SecurityEnabled `
   -MailNickname "$($SecureGroupMailName6)" `
   -GroupTypes "DynamicMembership" `
   -MembershipRule "$($SecureGroupQuery6)" `
   -MembershipRuleProcessingState "Paused"
Update-MgGroup -GroupId $SecureGroup6.Id -MembershipRuleProcessingState "On"
