# Get Az Modules

## Description

A Powershell script that identifies which Az modules is needed to run a script that contains Az cmdlets. Can also be used to identify required Az modules for your custom module.

Avoid installing all [Az.* modules](https://github.com/Azure/azure-powershell/) in GitHub runners and other transient/minimal environments to save time and resources and handle your dependencies more explicitly.

Why?

1. Only use the depencies you need (only use required modules)
2. Deal with dependencies explicitly (use required versions)

PS: If you're new to the Az module please refer to the [official installation docs](https://docs.microsoft.com/en-us/powershell/azure/install-az-ps).

## Usage


```powershell
./Get-AzModules.ps1 -Path <path to .ps1 or .psm1 file>
```

### Examples

Tips: Try to run the script against any of the files in [samples](./samples).

#### Basic usage

```powershell
./Get-AzModules.ps1 -Path ./samples/sample.ps1

Looking for Az modules needed for sample.ps1...
Number of unique Az cmdlets found: 17
Number of Az modules used: 3
Az.Compute
Az.Network
Az.Resources
```

#### Check versions of installed modules
```powershell
./Get-AzModules.ps1 -Path ./samples/sample.ps1 -CheckVersions

Looking for Az modules needed for sample.ps1...
Number of unique Az cmdlets found: 17
Number of Az modules used: 3
WARNING: Az.Resources: latest version [4.3.1] newer than installed version [4.2.0]
WARNING: Az.Compute: latest version [4.17.0] newer than installed version [4.15.0]
WARNING: Az.Network: latest version [4.11.0] newer than installed version [4.10.0]

Name         InstalledVersion LatestVersion
----         ---------------- -------------
Az.Resources 4.2.0            4.3.1
Az.Compute   4.15.0           4.17.0
Az.Network   4.10.0           4.11.0
```

#### Get info about modules not installed

```powershell
/Get-AzModules.ps1 -Path ./samples/nondefault.ps1     

Looking for Az modules needed for nondefault.ps1...
Number of unique Az cmdlets found: 3
WARNING: Get-AzSubscriptionAlias was not found. Available in module Az.Subscription [0.8.0] from PSGallery
WARNING: Get-AzStackEdgeDevice was not found. Available in module Az.StackEdge [0.1.0] from PSGallery
Number of Az modules used: 3
Az.Resources
Az.StackEdge
Az.Subscription
```

#### Print all cmdlets

```powershell
./Get-AzModules.ps1 -Path ./samples/sample.ps1 -Verbose

Looking for Az modules needed for sample.ps1...
Number of unique Az cmdlets found: 17
VERBOSE: New-AzResourceGroup uses Az.Resources
VERBOSE: New-AzAvailabilitySet uses Az.Compute
VERBOSE: New-AzVirtualNetworkSubnetConfig uses Az.Network
VERBOSE: New-AzVirtualNetwork uses Az.Network
VERBOSE: New-AzPublicIpAddress uses Az.Network
VERBOSE: New-AzLoadBalancerFrontendIpConfig uses Az.Network
VERBOSE: New-AzLoadBalancerBackendAddressPoolConfig uses Az.Network
VERBOSE: New-AzLoadBalancerProbeConfig uses Az.Network
VERBOSE: New-AzLoadBalancerRuleConfig uses Az.Network
VERBOSE: New-AzLoadBalancer uses Az.Network
VERBOSE: New-AzNetworkInterfaceIpConfig uses Az.Network
VERBOSE: New-AzNetworkInterface uses Az.Network
VERBOSE: New-AzVMConfig uses Az.Compute
VERBOSE: Set-AzVMOperatingSystem uses Az.Compute
VERBOSE: Set-AzVMSourceImage uses Az.Compute
VERBOSE: Add-AzVMNetworkInterface uses Az.Compute
VERBOSE: New-AzVM uses Az.Compute
Number of Az modules used: 3
Az.Compute
Az.Network
Az.Resources
```

#### Use in script or pipeline

```powershell
$modules = ./Get-AzModules.ps1 -Path ./samples/sample.ps1 -CheckVersions

foreach ($module in $modules){
    Install-Module $module.Name -RequiredVersion $module.LatestVersion -Force
}
```

## License

The MIT License applies to the code contained in this repo. For more information, see [LICENSE](./LICENSE).
