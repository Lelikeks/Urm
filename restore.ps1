param([string]$instance, [string]$dbname, [string]$user, [string]$password)

$currentPath = Split-Path $MyInvocation.MyCommand.Path
$sqlFile = (Join-Path $currentPath "script.sql")

sqlcmd -S $instance -U $user -P $password -Q @"
if exists(select * from sys.databases where name='$dbname')
begin
	alter database $dbname set single_user with rollback immediate
	drop database $dbname
end
create database $dbname
"@

sqlcmd -S $instance -d $dbname -U $user -P $password -i $sqlFile

$currentPath = Split-Path $MyInvocation.MyCommand.Path

function RestoreData($table)
{
    $dataFile = (Join-Path $currentPath "data\$table.dat")
    & bcp $table in $dataFile -S $instance -d $dbname -U $user -P $password -n
}

RestoreData "aspnet_Applications"
RestoreData "aspnet_Membership"
RestoreData "aspnet_Paths"
RestoreData "aspnet_PersonalizationAllUsers"
RestoreData "aspnet_PersonalizationPerUser"
RestoreData "aspnet_Profile"
RestoreData "aspnet_Roles"
RestoreData "aspnet_SchemaVersions"
RestoreData "aspnet_Users"
RestoreData "aspnet_UsersInRoles"
RestoreData "aspnet_WebEvent_Events"
RestoreData "ServiceAreas"
RestoreData "ReferenceBooks"
RestoreData "ReferenceTableValues"
RestoreData "ReferenceTableValuesOtherTheme"
RestoreData "ETMFC"
RestoreData "ETMFC_shedule"
RestoreData "ETMFC_working_time"
RestoreData "Departments"
RestoreData "DepartmentMfcRelations"
RestoreData "DepartmentSecurityDepartments"
RestoreData "LifeSituations"
RestoreData "ServiceLifeSituation"
RestoreData "Services"
RestoreData "Services_CommonService"
RestoreData "Services_InformationService"
RestoreData "KLADR"
RestoreData "KLADR_ALTNAMES"
RestoreData "KLADR_DOMA"
RestoreData "KLADR_FLAT"
RestoreData "KLADR_IMAGES"
RestoreData "KLADR_SOCRBASE"
RestoreData "KLADR_STREET"
RestoreData "EmployeeIdentity"
RestoreData "Employees"
RestoreData "EmployeeTaskQueues"
RestoreData "Answers"
RestoreData "AnswerVariants"
RestoreData "ArchiveFolders"
RestoreData "ArchiveTypes"
RestoreData "DynamicGroupDynamicRefs"
RestoreData "DynamicProperties"
RestoreData "DynamicRefs"
RestoreData "DynamicRefs_DynamicAttribute"
RestoreData "DynamicRefs_DynamicDocGroup"
RestoreData "DynamicRefs_DynamicGroup"
RestoreData "DynamicRefs_DynamicType"
RestoreData "DynamicRefs_NativeType"
RestoreData "ExternalReferenceBookValues"
RestoreData "Forms"
RestoreData "NativeProperties"
RestoreData "QuestionOrders"
RestoreData "Questions"
RestoreData "Reports"
RestoreData "RoleDepartments"
RestoreData "RoleRights"
RestoreData "Roles"
RestoreData "Scenarios"
RestoreData "ServiceAnswerVariants"
RestoreData "ServiceDenialItems"
RestoreData "ServiceDenials"
RestoreData "ServiceDocumentTypes"
RestoreData "ServiceQuestionaries"
RestoreData "ServiceQuestionaryTreeItems"
RestoreData "ServiceSecurityDepartments"
RestoreData "ServiceVariantPaths"
RestoreData "ServiceVariants"
RestoreData "ServiceVariantStepDependences"
RestoreData "ServiceVariantSteps"
RestoreData "ServiceVariantSteps_Consult"
RestoreData "ServiceVariantSteps_Delivery"
RestoreData "ServiceVariantSteps_Order"
RestoreData "ServiceVariantSteps_Reception"
RestoreData "ServiceVariantSteps_SmevOrder"
RestoreData "SgdServiceSecurityDepartments"
RestoreData "SmevServiceBindings"
RestoreData "SmevServiceBindingValues"
RestoreData "SmevServices"
RestoreData "SystemSettings"
RestoreData "TaskQueueDepartments"
RestoreData "TaskQueues"
RestoreData "TaskTypeAssignments"
RestoreData "UserRights"
RestoreData "UserRoles"