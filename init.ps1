docker build -t base64app:latest .
docker run --rm -p 8080:7071 -d base64app:latest