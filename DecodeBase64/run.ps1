using namespace System
using namespace System.Convert
using namespace System.Net
using namespace System.Text.Encoding

# Input bindings are passed in via param block.
param($Request, $TriggerMetadata)

<#
Example exuection:
http://localhost:7071/api/DecodeBase64?Text=YwBoAHIAaQBzAHQAaQBhAG4A
#>

# Write to the Azure Functions log stream.
Write-Host "DecodeBase64 function processed a request."

$Name = $Request.Query.Text
if (-not $Name) {
    $Name = $Request.Body.Name
    $body = "Trigger executed successfully. No function parameter passed."
    $StatusCode = [System.Net.HttpStatusCode]::OK
}

if ($Name) {
    $EncodedText = $Name

    try {
        $DecodedBytes = [System.Convert]::FromBase64String($EncodedText)
        $Decoded = $([System.Text.Encoding]::Unicode.GetString($DecodedBytes))
        $Body = "Decoded parameter $($name) from Base64 = $($Decoded)"
        $StatusCode = [System.Net.HttpStatusCode]::OK
    }
    catch {
        $Error[0]
        Write-Error "Execution failed: $_"
        $Body = "$_"
        $StatusCode = [HttpStatusCode]::BadRequest
    }
}

# Associate values to output bindings by calling 'Push-OutputBinding'.
Push-OutputBinding -Name Response -Value ([HttpResponseContext]@{
        StatusCode = $StatusCode
        Body       = $body
    })
