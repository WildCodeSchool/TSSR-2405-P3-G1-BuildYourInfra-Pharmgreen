# Chemin du répertoire de base
$basePath = "C:\Chemin\Vers\Le\Dossier\De\Base"

# Tableau contenant les noms des dossiers et sous-dossiers à créer
$dossiers = @(
    "Départements",
    "Départements\Communication",
    "Départements\Direction_Financière",
    "Départements\Ressources_Humaines",
    "Départements\Direction_Générale",
    "Départements\Direction_marketing"
    "Départements\Direction_Informatique"
    "Départements\Externe"
    "Départements\Services_Généraux"
    "Départements\Juridique"
    "Départements\R&D"
    "Départements\Commercial"
    "Services"
    "Services\Publicité"
    "Services\Relations-publiques"
    "Services\Controle_Gestion"
    "Services\Finance"
    "Services\Comptabilite"
    "Services\Digital"
    "Services\Operationel"
    "Services\Produit"
    "Services\Strategique"
    "Services\Innovation"
    "Services\Lab"
    "Services\Formation"
    "Services\Performance"
    "Services\Recrutement"
    "Services\Securite"
    "Services\Contentieux"
    "Services\Contrats"
    "Services\Immobilier"
    "Services\Log"
    "Services\Data"
    "Services\Dev"
    "Services\ADV"
    "Services\B2B"
    "Services\B2C"
    "Services\International"
    "Services\Grands-Comptes"
    "Services\Achat"
    "Services\Service_Client"
)

# Boucle pour créer chaque dossier et sous-dossier
foreach ($dossier in $dossiers) {
    $fullPath = Join-Path -Path $basePath -ChildPath $dossier
    if (-Not (Test-Path -Path $fullPath)) {
        New-Item -ItemType Directory -Path $fullPath
        Write-Host "Créé: $fullPath"
    } else {
        Write-Host "Existe déjà: $fullPath"
    }
}
