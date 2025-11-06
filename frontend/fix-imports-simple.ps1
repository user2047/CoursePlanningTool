# PowerShell script to fix import paths in SyllabusView components
$baseDir = "src/components/screens/CoursePage/SyllabusView"

# Get all TypeScript files in SyllabusView directory
$files = Get-ChildItem -Path $baseDir -Recurse -Include "*.tsx", "*.ts" | Where-Object { $_.FullName -notmatch "node_modules" }

foreach ($file in $files) {
    Write-Host "Processing: $($file.Name)"
    
    # Read the file content
    $content = Get-Content -Path $file.FullName -Raw
    $originalContent = $content
    
    # Replace specific problematic import patterns
    $content = $content -replace '"\.\./\.\./\.\./\.\./\.\./\.\./\.\./components/', '"../../../../components/'
    $content = $content -replace '"\.\./\.\./\.\./\.\./\.\./\.\./\.\./utils/', '"../../../../utils/'
    $content = $content -replace '"\.\./\.\./\.\./\.\./\.\./\.\./\.\./SyllabusLayout/', '"../../../../SyllabusLayout/'
    $content = $content -replace '"\.\./\.\./\.\./\.\./\.\./\.\./\.\./assets/', '"../../../../assets/'
    
    # Replace 6-level paths
    $content = $content -replace '"\.\./\.\./\.\./\.\./\.\./\.\./components/', '"../../../../components/'
    $content = $content -replace '"\.\./\.\./\.\./\.\./\.\./\.\./utils/', '"../../../../utils/'
    $content = $content -replace '"\.\./\.\./\.\./\.\./\.\./\.\./SyllabusLayout/', '"../../../../SyllabusLayout/'
    $content = $content -replace '"\.\./\.\./\.\./\.\./\.\./\.\./assets/', '"../../../../assets/'
    
    # Write back if changed
    if ($content -ne $originalContent) {
        Set-Content -Path $file.FullName -Value $content -NoNewline
        Write-Host "Updated: $($file.Name)"
    }
}

Write-Host "Done fixing import paths!"