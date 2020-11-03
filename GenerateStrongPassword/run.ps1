using namespace System.Net

# Input bindings are passed in via param block.
param($Request, $TriggerMetadata)

<#
Example exuection:
http://localhost:7071/api/GenerateStrongPassword
http://localhost:7071/api/GenerateStrongPassword?Count=1
#>

# Write to the Azure Functions log stream.
Write-Host "GenerateStrongPassword function processed a request."

# import dependancy
Import-Module RandomPasswordGenerator -Verbose

$Count = $Request.Query.Count

# password length
$Len = 18

# if no count supplied iterate once
if (-not $Count) {
    # generate a random password
    $Pw = Get-RandomPassword -PasswordLength $Len

    # write result to web page and return 200
    $Body = "Secure password $($Ps.PasswordId): $(($Pw).PasswordValue)"
    $StatusCode = [System.Net.HttpStatusCode]::OK
}
else {
    try {
        # generate a number of password from count parameter
        $Pws = Get-RandomPassword -PasswordLength $Len -NoOfPasswords $Count

        # write them into the web page body and return 200
        $Body = $Pws | % { "$($_.PasswordId): $($_.PasswordValue)" }
        $StatusCode = [System.Net.HttpStatusCode]::OK
    }
    catch {
        # this goes into app logging
        Write-Error "$_"
        # so we need to return a non-200 status code back
        $StatusCode = [System.Net.HttpStatusCode]::BadRequest
    }
}

# Associate values to output bindings by calling 'Push-OutputBinding'.
Push-OutputBinding -Name Response -Value ([HttpResponseContext]@{
    StatusCode = $StatusCode
    Body = $Body
})