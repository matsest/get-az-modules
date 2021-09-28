# Az.Resources
function Get-CustomAzRgLocations {
    $rgs = Get-AzResourceGroup
    return $rgs | Select-Object -Unique Location
}

# Az.Accounts
function Get-CustomAzTenantDomains {
    $tenants = Get-AzTenant
    return $tenants | Select-Object -ExpandProperty Domains
}