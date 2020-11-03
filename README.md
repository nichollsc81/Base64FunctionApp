## To build

```sh
& docker build -t base64app:latest .
```
<br>

## To run

```sh
& docker run --rm -p 8080:7071 -d base64app:latest
```
<br>

## Test

```
http://localhost:7071/api/EncodeBase64?Text=ThisIsATestString
```