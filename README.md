## To build

```sh
docker build -t base64functionapp:latest .
```
<br>

## To run

```sh
docker run --rm -p 8080:7071 -d base64functionapp:latest
```
<br>

## Test

Encode a string:
```
$a = iwr http://localhost:8080/api/EncodeBase64?Text=ThisIsATestString
$a.Content
```

Decode a string:
```
$b = iwr http://localhost:8080/api/DecodeBase64?Text=VABoAGkAcwBJAHMAQQBUAGUAcwB0AFMAdAByAGkAbgBnAA==
$b.Content
```

Create a random password:
```
$c = iwr http://localhost:8080/api/GenerateStrongPassword
$c.Content
```