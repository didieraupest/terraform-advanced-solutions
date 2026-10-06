# HelloWorldFunction on Cloud Run

Ce dossier reprend le même code .NET que la variante Cloud Functions. Le
`Dockerfile` le publie dans une image .NET 8 qui lance le Functions Framework
comme application HTTP dans un conteneur Cloud Run.

Pour tester localement avec le SDK .NET 8 :

```powershell
cd HelloWorldFunction
dotnet run -- --target=HelloWorldFunction.Function --port=8080
```

La configuration et le déploiement du conteneur sont gérés par Terraform dans
le dossier parent.
