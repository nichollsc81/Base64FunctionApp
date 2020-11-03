using namespace System
using namespace System.Convert
using namespace System.Net
using namespace System.Text.Encoding

# Input bindings are passed in via param block.
param($Request, $TriggerMetadata)

# Write to the Azure Functions log stream.
Write-Host "EncodeBase64 function processed a request."

# Interact with query parameters or the body of the request.
$name = $Request.Query.Text
if (-not $name) {
    $name = $Request.Body.Name
    $body = "Trigger executed successfully. No function parameter passed."
    $StatusCode = [System.Net.HttpStatusCode]::OK
}

<#
Example exuection:
http://localhost:7071/api/EncodeBase64?Text=christian
#>

if ($name) {
    try {
        $Bytes = [System.Text.Encoding]::Unicode.GetBytes($name)
        $OutputTable = [PSCustomObject]@{
            PlaintextString = $name
            EncodedOutput = $([System.Convert]::ToBase64String($Bytes))
        }
        #$Body = $OutputTable
        
        $Body = "Encoded parameter $($name) to Base64:: $([System.Convert]::ToBase64String($Bytes))"
        $StatusCode = [System.Net.HttpStatusCode]::OK
    }
    catch {
        Write-Error "Failed to encode."
        $Body = "Failed to encode $($name)"
        $StatusCode = [HttpStatusCode]::BadRequest
    }
}

# Associate values to output bindings by calling 'Push-OutputBinding'.
Push-OutputBinding -Name Response -Value ([HttpResponseContext]@{
        StatusCode = $StatusCode
        Body       = $body
    })