# Supprimer tous les objets supprimés
Get-MgDirectoryDeletedItem | ForEach-Object {
    Remove-MgDirectoryDeletedItem -DirectoryObjectId $_.Id
}