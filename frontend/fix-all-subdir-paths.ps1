# PowerShell script to fix all import paths in SyllabusView subdirectories
$baseDir = "src/components/screens/CoursePage/SyllabusView"

# Get all TypeScript files in subdirectories (not root)
$subdirFiles = Get-ChildItem -Path $baseDir -Recurse -Include "*.tsx", "*.ts" | Where-Object { 
    $_.Directory.FullName -ne (Get-Item $baseDir).FullName 
}

foreach ($file in $subdirFiles) {
    $relativePath = $file.FullName.Replace((Get-Location).Path, "").Replace("\", "/")
    Write-Host "Processing: $relativePath"
    
    $content = Get-Content -Path $file.FullName -Raw
    $originalContent = $content
    
    # Fix import paths from 4 levels to 5 levels for subdirectory files
    $content = $content -replace '"\.\./\.\./\.\./\.\./components/', '"../../../../../components/'
    $content = $content -replace '"\.\./\.\./\.\./\.\./utils/', '"../../../../../utils/'
    $content = $content -replace '"\.\./\.\./\.\./\.\./SyllabusLayout/', '"../../../../../SyllabusLayout/'
    $content = $content -replace '"\.\./\.\./\.\./\.\./assets/', '"../../../../../assets/'
    
    if ($content -ne $originalContent) {
        Set-Content -Path $file.FullName -Value $content -NoNewline
        Write-Host "  ✓ Updated: $($file.Name)"
    } else {
        Write-Host "  - No changes needed: $($file.Name)"
    }
}

Write-Host "All subdirectory import path fixing complete!"