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
