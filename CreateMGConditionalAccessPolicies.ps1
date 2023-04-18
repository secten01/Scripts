Connect-MgGraph -Scopes "Application.Read.All","Policy.Read.All","Policy.ReadWrite.ConditionalAccess"

$BreakGlassUser1 = get-mguser -Filter "startsWith(UserPrincipalName, 'BreakGlass1')"
$BreakGlassUser2 = get-mguser -Filter "startsWith(UserPrincipalName, 'BreakGlass2')"
$SecureUsersGroup1 = get-mggroup -Filter "startsWith(DisplayName, 'AADConnect Sync')"
$SecureUsersGroup2 = get-mggroup -Filter "startsWith(DisplayName, 'Secure Workstation Users')"
$BreakGlassUser1 = $($BreakGlassUser1).Id
$BreakGlassUser2 = $($BreakGlassUser2).Id
$SecureUsersGroup1 = $($SecureUsersGroup1).Id
$SecureUsersGroup2 = $($SecureUsersGroup2).Id

#Create Named Location "Trusted Locations - Switzerland"
$params = @{
"@odata.type" = "#microsoft.graph.countryNamedLocation"
DisplayName = "Trusted Locations - Switzerland"
CountriesAndRegions = @(
    "CH"
)
IncludeUnknownCountriesAndRegions = $true
}

$TrustedLocation1 = New-MgIdentityConditionalAccessNamedLocation -BodyParameter $params
$TrustedLocation1 = $($TrustedLocation1).id

#Create Conditional Access policy "ALL - Require multifactor authentication for all users"
$conditions = @{
    Applications = @{
        includeApplications = 'All'
    };
    Users = @{
        excludeUsers = @(
            "$($BreakGlassUser1)";
            "$($BreakGlassUser2)";
            "$($SecureUsersGroup1)";
        )
        includeUsers = "All"
    };
    }
    $grantcontrols = @{
        BuiltInControls = @('mfa'); 
        Operator = 'OR'
    }
$Params = @{
    DisplayName = "ALL - Require multifactor authentication for all users";
    State = "Enabled";
    Conditions = $conditions;
    GrantControls = $grantcontrols;  
}
New-MgIdentityConditionalAccessPolicy @Params

#Create Conditional Access policy "ALL - Block access for unknown or unsupported device platform"
$conditions = @{
    Applications = @{
        includeApplications = 'All'
    };
    Platforms = @{
        excludePlatforms = @(
        "Android";
        "iOS";
        "Windows";
        "macOS";
        "Linux";
        "WindowsPhone";
        )
        includePlatforms = "All"
    };
    Users = @{
        excludeUsers = @(
            "$($BreakGlassUser1)";
            "$($BreakGlassUser2)";
            "$($SecureUsersGroup1)";
        )
        includeUsers = "All"
    };
    }
    $grantcontrols = @{
        BuiltInControls = @("block"); 
        Operator = 'OR'
    }
$Params = @{
    DisplayName = "ALL - Block access for unknown or unsupported device platform";
    State = "Enabled";
    Conditions = $conditions;
    GrantControls = $grantcontrols;  
}
New-MgIdentityConditionalAccessPolicy @Params

#Create Conditional Access policy "ALL - No persistent browser session"
$conditions = @{
    Applications = @{
        includeApplications = 'All'
        };
        devices = @{
            deviceFilter = @{
                mode = "include";
                rule = "device.isCompliant -ne True"
            }
        }
        Users = @{
        excludeUsers = @(
            "$($BreakGlassUser1)";
            "$($BreakGlassUser2)";
            "$($SecureUsersGroup1)";
        )
        includeUsers = "All"
    };
}
    $sessionControls = @{
        signInFrequency = @{
            value = "1";
            type = "hours";
            authenticationType = "primaryAndSecondaryAuthentication";
            frequencyInterval = "timeBased";
            isEnabled = $true;
        };
        persistentBrowser = @{
            mode = "never";
            isEnabled = $true
        }
    }

$Params = @{
    DisplayName = "ALL - No persistent browser session";
    State = "EnabledForReportingButNotEnforced";
    Conditions = $conditions;
    SessionControls = $sessioncontrols;  
}
New-MgIdentityConditionalAccessPolicy @Params

#Create Conditional Access policy "ALL - Use application enforced restrictions for unmanaged devices"
$conditions = @{
    Applications = @{
        includeApplications = 'Office365'
    };
    Users = @{
        excludeUsers = @(
            "$($BreakGlassUser1)";
            "$($BreakGlassUser2)";
            "$($SecureUsersGroup1)";
        )
        includeUsers = "All"
    };
}
$sessionControls = @{
    applicationEnforcedRestrictions = @{
        isEnabled = $true;
    };
}
$Params = @{
    DisplayName = "ALL - Use application enforced restrictions for unmanaged devices";
    State = "EnabledForReportingButNotEnforced";
    Conditions = $conditions;
    SessionControls = $sessioncontrols;  
}
New-MgIdentityConditionalAccessPolicy @Params

#Create Conditional Access policy "ALL - Securing security info registration"
$conditions = @{
        Applications = @{
            includeUserActions =  "urn:user:registersecurityinfo"
    };
        Users = @{
        excludeUsers = @(
            "$($BreakGlassUser1)";
            "$($BreakGlassUser2)";
            "$($SecureUsersGroup1)";
        )
        includeUsers = "All"
        excludeRoles = @(
                "62e90394-69f5-4237-9190-012177145e10"
        )
    };
        locations = @{
            includeLocations = "All"
            excludeLocations = @(
                "$($TrustedLocation1)"
            )
    };
}
    $grantcontrols = @{
        BuiltInControls = @('mfa'); 
        Operator = 'OR'
}
    $Params = @{
        DisplayName = "ALL - Securing security info registration";
        State = "EnabledForReportingButNotEnforced";
        Conditions = $conditions;
        GrantControls = $grantcontrols;
    
}
New-MgIdentityConditionalAccessPolicy @Params

#Create Conditional Access policy "EUD - Require multifactor authentication for risky sign-ins"
$conditions = @{
        signInRiskLevels = @(
        "high"
    );
        Applications = @{
        includeApplications = 'All'
    };
        Users = @{
        excludeUsers = @(
            "$($BreakGlassUser1)";
            "$($BreakGlassUser2)";
            "$($SecureUsersGroup1)";
            "$($SecureUsersGroup2)";
        )
        includeUsers = "All"
        excludeRoles = @(
            "62e90394-69f5-4237-9190-012177145e10";
            "194ae4cb-b126-40b2-bd5b-6091b380977d";
            "f28a1f50-f6e7-4571-818b-6a12f2af6b6c";
            "29232cdf-9323-42fd-ade2-1d097af3e4de";
            "b1be1c3e-b65d-4f19-8427-f6fa0d97feb9";
            "729827e3-9c14-49f7-bb1b-9608f156bbb8";
            "b0f54661-2d74-4c50-afa3-1ec803f12efe";
            "fe930be7-5e62-47db-91af-98c3a49a38b1";
            "c4e39bd9-1100-46d3-8c65-fb160da0071f";
            "9b895d92-2cd3-44c7-9d02-a6ac2d5ea5c3";
            "158c047a-c907-4556-b7ef-446551a6b5f7";
            "966707d0-3269-4727-9be2-8c3a10f19b9d";
            "7be44c8a-adaf-4e2a-84d6-ab2649e08a13";
            "e8611ab8-c189-46e8-94e1-60213ab1f814";
            "3a2c62db-5318-420d-8d74-23affee5d9d5"
        )        
    };
}
$grantcontrols = @{
    BuiltInControls = @('mfa'); 
    Operator = 'OR'
}
    $Params = @{
        DisplayName = "EUD - Require multifactor authentication for risky sign-ins";
        State = "Enabled";
        Conditions = $conditions;
        GrantControls = $grantcontrols;  
}
New-MgIdentityConditionalAccessPolicy @Params

#Create Conditional Access policy "PAW - Require multifactor authentication for risky sign-ins"
$conditions = @{
        signInRiskLevels = @(
        "high";
        "medium"
    );
        Applications = @{
        includeApplications = 'All'
    };
        Users = @{
        excludeUsers = @(
            "$($BreakGlassUser1)";
            "$($BreakGlassUser2)";
            "$($SecureUsersGroup1)";
        )
        includeUsers = "$($SecureUsersGroup2)"
        includeRoles = @(
            "62e90394-69f5-4237-9190-012177145e10";
            "194ae4cb-b126-40b2-bd5b-6091b380977d";
            "f28a1f50-f6e7-4571-818b-6a12f2af6b6c";
            "29232cdf-9323-42fd-ade2-1d097af3e4de";
            "b1be1c3e-b65d-4f19-8427-f6fa0d97feb9";
            "729827e3-9c14-49f7-bb1b-9608f156bbb8";
            "b0f54661-2d74-4c50-afa3-1ec803f12efe";
            "fe930be7-5e62-47db-91af-98c3a49a38b1";
            "c4e39bd9-1100-46d3-8c65-fb160da0071f";
            "9b895d92-2cd3-44c7-9d02-a6ac2d5ea5c3";
            "158c047a-c907-4556-b7ef-446551a6b5f7";
            "966707d0-3269-4727-9be2-8c3a10f19b9d";
            "7be44c8a-adaf-4e2a-84d6-ab2649e08a13";
            "e8611ab8-c189-46e8-94e1-60213ab1f814";
            "3a2c62db-5318-420d-8d74-23affee5d9d5"
        )        
    };
}
$grantcontrols = @{
    BuiltInControls = @('mfa'); 
    Operator = 'OR'
}
    $Params = @{
        DisplayName = "PAW - Require multifactor authentication for risky sign-ins";
        State = "Enabled";
        Conditions = $conditions;
        GrantControls = $grantcontrols;  
}
New-MgIdentityConditionalAccessPolicy @Params

#Create Conditional Access policy "EUD - Require password change for high-risk users"
$conditions = @{
        userRiskLevels = @(
        "high"
    );
        Applications = @{
        includeApplications = 'All'
    };
        Users = @{
        excludeUsers = @(
            "$($BreakGlassUser1)";
            "$($BreakGlassUser2)";
            "$($SecureUsersGroup1)";
            "$($SecureUsersGroup2)";
        )
        includeUsers = "All"
        excludeRoles = @(
            "62e90394-69f5-4237-9190-012177145e10";
            "194ae4cb-b126-40b2-bd5b-6091b380977d";
            "f28a1f50-f6e7-4571-818b-6a12f2af6b6c";
            "29232cdf-9323-42fd-ade2-1d097af3e4de";
            "b1be1c3e-b65d-4f19-8427-f6fa0d97feb9";
            "729827e3-9c14-49f7-bb1b-9608f156bbb8";
            "b0f54661-2d74-4c50-afa3-1ec803f12efe";
            "fe930be7-5e62-47db-91af-98c3a49a38b1";
            "c4e39bd9-1100-46d3-8c65-fb160da0071f";
            "9b895d92-2cd3-44c7-9d02-a6ac2d5ea5c3";
            "158c047a-c907-4556-b7ef-446551a6b5f7";
            "966707d0-3269-4727-9be2-8c3a10f19b9d";
            "7be44c8a-adaf-4e2a-84d6-ab2649e08a13";
            "e8611ab8-c189-46e8-94e1-60213ab1f814";
            "3a2c62db-5318-420d-8d74-23affee5d9d5"
        )        
    };
}
$grantcontrols = @{
    BuiltInControls = @(
        'mfa';
        'passwordChange'
    )
    Operator = 'AND'
}
    $Params = @{
        DisplayName = "EUD - Require password change for high-risk users";
        State = "Enabled";
        Conditions = $conditions;
        GrantControls = $grantcontrols;  
}
New-MgIdentityConditionalAccessPolicy @Params

#Create Conditional Access policy "PAW - Block high-risk users"
$conditions = @{
        userRiskLevels = @(
        "high"
    );
        Applications = @{
        includeApplications = 'All'
    };
        Users = @{
        excludeUsers = @(
            "$($BreakGlassUser1)";
            "$($BreakGlassUser2)";
            "$($SecureUsersGroup1)";
        )
        includeUsers = "$($SecureUsersGroup2)"
        includeRoles = @(
            "62e90394-69f5-4237-9190-012177145e10";
            "194ae4cb-b126-40b2-bd5b-6091b380977d";
            "f28a1f50-f6e7-4571-818b-6a12f2af6b6c";
            "29232cdf-9323-42fd-ade2-1d097af3e4de";
            "b1be1c3e-b65d-4f19-8427-f6fa0d97feb9";
            "729827e3-9c14-49f7-bb1b-9608f156bbb8";
            "b0f54661-2d74-4c50-afa3-1ec803f12efe";
            "fe930be7-5e62-47db-91af-98c3a49a38b1";
            "c4e39bd9-1100-46d3-8c65-fb160da0071f";
            "9b895d92-2cd3-44c7-9d02-a6ac2d5ea5c3";
            "158c047a-c907-4556-b7ef-446551a6b5f7";
            "966707d0-3269-4727-9be2-8c3a10f19b9d";
            "7be44c8a-adaf-4e2a-84d6-ab2649e08a13";
            "e8611ab8-c189-46e8-94e1-60213ab1f814";
            "3a2c62db-5318-420d-8d74-23affee5d9d5"
        )        
    };
}
$grantcontrols = @{
    BuiltInControls = @(
        'block'
    )
    Operator = 'OR'
}
    $Params = @{
        DisplayName = "PAW - Block high-risk users";
        State = "EnabledForReportingButNotEnforced";
        Conditions = $conditions;
        GrantControls = $grantcontrols;  
}
New-MgIdentityConditionalAccessPolicy @Params

#Create Conditional Access policy "PAW - Require compliant or hybrid Azure AD joined device for admins"
$conditions = @{
        platforms = @{
            includePlatforms = 'All'
            excludePlatforms = @(
                "android";
                "iOS";
                "macOS";
                "linux"
            )
        }
            Applications = @{
        includeApplications = 'All'
    };
        Users = @{
        excludeUsers = @(
            "$($BreakGlassUser1)";
            "$($BreakGlassUser2)";
            "$($SecureUsersGroup1)";
        )
        includeUsers = "$($SecureUsersGroup2)"
        includeRoles = @(
                "62e90394-69f5-4237-9190-012177145e10";
                "194ae4cb-b126-40b2-bd5b-6091b380977d";
                "f28a1f50-f6e7-4571-818b-6a12f2af6b6c";
                "29232cdf-9323-42fd-ade2-1d097af3e4de";
                "b1be1c3e-b65d-4f19-8427-f6fa0d97feb9";
                "729827e3-9c14-49f7-bb1b-9608f156bbb8";
                "b0f54661-2d74-4c50-afa3-1ec803f12efe";
                "fe930be7-5e62-47db-91af-98c3a49a38b1";
                "c4e39bd9-1100-46d3-8c65-fb160da0071f";
                "9b895d92-2cd3-44c7-9d02-a6ac2d5ea5c3";
                "158c047a-c907-4556-b7ef-446551a6b5f7";
                "966707d0-3269-4727-9be2-8c3a10f19b9d";
                "7be44c8a-adaf-4e2a-84d6-ab2649e08a13";
                "e8611ab8-c189-46e8-94e1-60213ab1f814";
                "3a2c62db-5318-420d-8d74-23affee5d9d5"
        )
    };
}
$grantcontrols = @{
    BuiltInControls = @(
        "compliantDevice";
        "domainJoinedDevice"
    )
    Operator = 'OR'
}
    $Params = @{
        DisplayName = "PAW - Require compliant or hybrid Azure AD joined device for admins";
        State = "EnabledForReportingButNotEnforced";
        Conditions = $conditions;
        GrantControls = $grantcontrols;  
}
New-MgIdentityConditionalAccessPolicy @Params

#Create Conditional Access policy "PAW - Force use of secure workstations for administrators"
$conditions = @{
        devices = @{
            deviceFilter = @{
                Mode = "exclude";
                Rule = "device.extensionAttribute1 -eq ""PAW"""
            }
        };
            Applications = @{
        includeApplications = 'All'
    };
        Users = @{
        excludeUsers = @(
            "$($BreakGlassUser1)";
            "$($BreakGlassUser2)";
            "$($SecureUsersGroup1)";
        )
        includeUsers = "$($SecureUsersGroup2)"
        includeRoles = @(
                "62e90394-69f5-4237-9190-012177145e10";
                "194ae4cb-b126-40b2-bd5b-6091b380977d";
                "f28a1f50-f6e7-4571-818b-6a12f2af6b6c";
                "29232cdf-9323-42fd-ade2-1d097af3e4de";
                "b1be1c3e-b65d-4f19-8427-f6fa0d97feb9";
                "729827e3-9c14-49f7-bb1b-9608f156bbb8";
                "b0f54661-2d74-4c50-afa3-1ec803f12efe";
                "fe930be7-5e62-47db-91af-98c3a49a38b1";
                "c4e39bd9-1100-46d3-8c65-fb160da0071f";
                "9b895d92-2cd3-44c7-9d02-a6ac2d5ea5c3";
                "158c047a-c907-4556-b7ef-446551a6b5f7";
                "966707d0-3269-4727-9be2-8c3a10f19b9d";
                "7be44c8a-adaf-4e2a-84d6-ab2649e08a13";
                "e8611ab8-c189-46e8-94e1-60213ab1f814";
                "3a2c62db-5318-420d-8d74-23affee5d9d5"
        )
    };
}
    $grantcontrols = @{
        BuiltInControls = @("block"); 
        Operator = 'OR'
}
    $Params = @{
        DisplayName = "PAW - Force use of secure workstations for administrators";
        State = "EnabledForReportingButNotEnforced";
        Conditions = $conditions;
        GrantControls = $grantcontrols;  
}
New-MgIdentityConditionalAccessPolicy @Params
