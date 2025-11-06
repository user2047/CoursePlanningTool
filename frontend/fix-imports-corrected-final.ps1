# PowerShell script to fix import paths in SyllabusView components
# This script fixes paths from SyllabusView components to point to the correct locations

$baseDir = "src/components/screens/CoursePage/SyllabusView"

# Get all TypeScript/JavaScript files in SyllabusView directory
$files = Get-ChildItem -Path $baseDir -Recurse -Include "*.tsx", "*.ts", "*.jsx", "*.js" | Where-Object { $_.FullName -notmatch "node_modules" }

foreach ($file in $files) {
    Write-Host "Processing: $($file.FullName)"
    
    # Read the file content
    $content = Get-Content -Path $file.FullName -Raw
    $originalContent = $content
    
    # Calculate relative depth from this file to src root
    $relativePath = $file.DirectoryName.Replace((Get-Location).Path, "").Replace("\", "/")
    $relativePath = $relativePath -replace "^/", ""
    
    # Count directory levels from src/components/screens/CoursePage/SyllabusView
    $srcIndex = $relativePath.IndexOf("src/")
    if ($srcIndex -ge 0) {
        $pathFromSrc = $relativePath.Substring($srcIndex + 4)  # Remove "src/"
        $levels = ($pathFromSrc -split "/").Length - 1
        $backPath = "../" * $levels
        
        Write-Host "  File depth from src: $levels levels, backPath: $backPath"
        
        # Fix common import patterns
        $content = $content -replace '"\.\./\.\.\/\.\./\.\./\.\.\/\.\./\.\./components/', """${backPath}components/"""
        $content = $content -replace '"\.\./\.\.\/\.\./\.\./\.\.\/\.\./\.\./utils/', """${backPath}utils/"""
        $content = $content -replace '"\.\./\.\.\/\.\./\.\./\.\.\/\.\./\.\./SyllabusLayout/', """${backPath}SyllabusLayout/"""
        $content = $content -replace '"\.\./\.\.\/\.\./\.\./\.\.\/\.\./\.\./assets/', """${backPath}assets/"""
        
        # Fix 6-level deep paths
        $content = $content -replace '"\.\./\.\.\/\.\./\.\./\.\.\/\.\./components/', """${backPath}components/"""
        $content = $content -replace '"\.\./\.\.\/\.\./\.\./\.\.\/\.\./utils/', """${backPath}utils/"""
        $content = $content -replace '"\.\./\.\.\/\.\./\.\./\.\.\/\.\./SyllabusLayout/', """${backPath}SyllabusLayout/"""
        $content = $content -replace '"\.\./\.\.\/\.\./\.\./\.\.\/\.\./assets/', """${backPath}assets/"""
        
        # Fix 5-level deep paths  
        $content = $content -replace '"\.\./\.\.\/\.\./\.\.\/\.\./components/', """${backPath}components/"""
        $content = $content -replace '"\.\./\.\.\/\.\./\.\.\/\.\./utils/', """${backPath}utils/"""
        $content = $content -replace '"\.\./\.\.\/\.\./\.\.\/\.\./SyllabusLayout/', """${backPath}SyllabusLayout/"""
        $content = $content -replace '"\.\./\.\.\/\.\./\.\.\/\.\./assets/', """${backPath}assets/"""
        
        # Fix 4-level deep paths
        $content = $content -replace '"\.\./\.\.\/\.\./\.\./components/', """${backPath}components/"""
        $content = $content -replace '"\.\./\.\.\/\.\./\.\./utils/', """${backPath}utils/"""
        $content = $content -replace '"\.\./\.\.\/\.\./\.\./SyllabusLayout/', """${backPath}SyllabusLayout/"""
        $content = $content -replace '"\.\./\.\.\/\.\./\.\./assets/', """${backPath}assets/"""
        
        if ($content -ne $originalContent) {
            Set-Content -Path $file.FullName -Value $content -NoNewline
            Write-Host "  ✓ Updated imports in $($file.Name)"
        } else {
            Write-Host "  - No changes needed in $($file.Name)"
        }
    }
}

Write-Host "Import path fixing complete!"