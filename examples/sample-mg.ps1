Connect-MgGraph -Scopes "User.Read.All", "Group.ReadWrite.All"
Get-MgUser
$user = Get-MgUser -Filter "displayName eq 'Megan Bowen'"
Get-MgUserJoinedTeam -UserId $user.Id