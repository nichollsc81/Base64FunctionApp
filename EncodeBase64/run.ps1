using namespace System
using namespace System.Convert
using namespace System.Net
using namespace System.Text.Encoding

# Input bindings are passed in via param block.
param($Request, $TriggerMetadata)

# Write to the Azure Functions log stream.
Write-Host "EncodeBase64 function processed a request."

# Interact with query parameters or the body of the request.
$Name = $Request.Query.Text
if (-not $Name) {
    # if no parameter indicate this in response
    $Name = $Request.Body.Name
    $body = "Trigger executed successfully. No function parameter passed."
    $StatusCode = [System.Net.HttpStatusCode]::OK
}

if ($Name) {
    try {
        # pass parameter and encode
        $Bytes = [System.Text.Encoding]::Unicode.GetBytes($Name)
        # populate hashtable
        $OutputTable = [PSCustomObject]@{
            PlaintextString = $Name
            EncodedOutput = $([System.Convert]::ToBase64String($Bytes))
        }

        # write out encoded value to body
        $Body = $([System.Convert]::ToBase64String($Bytes))
        # return 200
        $StatusCode = [System.Net.HttpStatusCode]::OK

        Write-Host "String encoded."
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