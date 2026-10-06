FROM mcr.microsoft.com/dotnet/sdk:8.0 AS build
WORKDIR /src
COPY HelloWorldFunction/HelloWorldFunction.csproj HelloWorldFunction/
RUN dotnet restore HelloWorldFunction/HelloWorldFunction.csproj
COPY HelloWorldFunction/ HelloWorldFunction/
WORKDIR /src/HelloWorldFunction
RUN dotnet publish HelloWorldFunction.csproj --configuration Release --output /app/publish /p:UseAppHost=false

FROM mcr.microsoft.com/dotnet/aspnet:8.0
WORKDIR /app
COPY --from=build /app/publish .
ENV ASPNETCORE_URLS=http://0.0.0.0:8080
EXPOSE 8080
ENTRYPOINT ["dotnet", "HelloWorldFunction.dll", "--target=HelloWorldFunction.Function", "--port=8080"]
