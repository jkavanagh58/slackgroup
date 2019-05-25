#Requires -Modules PSSlack
[CmdletBinding()]
Param (
    [parameter(Mandatory=$False, ValueFromPipeline=$True,
        HelpMessage = "API Legacy Token")]
    [System.String]$token = 'xoxp-Get your own',
    [parameter(Mandatory=$False, ValueFromPipeline=$True,
        HelpMessage = "HelpMessage")]
    [System.String]$webhook = "get your own",
    [parameter(Mandatory=$False, ValueFromPipeline=$False,
        HelpMessage = "None")]
    [System.String]$nope
)
<#
Send-SlackMessage -Token $token 
                  -Channel '@john kavanagh' 
                  -Parse full `
                  -Text 'Hello Myself!'
#>

Send-SlackMessage -Token $token -Username "@John Kavanagh" -IconEmoji ":bomb:" -Channel "team-platform" -SlackMessage "Just a simple example"