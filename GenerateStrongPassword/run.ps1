using namespace System.Net

# Input bindings are passed in via param block.
param($Request, $TriggerMetadata)

# Write to the Azure Functions log stream.
Write-Host "GenerateStrongPassword function processed a request."

# import dependancy
Import-Module RandomPasswordGenerator -Verbose

$Count = $Request.Query.Count

# password length
$Len = $Request.Query.Length
# length if not supplied is 1 so need to handle that
if ($Len -le 1) {
    # if no length parameter supplied default to 18
    Write-Host "Setting min length."
    $Len = '18'
}
elseif ($Len -gt 24) {
    # handle silly password lengths
    Write-Host "Stipulated length too long."
    $Body = "Stipuldated length $($Len) too long. Ensure 24 characters or less or less."

    Push-OutputBinding -Name Response -Value ([HttpResponseContext]@{
        StatusCode = [System.Net.HttpStatusCode]::BadRequest
        Body = $Body
    })
    # exit cleanly
    Exit(0)
}
else {
    Write-Host "Detected a length"
}

# if no count supplied iterate once
if (-not $Count) {
    # generate a random password
    $Pw = Get-RandomPassword -PasswordLength $Len

    # write result to web page and return 200
    $Body = "$(($Pw).PasswordValue)"
    $StatusCode = [System.Net.HttpStatusCode]::OK
}
else {
    try {
        # generate a number of password from count parameter
        $Pws = Get-RandomPassword -PasswordLength $Len -NoOfPasswords $Count

        # write them into the web page body and return 200
        $Body = $Pws | % { "$($_.PasswordValue)" }
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