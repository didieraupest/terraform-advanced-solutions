# Alternative S01E02 - Cloud Run

Cette variante reprend le code .NET de `S01E02/code` et le déploie sous la forme
d'un **service Cloud Run conteneurisé**, sans ressource Cloud Functions Gen 2.
Cloud Build construit l'image Docker, la publie dans Artifact Registry, puis
Terraform déploie le service Cloud Run et autorise les appels HTTP publics.

## Prérequis

- Terraform 1.5 ou ultérieur.
- Un projet Google Cloud avec la facturation activée.
- Google Cloud CLI installé et authentifié (`gcloud auth login` et
  `gcloud auth application-default login`).
- Les droits nécessaires pour activer les API, créer des comptes de service,
  configurer IAM, lancer un build Cloud Build avec le compte de service prévu,
  écrire dans le bucket temporaire de build et déployer sur Cloud Run.

## Déploiement

Depuis ce dossier :

```powershell
terraform init
terraform plan -var-file="environment.tfvars"
terraform apply -var-file="environment.tfvars"
```

L'URL du service est affichée par la sortie Terraform `service_url`. Le service
est public, comme la fonction HTTP de la variante d'origine.

Lors de `terraform apply`, un provisioner local appelle
`gcloud builds submit` pour construire `code/Dockerfile` avec Cloud Build. L'image
versionnée par empreinte source est publiée dans le dépôt Artifact Registry
créé par Terraform. Cette étape requiert `gcloud` sur la machine qui exécute
Terraform et les autorisations de lancer des builds et d'utiliser le compte de
service de build. Terraform crée les ressources, puis déploie le service
Cloud Run avec l'image construite. Le bucket dédié au build est supprimé avec
son contenu lors de `terraform destroy`.

## Nettoyage

```powershell
terraform destroy -var-file="environment.tfvars"
```

## Différence avec la variante originale

- **S01E02** : Cloud Functions Gen 2 gère le build et l'hébergement de la
  fonction.
- **S01E02-CloudRun** : Cloud Build construit une image de conteneur et
  Terraform déploie directement un service Cloud Run. Cette approche facilite
  l'évolution vers une application conteneurisée, au prix de la gestion explicite
  du build et du dépôt d'images.
