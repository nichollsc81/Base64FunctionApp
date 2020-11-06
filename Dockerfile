ARG VARIANT=3.0-powershell7-core-tools
FROM mcr.microsoft.com/azure-functions/powershell:${VARIANT}

# set runtime folder
ENV FuncAppRoot /home/base64functionapp
ENV AzureFunctionsJobHost__Logging__Console__IsEnabled=true

# copy project contents into env rootsett
COPY . ${FuncAppRoot}

# set location
WORKDIR ${FuncAppRoot}

# start function
#ENTRYPOINT ["pwsh", "-Command", "$ErrorActionPreference = 'Stop'; $ProgressPreference = 'SilentlyContinue';"]
#CMD ["pwsh","-command","func start --powershell -p $env:RUN_TIME_PORT"]
CMD ["pwsh","-command","func start --powershell"]