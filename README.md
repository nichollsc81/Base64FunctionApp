## To build

```sh
docker build -t base64functionapp:latest .
```
<br>

## To run

Run function app bound to localhost port 8080
```sh
docker run --rm -p 8080:7071 -d base64functionapp:v7
```
<br>

## Test

Encode a string:
```
$a = iwr http://localhost:8088/api/EncodeBase64?Text=ThisIsATestString
$a.Content | ConvertFrom-Json
```

Decode a string:
```
$b = iwr http://localhost:8080/api/DecodeBase64?Text=VABoAGkAcwBJAHMAQQBUAGUAcwB0AFMAdAByAGkAbgBnAA==
$b.Content | ConvertFrom-Json
```

Create a random password:
```
$c = iwr http://localhost:8080/api/GenerateStrongPassword
$c.Content | ConvertFrom-Json
```

Create 2 password of length 8
```
$d = iwr http://localhost:8080/api/GenerateStrongPassword?Count=2&Length=8
$d.Content | ConvertFrom-Json

```

## Demo

A demo file for building an image, spawning a container and chaining 2 functions is available [here](demo.ps1).