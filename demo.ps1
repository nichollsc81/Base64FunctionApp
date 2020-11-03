# build images
docker build -t base64functionapp:latest .

# run function app container
docker run --rm -p 7071:7071 -d base64functionapp:latest

# set a string to manipulate
$Param = 'ThisIsATestString'
$PublishPort = '7071'

# use function app to encode $Param
$a = iwr "http://localhost:$($PublishPort)/api/EncodeBase64?Text=$($Param)"

# if successful
if(($a.StatusCode) -eq 200) {

    # show encoded value
    $Encoded = $A.Content

    # pass encoded value to decode in function chain
    $Decoded = (iwr "http://localhost:$($PublishPort)/api/DecodeBase64?Text=$($a.content)").Content

    # capture what we've done. PlainText and Decoded shoudl match!
    $TestResult = [PSCustomObject]@{
        PlainTextString = $Param
        EncodedString = $Encoded
        DecodedString = $Decoded
    }
    $TestResult
}