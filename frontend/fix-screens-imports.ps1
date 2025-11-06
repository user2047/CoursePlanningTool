# Script to fix import paths in screens/SyllabusView components
$copyPath = "C:\Users\camer\OneDrive\Documents\Desktop\both\copy\CoursePlanningTool\frontend\src"
$screensSyllabusPath = "$copyPath\screens\SyllabusView"

Write-Host "Fixing import paths in screens/SyllabusView components..." -ForegroundColor Green

# Get all tsx files in the screens SyllabusView directory and subdirectories
$files = Get-ChildItem -Path $screensSyllabusPath -Filter "*.tsx" -Recurse -ErrorAction SilentlyContinue

foreach ($file in $files) {
    Write-Host "Processing: $($file.Name)" -ForegroundColor Yellow
    
    $content = Get-Content $file.FullName -Raw
    $originalContent = $content
    
    # Fix paths for screens/SyllabusView (these need different adjustments)
    $relativePath = $file.FullName.Replace($screensSyllabusPath, "").Replace("\", "/")
    $depth = ($relativePath.Split('/') | Where-Object { $_ -ne "" }).Count - 1
    
    if ($depth -eq 0) {
        # Files directly in screens/SyllabusView folder (2 levels up to src)
        $content = $content -replace [regex]::Escape('../../components/Button/ButtonLogic'), '../../../components/Button/ButtonLogic'
        $content = $content -replace [regex]::Escape('../../SyllabusLayout/SyllabusPageHeader'), '../../../SyllabusLayout/SyllabusPageHeader'
    } else {
        # Files in subdirectories of screens/SyllabusView  
        $dotsPrefix = "../" * ($depth + 2)  # 2 levels up to get to src, then adjust for depth
        $content = $content -replace [regex]::Escape('../../../components/Button/ButtonLogic'), "${dotsPrefix}../components/Button/ButtonLogic"
        $content = $content -replace [regex]::Escape('../../../SyllabusLayout/SyllabusPageHeader'), "${dotsPrefix}../SyllabusLayout/SyllabusPageHeader"
    }
    
    # Write back if changed
    if ($content -ne $originalContent) {
        Set-Content -Path $file.FullName -Value $content -NoNewline
        Write-Host "  Updated imports in $($file.Name)" -ForegroundColor Cyan
    }
}

Write-Host "screens/SyllabusView import path fixes complete!" -ForegroundColor Green