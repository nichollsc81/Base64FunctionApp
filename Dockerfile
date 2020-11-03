ARG VARIANT=6
FROM mcr.microsoft.com/azure-functions/powershell:3.0-powershell${VARIANT}-core-tools

# set runtime folder
ENV FuncAppRoot=/home/base64functionapp

# copy project contents into env root
COPY . ${FuncAppRoot}

# set location
WORKDIR ${FuncAppRoot}

# start function
CMD ["pwsh","-command","func start --verbose"]