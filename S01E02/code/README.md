# README

Créer moi une Cloud Run Function pour GCP utilisant .NET 10 et renvoyant "Hello World !" en réponse à un HTTP Trigger

## Cloud Run Function - HelloWorldFunction

> Note : le SDK .NET 10 n'étant pas disponible sur cette machine, le projet cible **.NET 8** (le SDK .NET 10 n'ayant pas pu être installé automatiquement). Pour migrer vers .NET 10 une fois le SDK installé, changez simplement `<TargetFramework>net8.0</TargetFramework>` en `<TargetFramework>net10.0</TargetFramework>` dans [HelloWorldFunction.csproj](./HelloWorldFunction/HelloWorldFunction.csproj).

Le code se trouve dans [HelloWorldFunction/](./HelloWorldFunction) et utilise le [Functions Framework pour .NET](https://github.com/GoogleCloudPlatform/functions-framework-dotnet) (`Google.Cloud.Functions.Hosting`) avec un déclencheur HTTP qui répond `Hello World !`.

### Tester en local

```powershell
cd HelloWorldFunction
dotnet run -- --target=HelloWorldFunction.Function --port=8080
```

Puis dans un autre terminal :

```powershell
curl http://localhost:8080
```

### Déployer sur Cloud Run (Cloud Run Functions)

Prérequis : avoir le [gcloud CLI](https://cloud.google.com/sdk/docs/install) installé et authentifié (`gcloud auth login`), ainsi qu'un projet GCP avec la facturation et les API Cloud Functions/Cloud Run activées.

```powershell
cd HelloWorldFunction
gcloud functions deploy hello-world-function `
  --gen2 `
  --runtime=dotnet8 `
  --region=europe-west1 `
  --source=. `
  --entry-point=HelloWorldFunction.Function `
  --trigger-http `
  --allow-unauthenticated
```

> Remplacez `--runtime=dotnet8` par `dotnet10` dès que ce runtime managé est disponible et que le projet aura été migré vers `net10.0`.

Une fois déployée, l'URL retournée par `gcloud` répondra `Hello World !` à toute requête HTTP (GET/POST).
