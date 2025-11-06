# Fix all import paths in subdirectories
$files = Get-ChildItem -Path "src/components/screens/CoursePage/SyllabusView" -Recurse -Include "*.tsx"

foreach ($file in $files) {
    $dir = $file.Directory.Name
    if ($dir -ne "SyllabusView") {
        Write-Host "Processing $($file.Name) in $dir"
        
        $content = Get-Content -Path $file.FullName -Raw
        $original = $content
        
        # Fix 4-level to 5-level paths for subdirectories
        $content = $content -replace '"\.\./\.\./\.\./\.\./components/', '"../../../../../components/'
        $content = $content -replace '"\.\./\.\./\.\./\.\./utils/', '"../../../../../utils/'
        $content = $content -replace '"\.\./\.\./\.\./\.\./SyllabusLayout/', '"../../../../../SyllabusLayout/'
        $content = $content -replace '"\.\./\.\./\.\./\.\./assets/', '"../../../../../assets/'
        
        if ($content -ne $original) {
            Set-Content -Path $file.FullName -Value $content -NoNewline
            Write-Host "Updated $($file.Name)"
        }
    }
}
Write-Host "Done!"