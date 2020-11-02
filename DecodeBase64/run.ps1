using namespace System
using namespace System.Convert
using namespace System.Net
using namespace System.Text.Encoding

# Input bindings are passed in via param block.
param($Request, $TriggerMetadata)

# Write to the Azure Functions log stream.
Write-Host "PowerShell HTTP trigger function processed a request."

$name = $Request.Query.Text
if (-not $name) {
    $name = $Request.Body.Name
    $body = "This HTTP triggered function executed successfully. No function parameter passed."
    $StatusCode = [HttpStatusCode]::OK
}

if ($name) {
    try {
        $EncodedText = $name
        $DecodedBytes = [System.Convert]::FromBase64String($EncodedText)
        $Body = [System.Text.Encoding]::Unicode.GetString($DecodedBytes)
        $StatusCode = [HttpStatusCode]::OK
    }
    catch {
        Write-Error "Failed to encode."
        $Body = "Failed to encode $($name)"
        $StatusCode = [HttpStatusCode]::BadRequest
    }
}

# Associate values to output bindings by calling 'Push-OutputBinding'.
Push-OutputBinding -Name Response -Value ([HttpResponseContext]@{
        StatusCode = [HttpStatusCode]::OK
        Body       = $body
    })
