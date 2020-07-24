# xActiveDirectory

The **xActiveDirectory** DSC resources allow you to configure and manage Active
Directory.
Note: these resources do not presently install the Remote Server Administration
Tools (RSAT).

This project has adopted the [Microsoft Open Source Code of Conduct](https://opensource.microsoft.com/codeofconduct/).
For more information see the [Code of Conduct FAQ](https://opensource.microsoft.com/codeofconduct/faq/) or contact [opencode@microsoft.com](mailto:opencode@microsoft.com) with any additional questions or comments.

## Branches

### master

[![Build status](https://ci.appveyor.com/api/projects/status/p4jejr60jrgb8ity/branch/master?svg=true)](https://ci.appveyor.com/project/PowerShell/xActiveDirectory/branch/master)
[![codecov](https://codecov.io/gh/PowerShell/xActiveDirectory/branch/master/graph/badge.svg)](https://codecov.io/gh/PowerShell/xActiveDirectory/branch/master)

This is the branch containing the latest release -
no contributions should be made directly to this branch.

### dev

[![Build status](https://ci.appveyor.com/api/projects/status/p4jejr60jrgb8ity/branch/dev?svg=true)](https://ci.appveyor.com/project/PowerShell/xActiveDirectory/branch/dev)
[![codecov](https://codecov.io/gh/PowerShell/xActiveDirectory/branch/dev/graph/badge.svg)](https://codecov.io/gh/PowerShell/xActiveDirectory/branch/dev)

This is the development branch
to which contributions should be proposed by contributors as pull requests.
This development branch will periodically be merged to the master branch,
and be released to [PowerShell Gallery](https://www.powershellgallery.com/).

## Contributing

Please check out common DSC Resource [contributing guidelines](https://github.com/PowerShell/DscResources/blob/master/CONTRIBUTING.md).

## Description

The **xActiveDirectory** module contains DSC resources for deployment and
configuration of Active Directory.
These DSC resources allow you to configure new domains, child domains, and high
availability domain controllers, establish cross-domain trusts and manage users,
groups and OUs.

## Resources

* **xADComputer** creates and manages Active Directory computer accounts.
* **xADDomain** creates new Active Directory forest configurations and new Active Directory domain configurations.
* **xADDomainController** installs and configures domain controllers in Active Directory.
* **xADDomainDefaultPasswordPolicy** manages an Active Directory domain's default password policy.
* **xADDomainTrust** establishes cross-domain trusts.
* **xADForestProperties** manages User Principal Name (UPN) suffixes and Service Principal Name (SPN) suffixes in a forest.
* **xADGroup** modifies and removes Active Directory groups.
* **xADObjectPermissionEntry** modifies the access control list of an Active Directory object.
* **xADOrganizationalUnit** creates and deletes Active Directory OUs.
* **xADRecycleBin** enables or disabled Active Directory Recycle Bin.
* **xADReplicationSite** creates and deletes Active Directory replication sites.
* **xADReplicationSubnet** add or removes Active Directory replication subnet.
* **xADServicePrincipalName** adds or removes the SPN to a user or computer account.
* **xADUser** modifies and removes Active Directory Users.
* **xWaitForDomain** waits for new, remote domain to setup.

(Note: the RSAT tools will not be installed when these resources are used to configure AD.)

### **xADComputer**

The xADComputer DSC resource will manage computer accounts within Active Directory.

* **`[String]` ComputerName** _(Key)_: Specifies the name of the computer to manage.
* **`[String]` Location** _(Write)_: Specifies the location of the computer, such as an office number.
* **`[String]` DnsHostName** _(Write)_: Specifies the fully qualified domain name (FQDN) of the computer.
* **`[String]` ServicePrincipalNames** _(Write)_: Specifies the service principal names for the computer account.
* **`[String]` UserPrincipalName** _(Write)_: Specifies the UPN assigned to the computer account.
* **`[String]` DisplayName** _(Write)_: "Specifies the display name of the computer.
* **`[String]` Path** _(Write)_: Specifies the X.500 path of the container where the computer is located.
* **`[String]` Description** _(Write)_: Specifies a description of the computer object.
* **`[Boolean]` Enabled** _(Write)_: Specifies if the computer account is enabled.
* **`[String]` Manager** _(Write)_: Specifies the user or group Distinguished Name that manages the computer object.
  * Valid values are the user's or group's DistinguishedName, ObjectGUID, SID or SamAccountName.
* **`[String]`DomainController** _(Write)_: Specifies the Active Directory Domain Services instance to connect to perform the task.
* **`[PSCredential]` DomainAdministratorCredential** _(Write)_: Specifies the user account credentials to use to perform the task.
* **`[String]` RequestFile** _(Write)_: Specifies the full path to the Offline Domain Join Request file to create.
* **`[String]` Ensure**: Specifies whether the computer account is present or absent.
  * Valid values are 'Present' and 'Absent'.
  * It not specified, it defaults to 'Present'.
* **`[Boolean]` RestoreFromRecycleBin** _(Write)_: Indicates whether or not the computer object should first tried to be restored from the recycle bin before creating a new computer object.
* **`[String]` DistinguishedName** _(Read)_: Returns the X.500 path of the computer object.
* **`[String]` SID** _(Read)_: Returns the security identifier of the computer object.

Note: An ODJ Request file will only be created when a computer account is first created in the domain.
Setting an ODJ Request file path for a configuration that creates a computer account that already exists will not cause the file to be created.

### **xADDomain**

The xADDomain resource creates a new domain in a new forest or a child domain in an existing forest. While it is possible to set the forest functional level and the domain functional level during deployment with this resource the common restrictions apply. For more information see [TechNet](https://docs.microsoft.com/en-us/windows-server/identity/ad-ds/active-directory-functional-levels).

* **`[String]` DomainName** _(Key)_: Name of the domain.
  * If no parent name is specified, this is the fully qualified domain name for the first domain in the forest.
* **`[String]` ParentDomainName** _(Write)_: Fully qualified name of the parent domain.
* **`[PSCredential]` DomainAdministratorCredential** _(Required)_: Credentials used to query for domain existence.
  * _Note: These are NOT used during domain creation._ During an Active Directory deployment the local administrator credentials are used for the domain administrator.

* **`[PSCredential]` SafemodeAdministratorPassword** _(Required)_: Password for the administrator account when the computer is started in Safe Mode.
* **`[PSCredential]` DnsDelegationCredential** _(Write)_: Credential used for creating DNS delegation.
* **`[String]` DomainNetBIOSName** _(Write)_: Specifies the NetBIOS name for the new domain.
  * If not specified, then the default is automatically computed from the value of the DomainName parameter.
* **`[String]` DatabasePath** _(Write)_: Specifies the fully qualified, non-Universal Naming Convention (UNC) path to a directory on a fixed disk of the local computer that contains the domain database.
* **`[String]` LogPath** _(Write)_: Specifies the fully qualified, non-UNC path to a directory on a fixed disk of the local computer where the log file for this operation will be written.
* **`[String]` SysvolPath** _(Write)_: Specifies the fully qualified, non-UNC path to a directory on a fixed disk of the local computer where the Sysvol file will be written.
* **`[String]` ForestMode** _(Write)_: Specifies the forest mode if a new forest is deployed. ForestMode will not be raised by this resource for existing forests.
  * Valid values are Win2008, Win2008R2, Win2012, Win2012R2 and WinThreshold (for Windows Server 2016 FFL)
* **`[String]` DomainMode** _(Write)_: Specifies the domain mode if a new domain is deployed. DomainMode will not be raised by this resource for existing domains.
  * Valid values are Win2008, Win2008R2, Win2012, Win2012R2 and WinThreshold (for Windows Server 2016 DFL)

### **xADDomainController**

* **`[String]` DomainName** _(Key)_: The fully qualified domain name for the domain where the domain controller will be present.
* **`[PSCredential]` DomainAdministratorCredential** _(Required)_: Specifies the credential for the account used to install the domain controller.
* **`[PSCredential]` SafemodeAdministratorPassword** _(Required)_: Password for the administrator account when the computer is started in Safe Mode.
* **`[String]` DatabasePath** _(Write)_: Specifies the fully qualified, non-Universal Naming Convention (UNC) path to a directory on a fixed disk of the local computer that contains the domain database.
* **`[String]` LogPath** _(Write)_: Specifies the fully qualified, non-UNC path to a directory on a fixed disk of the local computer where the log file for this operation will be written.
* **`[String]` SysvolPath** _(Write)_: Specifies the fully qualified, non-UNC path to a directory on a fixed disk of the local computer where the Sysvol file will be written.
* **`[String]` SiteName** _(Write)_: Specify the name of an existing site where new domain controller will be placed.

### **xADDomainDefaultPasswordPolicy**

The xADDomainDefaultPasswordPolicy DSC resource will manage an Active Directory domain's default password policy.

* **`[String]` DomainName** _(Key)_: Name of the domain to which the password policy will be applied.
* **`[Boolean]` ComplexityEnabled** _(Write)_: Whether password complexity is enabled for the default password policy.
* **`[UInt32]` LockoutDuration** _(Write)_: Length of time that an account is locked after the number of failed login attempts (minutes).
* **`[UInt32]` LockoutObservationWindow** _(Write)_: Maximum time between two unsuccessful login attempts before the counter is reset to 0 (minutes).
* **`[UInt32]` LockoutThreshold** _(Write)_: Number of unsuccessful login attempts that are permitted before an account is locked out.
* **`[UInt32]` MinPasswordAge** _(Write)_: Minimum length of time that you can have the same password (minutes).
* **`[UInt32]` MaxPasswordAge** _(Write)_: Maximum length of time that you can have the same password (minutes).
* **`[UInt32]` MinPasswordLength** _(Write)_: Minimum number of characters that a password must contain.
* **`[UInt32]` PasswordHistoryCount** _(Write)_: Number of previous passwords to remember.
* **`[Boolean]` ReversibleEncryptionEnabled** _(Write)_: Whether the directory must store passwords using reversible encryption.
* **`[String]` DomainController** _(Write)_: An existing Active Directory domain controller used to perform the operation.
* **`[PSCredential]` Credential** _(Write)_: User account credentials used to perform the operation.

### **xADDomainTrust**

* **`[String]` TargetDomainName** _(Key)_: Name of the AD domain that is being trusted
* **`[PSCredential]` TargetDomainAdministratorCredential** _(Required)_: Credentials to authenticate to the target domain
* **`[String]` Ensure** _(Write)_: Specifies whether the domain trust is present or absent
* **`[String]` TrustType** _(Write)_: Type of trust
* **`[String]` TrustDirection** _(Write)_: Direction of trust, the values for which may be Bidirectional,Inbound, or Outbound
* **`[String]` SourceDomainName** _(Write)_: Name of the AD domain that is requesting the trust

### **xADGroup**

The xADGroup DSC resource will manage groups within Active Directory.

* **`[String]` GroupName** _(Key)_: Name of the Active Directory group to manage.
* **`[String]` Category** _(Write)_: This parameter sets the GroupCategory property of the group.
  * Valid values are 'Security' and 'Distribution'.
  * If not specified, it defaults to 'Security'.
* **`[String]` GroupScope** _(Write)_: Specifies the group scope of the group.
  * Valid values are 'DomainLocal', 'Global' and 'Universal'.
  * If not specified, it defaults to 'Global'.
* **`[String]` Path** _(Write)_: Path in Active Directory to place the group, specified as a Distinguished Name (DN).
* **`[String]` Description** _(Write)_: Specifies a description of the group object.
* **`[String]` DisplayName** _(Write)_: Specifies the display name of the group object.
* **`[String[]]` Members** _(Write)_: Specifies the explicit AD objects that should comprise the group membership.
  * If not specified, no group membership changes are made.
  * If specified, all undefined group members will be removed the AD group.
  * This property cannot be specified with either 'MembersToInclude' or 'MembersToExclude'.
* **`[String[]]` MembersToInclude** _(Write)_: Specifies AD objects that must be in the group.
  * If not specified, no group membership changes are made.
  * If specified, only the specified members are added to the group.
  * If specified, no users are removed from the group using this parameter.
  * This property cannot be specified with the 'Members' parameter.
* **`[String[]]` MembersToExclude** _(Write)_: Specifies AD objects that _must not_ be in the group.
  * If not specified, no group membership changes are made.
  * If specified, only those specified are removed from the group.
  * If specified, no users are added to the group using this parameter.
  * This property cannot be specified with the 'Members' parameter.
* **`[String]` MembershipAttribute** _(Write)_: Defines the AD object attribute that is used to determine group membership.
  * Valid values are 'SamAccountName', 'DistinguishedName', 'ObjectGUID' and 'SID'.
  * If not specified, it defaults to 'SamAccountName'.
  * You cannot mix multiple attribute types.
* **`[String]` ManagedBy** _(Write)_: Specifies the user or group that manages the group object.
  * Valid values are the user's or group's DistinguishedName, ObjectGUID, SID or SamAccountName.
* **`[String]` Notes** _(Write)_: The group's info attribute.
* **`[String]` Ensure** _(Write)_: Specifies whether the group is present or absent.
  * Valid values are 'Present' and 'Absent'.
  * It not specified, it defaults to 'Present'.
* **`[String]` DomainController** _(Write)_: An existing Active Directory domain controller used to perform the operation.
  * If not running on a domain controller, this is required.
* **`[PSCredential]` Credential** _(Write)_: User account credentials used to perform the operation.
  * If not running on a domain controller, this is required.
* **`[Boolean]` RestoreFromRecycleBin** _(Write)_: Indicates whether or not the group object should first tried to be restored from the recycle bin before creating a new group object.

### **xADObjectPermissionEntry**

The xADObjectPermissionEntry DSC resource will manage access control lists on Active Directory objects. The resource is
designed to to manage just one entry in the list of permissios (ACL) for one AD object. It will only interact with the
one permission and leave all others as they were. The resource can be used multiple times to add multiple entries into
one ACL.

* **Ensure**: Indicates if the access will be added (Present) or will be removed (Absent). Default is 'Present'.
* **Path**: Active Directory path of the object, specified as a Distinguished Name.
* **IdentityReference**: Indicates the identity of the principal for the ace. Use the notation DOMAIN\SamAccountName for the identity.
* **ActiveDirectoryRights**: A combination of one or more of the ActiveDirectoryRights enumeration values that specifies the rights of the access rule. Default is 'GenericAll'. Valid values: { AccessSystemSecurity | CreateChild | Delete | DeleteChild | DeleteTree | ExtendedRight | GenericAll | GenericExecute | GenericRead | GenericWrite | ListChildren | ListObject | ReadControl | ReadProperty | Self | Synchronize | WriteDacl | WriteOwner | WriteProperty }
* **AccessControlType**: Indicates whether to Allow or Deny access to the target object.
* **ObjectType**: The schema GUID of the object to which the access rule applies. If the permission entry shouldn't be restricted to a specific object type, use the zero guid: 00000000-0000-0000-0000-000000000000.
* **ActiveDirectorySecurityInheritance**: One of the 'ActiveDirectorySecurityInheritance' enumeration values that specifies the inheritance type of the access rule. { All | Children | Descendents | None | SelfAndChildren }.
* **InheritedObjectType**: The schema GUID of the child object type that can inherit this access rule. If the permission entry shouldn't be restricted to a specific inherited object type, use the zero guid: 00000000-0000-0000-0000-000000000000.

### **xADOrganizationalUnit**

The xADOrganizational Unit DSC resource will manage OUs within Active Directory.

* **`[String]` Name** _(Key)_: Name of the Active Directory organizational unit to manage.
* **`[String]` Path** _(Key)_: Specified the X500 (DN) path of the organizational unit's parent object.
* **`[String]` Description** _(Write)_: The OU description property.
* **`[Boolean]` ProtectedFromAccidentalDeletion** _(Write)_: Valid values are $true and $false. If not specified, it defaults to $true.
* **`[String]` Ensure** _(Write)_: Specifies whether the OU is present or absent. Valid values are 'Present' and 'Absent'. It not specified, it defaults to 'Present'.
* **`[PSCredential]` Credential** _(Write)_: User account credentials used to perform the operation. Note: _if not running on a domain controller, this is required_.
* **`[Boolean]` RestoreFromRecycleBin** _(Write)_: Indicates whether or not the organizational unit should first tried to be restored from the recycle bin before creating a new organizational unit.

### **xADRecycleBin**

The xADRecycleBin DSC resource will enable the Active Directory Recycle Bin feature for the target forest.
This resource first verifies that the forest mode is Windows Server 2008 R2 or greater.  If the forest mode
is insufficient, then the resource will exit with an error message.  The change is executed against the
Domain Naming Master FSMO of the forest.
(Note: This resource is compatible with a Windows 2008 R2 or above target node.)

* **`[String]` ForestFQDN** _(Key)_:  Fully qualified domain name of forest to enable Active Directory Recycle Bin.
* **`[PSCredential]` EnterpriseAdministratorCredential** _(Required)_:  Credential with Enterprise Administrator rights to the forest.
* **`[Boolean]` RecycleBinEnabled** _(Read)_:  Read-only. Returned by Get.
* **`[String]` ForestMode** _(Read)_:  Read-only. Returned by Get.

### **xADReplicationSite**

* **`[String]` Name** _(Key)_: Specifies the name of the AD replication site.
* **`[String]` Ensure** _(Write)_: Specifies if the AD replication site should be added or remove. Default value is 'Present'. { *Present* | Absent }.
* **`[Boolean]` RenameDefaultFirstSiteName** _(Write)_: Specify if the Default-First-Site-Name should be renamed, if it exists. Dafult value is 'false'.

### **xADReplicationSubnet**

The xADReplicationSubnet DSC resource will manage replication subnets.

* **`[String]` Name** _(Key)_: The name of the AD replication subnet, e.g. 10.0.0.0/24.
* **`[String]` Site** _(Required)_: The name of the assigned AD replication site, e.g. Default-First-Site-Name.
* **`[String]` Ensure** _(Write)_: Specifies if the AD replication subnet should be added or remove. Default value is 'Present'.
* **`[String]` Location** _(Write)_: The location for the AD replication site. Default value is empty.

### **xADServicePrincipalName**

The xADServicePrincipalName DSC resource will manage service principal names.

* **`[String]` ServicePrincipalName** _(Key)_: The full SPN to add or remove, e.g. HOST/LON-DC1.
* **`[String]` Ensure** _(Write)_: Specifies if the service principal name should be added or remove. Default value is 'Present'. { *Present* | Absent }.
* **`[String]` Account** _(Write)_: The user or computer account to add or remove the SPN, e.b. User1 or LON-DC1$. Default value is ''. If Ensure is set to Present, a value must be specified.

### **xADUser**

* **`[String]` DomainName** _(Key)_: Name of the domain to which the user will be added.
  * The Active Directory domain's fully-qualified domain name must be specified, i.e. contoso.com.
  * This parameter is used to query and set the user's account password.
* **`[String]` UserName** _(Key)_: Specifies the Security Account Manager (SAM) account name of the user.
  * To be compatible with older operating systems, create a SAM account name that is 20 characters or less.
  * Once created, the user's SamAccountName and CN cannot be changed.
* **`[PSCredential]` Password** _(Write)_: Password value for the user account.
  * _If the account is enabled (default behaviour) you must specify a password._
  * _You must ensure that the password meets the domain's complexity requirements._
* **`[String]` Ensure** _(Write)_: Specifies whether the given user is present or absent.
  * If not specified, this value defaults to Present.
* **`[String]` DomainController** _(Write)_: Specifies the Active Directory Domain Services instance to connect to.
  * This is only required if not executing the task on a domain controller.
* **`[PSCredential]` DomainAdministratorCredential** _(Write)_: User account credentials used to perform the task.
  * This is only required if not executing the task on a domain controller or using the -DomainController parameter.
* **`[String]` CommonName** _(Write)_: Specifies the user's CN of the user account.
  * If not specified, this defaults to the ___UserName___ value.
* **`[String]` UserPrincipalName** _(Write)_: Each user account has a user principal name (UPN) in the format [user]@[DNS-domain-name].
* **`[String]` DisplayName** _(Write)_: Specifies the display name of the user object.
* **`[String]` Path** _(Write)_: The organizational unit to place the user in.
* **`[String]` GivenName** _(Write)_: Specifies the user's first or given name.
* **`[String]` Initials** _(Write)_: Specifies the initials that represent part of a user's name.
* **`[String]` Surname** _(Write)_: Specifies the user's last name or surname.
* **`[String]` Description** _(Write)_: Specifies a description of the user object.
* **`[String]` StreetAddress** _(Write)_: Specifies the user's street address.
* **`[String]` POBox** _(Write)_: Specifies the user's post office box number.
* **`[String]` City** _(Write)_: Specifies the user's town or city.
* **`[String]` State** _(Write)_: Specifies the user's state or province.
* **`[String]` PostalCode** _(Write)_: Specifies the user's postal code or zip code.
* **`[String]` Country** _(Write)_: Specifies the country or region code for the user's language of choice.
  * This should be specified as the country's two character ISO-3166 code.
* **`[String]` Department** _(Write)_: Specifies the user's department.
* **`[String]` Division** _(Write)_: Specifies the user's division.
* **`[String]` Company** _(Write)_: Specifies the user's company.
* **`[String]` Office** _(Write)_: Specifies the location of the user's office or place of business.
* **`[String]` JobTitle** _(Write)_: Specifies the user's job title.
* **`[String]` EmailAddress** _(Write)_: Specifies the user's e-mail address.
* **`[String]` EmployeeID** _(Write)_: Specifies the user's employee ID.
* **`[String]` EmployeeNumber** _(Write)_: Specifies the user's employee number.
* **`[String]` HomeDirectory** _(Write)_: Specifies a user's home directory path.
* **`[String]` HomeDrive** _(Write)_: Specifies a drive that is associated with the UNC path defined by the HomeDirectory property.
  * The drive letter is specified as "[DriveLetter]:" where [DriveLetter] indicates the letter of the drive to associate.
  * The [DriveLetter] must be a single, uppercase letter and the colon is required.
* **`[String]` HomePage** _(Write)_: Specifies the URL of the home page of the user object.
* **`[String]` ProfilePath** _(Write)_: Specifies a path to the user's profile.
  * This value can be a local absolute path or a Universal Naming Convention (UNC) path.
* **`[String]` LogonScript** _(Write)_: Specifies a path to the user's log on script.
  * This value can be a local absolute path or a Universal Naming Convention (UNC) path.
* **`[String]` Notes** _(Write)_: Sets the notes attribute.
* **`[String]` OfficePhone** _(Write)_: Specifies the user's office telephone number.
* **`[String]` MobilePhone** _(Write)_: Specifies the user's mobile phone number.
* **`[String]` Fax** _(Write)_: Specifies the user's fax phone number.
* **`[String]` Pager** _(Write)_: Specifies the user's pager number.
* **`[String]` IPPhone** _(Write)_: Specifies the user's IP telephony number.
* **`[String]` HomePhone** _(Write)_: Specifies the user's home telephone number.
* **`[Boolean]` Enabled** _(Write)_: Specifies if an account is enabled.
  * An enabled account requires a password.
* **`[String]` Manager** _(Write)_: Specifies the user's manager.
  * This value can be specified as a DN, ObjectGUID, SID or SamAccountName.
* **`[Boolean]` PasswordNeverExpires** _(Write)_: Specifies whether the password of an account can expire.
  * If not specified, this value defaults to False.
* **`[Boolean]` CannotChangePassword** _(Write)_: Specifies whether the account password can be changed.
  * If not specified, this value defaults to False.
* **`[String]` PasswordAuthentication** _(Write)_: Specifies the authentication context used when testing users' passwords.
  * The 'Negotiate' option supports NTLM authentication - which may be required when testing users' passwords when Active Directory Certificate Services (ADCS) is deployed.
* **`[Boolean]` PasswordNeverResets** _(Write)_: Specifies whether existing user's password should be reset (default $false).
* **`[Boolean]` RestoreFromRecycleBin** _(Write)_: Indicates whether or not the user object should first tried to be restored from the recycle bin before creating a new user object.
* **`[String]` DistinguishedName** _(Read)_: The user distinguished name, returned with Get.

### **xWaitForADDomain**

* **`[String]` DomainName** _(Key)_: Name of the remote domain.
* **`[UInt64]` RetryIntervalSec** _(Write)_: Interval to check for the domain's existence.
* **`[UInt32]` RetryCount** _(Write)_: Maximum number of retries to check for the domain's existence.
* **`[UInt32]` RebootRetryCount** _(Write)_: Maximum number of reboots to process in order to wait for a domain's existence.

### **xADForestProperties**

The xADForestProperties DSC resource will manage User Principal Name (UPN) suffixes and Service Principal Name (SPN) suffixes in a forest.

* **Credential**: (optional) "Specifies the user account credentials to use to perform this task.
* **ForestName**: Specifies the target Active Directory forest for the change.
* **ServicePrincipalNameSuffix**: (optional) The Service Principal Name Suffix(es) to be explicitly defined in the forest and replace existing
    SPNs. Cannot be used with ServicePrincipalNameSuffixToAdd or ServicePrincipalNameSuffixToRemove.
* **ServicePrincipalNameSuffixToAdd**: (optional) The Service Principal Name Suffix(es) to add in the forest. Cannot be used with ServicePrincipalNameSuffix.
* **ServicePrincipalNameSuffixToRemove**: (optional) The Service Principal Name Suffix(es) to remove in the forest. Cannot be used with ServicePrincipalNameSuffix.
* **UserPrincipalNameSuffix**: (optional) The User Principal Name Suffix(es) to be explicitly defined in the forest and replace existing
    UPNs. Cannot be used with UserPrincipalNameSuffixToAdd or UserPrincipalNameSuffixToRemove.
* **UserPrincipalNameSuffixToAdd**: (optional) The User Principal Name Suffix(es) to add in the forest. Cannot be used with UserPrincipalNameSuffix.
* **UserPrincipalNameSuffixToRemove**: (optional) The User Principal Name Suffix(es) to remove in the forest. Cannot be used with UserPrincipalNameSuffix.

## Versions

### Unreleased

### 2.23.0.0

* Explicitly removed extra hidden files from release package

### 2.22.0.0

* Add PasswordNeverResets parameter to xADUser to facilitate user lifecycle management
* Update appveyor.yml to use the default template.
* Added default template files .gitattributes, and .gitignore, and
  .vscode folder.
* Added xADForestProperties: New resource to manage User and Principal Name Suffixes for a Forest.

### 2.21.0.0

* Added xADObjectPermissionEntry
  * New resource added to control the AD object permissions entries [Claudio Spizzi (@claudiospizzi)](https://github.com/claudiospizzi)
* Changes to xADCommon
  * Assert-Module has been extended with a parameter ImportModule to also import the module ([issue #218](https://github.com/PowerShell/xActiveDirectory/issues/218)). [Jan-Hendrik Peters (@nyanhp)](https://github.com/nyanhp)
* Changes to xADDomain
  * xADDomain makes use of new parameter ImportModule of Assert-Module in order to import the ADDSDeployment module ([issue #218](https://github.com/PowerShell/xActiveDirectory/issues/218)). [Jan-Hendrik Peters (@nyanhp)](https://github.com/nyanhp)
* xADComputer, xADGroup, xADOrganizationalUnit and xADUser now support restoring from AD recycle bin ([Issue #221](https://github.com/PowerShell/xActiveDirectory/issues/211)). [Jan-Hendrik Peters (@nyanhp)](https://github.com/nyanhp)

### 2.20.0.0

* Changes to xActiveDirectory
  * Changed MSFT_xADUser.schema.mof version to "1.0.0.0" to match other resources ([issue #190](https://github.com/PowerShell/xActiveDirectory/issues/190)). [thequietman44 (@thequietman44)](https://github.com/thequietman44)
  * Removed duplicated code from examples in README.md ([issue #198](https://github.com/PowerShell/xActiveDirectory/issues/198)). [thequietman44 (@thequietman44)](https://github.com/thequietman44)
  * xADDomain is now capable of setting the forest and domain functional level ([issue #187](https://github.com/PowerShell/xActiveDirectory/issues/187)). [Jan-Hendrik Peters (@nyanhp)](https://github.com/nyanhp)

### 2.19.0.0

* Changes to xActiveDirectory
  * Activated the GitHub App Stale on the GitHub repository.
  * The resources are now in alphabetical order in the README.md
    ([issue #194](https://github.com/PowerShell/xActiveDirectory/issues/194)).
  * Adding a Branches section to the README.md with Codecov badges for both
    master and dev branch ([issue #192](https://github.com/PowerShell/xActiveDirectory/issues/192)).
  * xADGroup no longer resets GroupScope and Category to default values ([issue #183](https://github.com/PowerShell/xActiveDirectory/issues/183)).
  * The helper function script file MSFT_xADCommon.ps1 was renamed to
    MSFT_xADCommon.psm1 to be a module script file instead. This makes it
    possible to report code coverage for the helper functions ([issue #201](https://github.com/PowerShell/xActiveDirectory/issues/201)).

### 2.18.0.0

* xADReplicationSite: Resource added.
* Added xADReplicationSubnet resource.
* Fixed bug with group members in xADGroup

### 2.17.0.0

* Converted AppVeyor.yml to use DSCResource.tests shared code.
* Opted-In to markdown rule validation.
* Readme.md modified resolve markdown rule violations.
* Added CodeCov.io support.
* Added xADServicePrincipalName resource.

### 2.16.0.0

* xAdDomainController: Update to complete fix for SiteName being required field.
* xADDomain: Added retry logic to prevent FaultException to crash in Get-TargetResource on subsequent reboots after a domain is created because the service is not yet running. This error is mostly occur when the resource is used with the DSCExtension on Azure.

### 2.15.0.0

* xAdDomainController: Fixes SiteName being required field.

### 2.14.0.0

* xADDomainController: Adds Site option.
* xADDomainController: Populate values for DatabasePath, LogPath and SysvolPath during Get-TargetResource.

### 2.13.0.0

* Converted AppVeyor.yml to pull Pester from PSGallery instead of Chocolatey
* xADUser: Adds 'PasswordAuthentication' option when testing user passwords to support NTLM authentication with Active Directory Certificate Services deployments
* xADUser: Adds descriptions to user properties within the schema file.
* xADGroup: Fixes bug when updating groups when alternate Credentials are specified.

### 2.12.0.0

* xADDomainController: Customer identified two cases of incorrect variables being called in Verbose output messages. Corrected.
* xADComputer: New resource added.
* xADComputer: Added RequestFile support.
* Fixed PSScriptAnalyzer Errors with v1.6.0.

### 2.11.0.0

* xWaitForADDomain: Made explicit credentials optional and other various updates

### 2.10.0.0

* xADDomainDefaultPasswordPolicy: New resource added.
* xWaitForADDomain: Updated to make it compatible with systems that don't have the ActiveDirectory module installed, and to allow it to function with domains/forests that don't have a domain controller with Active Directory Web Services running.
* xADGroup: Fixed bug where specified credentials were not used to retrieve existing group membership.
* xADDomain: Added check for Active Directory cmdlets.
* xADDomain: Added additional error trapping, verbose and diagnostic information.
* xADDomain: Added unit test coverage.
* Fixes CredentialAttribute and other PSScriptAnalyzer tests in xADCommon, xADDomin, xADGroup, xADOrganizationalUnit and xADUser resources.

### 2.9.0.0

* xADOrganizationalUnit: Merges xADOrganizationalUnit resource from the PowerShell gallery
* xADGroup: Added Members, MembersToInclude, MembersToExclude and MembershipAttribute properties.
* xADGroup: Added ManagedBy property.
* xADGroup: Added Notes property.
* xADUser: Adds additional property settings.
* xADUser: Adds unit test coverage.

### 2.8.0.0

* Added new resource: xADGroup
* Fixed issue with NewDomainNetbiosName parameter.

### 2.7.0.0

* Added DNS flush in retry loop
* Bug fixes in xADDomain resource

### 2.6.0.0

* Removed xDscResourceDesigner tests (moved to common tests)

### 2.5.0.0

* Updated xADDomainTrust and xADRecycleBin tests

### 2.4.0.0

* Added xADRecycleBin resource
* Minor fixes for xADUser resource

### 2.3

* Added xADRecycleBin.
* Modified xADUser to include a write-verbose after user is removed when Absent.
* Corrected xADUser to successfully create a disabled user without a password.

### 2.2

* Modified xAdDomain and xAdDomainController to support Ensure as Present / Absent, rather than True/False.
  Note: this may cause issues for existing scripts.
* Corrected return value to be a hashtable in both resources.

### 2.1.0.0

* Minor update: Get-TargetResource to use domain name instead of name.

### 2.0.0.0

* Updated release, which added the resource:
  * xADDomainTrust

### 1.0.0.0

* Initial release with the following resources:
  * xADDomain, xADDomainController, xADUser, and xWaitForDomain

## Examples

### Create a highly available Domain using multiple domain controllers

In the following example configuration, a highly available domain is created by adding a domain controller to an existing domain.
This example uses the xWaitForDomain resource to ensure that the domain is present before the second domain controller is added.

```powershell
# A configuration to Create High Availability Domain Controller
Configuration AssertHADC
{
   param
    (
        [Parameter(Mandatory)]
        [pscredential]$safemodeAdministratorCred,
        [Parameter(Mandatory)]
        [pscredential]$domainCred,
        [Parameter(Mandatory)]
        [pscredential]$DNSDelegationCred,
        [Parameter(Mandatory)]
        [pscredential]$NewADUserCred
    )
    Import-DscResource -ModuleName xActiveDirectory
    Node $AllNodes.Where{$_.Role -eq "Primary DC"}.Nodename
    {
        WindowsFeature ADDSInstall
        {
            Ensure = "Present"
            Name = "AD-Domain-Services"
        }
        xADDomain FirstDS
        {
            DomainName = $Node.DomainName
            DomainAdministratorCredential = $domainCred
            SafemodeAdministratorPassword = $safemodeAdministratorCred
            DnsDelegationCredential = $DNSDelegationCred
            DependsOn = "[WindowsFeature]ADDSInstall"
        }
        xWaitForADDomain DscForestWait
        {
            DomainName = $Node.DomainName
            DomainUserCredential = $domainCred
            RetryCount = $Node.RetryCount
            RetryIntervalSec = $Node.RetryIntervalSec
            DependsOn = "[xADDomain]FirstDS"
        }
        xADUser FirstUser
        {
            DomainName = $Node.DomainName
            DomainAdministratorCredential = $domainCred
            UserName = "dummy"
            Password = $NewADUserCred
            Ensure = "Present"
            DependsOn = "[xWaitForADDomain]DscForestWait"
        }
    }
    Node $AllNodes.Where{$_.Role -eq "Replica DC"}.Nodename
    {
        WindowsFeature ADDSInstall
        {
            Ensure = "Present"
            Name = "AD-Domain-Services"
        }
        xWaitForADDomain DscForestWait
        {
            DomainName = $Node.DomainName
            DomainUserCredential = $domainCred
            RetryCount = $Node.RetryCount
            RetryIntervalSec = $Node.RetryIntervalSec
            DependsOn = "[WindowsFeature]ADDSInstall"
        }
        xADDomainController SecondDC
        {
            DomainName = $Node.DomainName
            DomainAdministratorCredential = $domainCred
            SafemodeAdministratorPassword = $safemodeAdministratorCred
            DnsDelegationCredential = $DNSDelegationCred
            DependsOn = "[xWaitForADDomain]DscForestWait"
        }
    }
}
# Configuration Data for AD
$ConfigData = @{
    AllNodes = @(
        @{
            Nodename = "dsc-testNode1"
            Role = "Primary DC"
            DomainName = "dsc-test.contoso.com"
            CertificateFile = "C:\publicKeys\targetNode.cer"
            Thumbprint = "AC23EA3A9E291A75757A556D0B71CBBF8C4F6FD8"
            RetryCount = 20
            RetryIntervalSec = 30
        },
        @{
            Nodename = "dsc-testNode2"
            Role = "Replica DC"
            DomainName = "dsc-test.contoso.com"
            CertificateFile = "C:\publicKeys\targetNode.cer"
            Thumbprint = "AC23EA3A9E291A75757A556D0B71CBBF8C4F6FD8"
            RetryCount = 20
            RetryIntervalSec = 30
        }
    )
}
AssertHADC -configurationData $ConfigData `
-safemodeAdministratorCred (Get-Credential -Message "New Domain Safe Mode Admin Credentials") `
-domainCred (Get-Credential -Message "New Domain Admin Credentials") `
-DNSDelegationCred (Get-Credential -Message "Credentials to Setup DNS Delegation") `
-NewADUserCred (Get-Credential -Message "New AD User Credentials")
Start-DscConfiguration -Wait -Force -Verbose -ComputerName "dsc-testNode1" -Path $PSScriptRoot\AssertHADC `
-Credential (Get-Credential -Message "Local Admin Credentials on Remote Machine")
Start-DscConfiguration -Wait -Force -Verbose -ComputerName "dsc-testNode2" -Path $PSScriptRoot\AssertHADC `
-Credential (Get-Credential -Message "Local Admin Credentials on Remote Machine")
```

### Create a child domain under a parent domain

In this example, we create a domain, and then create a child domain on another node.

```powershell
# Configuration to Setup Parent Child Domains

Configuration AssertParentChildDomains
{
    param
    (
        [Parameter(Mandatory)]
        [pscredential]$safemodeAdministratorCred,

        [Parameter(Mandatory)]
        [pscredential]$domainCred,

        [Parameter(Mandatory)]
        [pscredential]$DNSDelegationCred,

        [Parameter(Mandatory)]
        [pscredential]$NewADUserCred
    )

    Import-DscResource -ModuleName xActiveDirectory

    Node $AllNodes.Where{$_.Role -eq "Parent DC"}.Nodename
    {
        WindowsFeature ADDSInstall
        {
            Ensure = "Present"
            Name = "AD-Domain-Services"
        }

        xADDomain FirstDS
        {
            DomainName = $Node.DomainName
            DomainAdministratorCredential = $domainCred
            SafemodeAdministratorPassword = $safemodeAdministratorCred
            DnsDelegationCredential = $DNSDelegationCred
            DependsOn = "[WindowsFeature]ADDSInstall"
        }

        xWaitForADDomain DscForestWait
        {
            DomainName = $Node.DomainName
            DomainUserCredential = $domainCred
            RetryCount = $Node.RetryCount
            RetryIntervalSec = $Node.RetryIntervalSec
            DependsOn = "[xADDomain]FirstDS"
        }

        xADUser FirstUser
        {
            DomainName = $Node.DomainName
            DomainAdministratorCredential = $domaincred
            UserName = "dummy"
            Password = $NewADUserCred
            Ensure = "Present"
            DependsOn = "[xWaitForADDomain]DscForestWait"
        }

    }

    Node $AllNodes.Where{$_.Role -eq "Child DC"}.Nodename
    {
        WindowsFeature ADDSInstall
        {
            Ensure = "Present"
            Name = "AD-Domain-Services"
        }

        xWaitForADDomain DscForestWait
        {
            DomainName = $Node.ParentDomainName
            DomainUserCredential = $domainCred
            RetryCount = $Node.RetryCount
            RetryIntervalSec = $Node.RetryIntervalSec
            DependsOn = "[WindowsFeature]ADDSInstall"
        }

        xADDomain ChildDS
        {
            DomainName = $Node.DomainName
            ParentDomainName = $Node.ParentDomainName
            DomainAdministratorCredential = $domainCred
            SafemodeAdministratorPassword = $safemodeAdministratorCred
            DependsOn = "[xWaitForADDomain]DscForestWait"
        }
    }
}

$ConfigData = @{

    AllNodes = @(
        @{
            Nodename = "dsc-testNode1"
            Role = "Parent DC"
            DomainName = "dsc-test.contoso.com"
            CertificateFile = "C:\publicKeys\targetNode.cer"
            Thumbprint = "AC23EA3A9E291A75757A556D0B71CBBF8C4F6FD8"
            RetryCount = 50
            RetryIntervalSec = 30
        },

        @{
            Nodename = "dsc-testNode2"
            Role = "Child DC"
            DomainName = "dsc-child"
            ParentDomainName = "dsc-test.contoso.com"
            CertificateFile = "C:\publicKeys\targetNode.cer"
            Thumbprint = "AC23EA3A9E291A75757A556D0B71CBBF8C4F6FD8"
            RetryCount = 50
            RetryIntervalSec = 30
        }
    )
}

AssertParentChildDomains -configurationData $ConfigData `
-safemodeAdministratorCred (Get-Credential -Message "New Domain Safe Mode Admin Credentials") `
-domainCred (Get-Credential -Message "New Domain Admin Credentials") `
-DNSDelegationCred (Get-Credential -Message "Credentials to Setup DNS Delegation") `
-NewADUserCred (Get-Credential -Message "New AD User Credentials")


Start-DscConfiguration -Wait -Force -Verbose -ComputerName "dsc-testNode1" -Path $PSScriptRoot\AssertParentChildDomains `
-Credential (Get-Credential -Message "Local Admin Credentials on Remote Machine")
Start-DscConfiguration -Wait -Force -Verbose -ComputerName "dsc-testNode2" -Path $PSScriptRoot\AssertParentChildDomains `
-Credential (Get-Credential -Message "Local Admin Credentials on Remote Machine")
```

### Create a cross-domain trust

In this example, we setup one-way trust between two domains.

```powershell
Configuration Sample_xADDomainTrust_OneWayTrust
{
    param
    (
        [Parameter(Mandatory)]
        [String]$SourceDomain,
        [Parameter(Mandatory)]
        [String]$TargetDomain,

        [Parameter(Mandatory)]
        [PSCredential]$TargetDomainAdminCred,
        [Parameter(Mandatory)]
        [String]$TrustDirection
    )
    Import-DscResource -module xActiveDirectory
    Node $AllNodes.Where{$_.Role -eq 'DomainController'}.NodeName
    {
        xADDomainTrust trust
        {
            Ensure                              = 'Present'
            SourceDomainName                    = $SourceDomain
            TargetDomainName                    = $TargetDomain
            TargetDomainAdministratorCredential = $TargetDomainAdminCred
            TrustDirection                      = $TrustDirection
            TrustType                           = 'External'
        }
    }
}
$config = @{
    AllNodes = @(
        @{
            NodeName      = 'localhost'
            Role          = 'DomainController'
            # Certificate Thumbprint that is used to encrypt/decrypt the credential
            CertificateID = 'B9192121495A307A492A19F6344E8752B51AC4A6'
        }
    )
}
Sample_xADDomainTrust_OneWayTrust -configurationdata $config `
                                  -SourceDomain safeharbor.contoso.com `
                                  -TargetDomain corporate.contoso.com `
                                  -TargetDomainAdminCred (get-credential) `
                                  -TrustDirection 'Inbound'
```

### Enable the Active Directory Recycle Bin

In this example, we enable the Active Directory Recycle Bin.

```powershell
Configuration Example_xADRecycleBin
{
Param(
    [parameter(Mandatory = $true)]
    [System.String]
    $ForestFQDN,

    [parameter(Mandatory = $true)]
    [System.Management.Automation.PSCredential]
    $EACredential
)

    Import-DscResource -Module xActiveDirectory

    Node $AllNodes.NodeName
    {
        xADRecycleBin RecycleBin
        {
           EnterpriseAdministratorCredential = $EACredential
           ForestFQDN = $ForestFQDN
        }
    }
}

$ConfigurationData = @{
    AllNodes = @(
        @{
            NodeName = '2012r2-dc'
        }
    )
}

Example_xADRecycleBin -EACredential (Get-Credential contoso\administrator) -ForestFQDN 'contoso.com' -ConfigurationData $ConfigurationData

Start-DscConfiguration -Path .\Example_xADRecycleBin -Wait -Verbose
```

### Create an Active Directory group

In this example, we add an Active Directory group to the default container (normally the Users OU).

```powershell
configuration Example_xADGroup
{
Param(
    [parameter(Mandatory = $true)]
    [System.String]
    $GroupName,

    [ValidateSet('DomainLocal','Global','Universal')]
    [System.String]
    $Scope = 'Global',

    [ValidateSet('Security','Distribution')]
    [System.String]
    $Category = 'Security',

    [ValidateNotNullOrEmpty()]
    [System.String]
    $Description
)

    Import-DscResource -Module xActiveDirectory

    Node $AllNodes.NodeName
    {
        xADGroup ExampleGroup
        {
           GroupName = $GroupName
           GroupScope = $Scope
           Category = $Category
           Description = $Description
           Ensure = 'Present'
        }
    }
}

Example_xADGroup -GroupName 'TestGroup' -Scope 'DomainLocal' -Description 'Example test domain local security group' -ConfigurationData $ConfigurationData

Start-DscConfiguration -Path .\Example_xADGroup -Wait -Verbose
```

### Create an Active Directory Replication Site

In this example, we will create an Active Directory replication site called
'Seattle'.

```powershell
configuration Example_xADReplicationSite
{
    Import-DscResource -Module xActiveDirectory

    Node $AllNodes.NodeName
    {
        xADReplicationSite 'SeattleSite'
        {
           Ensure = 'Present'
           Name   = 'Seattle'
        }
    }
}

Example_xADReplicationSite

Start-DscConfiguration -Path .\Example_xADReplicationSite -Wait -Verbose
```

### Create an Active Directory Replication Site (Rename Default-First-Site-Name)

In this example, we will create an Active Directory replication site called
'Seattle'. If the 'Default-First-Site-Name' site exists, it will rename this
site instead of create a new one.

```powershell
configuration Example_xADReplicationSite
{
    Import-DscResource -Module xActiveDirectory

    Node $AllNodes.NodeName
    {
        xADReplicationSite 'SeattleSite'
        {
           Ensure                     = 'Present'
           Name                       = 'Seattle'
           RenameDefaultFirstSiteName = $true
        }
    }
}

Example_xADReplicationSite

Start-DscConfiguration -Path .\Example_xADReplicationSite -Wait -Verbose
```

### Remove an Active Directory Replication Site

In this example, we will remove the Active Directory replication site called
'Cupertino'.

```powershell
configuration Example_xADReplicationSite
{
    Import-DscResource -Module xActiveDirectory

    Node $AllNodes.NodeName
    {
        xADReplicationSite 'CupertinoSite'
        {
           Ensure = 'Absent'
           Name   = 'Cupertino'
        }
    }
}

Example_xADReplicationSite

Start-DscConfiguration -Path .\Example_xADReplicationSite -Wait -Verbose
```

### Create an Active Directory OU

In this example, we add an Active Directory organizational unit to the 'example.com' domain root.

```powershell
configuration Example_xADOrganizationalUnit
{
Param(
    [parameter(Mandatory = $true)]
    [System.String]
    $Name,

    [parameter(Mandatory = $true)]
    [System.String]
    $Path,

    [System.Boolean]
    $ProtectedFromAccidentalDeletion = $true,

    [ValidateNotNull()]
    [System.String]
    $Description = ''
)

    Import-DscResource -Module xActiveDirectory

    Node $AllNodes.NodeName
    {
        xADOrganizationalUnit ExampleOU
        {
           Name = $Name
           Path = $Path
           ProtectedFromAccidentalDeletion = $ProtectedFromAccidentalDeletion
           Description = $Description
           Ensure = 'Present'
        }
    }
}

Example_xADOrganizationalUnit -Name 'Example OU' -Path 'dc=example,dc=com' -Description 'Example test organizational unit' -ConfigurationData $ConfigurationData

Start-DscConfiguration -Path .\Example_xADOrganizationalUnit -Wait -Verbose

```

### Configure Active Directory Domain Default Password Policy

In this example, we configure an Active Directory domain's default password policy to set the minimum password length and complexity.

```powershell
configuration Example_xADDomainDefaultPasswordPolicy
{
    Param
    (
        [parameter(Mandatory = $true)]
        [System.String]
        $DomainName,

        [parameter(Mandatory = $true)]
        [System.Boolean]
        $ComplexityEnabled,

        [parameter(Mandatory = $true)]
        [System.Int32]
        $MinPasswordLength,
    )

    Import-DscResource -Module xActiveDirectory

    Node $AllNodes.NodeName
    {
        xADDomainDefaultPasswordPolicy 'DefaultPasswordPolicy'
        {
           DomainName = $DomainName
           ComplexityEnabled = $ComplexityEnabled
           MinPasswordLength = $MinPasswordLength
        }
    }
}

Example_xADDomainDefaultPasswordPolicy -DomainName 'contoso.com' -ComplexityEnabled $true -MinPasswordLength 8

Start-DscConfiguration -Path .\Example_xADDomainDefaultPasswordPolicy -Wait -Verbose
```

### Create an Active Directory Computer Account

In this example, we create a 'NANO-001' computer account in the 'Server' OU of the 'example.com' Active Directory domain.

```powershell
configuration Example_xADComputerAccount
{
    Param
    (
        [parameter(Mandatory = $true)]
        [System.String]
        $DomainController,

        [parameter(Mandatory = $true)]
        [System.Management.Automation.PSCredential]
        $DomainCredential,

        [parameter(Mandatory = $true)]
        [System.String]
        $ComputerName,

        [parameter(Mandatory = $true)]
        [System.String]
        $Path
    )

    Import-DscResource -Module xActiveDirectory

    Node $AllNodes.NodeName
    {
        xADComputer "$ComputerName"
        {
           DomainController = $DomainController
           DomainAdministratorCredential = $DomainCredential
           ComputerName = $ComputerName
           Path = $Path
        }
    }
}

Example_xADComputerAccount -DomainController 'DC01' `
    -DomainCredential (Get-Credential -Message "Domain Credentials") `
    -ComputerName 'NANO-001' `
    -Path 'ou=Servers,dc=example,dc=com' `
    -ConfigurationData $ConfigurationData

Start-DscConfiguration -Path .\Example_xADComputerAccount -Wait -Verbose
```

### Create an Active Directory Computer Account and an ODJ Request File

In this example, we create a 'NANO-200' computer account in the 'Nano' OU of the 'example.com' Active Directory domain as well as creating an Offline Domain Join Request file.

```powershell
configuration Example_xADComputerAccountODJ
{
    Param
    (
        [parameter(Mandatory = $true)]
        [System.String]
        $DomainController,

        [parameter(Mandatory = $true)]
        [System.Management.Automation.PSCredential]
        $DomainCredential,

        [parameter(Mandatory = $true)]
        [System.String]
        $ComputerName,

        [parameter(Mandatory = $true)]
        [System.String]
        $Path,

        [parameter(Mandatory = $true)]
        [System.String]
        $RequestFile
    )

    Import-DscResource -Module xActiveDirectory

    Node $AllNodes.NodeName
    {
        xADComputer "$ComputerName"
        {
           DomainController = $DomainController
           DomainAdministratorCredential = $DomainCredential
           ComputerName = $ComputerName
           Path = $Path
           RequestFile = $RequestFile
        }
    }
}

Example_xADComputerAccountODJ -DomainController 'DC01' `
    -DomainCredential (Get-Credential -Message "Domain Credentials") `
    -ComputerName 'NANO-200' `
    -Path 'ou=Nano,dc=example,dc=com' `
    -RequestFile 'd:\ODJFiles\NANO-200.txt' `
    -ConfigurationData $ConfigurationData

Start-DscConfiguration -Path .\Example_xADComputerAccount -Wait -Verbose
```

### Create User Principal Name (UPN) suffixes and Service Principal Name suffixes

In this example the User Principal name suffixes "fabrikam.com" and "industry.com" and Service Principal name suffixes "corporate.com" are added to the Contoso forest.

```powershell
configuration Example_ADPrincipalSuffix
{
    Param
    (
        [parameter(Mandatory = $true)]
        [System.String]
        $TargetName,

        [parameter(Mandatory = $true)]
        [System.String]
        $ForestName,

        [parameter(Mandatory = $true)]
        [String[]]
        $UserPrincipalNameSuffix,

        [parameter(Mandatory = $true)]
        [String[]]
        $ServicePrincipalNameSuffix
    )

Import-DscResource -ModuleName xActiveDirectory

    node $TargetName
    {
        xADForestProperties $ForestName
        {
            ForestName = $ForestName
            UserPrincipalNameSuffix = $UserPrincipalNameSuffix
            ServicePrincipalNameSuffix = $ServicePrincipalNameSuffix
        }
    }
}

$parameters = @{
    TargetName = 'dc.contoso.com'
    ForestName = 'contoso.com'
    UserPrincipalNameSuffix = 'fabrikam.com','industry.com'
    ServicePrincipalNameSuffix = 'corporate.com'
    OutputPath = c:\output
}

Example_ADPrincipalSuffix @parameters

Start-DscConfiguration -Path c:\output -Wait -Verbose
```
