param([string]$instance, [string]$dbname, [string]$user, [string]$password)

[System.Reflection.Assembly]::LoadWithPartialName("Microsoft.SqlServer.ConnectionInfo") | out-null
[System.Reflection.Assembly]::LoadWithPartialName("Microsoft.SqlServer.Smo") | out-null

$connection = New-Object ('Microsoft.SqlServer.Management.Common.ServerConnection') $instance, $user, $password
$server = New-Object ('Microsoft.SqlServer.Management.Smo.Server') $connection
$database = $server.Databases[$dbname]

$scripter = New-Object ('Microsoft.SqlServer.Management.Smo.Scripter') $server
$scripter.Options.Indexes = $true
$scripter.Options.DriAllConstraints = $true

$currentPath = Split-Path $MyInvocation.MyCommand.Path
$scriptPath = Join-Path $currentPath "script.sql"

if (Test-Path $scriptPath) { Remove-Item $scriptPath }

$allUrns = @()
$allUrns += $database.Sequences | % { $_.Urn }
$allUrns += $database.Tables | ? { -not $_.IsSystemObject } | % { $_.Urn }
$allUrns += $database.Views | ? { -not $_.IsSystemObject } | % { $_.Urn }
$allUrns += $database.UserDefinedTableTypes | % { $_.Urn }
$allUrns += $database.StoredProcedures | ? { -not $_.IsSystemObject } | % { $_.Urn }
$allUrns += $database.UserDefinedFunctions | ? { -not $_.IsSystemObject } | % { $_.Urn }
$allUrns += $database.Users | ? { -not $_.IsSystemObject } | % { $_.Urn }
$allUrns += $database.Roles | ? { -not $_.IsFixedRole } | % { $_.Urn }
$allUrns += $database.Schemas | ? { -not $_.IsSystemObject } | % { $_.Urn }

$scripter.Script($allUrns) | % { $_ + "`r`nGO" } >> $scriptPath

function DumpData($table)
{
    $dataFile = (Join-Path $currentPath "data\$table.dat")
    & bcp $table out $dataFile -S $instance -d $dbname -U $user -P $password -n
}

DumpData "aspnet_Applications"
DumpData "aspnet_Membership"
DumpData "aspnet_Paths"
DumpData "aspnet_PersonalizationAllUsers"
DumpData "aspnet_PersonalizationPerUser"
DumpData "aspnet_Profile"
DumpData "aspnet_Roles"
DumpData "aspnet_SchemaVersions"
DumpData "aspnet_Users"
DumpData "aspnet_UsersInRoles"
DumpData "aspnet_WebEvent_Events"
DumpData "ServiceAreas"
DumpData "ReferenceBooks"
DumpData "ReferenceTableValues"
DumpData "ReferenceTableValuesOtherTheme"
DumpData "ETMFC"
DumpData "ETMFC_shedule"
DumpData "ETMFC_working_time"
DumpData "Departments"
DumpData "DepartmentMfcRelations"
DumpData "DepartmentSecurityDepartments"
DumpData "LifeSituations"
DumpData "ServiceLifeSituation"
DumpData "Services"
DumpData "Services_CommonService"
DumpData "Services_InformationService"
DumpData "KLADR"
DumpData "KLADR_ALTNAMES"
DumpData "KLADR_DOMA"
DumpData "KLADR_FLAT"
DumpData "KLADR_IMAGES"
DumpData "KLADR_SOCRBASE"
DumpData "KLADR_STREET"
DumpData "EmployeeIdentity"
DumpData "Employees"
DumpData "EmployeeTaskQueues"
DumpData "Answers"
DumpData "AnswerVariants"
DumpData "ArchiveFolders"
DumpData "ArchiveTypes"
DumpData "DynamicGroupDynamicRefs"
DumpData "DynamicProperties"
DumpData "DynamicRefs"
DumpData "DynamicRefs_DynamicAttribute"
DumpData "DynamicRefs_DynamicDocGroup"
DumpData "DynamicRefs_DynamicGroup"
DumpData "DynamicRefs_DynamicType"
DumpData "DynamicRefs_NativeType"
DumpData "ExternalReferenceBookValues"
DumpData "Forms"
DumpData "NativeProperties"
DumpData "QuestionOrders"
DumpData "Questions"
DumpData "Reports"
DumpData "RoleDepartments"
DumpData "RoleRights"
DumpData "Roles"
DumpData "Scenarios"
DumpData "ServiceAnswerVariants"
DumpData "ServiceDenialItems"
DumpData "ServiceDenials"
DumpData "ServiceDocumentTypes"
DumpData "ServiceQuestionaries"
DumpData "ServiceQuestionaryTreeItems"
DumpData "ServiceSecurityDepartments"
DumpData "ServiceVariantPaths"
DumpData "ServiceVariants"
DumpData "ServiceVariantStepDependences"
DumpData "ServiceVariantSteps"
DumpData "ServiceVariantSteps_Consult"
DumpData "ServiceVariantSteps_Delivery"
DumpData "ServiceVariantSteps_Order"
DumpData "ServiceVariantSteps_Reception"
DumpData "ServiceVariantSteps_SmevOrder"
DumpData "SgdServiceSecurityDepartments"
DumpData "SmevServiceBindings"
DumpData "SmevServiceBindingValues"
DumpData "SmevServices"
DumpData "SystemSettings"
DumpData "TaskQueueDepartments"
DumpData "TaskQueues"
DumpData "TaskTypeAssignments"
DumpData "UserRights"
DumpData "UserRoles"