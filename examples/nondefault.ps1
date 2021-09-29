$aliasName = 'myalias'
$rgName = 'myRg'

# Az.Resources
Get-AzResourceGroup $rgName

# Az.Subscription
Get-AzSubscriptionAlias $aliasName

# Az.StackEdge
Get-AzStackEdgeDevice