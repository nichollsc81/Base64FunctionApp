using namespace System.Net

# Input bindings are passed in via param block.
param($Request, $TriggerMetadata)

<#
Example exuection:
http://localhost:7071/api/GenerateStrongPassword
#>

# Write to the Azure Functions log stream.
Write-Host "GenerateStrongPassword function processed a request."

# import dependancy
Import-Module RandomPasswordGenerator -Verbose

$Count = $Request.Query.Count
if (-not $Count) {
    $Pw = Get-RandomPassword -PasswordLength 18

    # write result to web page
    $Body = "Secure password: $(($Pw).PasswordValue)"
    $StatusCode = [System.Net.HttpStatusCode]::OK
}
else {
    try {
        $Pws = Get-RandomPassword -PasswordLength 18 -Count $Count
        $Body = "Secure password: $(($Pws).PasswordValue)"
        $StatusCode = [System.Net.HttpStatusCode]::OK
    }
    catch {
        Write-Error "$_"
        $StatusCode = [System.Net.HttpStatusCode]::BadRequest
    }
}


# Associate values to output bindings by calling 'Push-OutputBinding'.
Push-OutputBinding -Name Response -Value ([HttpResponseContext]@{
    StatusCode = $StatusCode
    Body = $Body
})