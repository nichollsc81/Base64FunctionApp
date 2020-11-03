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
        $DecodedBytes = [System.Convert]::FromBase64String($EncodedText)
        $OutputTable = [PSCustomObject]@{
            EncodedString = $Name
            DecodedOutput = $([System.Text.Encoding]::Unicode.GetString($DecodedBytes))
        }
        #$Body = $OutputTable

        $Body = "Decoded string $($Name) from Base64:: $([System.Text.Encoding]::Unicode.GetString($DecodedBytes))"
        $StatusCode = [System.Net.HttpStatusCode]::OK

        if($LASTEXITCODE -ne 0) {
            $Body = "Execution failed."
            $StatusCode = [HttpStatusCode]::BadRequest
        }
}

# Associate values to output bindings by calling 'Push-OutputBinding'.
Push-OutputBinding -Name Response -Value ([HttpResponseContext]@{
        StatusCode = $StatusCode
        Body       = $body
    })
